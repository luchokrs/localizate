json.extract! store, :id, :name, :rut, :street_name, :ext_number, :int_number, :geolocation, :business_name, :admin_user_id, :email, :status, :created_at, :updated_at
json.url store_url(store, format: :json)
