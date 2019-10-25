FactoryBot.define do
  factory :user do
    sequence(:email) { Faker::Internet.email }
    password { "123123" }
    password_confirmation { "123123" }
    sequence(:authentication_token) { SecureRandom.urlsafe_base64 }
  end
end
