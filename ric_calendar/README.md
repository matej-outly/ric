# Ric Calendar

Ric Calendar adds ability to models to be schedulable in time. These models then
became events, which can be both non-repeating or recurring.

Calendar widget is based on `Fullcalendar.io`. These gems are needed for proper
function:

```ruby
# Calendar
gem 'fullcalendar.io-rails'

#
# For recurring events:
#

# Schedule
gem 'ice_cube'

# Form widget
gem 'recurring_select'
```

## Classic (non-repeating) events

Non-repeating model must have these columns:

```ruby
# Event start
t.date :start_date, index: true
t.time :start_time, null: true

# Event end
t.date :end_date, index: true
t.time :end_time, null: true

# All day
t.boolean :all_day

```

## Recurring events

In addition to classic events, recurring evens must have these columns:

```ruby
# Recurrence rule
t.text :recurrence_rule, null: true

# Is it generated?
t.integer :source_event_id, null: true
```

## Calendars

Calendars are backbone for viewing events. Each model can implement optional
`calendar_id` attribute, which is foreign key into `calendars` table. Calendars
table has at least these columns:

```ruby
# Model
t.string :model

# If editable, path to controller (such as "calendar_event_path")
t.string :edit_action, null: true

# Color
t.string :color

```

Each row represents one calendar with its own attributes, such as color.

The meaning is:
- `:model` - name of model, ie. `"RicCalendar::CalendarEvent"`
- `:edit_action` - if `null`, it is not possible to edit events in Fullcalendar by
  drag&drop. If you want enable this feature, fill the path to appropriate edit
  controller. Will be explained bellow. Example `"calendar_event_path"`
- `:color` - color of calendar (CSS style) or `null` to use default. Example `"#fff"`


## Editing events by drag&drop in Fullcalendar

Editing events is enabled for whole calendar by filling `edit_action` column, which
must points to special update action of controller.