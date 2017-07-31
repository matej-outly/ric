# RicPlugin

With RicPlugin you can define a set of dynamic plugins which can be activated or deactivated dynamically for different subjects (i.e. organizations). You can also define relations between defined plugins. Relations can be:

- Dependance - if one plugin is active, dependent plugin must be also active
- Exclusion - if one plugin is active, excluded plugin cannot be active

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
