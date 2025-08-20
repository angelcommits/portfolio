# Domain-Driven Design Patterns & Migration Guide

## 🎯 Overview

This guide provides comprehensive workflows for implementing Domain-Driven Design (DDD) patterns and migrating from traditional Rails MVC to a DDD architecture in the Portfolio Backend project. DDD helps manage complexity by aligning software design with business domains.

## 🏗️ DDD Architecture Overview

### Core Concepts

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                         │
│                 (Controllers, API, Views)                     │
├─────────────────────────────────────────────────────────────┤
│                    Application Layer                          │
│              (Use Cases, Application Services)                │
├─────────────────────────────────────────────────────────────┤
│                      Domain Layer                             │
│        (Entities, Value Objects, Domain Services)             │
├─────────────────────────────────────────────────────────────┤
│                  Infrastructure Layer                         │
│         (Repositories, External Services, ORM)                │
└─────────────────────────────────────────────────────────────┘
```

### DDD Building Blocks

1. **Entities**: Objects with identity that persist over time
2. **Value Objects**: Immutable objects defined by their attributes
3. **Aggregates**: Clusters of entities with clear boundaries
4. **Domain Services**: Stateless operations that don't belong to entities
5. **Repositories**: Abstractions for data persistence
6. **Domain Events**: Significant business occurrences
7. **Application Services**: Orchestrate use cases
8. **Bounded Contexts**: Explicit boundaries between domains

## 🚀 Migration Workflows

### Workflow 1: Setting Up DDD Structure

```bash
# 1. Create DDD directory structure
mkdir -p app/contexts/{identity,portfolio,site_management,customer,content,inference}
mkdir -p app/contexts/shared/{domain,infrastructure}

# 2. Create subdirectories for each context
for context in identity portfolio site_management customer content inference; do
  mkdir -p app/contexts/$context/{domain,application,infrastructure,presentation}
  mkdir -p app/contexts/$context/domain/{entities,value_objects,services,events,repositories}
  mkdir -p app/contexts/$context/application/{commands,queries,services}
  mkdir -p app/contexts/$context/infrastructure/{repositories,adapters}
done

# 3. Configure Rails to autoload contexts
# config/application.rb
config.autoload_paths << Rails.root.join('app/contexts')
config.eager_load_paths << Rails.root.join('app/contexts')
```

### Workflow 2: Creating Domain Entities

#### Step 1: Define Base Entity
```ruby
# app/contexts/shared/domain/entity.rb
module Shared
  module Domain
    class Entity
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Serialization

      attribute :id, :string
      attribute :created_at, :datetime
      attribute :updated_at, :datetime

      def ==(other)
        other.is_a?(self.class) && other.id == id
      end

      def persisted?
        id.present?
      end

      protected

      def assert_invariants
        # Override in subclasses to enforce business rules
      end
    end
  end
end
```

#### Step 2: Create Domain Entity
```ruby
# app/contexts/portfolio/domain/entities/project.rb
module Portfolio
  module Domain
    module Entities
      class Project < Shared::Domain::Entity
        attribute :name, :string
        attribute :description, :string
        attribute :status, :string, default: 'draft'
        attribute :technologies, :array, default: []
        attribute :start_date, :date
        attribute :end_date, :date
        attribute :user_id, :string
        attribute :featured, :boolean, default: false

        validates :name, presence: true
        validates :status, inclusion: { in: ProjectStatus::ALL }

        def publish!
          raise InvalidStateError, "Can't publish archived project" if archived?
          
          self.status = ProjectStatus::PUBLISHED
          self.published_at = Time.current
          assert_invariants
        end

        def archive!
          self.status = ProjectStatus::ARCHIVED
          self.archived_at = Time.current
          self.featured = false
          assert_invariants
        end

        def add_technology(technology)
          raise ArgumentError, "Technology must be valid" unless technology.valid?
          
          self.technologies << technology
          assert_invariants
        end

        def featured?
          featured && published?
        end

        def published?
          status == ProjectStatus::PUBLISHED
        end

        def archived?
          status == ProjectStatus::ARCHIVED
        end

        protected

        def assert_invariants
          if featured? && !published?
            raise InvariantViolationError, "Only published projects can be featured"
          end

          if end_date.present? && start_date.present? && end_date < start_date
            raise InvariantViolationError, "End date must be after start date"
          end
        end
      end
    end
  end
end
```

### Workflow 3: Implementing Value Objects

#### Step 1: Create Base Value Object
```ruby
# app/contexts/shared/domain/value_object.rb
module Shared
  module Domain
    class ValueObject
      include ActiveModel::Model
      include ActiveModel::Attributes

      def ==(other)
        other.is_a?(self.class) && attributes == other.attributes
      end

      def hash
        attributes.hash
      end

      def to_h
        attributes.symbolize_keys
      end

      protected

      def self.from_primitive(value)
        new(value)
      end

      def to_primitive
        attributes
      end
    end
  end
end
```

#### Step 2: Implement Specific Value Objects
```ruby
# app/contexts/portfolio/domain/value_objects/project_status.rb
module Portfolio
  module Domain
    module ValueObjects
      class ProjectStatus < Shared::Domain::ValueObject
        DRAFT = 'draft'
        PUBLISHED = 'published'
        ARCHIVED = 'archived'
        ALL = [DRAFT, PUBLISHED, ARCHIVED].freeze

        attribute :value, :string

        validates :value, inclusion: { in: ALL }

        def self.draft
          new(value: DRAFT)
        end

        def self.published
          new(value: PUBLISHED)
        end

        def self.archived
          new(value: ARCHIVED)
        end

        def draft?
          value == DRAFT
        end

        def published?
          value == PUBLISHED
        end

        def archived?
          value == ARCHIVED
        end

        def to_s
          value
        end
      end
    end
  end
end

# app/contexts/site_management/domain/value_objects/contact_point.rb
module SiteManagement
  module Domain
    module ValueObjects
      class ContactPoint < Shared::Domain::ValueObject
        attribute :type, :string
        attribute :value, :string
        attribute :label, :string
        attribute :primary, :boolean, default: false

        validates :type, presence: true
        validates :value, presence: true

        def self.email(address, label: nil, primary: false)
          new(
            type: 'email',
            value: address,
            label: label || 'Email',
            primary: primary
          )
        end

        def self.phone(number, label: nil, primary: false)
          new(
            type: 'phone',
            value: number,
            label: label || 'Phone',
            primary: primary
          )
        end

        def self.social(platform, handle, primary: false)
          new(
            type: 'social',
            value: handle,
            label: platform.capitalize,
            primary: primary
          )
        end

        def email?
          type == 'email'
        end

        def phone?
          type == 'phone'
        end

        def social?
          type == 'social'
        end

        def formatted_value
          case type
          when 'email'
            value
          when 'phone'
            format_phone_number(value)
          when 'social'
            "@#{value}"
          else
            value
          end
        end

        private

        def format_phone_number(number)
          # Implement phone formatting logic
          number.gsub(/(\d{3})(\d{3})(\d{4})/, '(\1) \2-\3')
        end
      end
    end
  end
end
```

### Workflow 4: Creating Aggregates

```ruby
# app/contexts/site_management/domain/entities/hero_section.rb
module SiteManagement
  module Domain
    module Entities
      class HeroSection < Shared::Domain::Entity
        # This is an Aggregate Root
        attribute :site_id, :string
        attribute :headline, :string
        attribute :subheadline, :string
        attribute :background_image_url, :string
        attribute :cta_buttons, :array, default: []
        attribute :layout_type, :string, default: 'centered'
        attribute :active, :boolean, default: true

        validates :headline, presence: true
        validates :site_id, presence: true

        def add_cta_button(button)
          raise ArgumentError, "Maximum 3 CTA buttons allowed" if cta_buttons.size >= 3
          
          self.cta_buttons << button
          assert_invariants
        end

        def remove_cta_button(button_id)
          self.cta_buttons = cta_buttons.reject { |btn| btn.id == button_id }
        end

        def activate!
          self.active = true
          # Domain event could be raised here
        end

        def deactivate!
          self.active = false
        end

        protected

        def assert_invariants
          if active && headline.blank?
            raise InvariantViolationError, "Active hero must have a headline"
          end

          if cta_buttons.size > 3
            raise InvariantViolationError, "Maximum 3 CTA buttons allowed"
          end
        end
      end

      class CTAButton < Shared::Domain::ValueObject
        attribute :id, :string, default: -> { SecureRandom.uuid }
        attribute :text, :string
        attribute :url, :string
        attribute :style, :string, default: 'primary'
        attribute :position, :integer

        validates :text, presence: true
        validates :url, presence: true
        validates :style, inclusion: { in: %w[primary secondary outline] }
      end
    end
  end
end
```

### Workflow 5: Implementing Repositories

#### Step 1: Define Repository Interface
```ruby
# app/contexts/shared/domain/repository.rb
module Shared
  module Domain
    class Repository
      class NotFoundError < StandardError; end
      class PersistenceError < StandardError; end

      def find(id)
        raise NotImplementedError
      end

      def find_by(criteria)
        raise NotImplementedError
      end

      def all
        raise NotImplementedError
      end

      def save(entity)
        raise NotImplementedError
      end

      def delete(entity)
        raise NotImplementedError
      end

      def exists?(id)
        raise NotImplementedError
      end

      def count
        raise NotImplementedError
      end
    end
  end
end
```

#### Step 2: Implement Concrete Repository
```ruby
# app/contexts/portfolio/infrastructure/repositories/project_repository.rb
module Portfolio
  module Infrastructure
    module Repositories
      class ProjectRepository < Shared::Domain::Repository
        def initialize(scope = ::Portfolio::Project)
          @scope = scope
        end

        def find(id)
          record = @scope.find_by(id: id)
          raise NotFoundError, "Project not found with id: #{id}" unless record
          
          map_to_entity(record)
        end

        def find_by(criteria)
          records = @scope.where(criteria)
          records.map { |record| map_to_entity(record) }
        end

        def all
          @scope.all.map { |record| map_to_entity(record) }
        end

        def save(entity)
          validate_entity!(entity)
          
          record = entity.persisted? ? update_record(entity) : create_record(entity)
          map_to_entity(record)
        rescue ActiveRecord::RecordInvalid => e
          raise PersistenceError, e.message
        end

        def delete(entity)
          record = @scope.find(entity.id)
          record.destroy!
          true
        rescue ActiveRecord::RecordNotFound
          raise NotFoundError, "Project not found with id: #{entity.id}"
        end

        def exists?(id)
          @scope.exists?(id: id)
        end

        def count
          @scope.count
        end

        def find_by_user(user_id)
          @scope.where(user_id: user_id).map { |record| map_to_entity(record) }
        end

        def find_featured
          @scope.where(featured: true, status: 'published')
                .map { |record| map_to_entity(record) }
        end

        private

        def map_to_entity(record)
          Domain::Entities::Project.new(
            id: record.id,
            name: record.name,
            description: record.description,
            status: record.status,
            technologies: map_technologies(record.technologies),
            start_date: record.start_date,
            end_date: record.end_date,
            user_id: record.user_id,
            featured: record.featured,
            created_at: record.created_at,
            updated_at: record.updated_at
          )
        end

        def map_technologies(tech_records)
          tech_records.map do |tech|
            Domain::ValueObjects::Technology.new(
              name: tech.name,
              category: tech.category
            )
          end
        end

        def create_record(entity)
          @scope.create!(map_to_attributes(entity))
        end

        def update_record(entity)
          record = @scope.find(entity.id)
          record.update!(map_to_attributes(entity))
          record
        end

        def map_to_attributes(entity)
          {
            name: entity.name,
            description: entity.description,
            status: entity.status,
            start_date: entity.start_date,
            end_date: entity.end_date,
            user_id: entity.user_id,
            featured: entity.featured
          }
        end

        def validate_entity!(entity)
          raise ArgumentError, "Entity must be a Project" unless entity.is_a?(Domain::Entities::Project)
          raise ArgumentError, "Entity is invalid" unless entity.valid?
        end
      end
    end
  end
end
```

### Workflow 6: Domain Services

```ruby
# app/contexts/portfolio/domain/services/project_publishing_service.rb
module Portfolio
  module Domain
    module Services
      class ProjectPublishingService
        def initialize(project_repository, event_publisher)
          @project_repository = project_repository
          @event_publisher = event_publisher
        end

        def publish_project(project_id, publisher_id)
          project = @project_repository.find(project_id)
          
          # Business rule: Only project owner can publish
          unless project.user_id == publisher_id
            raise UnauthorizedError, "Only project owner can publish"
          end

          # Business rule: Must have at least one technology
          if project.technologies.empty?
            raise InvalidStateError, "Project must have at least one technology"
          end

          # State transition
          project.publish!
          
          # Persist changes
          @project_repository.save(project)
          
          # Publish domain event
          @event_publisher.publish(
            Events::ProjectPublished.new(
              project_id: project.id,
              publisher_id: publisher_id,
              published_at: Time.current
            )
          )
          
          project
        end

        def schedule_publish(project_id, publish_at, scheduler_id)
          project = @project_repository.find(project_id)
          
          # Validate scheduling
          if publish_at <= Time.current
            raise ArgumentError, "Publish date must be in the future"
          end

          # Create scheduled job
          PublishProjectJob.set(wait_until: publish_at).perform_later(
            project_id: project_id,
            publisher_id: scheduler_id
          )

          # Return scheduling confirmation
          {
            project_id: project_id,
            scheduled_for: publish_at,
            status: 'scheduled'
          }
        end
      end
    end
  end
end
```

### Workflow 7: Application Services / Use Cases

```ruby
# app/contexts/portfolio/application/commands/create_project_command.rb
module Portfolio
  module Application
    module Commands
      class CreateProjectCommand
        include ActiveModel::Model

        attr_accessor :name, :description, :technologies, :start_date, :end_date, :user_id

        validates :name, presence: true
        validates :user_id, presence: true
      end
    end
  end
end

# app/contexts/portfolio/application/services/create_project_service.rb
module Portfolio
  module Application
    module Services
      class CreateProjectService
        def initialize(project_repository, technology_repository, event_publisher)
          @project_repository = project_repository
          @technology_repository = technology_repository
          @event_publisher = event_publisher
        end

        def execute(command)
          validate_command!(command)

          # Create domain entity
          project = Domain::Entities::Project.new(
            name: command.name,
            description: command.description,
            start_date: command.start_date,
            end_date: command.end_date,
            user_id: command.user_id,
            status: Domain::ValueObjects::ProjectStatus::DRAFT
          )

          # Add technologies
          if command.technologies.present?
            technologies = @technology_repository.find_by_names(command.technologies)
            technologies.each { |tech| project.add_technology(tech) }
          end

          # Save project
          saved_project = @project_repository.save(project)

          # Publish event
          @event_publisher.publish(
            Domain::Events::ProjectCreated.new(
              project_id: saved_project.id,
              user_id: command.user_id,
              created_at: Time.current
            )
          )

          # Return result
          Result.success(saved_project)
        rescue StandardError => e
          Result.failure(e.message)
        end

        private

        def validate_command!(command)
          raise ArgumentError, "Invalid command" unless command.valid?
        end
      end

      class Result
        attr_reader :value, :error

        def self.success(value)
          new(success: true, value: value)
        end

        def self.failure(error)
          new(success: false, error: error)
        end

        def initialize(success:, value: nil, error: nil)
          @success = success
          @value = value
          @error = error
        end

        def success?
          @success
        end

        def failure?
          !@success
        end
      end
    end
  end
end
```

### Workflow 8: Domain Events

```ruby
# app/contexts/shared/domain/event.rb
module Shared
  module Domain
    class Event
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :aggregate_id, :string
      attribute :occurred_at, :datetime, default: -> { Time.current }
      attribute :metadata, :hash, default: {}

      validates :aggregate_id, presence: true

      def event_type
        self.class.name.demodulize.underscore
      end

      def to_h
        attributes.merge(event_type: event_type)
      end
    end
  end
end

# app/contexts/portfolio/domain/events/project_published.rb
module Portfolio
  module Domain
    module Events
      class ProjectPublished < Shared::Domain::Event
        attribute :project_id, :string
        attribute :publisher_id, :string
        attribute :published_at, :datetime

        alias_attribute :aggregate_id, :project_id
      end
    end
  end
end

# app/contexts/shared/infrastructure/event_publisher.rb
module Shared
  module Infrastructure
    class EventPublisher
      def initialize
        @handlers = Hash.new { |h, k| h[k] = [] }
      end

      def subscribe(event_type, handler)
        @handlers[event_type] << handler
      end

      def publish(event)
        handlers = @handlers[event.class] + @handlers[event.class.superclass]
        
        handlers.each do |handler|
          handler.call(event)
        rescue StandardError => e
          Rails.logger.error "Event handler failed: #{e.message}"
          # Could implement retry logic or dead letter queue
        end

        # Also publish to external systems (EventStore, Kafka, etc.)
        persist_event(event)
      end

      private

      def persist_event(event)
        # Store event for event sourcing
        StoredEvent.create!(
          event_type: event.event_type,
          aggregate_id: event.aggregate_id,
          payload: event.to_h,
          occurred_at: event.occurred_at
        )
      end
    end
  end
end
```

### Workflow 9: Anti-Corruption Layer

```ruby
# app/contexts/portfolio/infrastructure/adapters/legacy_project_adapter.rb
module Portfolio
  module Infrastructure
    module Adapters
      class LegacyProjectAdapter
        def initialize(legacy_model = ::Portfolio::Project)
          @legacy_model = legacy_model
        end

        def find_all_for_migration
          @legacy_model.includes(:technologies, :user).find_each do |legacy_project|
            yield map_to_domain(legacy_project)
          end
        end

        def import_from_legacy(domain_project)
          # Map domain object back to legacy for gradual migration
          legacy_attributes = {
            name: domain_project.name,
            description: domain_project.description,
            status: domain_project.status,
            user_id: domain_project.user_id,
            featured: domain_project.featured
          }

          @legacy_model.create!(legacy_attributes)
        end

        private

        def map_to_domain(legacy_project)
          Domain::Entities::Project.new(
            id: legacy_project.id,
            name: legacy_project.name,
            description: legacy_project.description,
            status: map_status(legacy_project.status),
            technologies: map_technologies(legacy_project.technologies),
            user_id: legacy_project.user_id,
            featured: legacy_project.featured || false,
            created_at: legacy_project.created_at,
            updated_at: legacy_project.updated_at
          )
        end

        def map_status(legacy_status)
          # Handle any legacy status mappings
          case legacy_status
          when 'active' then Domain::ValueObjects::ProjectStatus::PUBLISHED
          when 'inactive' then Domain::ValueObjects::ProjectStatus::DRAFT
          else legacy_status
          end
        end

        def map_technologies(legacy_technologies)
          legacy_technologies.map do |tech|
            Domain::ValueObjects::Technology.new(
              name: tech.name,
              category: tech.category || 'general'
            )
          end
        end
      end
    end
  end
end
```

### Workflow 10: Controller Integration

```ruby
# app/controllers/api/v1/portfolio/projects_controller.rb
module Api
  module V1
    module Portfolio
      class ProjectsController < ApplicationController
        def index
          # Use query service
          query_service = ::Portfolio::Application::Queries::ListProjectsQuery.new(
            project_repository
          )
          
          projects = query_service.execute(
            user_id: params[:user_id],
            status: params[:status],
            page: params[:page]
          )

          render json: {
            data: serialize_projects(projects),
            meta: pagination_meta(projects)
          }
        end

        def create
          # Build command from params
          command = ::Portfolio::Application::Commands::CreateProjectCommand.new(
            project_params.merge(user_id: current_user.id)
          )

          # Execute use case
          result = create_project_service.execute(command)

          if result.success?
            render json: serialize_project(result.value), status: :created
          else
            render json: { error: result.error }, status: :unprocessable_entity
          end
        end

        def publish
          result = publishing_service.publish_project(
            params[:id],
            current_user.id
          )

          render json: serialize_project(result), status: :ok
        rescue Portfolio::Domain::UnauthorizedError => e
          render json: { error: e.message }, status: :forbidden
        rescue Portfolio::Domain::InvalidStateError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end

        private

        def project_repository
          @project_repository ||= ::Portfolio::Infrastructure::Repositories::ProjectRepository.new
        end

        def create_project_service
          @create_project_service ||= ::Portfolio::Application::Services::CreateProjectService.new(
            project_repository,
            technology_repository,
            event_publisher
          )
        end

        def publishing_service
          @publishing_service ||= ::Portfolio::Domain::Services::ProjectPublishingService.new(
            project_repository,
            event_publisher
          )
        end

        def technology_repository
          @technology_repository ||= ::Portfolio::Infrastructure::Repositories::TechnologyRepository.new
        end

        def event_publisher
          @event_publisher ||= Shared::Infrastructure::EventPublisher.new
        end

        def project_params
          params.require(:project).permit(:name, :description, :start_date, :end_date, technologies: [])
        end

        def serialize_project(project)
          ProjectSerializer.new(project).as_json
        end

        def serialize_projects(projects)
          projects.map { |project| serialize_project(project) }
        end
      end
    end
  end
end
```

## 🔄 Migration Strategy

### Phase 1: Foundation (Week 1-2)
1. Set up DDD directory structure
2. Create shared domain components
3. Implement event infrastructure
4. Set up first bounded context (Identity)

### Phase 2: Core Domains (Week 3-4)
1. Complete Portfolio context
2. Extract Site Management context
3. Implement repositories and services
4. Add anti-corruption layers

### Phase 3: Advanced Patterns (Week 5-6)
1. Implement domain events fully
2. Add process managers/sagas
3. Create query services
4. Implement caching strategies

### Phase 4: Complete Migration (Week 7-8)
1. Migrate remaining domains
2. Remove legacy code
3. Optimize performance
4. Complete documentation

## 📊 Migration Checklist

### Per Bounded Context
- [ ] Define aggregate boundaries
- [ ] Create domain entities
- [ ] Implement value objects
- [ ] Create repository interfaces
- [ ] Implement repository adapters
- [ ] Define domain services
- [ ] Create application services
- [ ] Implement domain events
- [ ] Add anti-corruption layer
- [ ] Update controllers
- [ ] Write comprehensive tests
- [ ] Document domain model

### Testing Strategy
```ruby
# spec/contexts/portfolio/domain/entities/project_spec.rb
require 'rails_helper'

RSpec.describe Portfolio::Domain::Entities::Project do
  describe 'invariants' do
    it 'enforces featured projects must be published' do
      project = build(:domain_project, featured: true, status: 'draft')
      
      expect { project.send(:assert_invariants) }.to raise_error(
        Portfolio::Domain::InvariantViolationError,
        /Only published projects can be featured/
      )
    end
  end

  describe '#publish!' do
    it 'transitions to published state' do
      project = build(:domain_project, status: 'draft')
      
      project.publish!
      
      expect(project).to be_published
      expect(project.published_at).to be_present
    end
  end
end
```

## 🎯 Best Practices

### 1. Keep Domain Pure
- No framework dependencies in domain layer
- No database concerns in entities
- Use plain Ruby objects when possible

### 2. Explicit Over Implicit
- Name concepts from business domain
- Make implicit rules explicit
- Use value objects for concepts

### 3. Protect Invariants
- Enforce business rules in entities
- Validate state transitions
- Fail fast on violations

### 4. Event-Driven Design
- Capture significant business events
- Use events for integration
- Enable event sourcing

### 5. Test Domain Logic
- Unit test entities and value objects
- Integration test repositories
- Test business scenarios

## 🔗 Next Steps

- Continue to [Frontend Integration](./05-frontend-integration.md)
- Review [Authentication Workflows](./06-authentication.md)
- Explore [Testing DDD](./03-testing-workflows.md#testing-ddd)

## 📚 Resources

- [Domain-Driven Design by Eric Evans](https://www.domainlanguage.com/ddd/)
- [Implementing Domain-Driven Design by Vaughn Vernon](https://www.informit.com/store/implementing-domain-driven-design-9780321834577)
- [DDD in Rails](https://blog.arkency.com/domain-driven-rails/)
- [Bounded Context Canvas](https://github.com/ddd-crew/bounded-context-canvas)
