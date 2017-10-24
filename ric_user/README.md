# RicUser

Configurable basis for users and roles management.

## Roles

User can be related to roles with several types of relation:

- User doesn't belong to any role
- User belongs to one role - in this case only `role` or `role_id` column is present in the `users` DB table.
- User has and belongs to many roles - in this case DB table `user_roles` is used to store the mapping.

Roles can be defined:

- Staticaly in configuration via `roles` configuration option.
- Dynamicaly in the DB table `roles`.
