require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    get new_registration_path

    assert_response :success
  end

  test "creates an account and signs the user in" do
    assert_difference("User.count") do
      post registration_path, params: {
        user: {
          email_address: "NewUser@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    assert_redirected_to root_path
    assert cookies[:session_id]
    assert_equal "newuser@example.com", User.order(:id).last.email_address
  end

  test "does not create an account with an existing email address" do
    assert_no_difference("User.count") do
      post registration_path, params: {
        user: {
          email_address: "ONE@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    assert_response :unprocessable_content
    assert_select "[role=alert]"
  end
end
