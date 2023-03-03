# frozen_string_literal: true

# Keywords scraping service logic
class KeywordScrapingService
  prepend SimpleCommand
  include ActiveModel::Validations

  validates :keyword, presence: true

  SCRAPING_URL = 'https://www.google.com'
  SEARCH_RESULT = 'result-stats'
  ADWORD_ADVERTISER = 'Ad'
  LINK = 'a'
  SEARCH_FORM = 'q'
  MIN_TIMEOUT = 3
  MAX_TIMEOUT = 6

  # NOTE: If the server IP is located in Europe, the terms and conditions page of the Google search service
  # must be bypassed due to strict privacy regulations.
  def initialize(keyword)
    @keyword = keyword
  end

  def call
    return unless valid?

    begin
      setup_search_data
      extract_search_data
      quit_driver
      build_search_result
    rescue StandardError => e
      handle_exception_for(e)
    end
  end

  private

  attr_reader :keyword

  def setup_search_data
    @driver = create_headless_chrome_driver
    navigate_to_scraping_url
    submit_keyword_search
    wait_until_search_result_displayed
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
    options.add_argument("--user-agent=#{user_agent}")
    options
  end

  def user_agent
    chrome_version = rand(70..96)
    chrome_minor_version = rand(0..999)
    webkit_version = rand(537..603)
    safari_version = rand(12..15)
    platform = %w[Windows Linux].sample

    # rubocop:disable Layout/LineLength
    "Mozilla/5.0 (#{platform}; Win64; x64) AppleWebKit/#{webkit_version}.36 (KHTML, like Gecko) Chrome/#{chrome_version}.#{chrome_minor_version} Safari/#{safari_version}.36"
    # rubocop:enable Layout/LineLength
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
    rand(MIN_TIMEOUT..MAX_TIMEOUT)
  end

  def extract_search_data
    @total_search_result = @driver.find_element(id: SEARCH_RESULT).text
    @total_links = @driver.find_elements(:css, LINK)
    @adwords_advertisers = @driver.find_elements(:xpath, "//span[contains(text(), '#{ADWORD_ADVERTISER}')]")
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
