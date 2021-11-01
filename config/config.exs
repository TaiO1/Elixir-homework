# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# Define your application's host and port (defaults to "http://localhost:4001")
#config :hound, app_host: "http://localhost", app_port: 4000

# Start with selenium driver (default)
config :hound, driver: "phantomjs"

# Use Chrome with the default driver (selenium)
#config :hound, browser: "chrome"

# Start with default driver at port 1234 and use firefox
#config :hound, port: 1234, browser: "firefox"

# Start Hound for PhantomJs
#config :hound, driver: "phantomjs"

# Start Hound for ChromeDriver (default port 9515 assumed)
#config :hound, driver: "chrome_driver"