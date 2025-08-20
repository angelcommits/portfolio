
# 🏗️ Estructura Inicial DDD para Rails

## 📁 Estructura de Carpetas

```
app/
├── domains/
│   ├── knowledge/
│   │   ├── entities/
│   │   ├── value_objects/
│   │   └── services/
│   ├── sessions/
│   ├── users/
│   └── tags/
├── services/
│   ├── knowledge/
│   ├── sessions/
│   └── authentication/
├── adapters/
│   ├── api/
│   │   ├── v1/
│   │   └── base_controller.rb
│   ├── storage/
│   └── notification/
├── jobs/
├── models/
│   ├── session.rb
│   ├── message.rb
│   ├── resource.rb
│   ├── user.rb
│   └── tag.rb
```

## 🧩 Modelos ActiveRecord y Migraciones

```ruby
# db/migrate/xxxx_create_sessions.rb
create_table :sessions do |t|
  t.references :user, foreign_key: true
  t.string :title
  t.timestamps
end

# db/migrate/xxxx_create_messages.rb
create_table :messages do |t|
  t.references :session, foreign_key: true
  t.integer :message_type
  t.text :content
  t.jsonb :metadata, default: {}
  t.timestamps
end

# db/migrate/xxxx_create_resources.rb
create_table :resources do |t|
  t.string :title
  t.text :summary
  t.string :source_type
  t.string :visibility
  t.string :tags, array: true, default: []
  t.string :file_path
  t.timestamps
end

# db/migrate/xxxx_create_users.rb
create_table :users do |t|
  t.string :email
  t.string :role
  t.string :twilio_phone_number
  t.timestamps
end

# db/migrate/xxxx_create_tags.rb
create_table :tags do |t|
  t.string :name
  t.timestamps
end
```

## 🔗 Endpoints RESTful Iniciales

```
POST   /api/v1/sessions
GET    /api/v1/sessions/:id
POST   /api/v1/messages
GET    /api/v1/messages?session_id=123
POST   /api/v1/resources
GET    /api/v1/resources/:id
GET    /api/v1/resources/search?tag=ruby
```

