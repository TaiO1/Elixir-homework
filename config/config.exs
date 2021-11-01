# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# Start with selenium driver (default)
#config :hound, driver: "phantomjs"

# Start Hound for ChromeDriver (default port 9515 assumed)
config :hound, driver: "chrome_driver"