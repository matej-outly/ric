# RicUrl

With this module you can generate, manage and integrate pretty (human readable and localized) URL adresses into the web appliation. It uses DB table `slugs` on the background for storing URL translations for all supported languages.

## Installation

Add gem to your Gemfile:

```ruby
gem "ric_url"
```

Add database migrations to you application (you can modify DB structure accordingly before migrating):

    $ rake ric_url:install:migrations
    $ rake db:migrate

Mount routing engine in your `routes.rb` file:

```ruby
mount RicUrl::Engine => "/", as: :ric_url
```

## Filters

Content of DB table `slugs` can be simply segmented into several subsets with `filter` attribute. If filters are enabled, translation table loads only slugs with filter attribute matching the the current filter defined by `current_app_filter` option. With this system, you can store slugs for different application variants (subdomains) in a single DB table (if many application variants uses the same database).

```ruby
RicUrl.setup do |config|
    config.use_filter = true
    config.current_app_filter = Rails.configuration.theme # contains "subdomain1", "subdomain2", etc.
    config.available_filter_urls = {
        subdomain1: "http://subdomain1.sample.com",
        subdomain2: "http://subdomain2.sample.com",
        subdomain3: "http://subdomain3.sample.com",
        subdomain4: "http://subdomain4.sample.com",
        subdomain5: "http://subdomain5.sample.com",
        subdomain6: "http://subdomain6.sample.com",
        subdomain7: "http://subdomain7.sample.com",
        subdomain7: "http://subdomain8.sample.com",
    }
    ...
end
```

## Static slugs

You can define set of slugs which is integrated into translation tables by default (not necessary to generate it in generators). Static slugs can be configured in module configuration file:

```ruby
RicUrl.setup do |config|
    config.static_slugs = [
        { locale: "cs", original: "search", translation: "vysledky-vyhledavani" },
        { locale: "en", original: "search", translation: "search-results" },
        { locale: "cs", original: "gallery", translation: "fotogalerie" },
        { locale: "en", original: "gallery", translation: "photogallery" },
    ]
    ...
end
```

Additionaly you can define `filter` attribute in each static slugs table.

## Other configuration options

Other supported configuration options are:

- disable_default_locale
- downcase_translations

