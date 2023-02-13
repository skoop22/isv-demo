FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base

WORKDIR /app
# Expose the port 5000
EXPOSE 5000
# Sets the environment variable
ENV ASPNETCORE_URLS=http://+:5000

RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser


# 
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY src/*.csproj .
RUN dotnet restore --use-current-runtime  

# copy everything else and build app
COPY src/. .
RUN dotnet publish -c Release -o /app --use-current-runtime --self-contained false --no-restore -v d

# final stage/image
FROM base
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "MvcMovie.dll"]