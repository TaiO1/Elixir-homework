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

    # Should input value into field, and add additional text. Verify each exists after input. 
    email = find_element(:id, "email")
    retrieve_password = find_element(:id, "form_submit")

    input_into_field(email, "test@")
    assert attribute_value(email, "value") == "test@"
    
    input_into_field(email, "test.org")
    assert attribute_value(email, "value") == "test@test.org"

    # Submit, navigate back one page to confirm button worked as intended
    retrieve_password |> click()
    assert visible_page_text() =~ "Internal Server Error"
    # Capture screenshot on failure
      catch
        error ->
        take_screenshot()
        raise error

    delete_cookies()
  end
end

defmodule AlertTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  # Start hound session and destroy when tests are run
  hound_session()

  test "Javascript Alerts" do
    navigate_to "https://the-internet.herokuapp.com/"

    content = find_element(:id, "content") 
    alert_nav = find_within_element(content, :xpath, ~s|//a[contains(@href, "javascript_alerts")]|)

    # Navigate to Add/Remove Elements page, confirm with URL
    alert_nav |> click()
    assert current_url() == "https://the-internet.herokuapp.com/javascript_alerts"

    # Aliases for JS buttons
    example = find_element(:xpath, ~s|//div[contains(@class, "example")]|)
    click_for_alert = find_within_element(example, :xpath, ~s|//button[contains(@onclick, "jsAlert()")]|)
    click_for_confirm = find_within_element(example, :xpath, ~s|//button[contains(@onclick, "jsConfirm()")]|)    
    click_for_prompt = find_within_element(example, :xpath, ~s|//button[contains(@onclick, "jsPrompt()")]|)
    alert = find_element(:css, "#result")
   
    # Click for JS Alert Button; Verify alert text exists after JS alert menu is closed
    click_for_alert |> click()
    # dialog_text(alert) == "I am a JS Alert"
    send_keys(:enter)

    # Click for JS Confirm Button; Verify no alert text exists before, and does exist after
    click_for_confirm |> click()
    send_keys(:enter)
    
    #confirm = find_element(:css, "#result")

    # Click for JS Confirm Part 2; Follow cancel flow, check message after
    click_for_confirm |> click()
    send_keys(:tab)
    send_keys(:enter)

    # JS Prompt button; Verify no alert text exists before, and does exist after 
    click_for_prompt |> click()
    send_text(:"You entered text")
    send_keys(:tab)
    send_keys(:enter)
    assert visible_text(alert) == "You entered text"
   
    delete_cookies()
  end
end

defmodule ContextTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  # Start hound session and destroy when tests are run
  hound_session()

  test "Context Menu in Heroku" do
    navigate_to "https://the-internet.herokuapp.com/"
    
    # Find Context Menu link, navigate to new page and confirm with URL 
    content = find_element(:id, "content")
    context_nav = find_within_element(content, :xpath, ~s|//a[contains(text(),"Context Menu")]|)

    context_nav |> click()
    assert current_url() == "https://the-internet.herokuapp.com/context_menu"

    # Alias context menu box, interact with context menu
    context_box = find_element(:id, "hot-spot")

    move_to(context_box, 5, 5)
    mouse_down("button \\ 2")
    path = take_screenshot("screenshot-test.png")
    assert File.exists?(path)

    delete_cookies()
  end
end
