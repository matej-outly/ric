# RicAuth

RicAuth manages standard functionality connected to user authentication. It is a wrapper around gem Devise, adds some custom views, views for admin access, extensions and supports OmniAuth integration. 

This document describes how to correctly integrate the module into the application. It works with two optionalities:

1. OmniAuth integration - users can authenticate via Facebook, Twitter and other OmniAuth services.
2. Admin access - authentication screens exists in two different versions - first for regular users, screens are in application layout, second for administrators, screens are in admin layout (typically RuthAdmin).

## Prerequisities

In many cases RicUser module is used for user management. Anyway, you can integrate it with your custom made user model without any problem.

In case of admin access optionality, RuthAdmin module should be integrated.

Also RicNotification module should be integrated. This module is necessary for RicAuth::Mailer.

## Gemfile

Following gems must be added to application Gemfile:

```ruby
# Authentication
gem "devise"
```

In case of OmniAuth integration, also these gems must be added:

```ruby
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-twitter" # etc ...
```

And of course gem of Ric modules:

```ruby
gem "ric_auth"
gem "ric_auth_admin" # In case of admin access optionality
```

## Devise configuration

Devise configuration must be added to `config/initializers/devise.rb`:

```ruby
Devise.setup do |config|
    require "devise/orm/active_record"
    config.mailer = "RicAuth::Mailer" # In case you want to use RicNotification for mailing
    config.case_insensitive_keys = [:email]
    config.strip_whitespace_keys = [:email]
    config.skip_session_storage = [:http_auth]
    config.stretches = Rails.env.test? ? 1 : 10
    config.reconfirmable = false
    config.expire_all_remember_me_on_sign_out = true
    config.password_length = 6..72
    config.reset_password_within = 6.hours
    config.sign_out_via = :delete
    config.warden do |manager|
        require "ric_auth/failure_app"
        manager.failure_app = RicAuth::FailureApp
    end
end
```

## OmniAuth configuration

In case of OmniAuth integration, OmniAuth configuration must be provided in `config/initializers/omniauth.rb` file:

```ruby
OmniAuth.config.logger = Rails.logger
Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, "...facebook key...", "...facebook secret..."
end
```

## DB table

In case of OmniAuth integration, `authentications` DB table must be created:

```
rake ric_auth:install:migrations
rake db:migrate
```

## Routes

```ruby
mount RicAuth::PublicEngine => "/auth", as: :ric_auth
mount RicAuthAdmin::Engine => "/admin/auth", as: :ric_auth_admin # In case of admin access optionality

# Must be defined otherwise RicAuth devise routes not working
devise_for :users, class_name: "RicUser::User", module: :devise
```

## Notifications

In case you want to use RicNotification module for mailing, it is ncessary to add the following notification template keys into RicNotfication configuration:

- user_new_password
- user_confirmation
- user_reset_password

These templates should be correctly defined in DB/admin interface.

## User model

In case you define custom user model or redefine user model provided by RicUser module, you must include these concerns:

```ruby
class User < ActiveRecord::Base
    include RicAuth::Concerns::Models::Devisable
    include RicAuth::Concerns::Models::Omniauthable # In case of OmniAuth integration
```

## OmniAuth login button

In case of OmniAuth integration tou can define login button like this:

```html
<a href="/auth/facebook">Login using Facebook</a>
```

## Role overriding

If user interface is designed just for one (static) role (person association) but one user can obtain multiple roles (people associations) user should be able to switch between defined roles. This functionality is integrated to RicAuth module. All you need to do is to provide `can_override_role` attribute on the User model. It can be done statically:

```ruby
module RicUser
    class User < ActiveRecord::Base
        ...

        # *********************************************************************
        # Overrides
        # *********************************************************************

        def can_override_role
            true
        end

    end
end
```

Alternatively you can add column `can_override_role` to the `users` DB table and enable role switching only for selected users.

## User overriding

This feature enables the system administrator to work with the application as a different user. The feature is integrated to the RicAuth module. All you need to do is to provide `can_override_user` attribute on the User model. It can be done with `can_override_user` column in the `users` DB table so you can enable this feature only for selected users. 

