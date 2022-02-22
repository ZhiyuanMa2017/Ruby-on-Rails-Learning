json.extract! user, :id, :name, :email, :password_digest, :remeber_digest, :major, :department, :phone_number, :birthday, :admin, :teacher, :created_at, :updated_at
json.url user_url(user, format: :json)
