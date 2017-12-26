# RicException

This module handles all application exceptions, displays correct error pages to the user and send e-mail notifications to the development support contact.

## Instalation

Gem must be included into the `Gemfile`:

```ruby
gem "ric_exception"
```

Additionaly you must connect correct exception app in the `application.rb` config file:

```ruby
config.exceptions_app = RicException::Engine
```

## E-mail notifications

Module can automatically send notification e-mails to developer support contact. Only internal errors are sent. Mailing can be activated by setting `mailer_sender` and `mailer_receiver` options in the module configuration file (`ric_exception.rb`):

```ruby
RicException.setup do |config|
    config.mailer_sender = "no-reply@sample.com"
    config.mailer_receiver = "support@developer.com"
    ...
end
```

## Custom layout

Youe can define your custom layout for exceptions in the module configuration file (`ric_exception.rb`):

```ruby
RicException.setup do |config|
    config.layout = "ruth_application_exception"
    ...
end
```

## Custom views

You can define your custom views displayed to user when error occures. In order to achieve this, you must override following view templates:

- `views/ric_exception/exceptions/not_found.html.erb`
- `views/ric_exception/exceptions/unacceptable.html.erb`
- `views/ric_exception/exceptions/internal_error.html.erb`

## Testing

You can test appearence of error pages by setting this to `routes.rb`:

```ruby
mount RicException::Engine => "/error"
```

Then you find the error pages on the following URLs:
- `http://localhost:3000/error/404`
- `http://localhost:3000/error/422`
- `http://localhost:3000/error/500`

## Known bugs and future features

- [ ] Should check for multiple sending of similar error message - to prevent SMTP overflow - once for 10 minutes
