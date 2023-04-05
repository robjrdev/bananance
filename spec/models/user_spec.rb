require 'rails_helper'

RSpec.describe User, type: :model do
  describe "creating new user" do
    it 'can be created with symbol, user and quantity' do
      user = User.new(email: 'test@email.com', password: 'password', first_name: 'testname', last_name: 'lastname')
      expect(user).to be_valid
    end
  end
end
