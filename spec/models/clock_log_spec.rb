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

    context 'with clocked_in_at date in future' do
      subject { build(:clock_log, clocked_in_at: 10.minutes.after) }

      it { is_expected.not_to be_valid }
    end

    context 'with clocked_out_at date in future' do
      subject { build(:clock_log, clocked_out_at: 10.minutes.after) }

      it { is_expected.not_to be_valid }
    end

    context 'with clocked in after clocked out' do
      subject { build(:clock_log, clocked_in_at: 5.minutes.after, clocked_out_at: 10.minutes.after) }

      it { is_expected.not_to be_valid }
    end

    context 'with overlapping of other clock log events for same user' do
      subject { build(:clock_log, user: user, clocked_in_at: 35.minutes.before, clocked_out_at: 15.minutes.before) }

      let(:user) { create(:user) }

      before do
        create(:clock_log, user: user, clocked_in_at: 40.minutes.before, clocked_out_at: 30.minutes.before)
        create(:clock_log, user: user, clocked_in_at: 20.minutes.before, clocked_out_at: 10.minutes.before)
      end

      it { is_expected.not_to be_valid }
    end

    context 'with overlapping of other clock log events for different users' do
      subject { build(:clock_log, clocked_in_at: 35.minutes.before, clocked_out_at: 15.minutes.before) }

      before do
        create(:clock_log, clocked_in_at: 40.minutes.before, clocked_out_at: 30.minutes.before)
        create(:clock_log, clocked_in_at: 20.minutes.before, clocked_out_at: 10.minutes.before)
      end

      it { is_expected.to be_valid }
    end
  end
end
