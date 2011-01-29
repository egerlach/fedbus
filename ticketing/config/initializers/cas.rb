require 'casclient'
require 'casclient/frameworks/rails/filter'

CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "https://cas.uwaterloo.ca/cas",
  :logger => Rails.logger
)
