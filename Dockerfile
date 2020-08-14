# https://hub.docker.com/_/microsoft-dotnet-core
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source


# copy csproj and restore as distinct layers$
COPY viva/TheRevolution.Network.Web.Api/*.csproj TheRevolution.Network.Web.Api/
COPY viva/TheRevolution.Network.Library/*.csproj TheRevolution.Network.Library/
RUN dotnet restore TheRevolution.Network.Web.Api/TheRevolution.Network.Web.Api.csproj

# copy and build app and libraries
COPY viva/TheRevolution.Network.Web.Api/ TheRevolution.Network.Web.Api/
COPY viva/TheRevolution.Network.Library/ TheRevolution.Network.Library/
WORKDIR /source/TheRevolution.Network.Web.Api
RUN dotnet build -c release --no-restore TheRevolution.Network.Web.Api.csproj

# test stage -- exposes optional entrypoint
# target entrypoint with: docker build --target test
FROM build AS test
WORKDIR /source/TheRevolution.Network.Tests
COPY viva/TheRevolution.Network.Tests .
ENTRYPOINT ["dotnet", "test", "--logger:trx"]

FROM build AS publish
RUN dotnet publish -c release --no-build -o /app TheRevolution.Network.Web.Api.csproj

# final stage/image
FROM mcr.microsoft.com/dotnet/core/runtime:3.1
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "TheRevolution.Network.dll"]
