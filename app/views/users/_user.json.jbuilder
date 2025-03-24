json.extract! user, :id, :name, :last_name, :rut, :phone, :email, :created_at, :updated_at
json.url user_url(user, format: :json)
