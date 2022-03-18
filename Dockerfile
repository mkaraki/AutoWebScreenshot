FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

COPY AutoWebScreenshot/AutoWebScreenshot.csproj ./
RUN dotnet restore

COPY AutoWebScreenshot/*.cs ./
RUN dotnet publish -c Release -o out

FROM ubuntu AS dl-webdriver

RUN apt-get update && apt-get install -y unzip wget

RUN export webdriver_version=$(wget -q -O - https://chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget -N -P /tmp https://chromedriver.storage.googleapis.com/$webdriver_version/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver_linux64.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/chromedriver

FROM mcr.microsoft.com/dotnet/runtime:6.0-focal

RUN apt-get update && apt-get install -y --no-install-recommends wget software-properties-common gnupg && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - &&\
    add-apt-repository "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" && \
    apt-get update && apt-get install -y --no-install-recommends google-chrome-stable && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build-env /app/out /app
COPY --from=dl-webdriver /usr/local/bin/chromedriver /app

WORKDIR /data

ENV NO_SANDBOX=1

ENTRYPOINT [ "dotnet", "/app/AutoWebScreenshot.dll" ]