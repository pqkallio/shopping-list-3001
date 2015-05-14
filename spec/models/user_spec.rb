require 'rails_helper'

describe User do
  let(:user){FactoryGirl.create(:user)}

  it "has the firstname, lastname and username set correctly" do
    expect(user.firstname).to eq("Pete")
    expect(user.lastname).to eq("Kallio")
    expect(user.username).to eq("petekallio")
  end

  it "has the email set correctly" do
    expect(user.email).to eq("petekallio@kallio.fi")
  end

  it "is saved with a proper password" do
    expect(user).to be_valid
    expect(User.count).to eq(1)
  end

  it "is not valid if the username is already in use" do
    user.save
    another_user = FactoryGirl.build(:user)

    expect(another_user).not_to be_valid
    another_user.save
    expect(User.count).to eq(1)
  end

  describe "is not saved if it misses" do
    it "firstname" do
      user = FactoryGirl.build(:user, firstname: nil)
    end

    it "lastname" do
      user = FactoryGirl.build(:user, lastname: nil)
    end

    it "username" do
      user = FactoryGirl.build(:user, username: nil)
    end
  end

  describe "The password is not valid if" do
    it "its length is less than 8" do
      user = FactoryGirl.build(:user, password:"S4l4S4n", password_confirmation:"S4l4s4n")

      expect(user).not_to be_valid
      user.save
      expect(User.count).to eq(0)
    end

    it "it has no digit" do
      user = FactoryGirl.build(:user, password:"Salasana", password_confirmation:"Salasana")

      expect(user).not_to be_valid
      user.save
      expect(User.count).to eq(0)
    end

    it "it has no capital letter" do
      user = FactoryGirl.build(:user, password:"s4l4s4n4", password_confirmation:"s4l4s4n4")

      expect(user).not_to be_valid
      user.save
      expect(User.count).to eq(0)
    end
  end

  describe "When it comes to lists, the user" do
    it "has no lists in the beginning" do
      expect(user.lists.count).to eq(0)
    end

    it "has one list when one list is created" do
      user.lists << List.create(name: "Kauppis")

      expect(user.lists.count).to eq(1)
    end

    it "has two lists when two lists are created" do
      user.lists << List.create(name: "Kauppis")
      user.lists << List.create(name: "Ikea")

      expect(user.lists.count).to eq(2)
    end

    it "has only one list if two lists with the same name are created" do
      user.lists << List.create(name: "Kauppis")
      user.lists << List.create(name: "Kauppis")

      expect(user.lists.count).to eq(1)
    end
  end
end