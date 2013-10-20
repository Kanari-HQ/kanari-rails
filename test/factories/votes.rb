FactoryGirl.define do
  factory :vote do
    vote_type "im-confused"
    created_at { Time.now }
  end
end