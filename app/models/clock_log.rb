# frozen_string_literal: true

# User Clock Logs record class
class ClockLog < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :clocked_in_at, presence: true, before_now: true
  validates :clocked_out_at, before_now: true
  validate :clocked_in_before_clocked_out
  validate :clock_log_without_overlap

  def clocked_in_before_clocked_out
    return unless clocked_out_at.present?

    errors.add(:clocked_in_at, "Clocked In event can't be after Clocked out!") if clocked_in_at > clocked_out_at
  end

  def clock_log_without_overlap
    errors.add(:clocked_in_at, 'Clocked In event overlapped with another Clock Log!') if ClockLog.where(
      'user_id = :user_id AND :clocked_in_at BETWEEN clocked_in_at AND clocked_out_at',
      user_id: user_id,
      clocked_in_at: clocked_in_at
    ).any?
    errors.add(:clocked_out_at, 'Clocked Out event overlapped with another Clock Log!') if ClockLog.where(
      'user_id = :user_id AND :clocked_out_at BETWEEN clocked_in_at AND clocked_out_at',
      user_id: user_id,
      clocked_out_at: clocked_out_at
    ).any?
  end
end
