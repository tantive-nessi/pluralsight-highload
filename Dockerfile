FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /BuildIt

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore 'HighLoad App.sln'
# Build and publish a release
RUN dotnet publish -c Release -o PublishOutput ./HighLoad.Console/HighLoad.Console.csproj

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /App
COPY --from=build-env /BuildIt/PublishOutput .
ENTRYPOINT ["dotnet", "HighLoad.Console.dll"]