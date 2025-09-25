require 'test_helper'

class UserValidationTest < ActiveSupport::TestCase
  test "should require password confirmation" do
    user = User.new(
      name: "Test User",
      email: "test@example.com", 
      role: "player",
      password: "password123"
    )
    
    assert_not user.valid?
    assert_includes user.errors[:password_confirmation], "kann nicht leer sein"
  end

  test "should validate matching passwords" do
    user = User.new(
      name: "Test User",
      email: "test@example.com",
      role: "player", 
      password: "password123",
      password_confirmation: "different_password"
    )
    
    assert_not user.valid?
    assert_includes user.errors[:password_confirmation], "stimmt nicht mit dem Passwort überein"
  end

  test "should be valid with matching passwords" do
    user = User.new(
      name: "Test User",
      email: "test@example.com",
      role: "player",
      password: "password123", 
      password_confirmation: "password123"
    )
    
    assert user.valid?
  end
end