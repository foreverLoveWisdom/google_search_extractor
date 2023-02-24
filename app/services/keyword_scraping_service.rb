# frozen_string_literal: true

# Keywords scraping service logic
class KeywordScrapingService
  prepend SimpleCommand
  include ActiveModel::Validations

  validates :keyword, presence: true

  SCRAPING_URL = 'https://www.google.com'
  SEARCH_RESULT = 'result-stats'
  SEARCH_FORM = 'q'

  def initialize(keyword)
    @keyword = keyword
  end

  def call
    return unless valid?

    setup_search_data
    extract_search_data
    quit_driver
    build_search_result
  end

  private

  attr_reader :keyword

  def setup_search_data
    @driver = create_headless_chrome_driver
    navigate_to_scraping_url
    submit_keyword_search
    wait_until_search_result_displayed
  rescue Selenium::WebDriver::Error::TimeOutError => e
    handle_exception_for(e)
  end

  def handle_exception_for(exception)
    log_error_and_backtrace(exception)
    errors.add(:base, I18n.t('keyword_scraping_service.errors.failed_to_scrape', keyword:))
  end

  def log_error_and_backtrace(exception)
    Rails.logger.error exception.message
    Rails.logger.error exception.backtrace.inspect
  end

  def create_headless_chrome_driver(web_driver = Selenium::WebDriver)
    web_driver.for(:chrome, options: add_driver_options)
  end

  def add_driver_options(options = Selenium::WebDriver::Chrome::Options.new)
    options.add_argument('--headless')
    options
  end

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
    # NOTE: Randomize timeout to avoid being detected as a bot
    wait = wait_driver.new(timeout: randomize_timeout)
    wait.until { @driver.find_element(id: SEARCH_RESULT).displayed? }
  end

  def randomize_timeout
    rand(3..6)
  end

  def extract_search_data
    @total_search_result = @driver.find_element(id: SEARCH_RESULT).text
    @total_links = @driver.find_elements(:css, 'a')
    @adwords_advertisers = @driver.find_elements(:xpath, "//span[contains(text(), 'Ad')]")
    @html = @driver.page_source
  end

  def build_search_result
    {
      total_search_results: @total_search_result,
      total_links: @total_links.size,
      adwords_advertisers: @adwords_advertisers.size,
      html: @html
    }
  end

  def quit_driver
    @driver.quit
  end
end
