json.array!(@users) do |user|
  json.extract! user, :id, :firstname, :lastname, :username, :email, :joined, :last_signin, :available, :password_digest
  json.url user_url(user, format: :json)
end
