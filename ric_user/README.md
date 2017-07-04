# RicUser

Highly configurable basis for users and roles management. Users can be additionaly related to some other objects (people) with different structural models.

## Roles

User can be related to roles with several types of relation:

- User doesn't belong to any role
- User belongs to one role - in this case only `role` of `role_id` column is present in the `users` DB table.
- User has and belongs to many roles - in this case DB table `user_roles` is used to store for this mapping.

Roles can be defined:

- Staticaly in configuration via `roles` configuration option.
- Dynamicaly in the DB table `roles`.

## People

Different models in the application can act like a person. It can be for instance Customer, Student, Teacher, Organization, etc. Even more than one people types can be defined in the application. User can be related to some person with several types of relation:

- User doesn't belong to any person
- Person with single user, user has max one person associated (model 1) - this model enforces that user belongs to one role.
- Person with single user, user has multiple people associated (model 2) - this enforces that user has and belongs to many roles.
- Person with multiple users, user has max one person associated (model 3) - this model enforces that user belongs to one role.
- Person with multiple users, user has multiple people associated (model 4).

## People selectors

This mechanism allows to bind a large number of people/user to some object in the application with a single database record. It can be used for receivers of bulk messages, for example. 

Selectors can be defined in the `app/models/ric_user/people_selector.rb` file:

```ruby
module RicUser
    class PeopleSelector < ActiveRecord::Base
        include RicUser::Concerns::Models::PeopleSelector

        # Define selector
        define_selector :one_teacher, {

            # Select function - DB query selecting valid people expected to be returned
            select: lambda { |params|
                Teacher.where(id: params[:id])
            },
           
            # Search function - [ {some_param: value, ...}, {some_param: value, ...}, ... ] defining valid selector params expected to be returned
            search: lambda { |query|
                Teacher.where("(lower(unaccent(name_lastname)) LIKE ('%' || lower(unaccent(trim(:query))) || '%'))", query: query).map { |person| { id: person.id } }
            },
           
            # Selector title - title uniquely identifying selector with given params expected to be returned
            title: lambda { |params|
                "Učitel: #{Teacher.find_by(id: params[:id])}"
            }

        }

        # Define selector
        define_selector :all_teachers, {

            # Select function - DB query selecting valid people expected to be returned
            select: lambda { |params|
                Teacher.all
            },
           
            # Search function - [ {some_param: value, ...}, {some_param: value, ...}, ... ] defining valid selector params expected to be returned
            search: lambda { |query|
                if "Všichni učitelé".unaccent.downcase.include?(query.unaccent.downcase)
                    [nil]
                else
                    []
                end
            },
           
            # Selector title - title uniquely identifying selector with given params expected to be returned
            title: lambda { |params|
                "Všichni učitelé"
            }
            
        }

    end
end
```
