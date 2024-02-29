json.extract! event, :id, :name, :eventDate, :location, :created_at, :updated_at
json.url event_url(event, format: :json)
