json.array!(@logs) do |event|
  json.extract! event, :id, :created_at, :action
  json.id event.id
  json.title event.action
  json.tooltip event.action
  json.start event.created_at
  json.end event.created_at
end