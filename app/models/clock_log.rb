# frozen_string_literal: true

# User Clock Logs record class
class ClockLog < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :clocked_in_at, presence: true
end
