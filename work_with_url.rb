# frozen_string_literal: true

# .rubocop.yml
module WorkWithUrl
  module_function

  def get_html(url)
    http = Curl.get(url) do |curl|
      curl.ssl_verify_peer = false
      curl.ssl_verify_host = 0
    end
    Nokogiri::HTML(http.body_str)
  end

  def form_page_url(url, p_counter)
    "#{url}?p=#{p_counter}"
  end
end
