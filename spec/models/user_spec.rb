# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { create(:user) }

    it { is_expected.to have_many(:rooms) }

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_presence_of(:provider) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password_confirmation) }
    it { is_expected.to validate_uniqueness_of(:email).scoped_to(:provider).case_insensitive }

    context 'password confirmation' do
      let(:valid_user) do
        {
          name: Faker::Name.name,
          email: Faker::Internet.email,
          provider: 'greenlight',
          password: 'Password123+',
          password_confirmation: 'Password123+'
        }
      end

      it 'validate the record for confirmed password' do
        user = described_class.new valid_user
        expect(user).to be_valid
      end

      it 'invalidate the record for mismatched password confirmation' do
        user = described_class.new valid_user
        user.password_confirmation = "#{user.password}extra"
        expect(user).to be_invalid
        expect(user.errors.first.details).to eq({ error: :confirmation, attribute: 'Password' })
      end
    end
  end
end
