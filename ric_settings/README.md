# RicSettings

With this module you can define global settings stored in DB so it can be modified by system administrator.

## Basic instalation

Include module to Gemfile:

```ruby
gem "ric_setings"
```

Install DB migrations with `rake ric_settings:install:migrations` and run migrations with `rake db:migrate`.

Finally create `models/ric_setings/settings_collection.rb` file and define available settings in here:

```ruby
module RicSettings
    class SettingsCollection
        include ActiveModel::Model
        include RicSettings::Concerns::Models::SettingsCollection

        #
        # Define available settings
        #
        setting "setting1", :string, "category1"
        setting "setting2", :integer, "category1"
        setting "setting3", :enum, "category3", values: ["value1", "value2", "value3"]

    end
end
```

You should define correct translations for your settings in your `config/locales/*.yml` files:

```yml
activerecord:
    attributes:
      ric_settings/settingscollection:
        category_values:
          category1: Kategorie X
          category2: Kategorie Y
          category3: Kategorie Z
        setting1: Nastavení X
        setting2: Nastavení Y
        setting3: Nastavení Z
        setting3_values:
          value1: Hodnota Z1
          value2: Hodnota Z2
          value3: Hodnota Z3
```

## Administration interface

To access administration interface you must mount engine in `routes.rb`:

```ruby
mount RicSettings::Engine => "/admin", as: :ric_settings
```

Now administration interface is accessible over `/admin/settings` URL. Don't forget to add authentication, authorization and correct layout by overriding `controllers/ric_settings/application_controller.rb` file.

## Usage

You can read defined settings with view helper `setting_get`:

```html
<%= setting_get("setting1") %>
...
<%= setting_get("setting2") %>
```
