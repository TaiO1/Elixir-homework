defmodule ForgotPassword do  
  # Screenshot on failure macro. Sends png to screenshots folder, also sets window size to 1920 x 1080 before capture 
  defmacro assert_sof(assertion) do
    quote do
      try do
        assert unquote(assertion)
      rescue
         error ->
          set_window_size current_window_handle(), 1920, 1080
          take_screenshot("screenshots/forgot_password.png")
          raise error
      end
    end
  end

  # Import helpers
  use Hound.Helpers
  use ExUnit.Case
  
  # Start hound session and destroy when tests are run
  hound_session()
  
  test "Forgot Password" do
    navigate_to "https://the-internet.herokuapp.com/"
    
    # Navigate to Forgot Password, confirm with URL 
    content = find_element(:id, "content")
    forgot_password_nav = find_within_element(content, :xpath, ~s|//a[contains(text(),"Forgot Password")]|)

    forgot_password_nav |> click()
    assert_sof current_url() == "https://the-internet.herokuapp.com/forgot_password"

    # Should input value into field, add additional text. Verify each exists after input 
    email = find_element(:id, "email")
    retrieve_password = find_element(:id, "form_submit")

    input_into_field(email, "test@")
    assert_sof attribute_value(email, "value") == "test@"
    input_into_field(email, "test.org")
    assert_sof attribute_value(email, "value") == "test@test.org"

    # Submit email, confirm redirect with text from new page
    retrieve_password |> click()
    assert_sof visible_page_text() =~ "Internal Server Error"

    # Navigate back a page after redirect, confirm email field stays populated
    navigate_back()
    input = find_element(:id, "email")
    assert_sof attribute_value(input, "value") == "test@test.org"

    delete_cookies()
  end
end

defmodule HoverTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  # Start hound session and destroy when tests are run
  hound_session()

  test "Mouse hover test" do
    navigate_to "https://the-internet.herokuapp.com/"
    
    # Find Hovers link, navigate to new page and confirm with URL 
    content = find_element(:id, "content")
    hovers_nav = find_within_element(content, :xpath, ~s|//a[contains(text(),"Hovers")]|)

    hovers_nav |> click()
    assert current_url() == "https://the-internet.herokuapp.com/hovers"

    # Hover over user1 avatar, confirm the right text appears
    hovers = find_element(:id, "content")
    user1 = find_within_element(hovers, :xpath, ~s|//div[contains(@class, "figure")]|)
    profile = find_within_element(user1, :xpath, ~s|//div[contains(@class, "figcaption")]|)
    view_profile = find_within_element(profile, :xpath, ~s|//a[contains(text(), "View profile")]|)

    move_to(user1, 0, 0)
    assert visible_page_text() =~ "name: user1"

    # Navigate to user profile, confirm redirect with page text
    view_profile |> click()
    assert visible_page_text() =~ "Not Found"

    delete_cookies()
  end
end

defmodule Geolocation do
  # Screenshot on failure macro. Sends png to screenshots folder, also sets window size to 1920 x 1080 before capture 
  defmacro assert_tfs(assertion) do
  quote do
    try do
        assert unquote(assertion)
      rescue
         error ->
          set_window_size current_window_handle(), 1920, 1080
          take_screenshot("screenshots/geolocation_failure.png")
          raise error
      end
    end
  end  
  
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  # Start hound session and destroy when tests are run
  hound_session()

  test "Geolocation" do
    navigate_to "https://the-internet.herokuapp.com/"

    # Find Geolocation, navigate to new page and confirm with URL 
    content = find_element(:id, "content")
    geolocation_nav = find_within_element(content, :xpath, ~s|//a[contains(text(),"Geolocation")]|)
  
    geolocation_nav |> click()
    assert_tfs current_url() == "https://the-internet.herokuapp.com/geolocation"

    # Attempt to grant browser location permission
    where_am_i = find_element(:xpath, ~s|//button[contains(text(),"Where am I?")]|)

    where_am_i |> click()
    
    send_keys :shift
    send_keys :tab
    send_keys :null

    send_keys :enter
    
    # PhantomJS does not support geolocation
    # If PhantomJS is in use, geolocation_failure screenshot should be added to screenshots folder
    # If Chromedriver is in use, geolocation_success screenshot should be added to screenshots folder. Should show your latitude and longitude
    assert_tfs visible_page_text() =~ "Latitude:"

    # View current location on Google Maps
    see_on_google = find_element(:xpath, ~s|//div[contains(text(),"See it on Google")]|)
    see_on_google |> click

    set_window_size current_window_handle(), 1920, 1080
    take_screenshot("screenshots/geolocation_success.png")
    
    delete_cookies()
  end 
end    
