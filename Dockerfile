#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /src
COPY TonyBark.Dashboard/Server/TonyBark.Dashboard.Server.csproj TonyBark.Dashboard/Server/
COPY TonyBark.Dashboard/Client/TonyBark.Dashboard.Client.csproj TonyBark.Dashboard/Client/
COPY TonyBark.Dashboard/Shared/TonyBark.Dashboard.Shared.csproj TonyBark.Dashboard/Shared/
RUN dotnet restore "TonyBark.Dashboard/Server/TonyBark.Dashboard.Server.csproj"
COPY . .
WORKDIR "/src/TonyBark.Dashboard/Server"
RUN dotnet build "TonyBark.Dashboard.Server.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TonyBark.Dashboard.Server.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TonyBark.Dashboard.Server.dll"]
