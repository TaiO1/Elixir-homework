defmodule FileUploadUITests do
    # Import helpers
    use Hound.Helpers
    use ExUnit.Case
    
    # Start hound session and destroy after tests are run
    hound_session()
    @url "https://qa-homework.divvy.co/"
    
    test "File Upload" do
      navigate_to @url
      # Navigate to File Upload, confirm with URL and visible text
      content = find_element(:id, "sidebar")
      find_within_element(content, :css, ~s|[href="/file_upload"]|) |> click()
      assert current_url() == "https://qa-homework.divvy.co/file_upload"
      assert visible_page_text() =~ "Select a File and Upload It (This Doesn't Send Your File Anywhere)"
      # Check Choose File and Upload buttons are visible
      choose_file = find_element(:css, ~s|[data-testid="FileUploadSelector--Button"]|)
      upload_button = find_element(:css, ~s|[data-testid="FileUpload--Button"]|)
      assert element_displayed?(choose_file)
      assert element_displayed?(upload_button)
      # Chrome is unable to interact with choose file button natively, confirming the buttons are displayed was the only option here
    end
  end
  