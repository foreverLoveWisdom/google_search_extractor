# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordScrapingService do
  subject(:keyword_scraping_service) { described_class.call(keyword) }

  let(:result) { keyword_scraping_service.result }

  let(:keyword) { 'insurance' }

  before do
    WebMock.disable_net_connect!
  end

  describe '#call' do
    let(:driver) { instance_double(Selenium::WebDriver::Driver) }
    let(:search_bar) { instance_double(Selenium::WebDriver::Element) }
    let(:result_stats) { instance_double(Selenium::WebDriver::Element) }
    let(:link_elements) { [instance_double(Selenium::WebDriver::Element)] }
    let(:ad_elements) { [instance_double(Selenium::WebDriver::Element)] }
    let(:extracted_scrape_data) do
      {
        total_search_results: 'About 123,456,789 results (0.65 seconds)',
        total_links: 1,
        adwords_advertisers: 1,
        html: '<html></html>'
      }
    end

    before do
      allow(Selenium::WebDriver::Chrome::Options).to receive(:new).and_return(double.as_null_object)
      allow(Selenium::WebDriver).to receive(:for).and_return(driver)
      allow(driver).to receive(:navigate).and_return(double.as_null_object)
      allow(driver).to receive(:find_element).with(name: 'q').and_return(search_bar)
      allow(driver).to receive(:find_element).with(id: 'result-stats').and_return(result_stats)
      allow(search_bar).to receive(:send_keys).and_return(double.as_null_object)
      allow(search_bar).to receive(:submit).and_return(double.as_null_object)
      allow(result_stats).to receive(:text).and_return('About 123,456,789 results (0.65 seconds)')
      allow(driver).to receive(:find_elements).with(:css, 'a').and_return(link_elements)
      allow(driver).to receive(:find_elements).with(:xpath, "//span[contains(text(), 'Ad')]").and_return(ad_elements)
      allow(driver).to receive(:page_source).and_return('<html></html>')
      allow(result_stats).to receive(:displayed?).and_return(true)
      allow(driver).to receive(:quit)
    end

    context 'when keyword is valid' do
      it 'returns extracted scrape data' do
        expect(result).to eq(extracted_scrape_data)
      end
    end

    context 'when keyword is invalid' do
      let(:keyword) { '' }

      it 'fails' do
        expect(keyword_scraping_service).to be_failure
      end

      it 'returns error message' do
        expect(keyword_scraping_service.errors.full_messages.to_sentence).to eq("Keyword can't be blank")
      end
    end
  end
end
