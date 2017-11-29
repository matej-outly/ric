# RicDms

This module implements simple document management system. Folder structure can be created, files can be uploaded and presented under different access policies. Documents are automatically versioned when new version of the document is uploaded.

## Installation

Add gem to your Gemfile:

```ruby
gem "ric_dms"
```

Add database migrations to you application (you can modify DB structure accordingly before migrating):

    $ rake ric_dms:install:migrations
    $ rake db:migrate

Mount routing engine in your `routes.rb` file:

```ruby
mount RicDms::Engine => "/", as: :ric_dms
```

## Configuration

You can configure module through `config/initializers/ric_dms.rb` file:

```ruby
RicDms.setup do |config|
    ...
end
```

Available options:

- document_model
- document_version_model
- document_folder_model