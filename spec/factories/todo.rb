FactoryBot.define do
  factory :todo do
    title {Faker::Lorem.characters(10)}
  end
end