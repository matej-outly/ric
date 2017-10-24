# RicPerson

## People

Different models in the application can act like a person. It can be for instance Employee, Customer, Student, Teacher or even whole Organization, etc. Even more than one people types can be defined in the application.

## Installation

## Usage



## Not implemented

(Not implemented) User can be related to some person with several types of relation:

- User doesn't belong to any person
- Person with single user, user has max one person associated (model 1) - this model enforces that user belongs to one role.
- Person with single user, user has multiple people associated (model 2) - this enforces that user has and belongs to many roles but only one role is associated with one person. Roles and people are mapped together through the similarity of the role "ref" and people's class name (i.e. role "student" mapped to "Student" model).
- Person with multiple users, user has max one person associated (model 3) - this model enforces that user belongs to one role. Roles and people are mapped together through the similarity of the role "ref" and people's class name (i.e. role "student" mapped to "Student" model).
- Person with multiple users, user has multiple people associated (model 4).

## People selectors

This mechanism allows you to bind a large number of people/users to some object in the application with a single database record. For example it can be used for receivers of bulk messages. 

Selectors can be defined in the `app/models/ric_person/people_selector.rb` file:

```ruby
module RicPerson
    class PeopleSelector < ActiveRecord::Base
        include RicPerson::Concerns::Models::PeopleSelector

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
