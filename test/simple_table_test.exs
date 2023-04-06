defmodule HomeworkUITests do
    # Import helpers
    use Hound.Helpers
    use ExUnit.Case
    
    # Start hound session and destroy after tests are run
    hound_session()
    @url "https://qa-homework.divvy.co/"
    
    test "Simple Table" do 
      navigate_to @url
      # Navigate to Simple Table, confirm with URL 
      content = find_element(:id, "sidebar")
      find_within_element(content, :xpath, ~s|//a[@href="/simple_table"]|) |> click()
      assert current_url() == "https://qa-homework.divvy.co/simple_table"
      # Clicking through the table options should display each table correctly, including the correct numbers inside of each
      detail = find_element(:id, "detail")
      assert visible_page_text() =~ "Click The Buttons and Verify the Right Number of Cells and Values Appear"
      num_table = find_element(:xpath, ~s|//*[@aria-label="a dense table"]|)
      # Assert data table has no visible text
      assert visible_text(num_table) =~ ""
      # Click Display 2x2, assert numbers match
      find_within_element(detail, :xpath, ~s|//button[text()='Display '][contains(.,'2') and contains(.,'x') and contains(.,' Table')]|) |> click()
      assert visible_text(num_table) =~ "1 2\n3 4"
      # Click Display 3x3, assert numbers match
      find_within_element(detail, :xpath, ~s|//button[text()='Display '][contains(.,'3') and contains(.,'x') and contains(.,' Table')]|) |> click()
      assert visible_text(num_table) =~ "1 2 3\n4 5 6\n7 8 9"
      # Click Display 4x4, assert numbers match
      find_within_element(detail, :xpath, ~s|//button[text()='Display '][contains(.,'4') and contains(.,'x') and contains(.,' Table')]|) |> click()
      assert visible_text(num_table) =~ "1 2 3 4\n5 6 7 8\n9 10 11 12\n13 14 15 16"
      # Click Display 5x5, assert numbers match
      find_within_element(detail, :xpath, ~s|//button[text()='Display '][contains(.,'5') and contains(.,'x') and contains(.,' Table')]|) |> click()
      assert visible_text(num_table) =~ "1 2 3 4 5\n6 7 8 9 10\n11 12 13 14 15\n16 17 18 19 20\n21 22 23 24 25"
      # Click Hide Table, assert data table is not visible
      find_within_element(detail, :xpath, ~s|//button[text()='Hide Table']|) |> click()
      assert visible_text(num_table) =~ ""
    end
end
