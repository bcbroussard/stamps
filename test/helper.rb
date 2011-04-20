require "bundler"
Bundler.setup

require 'simplecov'
SimpleCov.merge_timeout 3600
SimpleCov.start do
  add_group 'Stamps', 'lib/stamps'
  add_group 'Faraday Middleware', 'lib/faraday'
end

require 'mocha'
require 'test/unit'
require 'stamps'
require 'shoulda'
require 'webmock/test_unit'
require 'json'
require 'multi_json'

Stamps.configure do |config|
  config.integration_id = 'XXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX'
  config.username       = 'USERNAME'
  config.password       = 'PASSXXXX'
  config.endpoint       = 'https://stamps.example.com/swsim/swsimv12.asmx'
  config.return_address  = {
    :full_name    => 'Big E-commerce Company',
    :address1     => '500 Wall Street',
    :address2     => 'Suite 234',
    :city         => 'New York',
    :state        => 'NY',
    :zip_code     => '10004',
    :phone_number => '9375551234'
  }
end

# Stub requests
def stub_post(web_method)
  stub_request(:post, Stamps.endpoint).
    with(:headers => {"SoapAction" => "#{Stamps.namespace}/#{web_method}"}).
    to_return(:body => fixture("#{web_method}.xml"))
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

Savon.configure do |config|
  config.log = false # disable logging
end