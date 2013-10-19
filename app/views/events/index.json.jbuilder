json.array!(@events) do |event|
  json.extract! event, :title, :event_code, :soundcloud_url, :start_time, :end_time
  json.url event_url(event, format: :json)
end
