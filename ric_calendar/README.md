# RicCalendar

Ric Calendar adds ability to models to be schedulable in time. These models then become events, which can be both non-repeating and recurring.

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

Each model implementation, must include `Schedulable` concern:

```ruby
include RicCalendar::Concerns::Models::Schedulable
```

From now, it has method `schedule(start_date, end_date)`, which returns scheduled
events. The result is an array of schedulable hashes in the form:

```ruby
{
	event: event, # Instance of "parent" class with event information
	start_date: Date,
	start_time: Time,
	end_date: Date,
	end_time: Time,
	all_day: boolean, # Is it the event all day?
	is_recurring: false, # Always false for non-recurring events
}
```

## Recurring events

In addition to classic events, recurring evens must have these columns:

```ruby
# Recurrence rule
t.text :recurrence_rule, null: true

# Is it generated?
t.integer :source_event_id, null: true
```

It is necessary to add also `Recurring` concern into model:

```ruby
include RicCalendar::Concerns::Models::Recurrenting
```

There is no other steps needed, `schedule` method now returns also recurring events.
Result structure has `is_recurring` attribute set to `true` for recurring events.

## Calendars

Calendars are backbone for viewing events. Each model can implement optional
`calendar_id` attribute, which is foreign key into `calendars` table. Calendars
table has at least these columns:

```ruby
# Model
t.string :model

# If editable, path to controller (such as "event_path")
t.string :edit_action, null: true

# Color
t.string :color

```

Each row represents one calendar with its own attributes, such as color.

The meaning is:
- `:model` - name of model, ie. `"RicCalendar::Event"`
- `:edit_action` - if `null`, it is not possible to edit events in Fullcalendar by
  drag&drop. If you want enable this feature, fill the path to appropriate edit
  controller. Will be explained bellow. Example `"event_path"`
- `:color` - color of calendar (CSS style) or `null` to use default. Example `"#fff"`


## Editing events by drag&drop in Fullcalendar

Editing events is enabled for whole calendar by filling `edit_action` column, which
must points to special update action of controller. To enable drag&drop editing
for your model, the simpliest way is to include `UpdateScheduleAction` concern
into your controller:

```ruby
include RicCalendar::Concerns::Controllers::UpdateScheduleAction
```

Also don't forget to set appropriate route:

```ruby
resources :my_controller do
	member do
		patch "update_schedule"
	end
end
```

And fill `edit_action` in database for calendar, which supports editing.

## Known bugs and issues

- Impossible to update schedule for all-day events
- Necessary to remove end_date input in event form and substitude it with datetime_range...
- Impossible to stretcj non-all-day event acros more days / maybe correct behavior
- Calendar state (page, view) stored in JavaScript storage
- Create new event from calendar with predefined date, edit event, destroy event from calendar
- Calendars filter - switch on/off shown calendars
- Validity from-to
- Validate start_date/start_time < end_date/end_time