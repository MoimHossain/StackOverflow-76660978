FROM ubuntu:20.04

LABEL Author="Moim Hossain"
LABEL Email="moimhossain@gmail.com"
LABEL GitHub="https://github.com/moimhossain"
LABEL BaseImage="ubuntu:20.04"
 
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && useradd -m agentuser
 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lsb-release \
    software-properties-common
 
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
 
# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64
 
WORKDIR /azp
RUN chown -R agentuser:agentuser /azp
RUN chmod 755 /azp

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Install .NET Core SDK
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-7.0
 
COPY ./start.sh .
RUN chmod +x start.sh
# All subsequent commands run under this user
USER agentuser
 
ENTRYPOINT [ "./start.sh", "--once" ]
