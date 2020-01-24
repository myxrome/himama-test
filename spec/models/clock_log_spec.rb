# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClockLog, type: :model do
  describe 'valid factory' do
    it 'has a valid factory' do
      expect(build(:clock_log)).to be_valid
    end
  end

  describe 'validations' do
    describe 'presence validations' do
      subject { build(:clock_log) }

      it { is_expected.to validate_presence_of :user }
      it { is_expected.to validate_presence_of :clocked_in_at }
    end
  end
end
