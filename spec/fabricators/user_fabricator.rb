Fabricator :user do
  email { Faker::Internet.email }
  password 'password'
  password_confirmation 'password'
  full_name { Faker::Name.name }
  admin false
  costumer_token { Faker::Lorem.words(1).join }
  active true
end

Fabricator :admin, from: :user do
  admin true
end