FactoryBot.define do
  factory :review do
    content_rating { 10 }
    recommend_rating { 8 }
    average_rating { 9 }
    association :user, factory: :user
    association :book, factory: :book
  end
end
