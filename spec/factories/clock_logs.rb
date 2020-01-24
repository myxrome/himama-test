# frozen_string_literal: true

FactoryBot.define do
  factory :clock_log do
    user { create(:user) }
    clocked_in_at { 30.minutes.ago }
  end
end
