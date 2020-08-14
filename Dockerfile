### PREPARE
FROM mcr.microsoft.com/dotnet/core/sdk:3.1.201 AS build
WORKDIR /src

# Copy csproj and sln and restore as distinct layers
COPY BlazorApp1/*.csproj BlazorApp1/
COPY BlazorApp1.sln .
RUN dotnet restore

### BUILD
COPY . .
RUN dotnet build "BlazorApp1.sln" -c Release -o /app

### PUBLISH
FROM build as publish
COPY . .
RUN dotnet publish "BlazorApp1.sln" -c Release -o /app

### RUNTIME IMAGE
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS final
WORKDIR /app
COPY --from=publish /app .
EXPOSE 80
ENTRYPOINT ["dotnet", "BlazorApp.WebAssembly.dll"]