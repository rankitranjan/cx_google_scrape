require 'playwright'

class SearchService
  GOOGLE_URL = "https://www.google.com/search?q=".freeze
  USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0"
  ].freeze

  def self.playwright_executable
     ENV.fetch("PLAYWRIGHT_CLI_EXECUTABLE_PATH") { './node_modules/.bin/playwright' }
  end

  def self.perform_search(keyword)
    search_url = "#{GOOGLE_URL}#{URI.encode_www_form_component(keyword)}"
    Playwright.create(playwright_cli_executable_path: playwright_executable) do |playwright|
      browser = initialize_browser(playwright)
      context = browser.new_context
      page = setup_page(context)

      begin
        perform_search_and_scrape(page, search_url)
      rescue StandardError => e
        handle_error(e)
      ensure
        browser.close
      end
    end
  end

  private

  def self.initialize_browser(playwright)
    playwright.chromium.launch(
      headless: true,
      args: [
        '--disable-blink-features=AutomationControlled',
        '--no-sandbox', '--disable-setuid-sandbox',
        '--disable-dev-shm-usage', '--disable-gpu'
      ]
    )
  end

  def self.setup_page(context)
    page = context.new_page
    page.set_viewport_size(width: 1920, height: 1080)
    page.set_extra_http_headers({ "User-Agent" => USER_AGENTS.sample })
    page
  end

  def self.perform_search_and_scrape(page, search_url)
    Rails.logger.info "Navigating to: #{search_url}"
    page.goto(search_url, timeout: 60_000)
    sleep(rand(3..5)) # Mimic human-like delay
    page.evaluate("window.scrollBy(0, document.body.scrollHeight)")
    sleep(rand(3..5))

    extract_search_data(page)
  end

  def self.extract_search_data(page)
    # Extract AdWords count
    adwords_count = page.locator("div.pla-unit, div.mnr-c").count
    adwords_count += page.locator("div[data-dtld]").count if adwords_count.zero?

    # Extract total links count
    total_links = page.locator('a').count

    # Extract total search results count
    total_results_text = page.text_content('#result-stats') || "0 results"
    total_results = total_results_text[/[\d,]+/].to_s.delete(',').to_i

    # Extract full HTML content
    html_content = page.content

    Rails.logger.info "AdWords: #{adwords_count}, Links: #{total_links}, Results: #{total_results}"

    {
      total_adwords: adwords_count,
      total_links: total_links,
      total_results: total_results,
      html_content: html_content,
      status: 'completed'
    }
  end

  def self.handle_error(error)
    Rails.logger.error "SearchService Error: #{error.message}"

    {
      total_adwords: 0,
      total_links: 0,
      total_results: 0,
      html_content: "",
      status: 'failed'
    }
  end
end
