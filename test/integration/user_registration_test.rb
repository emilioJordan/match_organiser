require 'test_helper'

class UserRegistrationTest < ActionDispatch::IntegrationTest
  test "should show password confirmation error" do
    get signup_path
    assert_response :success
    
    # Versuche Registrierung mit nicht übereinstimmenden Passwörtern
    post signup_path, params: {
      user: {
        name: "Test User",
        email: "test@example.com",
        role: "player",
        password: "password123",
        password_confirmation: "wrongpassword"
      }
    }
    
    # Sollte zur Registrierungsseite zurückkehren mit Fehlern
    assert_response :unprocessable_entity
    assert_select '.alert-danger', text: /Passwort bestätigen stimmt nicht mit dem Passwort überein/
  end
  
  test "should create user with matching passwords" do
    get signup_path
    assert_response :success
    
    # Erfolgreiche Registrierung mit übereinstimmenden Passwörtern
    assert_difference 'User.count', 1 do
      post signup_path, params: {
        user: {
          name: "Test User",
          email: "test@example.com", 
          role: "player",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    
    # Sollte zur Hauptseite weiterleiten
    assert_redirected_to root_path
    assert_not_empty flash[:notice]
  end
end