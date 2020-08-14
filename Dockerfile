FROM ubuntu:focal

RUN apt-get update && apt-get install -y wget && apt-get upgrade -y
RUN wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update && apt-get upgrade && apt-get install -y apt-transport-https dotnet-sdk-3.1 nginx
RUN mkdir -p /var/www/threrevolution.network
ADD viva /var/www/therevolution.network/viva
RUN cd /var/www/therevolution.network/viva && dotnet build TheRevolution.Network.sln -o ./release
ADD run.sh /var/www/therevolution.network/run.sh
ENTRYPOINT [ /var/www/therevolution.network/run.sh ]
