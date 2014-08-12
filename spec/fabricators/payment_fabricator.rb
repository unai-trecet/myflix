Fabricator :payment do
  user_id { (1..100).to_a.sample }
  amount 999
  reference_id { Faker::Lorem.words(1).join }
end