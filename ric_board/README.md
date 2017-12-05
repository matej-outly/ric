# RicBoard

This module implements framework for application dashboard definition. Dashboard is a bunch of panels and tickets composed into a grid layout. A set of displayed panels and tickets is defined by currently signed user and it's user role.

## Installation

Add gem to your Gemfile:

```ruby
gem "ric_board"
```

Add database migrations to you application (you can modify DB structure accordingly before migrating):

    $ rake ric_board:install:migrations
    $ rake db:migrate

Mount routing engine in your `routes.rb` file:

```ruby
mount RicBoard::Engine => "/", as: :ric_board
```

You can route your root to RicBoard dashboard with this route:

```ruby
root "ric_board/boards#show"
```

## Configuration

You can configure module through `config/initializers/ric_board.rb` file:

```ruby
RicBoard.setup do |config|
    ...
end
```

Available options:

- board_ticket_model
- board_ticket_types
- group_board_tickets
- use_person

## Board tickets

Ticket is a dashboard element representing a single event. Its pupose is to notify signed user about some events or critical informations which occured in the application. It doesn't contain any message, only reference to ticketable object.

Ticket is always associated with some ticketable object in the application. It's created together with some action on the associated object - create, update or destroy. Ticketable objects can be defined:

```ruby
class Sample < ActiveRecord::Base
    include RicBoard::Concerns::Models::Ticketable

    def board_ticket_params
        {
            date: self.some_date_field, # Nil for closable tickets or Date object
            owner: self.some_owner, # Single owner or array of owners
            create: false, # Possible to disable create action
            update: false, # Possible to disable update action
            destroy: false, # Possible to disable destroy action
            key: "samples", # Optional if key can't be derived from subject class name
        }
    end

    ...
end
```

Tickets are created or destroyed automatically based on passed owners. Ticket can be (based on parameter `date`, see comments in example) either dated or closable:

- Dated - Associated with some date in the future and not manualy closable by the user.
- Closable - Not associated with a specific date but manually closable by user.

### Ticket display

You should define a view template to display a ticket of some kind (based on ticketable object class name of passed key). All ticket templates are saved in `views/ric_board/borad_tickets` directory.

When displaying a single ticket you should dig for more information about the event in the associated ticketable object. Example template `views/ric_board/borad_tickets/samples.html.erb` can look like:

```erb
<% if board_ticket.subject %>
    <% sample = board_ticket.subject %>
    <div class="ticket-heading">
        <strong><%= board_ticket.date.strftime("%-d. %-m. %Y") %></strong> /
        <%= sample.title %>
    </div>
    <div class="ticket-body">
        <strong><%= rug_format_enum(sample.kind, object: sample, column: :kind) %></strong> - 
        <%= sample.text %>
    </div>
<% end %>
```

## Board panels


## Layout



