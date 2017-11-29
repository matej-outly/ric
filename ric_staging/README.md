# RicStaging

RicStaging provides model and controllers for saving stage of different objects in the system.

## Installation

Add gem to your Gemfile:

```ruby
gem "ric_staging"
```

Add database migrations to you application (you can modify DB structure accordingly before migrating):

    $ rake ric_staging:install:migrations
    $ rake db:migrate

Mount routing engine in your `routes.rb` file:

```ruby
mount RicStaging::Engine => "/", as: :ric_staging
```

## Configuration

You can configure module through `config/initializers/ric_staging.rb` file:

```ruby
RicStaging.setup do |config|
    ...
end
```

Available options:

- stage_model

## Subject

Each stage can be binded to subject which creates a scope in which the stage is managed. Subject association is set as polymorphic so there is a possibility to bind stage to different subjects.

Staging on a subject can be enabled by including the Stagable concern:

```ruby
class Sample < ActiveRecord::Base
    include RicStaging::Concerns::Models::Stagable

    ...
end
```

## Usage

### Models

Current stage can be retrieved from stagable subject with this method:

```ruby
stage = sample.stage(:cs) # => RicStaging::Stage object
stage.stage_obj.value # => i.e. "developed"
stage.stage_obj.label # => i.e. "Rozpracováno"
```

Stage can be modified:

```ruby
stage = sample.stage(:cs) # => RicStaging::Stage object
stage.stage = "done"
stage.save
```

### Views

```erb
<%= rug_format_state(sample.stage(:cs).stage, 
    object: sample.stage(:cs), 
    column: :stage
) %>
```

```erb
<%= rug_format_state(node.stage(@locale).stage, 
    object: sample.stage(:cs), 
    column: :stage,
    format: :button,
    size: :xs,
    path: -> (unused, to) { ric_staging.transit_stages_path(subject_type: "Sample", subject_id: sample.id, locale: :cs, to: to) }
) %>
```
