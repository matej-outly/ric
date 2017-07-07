# RicException

This module handles all application exceptions, displays correct error pages to the user and send e-mail notifications to the development support contact.

## Instalation

Gem must be included into the `Gemfile`:

```ruby
gem "ric_exception"
```

Additionaly you must connect correct exception app in the `application.rb` config file:

```ruby
# Use RicException as exceptions app
config.exceptions_app = RicException::Engine
```

## Configuration



## Custom views

In case you want to define your custom views, you must override these view templates:

- `views/ric_exception/exceptions/internal_error.html.erb`
- `views/ric_exception/exceptions/not_found.html.erb`
- `views/ric_exception/exceptions/unacceptable.html.erb`