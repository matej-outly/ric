# RicNotification

With this module you can create notifications based on templates defined by the system administrator and send it in a batch with different delivery methods:

- E-mail
- SMS (RicSms module necessary)
- Mailboxer (RicMailboxer module necessary)

## Installation

Add gem to your Gemfile:

```ruby
gem "ric_notification"
```

Add database migrations to you application (you can modify DB structure accordingly before migrating):

    $ rake ric_notification:install:migrations
    $ rake db:migrate

Mount routing engine in your `routes.rb` file:

```ruby
mount RicNotification::Engine => "/", as: :ric_notification
```

## Configuration

You can configure module through `config/initializers/ric_notification.rb` file:

```ruby
RicNotification.setup do |config|
    config.mailer_sender = "no-reply@domain.com"
    config.delivery_kinds = [
        :email
    ]
    config.template_refs = [
        :user_new_password,
    ]
end
```

Available options:

- notification_model
- notification_delivery_model
- notification_receiver_model
- notification_template_model
- mailer_sender
- delivery_kinds
- template_refs

## Known bugs

- [ ] Repeated delivery if marked as "sent" not working - should remove the "sent" flag and deliver
