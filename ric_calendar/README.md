# Ric Calendar

Ric Calendar adds ability to models to be schedulable in time.

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