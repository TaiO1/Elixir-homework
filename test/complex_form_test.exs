defmodule ComplexFormUITests do
    # Import helpers
    use Hound.Helpers
    use ExUnit.Case

    # Start hound session and destroy after tests are run
    hound_session()
    @url "https://qa-homework.divvy.co/"

    test "Complex Form Navigation" do
      navigate_to @url
      # Navigate to Complex Form, confirm with URL and visible text
      content = find_element(:id, "sidebar")
      find_within_element(content, :css, ~s|[href="/complex_form"]|) |> click()
      assert current_url() == "https://qa-homework.divvy.co/complex_form"
      assert visible_page_text() =~ "Fill Out the Form and Verify Error Handling While Noting Any Issues"
      form = find_element(:css, ~s|form[action="#"]|)
      # Clicking Continue For Delivery, confirming that Required error messaging appears
      find_within_element(form, :xpath, ~s|//button[text()='CONTINUE FOR DELIVERY']|) |> click()
      assert element_displayed?(find_element(:xpath, ~s|//p[text()='Required']|))
      # Navigating to final form screen, confirming with Special Instructions is displayed, then navigating back
      find_element(:xpath, ~s|//button[text()='NEXT STEP']|) |> click()
      find_element(:xpath, ~s|//button[text()='NEXT STEP']|) |> click()
      assert element_displayed?(find_element(:xpath, ~s|//span[text()='Special Instructions']|))
      find_element(:xpath, ~s|//button[text()='PREVIOUS STEP']|) |> click()
      find_element(:xpath, ~s|//button[text()='PREVIOUS STEP']|) |> click()
      # Confirming we are back on the first form screen using Contact Information
      assert element_displayed?(find_element(:xpath, ~s|//p[text()='Contact Information']|))
    end

    test "Complex Form Happy Path" do
      # Navigate to complex form
      navigate_to "https://qa-homework.divvy.co/complex_form"
      # Retrieve form, fill form elements
      form = find_element(:css, ~s|form[action="#"]|)
      find_within_element(form, :name, "firstName") |> fill_field("john")
      find_within_element(form, :name, "lastName") |> fill_field("doe")
      find_within_element(form, :name, "email") |> fill_field("a@a.gov")
      find_within_element(form, :name, "phone") |> fill_field("8015555555")
      find_within_element(form, :name, "addressLine1") |> fill_field("123 fake st")
      find_within_element(form, :name, "city") |> fill_field("lehi")
      # The line below is how I would have liked to fill out certain fields, using JS scripts, however I was not able to get it working yet
      # execute_script("document.getElementsByName(\"state\").value = \"UT\"")
      # Below is a very fragile set of actions that work to fill out the form currently, but are by no means my preferred method for testing UI elements
      # If anything changes on either of the first two pages of this form, the test will likely fail
      # Setting address State
      send_keys :tab
      send_keys :enter
      send_text "u"
      send_keys :enter
      # Setting pickup time to be 5:30 pm on 09/10/2023
      send_keys :tab
      send_text "09102023"
      send_keys :tab
      send_text "0530p"
      find_within_element(form, :xpath, ~s|//button[text()='CONTINUE FOR DELIVERY']|) |> click()
      # Accepting dialog before moving on
      accept_dialog()
      find_element(:xpath, ~s|//button[text()='NEXT STEP']|) |> click()
      # Setting pizza toppings for Tai's favorite pizza
      find_element(:xpath, ~s|//span[text()='Large']|) |> click()
      find_element(:xpath, ~s|//span[text()='Stuffed Crust']|) |> click()
      find_element(:xpath, ~s|//span[text()='Cheese']|) |> click()
      find_element(:xpath, ~s|//span[text()='Cheese']|) |> click()
      send_keys :tab
      send_keys :enter
      send_text "e"
      send_keys :enter
      find_element(:xpath, ~s|//span[text()='Tomato Sauce']|) |> click()
      send_keys :tab
      send_keys :enter
      send_text "e"
      send_keys :enter
      find_element(:xpath, ~s|//span[text()='pepperoni']|) |> click()
      find_element(:xpath, ~s|//span[text()='jalapenos']|) |> click()
      find_element(:xpath, ~s|//span[text()='pineapple']|) |> click()
      find_element(:xpath, ~s|//button[text()='ADD TO ORDER']|) |> click()
      # Accepting dialog before moving on
      accept_dialog()
      find_element(:xpath, ~s|//button[text()='NEXT STEP']|) |> click()
      find_element(:xpath, ~s|//span[text()='Special Instructions']|) |> click()
      send_text "Please charge a 30% gratuity to the credit card on file"
      find_element(:xpath, ~s|//button[text()='SUBMIT ORDER']|) |> click()
      # Accept final dialog, order has been submitted
      accept_dialog()
    end

    test "Complex Form Order Details Sad Path" do
      # Navigate to complex form
      navigate_to "https://qa-homework.divvy.co/complex_form"
      # Verify form elements show expected error messaging
      form = find_element(:css, ~s|form[action="#"]|)
      find_within_element(form, :name, "firstName") |> click()
      send_keys :tab
      assert element_displayed?(find_element(:xpath, ~s|//p[text()='Required']|))
      send_text "doe"
      send_keys :tab
      send_text "john"
      send_keys :tab
      assert element_displayed?(find_element(:xpath, ~s|//p[text()='Invalid email address']|))
      find_within_element(form, :xpath, ~s|//button[text()='CONTINUE FOR DELIVERY']|) |> click()
      # This confirms that even with required fields missing data, we are able to move to the pizza builder screen
      find_element(:xpath, ~s|//button[text()='NEXT STEP']|) |> click()
    end

    test "Complex Form Pizza Builder Sad Path" do
      # Navigate to complex form
      navigate_to "https://qa-homework.divvy.co/complex_form"
      # Click Next Step, skip to pizza builder
      find_element(:xpath, ~s|//button[text()='NEXT STEP']|) |> click()
      find_element(:xpath, ~s|//span[text()='Cheese']|) |> click()
      find_element(:xpath, ~s|//span[text()='Cheese']|) |> click()
      assert element_displayed?(find_element(:xpath, ~s|//label[text()='Cheese Amount']|))
      send_keys :tab
      send_keys :tab
      assert element_displayed?(find_element(:xpath, ~s|//p[text()='Required']|))
    end
  end
