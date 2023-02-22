# frozen_string_literal: true

# Keywords scraping service logic
# Consider to extract Selenium related logic to a separate class
# and use dependency injection to inject it into this service
# to make it easier to test
# Ask chatbot to help here. How can I separate Selenium related logic and inject it
class KeywordScrapingService
  prepend SimpleCommand
  include ActiveModel::Validations

  validates :keyword, presence: true

  SCRAPING_URL = 'https://www.google.com'
  TIMEOUT = 3 # seconds
  SEARCH_RESULT = 'result-stats'
  SEARCH_FORM = 'q'

  def initialize(keyword)
    @keyword = keyword
  end

  def call
    return unless valid?

    setup_search_data
    total_search_result, link_elements, ad_elements = extract_search_data
    quit_driver

    build_search_result(total_search_result, link_elements, ad_elements)
  end

  private

  attr_reader :keyword

  def setup_search_data
    @driver = create_headless_chrome_driver
    navigate_to_scraping_url
    submit_keyword_search
    wait_until_search_result_displayed
  end

  def create_headless_chrome_driver(web_driver = Selenium::WebDriver)
    web_driver.for(:chrome, options: add_driver_options)
  end

  def add_driver_options(options = Selenium::WebDriver::Chrome::Options.new)
    options.add_argument('--headless')
    options.add_argument("user-agent=#{user_agent}")
    options
  end

  # TODO: Add a double to test this method
  def user_agent(custom_user_agent = 'chrome')
    generate_user_agent(navigator: custom_user_agent)
  end

  def navigate_to_scraping_url
    @driver.navigate.to SCRAPING_URL
  end

  def submit_keyword_search
    search_bar = @driver.find_element(name: SEARCH_FORM)
    search_bar.send_keys(keyword)
    search_bar.submit
  end

  def wait_until_search_result_displayed(wait_driver = Selenium::WebDriver::Wait)
    wait = wait_driver.new(timeout: TIMEOUT)
    wait.until { @driver.find_element(id: SEARCH_RESULT).displayed? }
  end

  def extract_search_data
    total_search_result = @driver.find_element(id: SEARCH_RESULT).text
    link_elements = @driver.find_elements(:css, 'a')
    ad_elements = @driver.find_elements(:xpath, "//span[contains(text(), 'Ad')]")

    [total_search_result, link_elements, ad_elements]
  end

  def build_search_result(total_search_result, link_elements, ad_elements)
    {
      total_search_result:,
      total_links: link_elements.size,
      total_ads: ad_elements.size
    }
  end

  # TODO: Add a double to test this method
  def quit_driver
    @driver.quit
  end
end
