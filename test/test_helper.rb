ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")
require 'yoo_ay'
require 'rails/test_help'
# require 'translate_routes_test_helper'
# require 'mocha'

require File.join(File.dirname(__FILE__),*%w(test_helper ui_generator_test_helper))
# require File.join(File.dirname(__FILE__),*%w(test_helper form_builder_test_helper))

class ActiveSupport::TestCase
  def self.should_have_snippets *snippets
    should "have snippets #{snippets * ', '}" do
      @generator.load_snippets
      
      snippets.each do |snippet|
        assert_kind_of Haml::Engine, @generator.snippets[snippet.to_sym], "Snippet :#{snippet} missing!"
      end
    end
  end
end
