# OpenAPI External Schemas Guide

## Estructura de Archivos para Schemas Externos

### Opción 1: Schemas JSON Individuales

```
swagger/
├── v1/
│   ├── swagger.yaml                    # Archivo principal OpenAPI
│   ├── schemas/                        # Schemas reutilizables
│   │   ├── models/
│   │   │   ├── profile.json
│   │   │   ├── customer.json
│   │   │   ├── project.json
│   │   │   └── article.json
│   │   ├── requests/
│   │   │   ├── profile_create.json
│   │   │   └── profile_update.json
│   │   ├── responses/
│   │   │   ├── profile_response.json
│   │   │   ├── profiles_list.json
│   │   │   └── error.json
│   │   └── common/
│   │       ├── pagination.json
│   │       └── metadata.json
│   └── parameters/
│       └── common.json
```

### Opción 2: Estructura por Dominio (DDD)

```
swagger/
├── v1/
│   ├── swagger.yaml
│   └── domains/
│       ├── site/
│       │   ├── schemas/
│       │   │   ├── profile.json
│       │   │   ├── content.json
│       │   │   └── social_network.json
│       │   └── paths/
│       │       └── profiles.yaml
│       ├── portfolio/
│       │   ├── schemas/
│       │   │   ├── project.json
│       │   │   └── technology.json
│       │   └── paths/
│       │       └── projects.yaml
│       └── shared/
│           └── schemas/
│               ├── error.json
│               └── pagination.json
```

## Ejemplos de Implementación

### 1. Schema Externo (profile.json)

```json
{
  "type": "object",
  "title": "Profile",
  "description": "User profile information",
  "properties": {
    "id": {
      "type": "integer",
      "description": "Unique identifier"
    },
    "email": {
      "type": "string",
      "format": "email",
      "description": "Contact email"
    },
    "brand": {
      "type": "string",
      "description": "Personal brand or name"
    },
    "startYear": {
      "type": "integer",
      "minimum": 2000,
      "maximum": 2100
    },
    "biography": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "socialLinks": {
      "$ref": "#/components/schemas/SocialLinks"
    },
    "images": {
      "$ref": "#/components/schemas/ProfileImages"
    }
  },
  "required": ["id", "email", "brand"],
  "additionalProperties": false
}
```

### 2. Schema de Response con Composición

```json
{
  "allOf": [
    { "$ref": "./common/api_response.json" },
    {
      "type": "object",
      "properties": {
        "data": {
          "$ref": "./models/profile.json"
        }
      }
    }
  ]
}
```

### 3. Archivo Principal swagger.yaml

```yaml
openapi: 3.0.3
info:
  title: Portfolio API
  version: 1.0.0

paths:
  /api/v1/site/profiles/{id}:
    $ref: './domains/site/paths/profiles.yaml#/profile_by_id'

components:
  schemas:
    # Referencias a archivos externos
    Profile:
      $ref: './schemas/models/profile.json'
    
    ProfileCreate:
      $ref: './schemas/requests/profile_create.json'
    
    ProfileResponse:
      $ref: './schemas/responses/profile_response.json'
    
    Error:
      $ref: './schemas/common/error.json'
```

## Configuración con rswag

### 1. swagger_helper.rb

```ruby
require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s
  
  # Cargar schemas externos
  def load_schema(path)
    JSON.parse(File.read(Rails.root.join('swagger', 'v1', path)))
  end
  
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Portfolio API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'www.example.com'
            }
          }
        }
      ],
      components: {
        schemas: {
          # Cargar schemas desde archivos JSON
          Profile: load_schema('schemas/models/profile.json'),
          Customer: load_schema('schemas/models/customer.json'),
          Error: load_schema('schemas/common/error.json'),
          Pagination: load_schema('schemas/common/pagination.json')
        }
      }
    }
  }
end
```

### 2. Rake Task para Validar Schemas

```ruby
# lib/tasks/swagger.rake
namespace :swagger do
  desc "Validate all JSON schemas"
  task validate: :environment do
    require 'json-schema'
    
    schema_files = Dir.glob(Rails.root.join('swagger', '**', '*.json'))
    
    schema_files.each do |file|
      begin
        schema = JSON.parse(File.read(file))
        JSON::Validator.validate!(schema, {}, :validate_schema => true)
        puts "✓ Valid: #{file}"
      rescue => e
        puts "✗ Invalid: #{file}"
        puts "  Error: #{e.message}"
      end
    end
  end
  
  desc "Generate TypeScript types from schemas"
  task generate_types: :environment do
    # Usar json-schema-to-typescript o similar
    system("npx json-schema-to-typescript swagger/v1/schemas/**/*.json -o app/frontend/types/api/")
  end
end
```

## Ventajas de Schemas Externos

### 1. **Reutilización**
```json
// schemas/common/timestamps.json
{
  "type": "object",
  "properties": {
    "createdAt": {
      "type": "string",
      "format": "date-time"
    },
    "updatedAt": {
      "type": "string",
      "format": "date-time"
    }
  }
}

// schemas/models/profile.json
{
  "allOf": [
    { "$ref": "../common/timestamps.json" },
    {
      "type": "object",
      "properties": {
        "id": { "type": "integer" }
      }
    }
  ]
}
```

### 2. **Versionado**
```
swagger/
├── v1/
│   └── schemas/
│       └── profile.json      # Versión 1
└── v2/
    └── schemas/
        └── profile.json      # Versión 2 con cambios
```

### 3. **Generación de Código**
```bash
# Generar tipos TypeScript
npx json-schema-to-typescript swagger/v1/schemas/models/*.json

# Generar validadores
npx ajv compile -s swagger/v1/schemas/models/*.json
```

### 4. **Validación en CI/CD**
```yaml
# .github/workflows/api-validation.yml
- name: Validate OpenAPI Schemas
  run: |
    bundle exec rake swagger:validate
    npm run validate:api-types
```

## Integración con Rails

### 1. Validación de Requests

```ruby
# app/controllers/concerns/schema_validation.rb
module SchemaValidation
  extend ActiveSupport::Concern
  
  def validate_request!(schema_path)
    schema = load_json_schema(schema_path)
    errors = JSON::Validator.fully_validate(schema, request_params)
    
    if errors.any?
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end
  
  private
  
  def load_json_schema(path)
    Rails.cache.fetch("schema:#{path}") do
      JSON.parse(File.read(Rails.root.join('swagger', 'v1', path)))
    end
  end
end
```

### 2. Serializers con Schemas

```ruby
# app/serializers/profile_serializer.rb
class ProfileSerializer
  def self.schema
    @schema ||= JSON.parse(
      File.read(Rails.root.join('swagger/v1/schemas/models/profile.json'))
    )
  end
  
  def as_json
    # Serializar según el schema
    schema_properties = self.class.schema['properties']
    
    schema_properties.each_with_object({}) do |(key, _), hash|
      hash[key.to_sym] = object.send(key) if object.respond_to?(key)
    end
  end
end
```

## Herramientas Recomendadas

1. **JSON Schema Validator**: Para validar schemas
2. **json-schema-to-typescript**: Generar tipos TypeScript
3. **openapi-generator**: Generar clientes SDK
4. **redoc**: Documentación alternativa a Swagger UI
5. **spectacle-docs**: Generador de documentación estática

Esta estructura te permite mantener los schemas organizados, reutilizables y fáciles de mantener, mientras que facilita la generación automática de tipos y validadores para tu aplicación.
