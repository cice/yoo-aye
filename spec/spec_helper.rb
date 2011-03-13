require 'rubygems'
require 'bundler/setup'
require 'yoo_aye'

require 'render_helper'
require 'nokogiri'
require "webrat/core/matchers"

module SpecHelper
  def anythings count
    [anything] * count
  end
end

ActionView::Base.send :include, YooAyeHelper

RSpec.configure do |config|
  config.include SpecHelper
  config.include Webrat::Matchers
  config.include RenderHelper
  
  config.before(:each) do
    initialize_view
  end
end