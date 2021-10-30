defmodule HomeworkTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  # Start hound session and destroy when tests are run
  hound_session()

  test "Add/Remove Elements in Heroku" do
    navigate_to "https://the-internet.herokuapp.com/"
    
    # Find Add/Remove Elements, navigate to new page and confirm with URL 
    content = find_element(:id, "content")
    checkboxes_nav = find_within_element(content, :xpath, ~s|//a[contains(text(),"Checkboxes")]|)

    checkboxes_nav |> click()
    assert current_url() == "https://the-internet.herokuapp.com/checkboxes"

    checkboxes = find_element(:id, "checkboxes")
    checkbox_1 = find_within_element(checkboxes, :xpath, ~s|//*[contains(text(),"checkbox")]|)
    
    checkbox_1 |> click()

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
    dialog_text(alert) == "I am a JS Alert"
    send_keys(:enter)
    assert visible_text(alert) == "You successfully clicked an alert"

    # Click for JS Confirm Button; Verify no alert text exists before, and does exist after
    click_for_confirm |> click()
    send_keys(:enter)
    
    #confirm = find_element(:css, "#result")

    # Click for JS Confirm Part 2; Follow cancel flow, check message after
    click_for_confirm |> click()
    send_keys(:tab)
    send_keys(:enter)
    #assert visible_text(cancel) == "You clicked: Cancel"

    # JS Prompt button; Verify no alert text exists before, and does exist after 
    click_for_prompt |> click()
    send_text "You entered text"
    send_keys(:tab)
    send_keys(:enter)
    
  end
end