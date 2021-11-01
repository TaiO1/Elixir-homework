These are my test cases written for Divvy's QA technical exercise.

There are 3 tests outlined in the homework_test.exs file.
Each of them addresses an item on this list https://the-internet.herokuapp.com/

If you clone the repo, the tests should run from the root directory with a 'mix test' command. 
Your machine will need a webdriver running for this command to execute. These tests have been written
specifically for use with Chromedriver and PhantomJS. The Geolocation test has different outcomes for each browser.

I will give a brief summary of what each test accomplishes, and why I chose it. 

**ForgotPassword**:
I wrote this test because the ability to fill fields, and also check the contents of those fields, is very important in web based automation. 

The test navigates to the list, finds the forgot password link, clicks the link and uses the URL to confirm the page redirect.
From there the test fills in the first half of an email address, and then tests what would happen if the second half of the email is added separately.
After using the Retrieve Password button, the tests confirms the existence of an error message on the new page. Finally, the test navigates back a page and checks the email field to see if the input data still exists. 

**HoverTest**
Elements that appear on hover can be very difficult to deal with for an automation engineer. That's why I chose this for the second test. 
Demonstrating the ability to not only confirm that elements appear on hover, but also the ability to interact with those elements, is a much needed skill in the tool belt of any automation specialist.

This test navigates to the list, then navigates to the hovers page, and confirms with the URL. 
From there, the test finds the user avatar with an xpath selector, hovers over the avatar, and selects the View profile option in the newly display user menu.
Finally, the test confirms the redirect was successful using the visible text on the page. The URL has not changed at this point, and would therefore be a false positive if it were used to confirm the success of the test. 

**Geolocation**
The final test was chosen for a slightly different reason than the two above. Is it important to be able to interact with a location menu that appears in your browser via automation? Absolutely. For this test, that was just an added bonus. 
The primary reason I chose geolocation for the final item to automate on the list was because of the differences between Hound compatible web drivers. 
Chromedriver allows for the ability to track location. PhantomJS does not. 
This test has a macro embedded that allows the user to make assertions the way they typically would, but if they reference this macro and that step of the test fails, the macro captures a screenshot before closing the test. 

Geolocation begins the way that all of these tests do; navigating to the list, and then navigating to the relevant menu item. The URL is used to confirm the redirect.
From there the tests selects the 'Where am I?' button which then reveals the location allow/deny modal. 
After allowing the browser access to location, the test uses the custom test fail screenshot assertion to confirm the page has not yet changed. If the page has changed, the text "See it on Google" will not be visible, and the screenshot will be captured. This is the flow when using PhantomJS. If the text is visible on the page, the browser will use the link to view the location with the given longitude and latitude on Google Maps. Finally, the test will confirm the redirect with the URL, and will set the window size to 1920 x 1080 before taking a screenshot.
The screenshot will be titled 'Success!' if the test passes, and 'failure' if it does. Both screenshot titles are included in .gitignore, so no personal information can be uploaded to the repo.
