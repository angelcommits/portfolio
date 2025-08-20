# 🛠️ Guía de Setup del Proyecto

Este documento describe los pasos para levantar el entorno de desarrollo desde cero.

## Requisitos

- Ruby (vía ASDF)
- Docker y Docker Compose
- Git

## Pasos

```bash
git clone https://github.com/mi-org/mi-backend.git
cd mi-backend
cp .env.example .env
asdf install
bundle install
make up
docker-compose run web rails db:setup
```

## Archivos relevantes

- `.env`: configuración del entorno
- `Makefile`: tareas automatizadas
- `entrypoints/`: scripts de inicialización
