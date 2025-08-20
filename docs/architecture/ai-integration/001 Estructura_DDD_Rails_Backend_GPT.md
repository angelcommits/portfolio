# 🏗️ Estructura Inicial DDD para Rails (Dominio centralizado bajo módulo GPT)

## 📁 Estructura de Carpetas

```
app/
├── domains/
│   └── gpt/
│       ├── knowledge/
│       │   ├── entities/
│       │   ├── value_objects/
│       │   └── services/
│       ├── sessions/
│       ├── users/
│       ├── tags/
│       └── resources/
├── services/
│   └── gpt/
│       ├── knowledge/
│       ├── sessions/
│       ├── evaluation/
│       └── authentication/
├── adapters/
│   ├── api/
│   │   ├── v1/
│   │   └── base_controller.rb
│   ├── storage/
│   └── notification/
├── jobs/
├── models/
│   └── gpt/
│       ├── session.rb
│       ├── message.rb
│       ├── resource.rb
│       ├── user.rb
│       └── tag.rb
```

## 🧩 Modelos ActiveRecord y Migraciones

```ruby
# db/migrate/xxxx_create_sessions.rb
create_table :gpt_sessions do |t|
  t.references :user, foreign_key: true
  t.string :title
  t.timestamps
end

# db/migrate/xxxx_create_messages.rb
create_table :gpt_messages do |t|
  t.references :session, foreign_key: { to_table: :gpt_sessions }
  t.integer :message_type
  t.text :content
  t.jsonb :metadata, default: {}
  t.timestamps
end

# db/migrate/xxxx_create_resources.rb
create_table :gpt_resources do |t|
  t.string :title
  t.text :summary
  t.string :source_type
  t.string :visibility
  t.string :tags, array: true, default: []
  t.string :file_path
  t.timestamps
end

# db/migrate/xxxx_create_users.rb
create_table :gpt_users do |t|
  t.string :email
  t.string :role
  t.string :twilio_phone_number
  t.timestamps
end

# db/migrate/xxxx_create_tags.rb
create_table :gpt_tags do |t|
  t.string :name
  t.timestamps
end
```

## 🔗 Endpoints RESTful Iniciales

```
POST   /api/v1/gpt/sessions
GET    /api/v1/gpt/sessions/:id
POST   /api/v1/gpt/messages
GET    /api/v1/gpt/messages?session_id=123
POST   /api/v1/gpt/resources
GET    /api/v1/gpt/resources/:id
GET    /api/v1/gpt/resources/search?tag=ruby
```
