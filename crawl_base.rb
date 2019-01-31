class CrawlBase
  def initialize(url)
    @base_url = url
    @http_options = {
      headers: { "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36" },
      timeout: 20,
      # ssl_version: :SSLv3,
      verify_mode: OpenSSL::SSL::VERIFY_NONE }
  end

  def base_url
    @base_url
  end

  def encode_data(content)
   content.force_encoding("ISO-8859-1").encode("utf-8", replace: nil) if !content.nil?
  end

  def normalized_url
    (Addressable::URI.parse @url).normalize.to_s rescue nil
  end

  def download
    @body = HTTParty.get(normalized_url, @http_options)
  rescue => e
    puts e.class
  end

  def page
    @page = Nokogiri::HTML(encode_data(download))
  end
  
  def sleep_random
    sleep (0..8).to_a.sample
  end

protected
  def dump!
    File.write('tmp/dump.html', download, mode: 'wb')
  end

  def dump
    @doc = Nokogiri::HTML(File.read('tmp/dump.html'))
    self
  end
end