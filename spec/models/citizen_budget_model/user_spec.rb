require 'rails_helper'

module CitizenBudgetModel
  RSpec.describe User, type: :model do
    describe '#create' do
      it 'should not require a password and send password reset instructions' do
        user = User.new(email: 'user@example.com')
        expect(user).to receive(:send_reset_password_instructions)
        expect{user.save!}.to_not raise_error
      end
    end
  end
end
