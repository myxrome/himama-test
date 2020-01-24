# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'valid factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end

  describe 'validations' do
    subject { build(:user) }

    describe 'presence validations' do
      it { is_expected.to validate_presence_of :email }
    end

    describe 'uniqueness validations' do
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end
  end

  describe 'devise' do
    let(:password) { Faker::Internet.password }
    let(:user) do
      create(:user, password: password, password_confirmation: password)
    end

    it 'is database authenticable' do
      expect(user).to be_valid_password(password)
    end
  end
end
