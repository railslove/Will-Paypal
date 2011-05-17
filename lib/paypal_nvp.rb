require "logger"
require "net/https"
require "cgi"

class PaypalNvp

  attr_accessor :config, :logger
  
  DEFAULT_OPTIONS = {
    :version => "50.0",
    :sandbox => false,
    :url => "",
    :params => {}
  }
  
  def initialize(config={})
    self.config = DEFAULT_OPTIONS.merge(config)
    self.logger = config.delete(:logger) || Logger.new(STDOUT)
  end

  def query_string_for(data)
    data.merge!({
     "USER"       => self.config[:user],
     "PWD"        => self.config[:password], 
     "SIGNATURE"  => self.config[:signature]
    })
    data.merge!(self.config[:params])
    query = []
    data.each do |key, value|
      query << "#{key.to_s.upcase}=#{URI.escape(value.to_s)}"
    end
    query.join("&")
  end
  
  def hash_from_query_string(query_string)
    hash = {}
    query_string.split("&").each do |element|
      a = element.split("=")
      hash[a[0]] = CGI.unescape(a[1]) if a.size == 2
    end
    hash
  end
  
  def call_paypal(data)
    uri = URI.parse(self.config[:url])
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    rootCA = '/etc/ssl/certs'
    if File.directory? rootCA
      http.ca_path = rootCA
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.verify_depth = 5
    else
      self.logger.warn "WARNING: no ssl certs found. Paypal communication will be insecure. DO NOT DEPLOY"
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    response = http.request_post(uri.path, self.query_string_for(data))
    
    response_hash = { :response => response }
    if response.kind_of? Net::HTTPSuccess
      response_hash.merge! self.hash_from_query_string(response.body)
    end
    response_hash
  end

end
