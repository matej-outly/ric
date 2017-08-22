# RicOrganization

RicOrganization module creates a network of organizations which are related through different relation types. These relations can be defined for instance:

- producer / consumer
- teacher / student
- etc.

We recommend to couple this module with the RicUser module. With this, system users can be effectively scoped into the created organizations. In addition, a structure of assignments can be created inside of the organization and users can be scoped to the assignments.

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

We assume that user has many roles (defined dynamicaly in DB). Association between users and roles (UserRole model) should be scoped by organization in order to determine in which organization the role is obtained. This can be achieved by RicUser configuration:

```ruby
RicUser.setup do |config| 
    config.scope_user_role_by_person = true
    config.user_role_person_model = "RicOrganization::Organization"
    ...
end
```

You must also add `person_id` column to the `user_roles` table.

