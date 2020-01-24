# frozen_string_literal: true

# DateTime attribute validator to check if datetime value in the past.
class BeforeNowValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    return unless record[attribute].present?

    record.errors[attribute] << (options[:message] || "can't be in the future!") if record[attribute] >= DateTime.now
  end
end
