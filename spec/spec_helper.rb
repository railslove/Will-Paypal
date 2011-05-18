$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require "paypal_nvp"
require "rspec"
require 'fakeweb'

RSpec.configure do |config|
end