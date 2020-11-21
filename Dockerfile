#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/runtime:3.1-buster-slim AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["dmcc/dmcc.csproj", "dmcc/"]
COPY ["dmcr/dmcr.csproj", "dmcr/"]
COPY ["cku/cku.csproj", "cku/"]
RUN dotnet restore "dmcc/dmcc.csproj"
COPY . .
WORKDIR "/src/dmcc"
RUN dotnet build "dmcc.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dmcc.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dmcc.dll"]
