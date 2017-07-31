# RicOrganization

RicOrganization module creates a network of organizations which are related through different relation types. These relations can be defined for instance:

- producer / consumer
- teacher / student
- etc.

We recommend to couple this module with the RicUser module. With this, system users can be effectively scoped into the created organizations. In addition, a structure of assignments can be created inside of the organization and users can be scoped to the assignments.

## RicUser coupling

You can couple this module with RicUser. Organizations acts as "people" in this coupling model. Organization model is associated with the User model through UserAssignment model which is also part of RicOrganization module. It means that user has and belongs to many organizations, so RicUser module must be configured accordingly. UserAssignment replaces standard UserPerson model defined in the RicUser module. Full RicUser configuration looks like this:

```ruby
RicUser.setup do |config|
    config.user_person_association = :many_users_many_people
    config.user_person_model = "RicOrganization::UserAssignment"
    ...
end
```

