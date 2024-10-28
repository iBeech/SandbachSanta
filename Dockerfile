# Use the SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY . .

# Restore and build
RUN dotnet restore "SandbachSanta/SandbachSanta.csproj"
RUN dotnet build "SandbachSanta/SandbachSanta.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "SandbachSanta/SandbachSanta.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Use the base image for runtime
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Final stage for runtime
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SandbachSanta.dll"]
