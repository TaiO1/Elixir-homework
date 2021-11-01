defmodule ForgotPassword do
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
    assert current_url() == "https://the-internet.herokuapp.com/forgot_password"

    # Should input value into field, add additional text. Verify each exists after input 
    email = find_element(:id, "email")
    retrieve_password = find_element(:id, "form_submit")

    input_into_field(email, "test@")
    assert attribute_value(email, "value") == "test@"
    input_into_field(email, "test.org")
    assert attribute_value(email, "value") == "test@test.org"

    # Submit email, confirm redirect with text from new page
    retrieve_password |> click()
    assert visible_page_text() =~ "Internal Server Error"

    # Navigate back a page after redirect, confirm email field stays populated
    navigate_back()
    input = find_element(:id, "email")
    assert attribute_value(input, "value") == "test@test.org"

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
  # Screenshot on failure macro. Test set to capture screenshot on either success or failure
  defmacro assert_tfs(assertion) do
  quote do
    try do
        assert unquote(assertion)
      rescue
         error ->
          set_window_size current_window_handle(), 1920, 1080
          take_screenshot("__screenshots/failure.png")
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
    delete_cookies()
    navigate_to "https://the-internet.herokuapp.com/"
    # Find Geolocation, navigate to new page and confirm with URL 
    content = find_element(:id, "content")
    geolocation_nav = find_within_element(content, :xpath, ~s|//a[contains(text(),"Geolocation")]|)
  
    geolocation_nav |> click()
    assert_tfs current_url() == "https://the-internet.herokuapp.com/geolocation"

    # Attempt to access location
    where_am_i = find_element(:xpath, ~s|//button[contains(text(),"Where am I?")]|)
    where_am_i |> click()
    # Pass keys to approve request modal
    send_keys :tab
    send_keys :tab
    send_keys :enter

    # Chromedriver supports geolocation, should pass this portion
    # PhantomJS does not support geolocation. Redirect screen will be captured as fail state
    assert_tfs visible_page_text() =~ "Where am I?"

    # Not a fan of hard coded waits, but the driver continually failed the test as the element didn't load fast enough.
    Process.sleep(50)
    # Navigate to Google Maps, screenshot current location
    assert_tfs visible_page_text() =~ "See it on Google"
    see_map = find_element(:xpath, ~s|//a[contains(text(),"See it on Google")]|)
    see_map |> click()
    assert current_url() =~ "www.google.com"

    # Set window size, and allow pause for Map to render before screenshot
    set_window_size current_window_handle(), 1920, 1080
    Process.sleep(50)
    # Screenshot on sucess. Test set to capture screenshot on either success or failure
    take_screenshot("__screenshots/Success!.png")
  end 
end    