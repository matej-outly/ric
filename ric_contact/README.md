# RicContact

## Installation

Add gem to your Gemfile:

```ruby
gem "ric_contact"
```

Add database migrations to you application (you can modify DB structure accordingly before migrating):

    $ rake ric_contact:install:migrations
    $ rake db:migrate

Mount routing engine in your `routes.rb` file:

```ruby
mount RicContact::PublicEngine => "/", as: :ric_contact_public
mount RicContact::AdminEngine => "/admin", as: :ric_contact_admin
```

## Configuration

You can configure module through `config/initializers/ric_contact.rb` file:

```ruby
RicContact.setup do |config|
    ...
end
```

Available options:

- contact_message_model
- contact_message_mailer
- save_contact_messages_to_db
- send_contact_messages_copy_to_author
- send_contact_messages_notification_to_author
- contact_message_attributes
- contact_message_receivers
- mailer_sender
- mailer_sender_name
- mailer_receiver
- recaptcha
- recaptcha_attribute

## reCAPTCHA

```ruby
Recaptcha.configure do |config|
    config.site_key   = "6LcTEDgUAAAAABC20zEgqqitk1mR7ss9S2Hfj3Sy"
    config.secret_key = "6LcTEDgUAAAAAGK5sAnV5DGuALxdn4t0qy50ph-2"
end
```

```ruby
def save_with_recaptcha
    (user_signed_in? || use_recaptcha != true || verify_recaptcha(model: @sample, attribute: :recaptcha)) && @sample.save
end
```

### Simple tag

```erb
<%= recaptcha_tags %>
```

### Multiple tags on one page

```js
var recaptchaOnload = function() {
    ['recaptcha-1', 'recaptcha-2'].forEach(function(elementId) {
        var element = document.getElementById(elementId);
        if (element) {
            grecaptcha.render(element, {
                'sitekey' : '<%= Recaptcha.configuration.site_key %>'
            });
        }
    });
};
```

```erb
<script src="https://www.google.com/recaptcha/api.js?onload=recaptchaOnload&render=explicit" async defer></script>
```

```erb
<div id="recaptcha-1" class="recaptcha"></div>
```