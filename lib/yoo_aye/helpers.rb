require 'yoo_aye/helper'


module YooAye
  module Helpers
    mattr_accessor :helpers
    self.helpers = %w[
      list
      table_list
    ]
    
    helpers.each do |helper|
      require "yoo_aye/helpers/#{helper}"
      const_get(helper.classify).inject
    end
  end
end