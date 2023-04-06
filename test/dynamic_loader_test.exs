defmodule DynamicLoaderUITests do
    # Import helpers
    use Hound.Helpers
    use ExUnit.Case
    use AssertEventually, timeout: 60_000, interval: 100
    
    # Start hound session and destroy after tests are run
    hound_session()
    @url "https://qa-homework.divvy.co/"

    test "Dynamic Loader Happy Path" do  
      navigate_to @url
      # Navigate to File Upload, confirm with URL and visible text
      content = find_element(:id, "sidebar")
      find_within_element(content, :css, ~s|[href="/dynamic_loader"]|) |> click()
      assert current_url() == "https://qa-homework.divvy.co/dynamic_loader"
      assert visible_page_text() =~ "Verify Loading Eventually Completes"
      # Assert that loading bar is visible, and starts with a value of 0
      assert element_displayed?(find_element(:css, ~s|[aria-valuenow="0"]|))
      assert element_displayed?(find_element(:xpath, ~s|//div[text()='Loading . . .']|))
      # Asserting that Complete! element is eventually visible. 60 second timeout set in AssertEventually import, checking every 100 ms
      assert_eventually element_displayed?(find_element(:xpath, ~s|//div[text()='Complete!']|))
    end
  end
  