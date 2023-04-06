defmodule FileDownloadUITests do
    # Import helpers
    use Hound.Helpers
    use ExUnit.Case
    
    # Start hound session and destroy after tests are run
    hound_session()
    @url "https://qa-homework.divvy.co/"

    test "File Download" do
      navigate_to @url
      # Navigate to File Upload, confirm with URL and visible text
      content = find_element(:id, "sidebar")
      find_within_element(content, :xpath, ~s|//a[@href="/file_download"]|) |> click()
      assert current_url() == "https://qa-homework.divvy.co/file_download"
      assert visible_page_text() =~ "Download The File and Verify its Contents"
      # Click Download button, confirm button element changes after click
      find_element(:xpath, ~s|//button[text()='Download']|) |> click()
      # Only way I could find to confirm if the download button changed after the click. 
      # Before the click, the download button only has a single child span element. After the click, there are 3 levels of span child elements
      post_click_button = find_element(:xpath, ~s|//button[text()='Download']/span/span/span|)
      # This allows us to assert that the element exists, we don't care about where on the page it is
      assert element_location(post_click_button)
    end
  end
  