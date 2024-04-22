require 'rails_helper'

RSpec.describe User, type: :model do
  before :all do
    @client = FactoryBot.create(:client)
    @c_model = FactoryBot.create(:user, client: @client, username: '山田太郎')
  end

  # database crud
  describe 'database crud' do
    # create
    it 'create' do
      expect(@c_model.save).to eq(true)

      expect(User.find(@c_model.id)).to have_attributes(
        client_id: @c_model.client_id,
        username: '山田太郎',
        password: nil,
        active: false
      )
    end

    # update
    it 'update' do
      model = User.find(@c_model.id)
      model.password = '12345'
      model.password_confirmation = '12345'
      expect(model.save).to eq(true)
      expect(User.find(@c_model.id)&.authenticate('12345'))
    end

    # delete
    it 'delete' do
      model = User.find(@c_model.id)
      m = model.destroy

      expect(m.username).to eq('山田太郎')
      expect(User.where(id: @c_model.id).count).to eq(0)
    end
  end

  # validation
  describe 'validation' do
    # valid with username, password, active and client_id
    it 'valid with username, password, active and client_id' do
      model = FactoryBot.build(:user, client: @client)

      expect(model).to be_valid
    end

    # invalid required username and password ユーザー登録
    it 'invalid required for username and password ユーザー登録' do
      model = FactoryBot.build(
        :user,
        username: nil,
        password: nil
      )

      model.valid?([:user])

      expect(model.errors.where(:username).first.type).to eq(:blank)
      expect(model.errors.where(:password).first.type).to eq(:blank)
      expect(model.save).to eq(false)
    end

    # invalid duplicate for username
    it 'invalid duplicate for username' do
      FactoryBot.create(:user, username: '有村太郎')
      model = FactoryBot.build(:user, username: '有村太郎')

      model.valid?

      expect(model.errors.where(:username).first.type).to eq(:taken)
      expect(model.save).to eq(false)
    end
  end
end
