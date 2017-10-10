# RicAttachment

RicAttachment provides model and controllers for saving and retrieving file attachments for different objects in the application. Multiple (save) backends are provided for common WYSIWYG editors such as Froala Editor or TinyMCE. 

## Installation

Add gem to your Gemfile:

```ruby
gem "ric_attachment"
```

Mount routing engine in your `routes.rb` file:

```ruby
mount RicAttachment::Engine => "/", as: :ric_attachment
```

## Configuration

You can configure module through `config/initializers/ric_attachment.rb` file:

```ruby
RicAttachment.setup do |config|
    config.enable_slugs = true
end
```

Available options:

- attachment_model
- enable_slugs

## Subject

Each attachment can be binded to subject which creates a scope in which the attachment is managed. Subject association is set as polymorphic so there is posiibility to bind attachment to different subjects.

## Slugs

Attachments can be suggified during save operation. In order to make it work you must integrate RicUrl module and set configuration option `enable_slugs` to `true`. Binded subjects must be slug generators too (must provide `compose_slug_translation` method).

