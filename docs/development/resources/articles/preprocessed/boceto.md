# Boceto modelos

```rb
# Deben ser compatibles con STI
module Company
  module Business
    # class User < ActiveRecord; end

    # class Platform < ActiveRecord
    #   belongs_to :owner, class_name: "Business::User" # Role::Owner
    #   validates :code, presence: true
    #   validates :name, presence: true
    # end
    #
    # class Role < ActiveRecord; end
    # class Role::Owner < Role; end
    # class Role::Admin < Role; end
    # class Role::Operator < Role; end
    # class Role::Subscriber < Role; end
    # class Role::Guest < Role; end

    class Platform::API < Platform; end
    class Platform::CLI < Platform; end

    class Bot < Platform; end
    class Bot::Chat < Bot; end

    class Business < Platform; end
    class Business::BackOffice < Business; end
    class Business::Dashboard < Business; end
    class Business::Marketplace < Business; end

    class Blog < Platform; end
    class Landing < Platform
      has_many :profiles, class_name: "Business::Profile" dependent: :restrict_with_error # owner can check one of them as :hero
      has_many :pages
    end

    class Profile < ActiveRecord
      has_many :contact_points, dependent: :restrict_with_error

      has_many :experiencies, dependent: :restrict_with_error
      has_many :academics, dependent: :restrict_with_error

      has_many :technologies, class_name: "Business/Technology", dependent: :restrict_with_error
      has_many :articles, class_name: "Blog::Post", dependent: :restrict_with_error
      has_one :portfolio, class_name: "Business::Portfolio", dependent: :restrict_with_error

      def customers
        experiencies.joins(:customers).map(&:customer)
      end
    end

    class ContactPoint < ActiveRecord
      TYPES = %w[location messaging social scheduling portfolio]

      belongs_to :profile, class_name: "Business/Profile"

      validates :type, presence: true, inclusion: { in: TYPES } # should be unique in :name combination
      validates :name, presence: true
    end

    class Experience < ActiveRecord
      belongs_to :customer
    end

    class Academyc < ActiveRecord; end

    class Technology < ActiveRecord
      has_many :categories, as: :categorizable

      validates :name, presence: true, uniqueness: true
    end

    class Portfolio < ActiveRecord
      has_many :projects, class_name: "Business::Projects"

      validates :name, presence: true, uniqueness: true
    end

    class Project < ActiveRecord
      has_many :categories, as: :categorizable
      has_many :collaborations, as: "Business::Collaboration"

      validates :name, presence: true, uniqueness: true
    end

    class Category < ActiveRecord
      TYPES = %w[backend frontend devops agile devops etc]

      belongs_to :categorizable, polimorphic: true

      validates :type, presence: true, uniqueness: true, inclusion: { in: TYPES }
    end

    class Customer < ActiveRecord
      has_many :experiencies, dependent: :restrict_with_error

      validates :name, presence: true
      validates :url, presence: true
    end

    class Page < ActiveRecord
      belongs_to :platform, class_name: "Business::Landing"
    end
  end

  module Blog
    class Post
      belongs_to :author, class_name: Blog::Config.author_class # Business::Profile

      validates :external_id, presence: true
    end
  end

  module Portfolio
    class Project; end
  end
end
```
