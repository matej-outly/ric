# RicTagging

## Installation

Add gem to your Gemfile:

```ruby
gem "ric_tagging"
```

Add database migrations to you application (you can modify DB structure accordingly before migrating):

    $ rake ric_tagging:install:migrations
    $ rake db:migrate

Mount routing engine in your `routes.rb` file:

```ruby
mount RicTagging::Engine => "/", as: :ric_tagging
```

## Configuration

You can configure module through `config/initializers/ric_tagging.rb` file:

```ruby
RicTagging.setup do |config|
    ...
end
```

Available options:

- tag_model

## Usage

If you want to integrate tagging to your model, you must do the following:

```ruby
class Sample < ActiveRecord::Base
    
    ...

    acts_as_taggable

    # *********************************************************************
    # Columns
    # *********************************************************************
    
    def self.permitted_columns
        return [
            ...
            :tag_ids,
            ...
        ]
    end

    def self.process_params(params)
        params[:tag_ids] = params[:tag_ids].split(",") if params[:tag_ids] && params[:tag_ids].is_a?(String)
        ...
        params
    end

    # *********************************************************************
    # Tag objects
    # *********************************************************************

    def tag_objects
        @tag_objects ||= RicTagging.tag_model.joins("INNER JOIN taggings ON taggings.tag_id = tags.id").where("taggings.taggable_id = ? AND taggings.taggable_type = ?", self.id, self.class.to_s)
    end

end
```

Now you can use this element in the form:

```erb
<%= f.token_input_row :tag_ids, ric_tagging.search_tags_path, as: :tags, value_attr: :id, label_attr: :name %>
```
