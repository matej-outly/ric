# RicOrganization

RicOrganization module creates a network of organizations which are related through different relation types. These relations can be defined for instance:

- producer / consumer
- lecturer / student
- etc.

We recommend to couple this module with the RicUser module. With this, system users can be effectively scoped into the created organizations. In addition, a structure of assignments can be created inside of the organization and users can be scoped to the assignments.

## Installation

Add gem to your Gemfile:

```ruby
gem "ric_organization"
```

Add database migrations to you application (you can modify DB structure accordingly before migrating):

    $ rake ric_organization:install:migrations
    $ rake db:migrate

Mount routing engine in your `routes.rb` file if you want to use basic organizations management screens:

```ruby
mount RicOrganization::Engine => "/admin", as: :ric_organization
```

## Configuration

You can configure module through `config/initializers/ric_organization.rb` file:

```ruby
RicOrganization.setup do |config|
    config.enable_organization_relations = true
    config.enable_organization_assignments = false
    config.relation_kinds = {
        lectures: {
            actor: :lecturer,
            actee: :student
        }
    }
end
```

Available options:

- attachment_model
- enable_organization_relations
- enable_organization_assignments
- enable_user_assignments
- relation_kinds

## RicUser coupling

You can couple this module with RicUser. Organizations acts as "people" in this coupling model. Organization model is associated with the User model through UserAssignment model which is also part of RicOrganization module. It means that user has and belongs to many organizations. In order to achieve this you must override `models/ric_user/user.rb` file:

```ruby
module RicUser
    class User < ActiveRecord::Base
        include RicUser::Concerns::Models::User
        include RicOrganization::Concerns::Models::User

        # *********************************************************************
        # Authentication
        # *********************************************************************

        include RicAuth::Concerns::Models::Devisable
        include RicAuth::Concerns::Models::Omniauthable
        
        # *********************************************************************
        # Roles
        # *********************************************************************

        include RicUser::Concerns::Models::User::MultiDynamicRoles

    end
end
```

It is also good if you add functionality to UserRole model. Override `models/ric_user/user_role.rb` file:

```ruby
module RicUser
    class UserRole < ActiveRecord::Base
        include RicUser::Concerns::Models::UserRole
        include RicOrganization::Concerns::Models::UserRole
    end
end
```

We assume that user has many roles (defined dynamically in DB). Association between users and roles (UserRole model) should be scoped by organization in order to determine organization in which the role is obtained. This can be achieved by RicUser configuration:

```ruby
RicUser.setup do |config| 
    config.scope_user_role_by_person = true
    config.user_role_person_model = "RicOrganization::Organization"
    ...
end
```

You must also add `person_id` column to the `user_roles` table.

