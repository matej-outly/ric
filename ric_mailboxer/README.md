# RicMailboxer

This module implements in-application messaging system. Backend of the module is based on `mailboxer` gem (https://github.com/mailboxer/mailboxer). Frontend implements controllers and views for displaying inbox and trashed conversations and for message composition.

## Prerequisities

If you want to connect in-application messaging with other communication services like e-mail of SMS service, you should intgrate `RicNotification` module to your application.

## Installation

Following gem must be added to the application Gemfile:

```ruby
gem "mailboxer"
```

And also RIC module gem must be included:

```ruby
gem "ric_mailboxer"
```

Add database migrations to you application:

    $ rake ric_mailboxer:install:migrations
    $ rake db:migrate

Alternatively you can user mailboxer install task. This should create the same migrations and adds mailboxer initializer to the application configuration:

    $ rails g mailboxer:install
    $ rake db:migrate

Mount routing engine in your `routes.rb` file:

```ruby
mount RicMailboxer::Engine => "/", as: :ric_mailboxer
```

## Mailboxer configuration

Mailboxer configuration must be added to `config/initializers/mailboxer.rb`:

```ruby
Mailboxer.setup do |config|
    config.uses_emails = false # Don't use standard emails
    config.email_method = :email # This should contain valid user e-mail address 
    config.name_method = :name_formatted # This should contain valid user name (formatted as simple string)
end
```

## RicMailboxer configuration

You can configure module through `config/initializers/ric_mailboxer.rb` file:

```ruby
RicMailboxer.setup do |config|
    ...
end
```

## Backend usage

For backend usage, please refer to the documentation of `mailboxer` gem: https://github.com/mailboxer/mailboxer

