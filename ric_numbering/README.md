# RicNumbering

This module can integrace custom sequence numbering to different objects in the application. This feature is very similar to autoincrement attributes in database, however this implementation supports some additional improvements:

- User can easily manage current or default number of different sequences via application interface.
- Sequences can be scoped. This means that you can model composite number sequences, for example "000204/001" where first part is number of client and the second part is a number of document created for the specific client.
- You can format the generated sequence numbers (internally represented as integer) into some fancy string.

## Installation

Add gem to your Gemfile:

```ruby
gem "ric_numbering"
```

Add database migrations to you application (you can modify DB structure accordingly before migrating):

    $ rake ric_numbering:install:migrations
    $ rake db:migrate

## Configuration

You can configure module through `config/initializers/ric_numbering.rb` file:

```ruby
RicNumbering.setup do |config|
    config.sequence_refs = [:sample, :document]
    config.sequence_formats = {
        sample: "%06d",
        document: "%03d"
    }
end
```

Available options:

- sequence_model
- sequence_refs - array of available sequence refs
- sequence_formats - specification of "sprintf" format strings used to format each sequence

## Usage

### Simple numbering

If you want your model to be numbered, you have to do the following steps. First ensure that your model contains integer attribute called `number`.

```ruby
add_column :samples, :number, :integer
```

Then include correct concern into your model and define mandatory and optional helper functions:

```ruby
class Sample < ActiveRecord::Base
    include RicNumbering::Concerns::Models::Numbered

    def sequence_owner
        self.organization
    end

    def sequence_ref
        :sample
    end

    ...
end
```

One time numbering will be performed together with `create` or `update` action (in case `number` attribute is not set).

Helper method `sequence_ref` is mandatory. If you return `nil` value, numbering will be ignored for the time being.

Hepler method `sequence_owner` is optional. You can provide object implementing `sequences` method. Usualy the owner model implements this association:

```ruby
class Organization < ActiveRecord::Base
    has_many :sequences, class_name: "RicNumbering::Sequence", dependent: :destroy, as: :owner
```

### Scoped numbering

If you want your model to be numbered in scope of other numbered model, you have to do the following. First ensure that your model contains integer attribute called `number` (see previous capter).

Then include correct concern into your model and define mandatory and optional helper functions:

```ruby
class Document < ActiveRecord::Base
    
    belongs_to :sample

    ...

    include RicNumbering::Concerns::Models::Numbered

    def sequence_owner
        if self.sample
            return self.sample.organization
        else
            return nil
        end
    end

    def sequence_ref
        if self.sample
            return :document
        else
            return nil
        end
    end

    def sequence_scope
        if self.sample
            return self.sample
        else
            return nil
        end
    end

    ...
end
```

Optional helper method `sequence_scope` must return numbered model which will be used for scoping of the `document` sequence.


