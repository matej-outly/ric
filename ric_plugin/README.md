# RicPlugin

With RicPlugin you can define a set of dynamic plugins which can be activated or deactivated dynamically for different subjects (i.e. organizations). You can also define relations between defined plugins. Relations can be:

- Dependance - if one plugin is active, dependent plugin must be also active
- Exclusion - if one plugin is active, excluded plugin cannot be active

## Installation

Add gem to your Gemfile:

```ruby
gem "ric_plugin"
```

Add database migrations to you application (you can modify DB structure accordingly before migrating):

    $ rake ric_plugin:install:migrations
    $ rake db:migrate

Mount routing engine in your `routes.rb` file:

```ruby
mount RicPlugin::Engine => "/", as: :ric_public
```

## Configuration

You can configure module through `config/initializers/ric_plugin.rb` file:

```ruby
RicPlugin.setup do |config|
    ...
end
```

Available options:

- plugin_model
- plugin_relation_model
- subject_model

## Plugin subject

Single model defined in application can be selected as "plugin subject". It means that plugins are activated and deactivated in the scope of this model. 

Let's say that you choose RicOrganization::Organization model to act as plugin subject. In order to correctly configure RicPlugin module you must define:

```ruby
RicPlugin.setup do |config| 
    config.subject_model = "RicOrganization::Organization"
    ...
end
```

Also you include `RicPlugin::Concerns::Models::Subject` concern into the selected "subject" model:

```ruby
module RicOrganization
    class Organization < ActiveRecord::Base
        include RicOrganization::Concerns::Models::Organization
        include RicPlugin::Concerns::Models::Subject
    end
end
```
