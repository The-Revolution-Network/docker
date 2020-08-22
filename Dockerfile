# https://hub.docker.com/_/microsoft-dotnet-core
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build

# copy csproj and restore as distinct layers$
WORKDIR /source/TheRevolutionNetwork.Library/
COPY ./viva/TheRevolutionNetwork.Library/*.csproj .

WORKDIR /source/TheRevolutionNetwork.Web.Api/
COPY ./viva/TheRevolutionNetwork.Web.Api/*.csproj .

RUN dotnet restore TheRevolutionNetwork.Web.Api.csproj

# copy and build app and libraries
WORKDIR /source/TheRevolutionNetwork.Library/
COPY ./viva/TheRevolutionNetwork.Library/ .

WORKDIR /source/TheRevolutionNetwork.Web.Api/
COPY ./viva/TheRevolutionNetwork.Web.Api/ .
RUN dotnet build -c release --no-restore TheRevolutionNetwork.Web.Api.csproj

# test stage -- exposes optional entrypoint
# target entrypoint with: docker build --target test
FROM build AS test
WORKDIR /source/TheRevolutionNetwork.Tests
COPY ./viva/TheRevolutionNetwork.Tests .
ENTRYPOINT ["dotnet", "test", "--logger:trx"]

FROM build AS publish
RUN dotnet publish -c release --no-build -o /app TheRevolutionNetwork.Web.Api.csproj

# final stage/image
FROM mcr.microsoft.com/dotnet/core/runtime:3.1
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "TheRevolutionNetwork.dll"]
