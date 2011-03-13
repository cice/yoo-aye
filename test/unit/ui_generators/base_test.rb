require 'test_helper'

module UiGenerators
  class BaseTest < ActiveSupport::TestCase
    context "Generator base" do
      setup do
        @base = KuduUi::UiGenerators::Base.new :a, :b
      end
      
      should 'provide #to_html for debugging purposes' do
        assert_equal 'KuduUi::UiGenerators::Base#to_html', @base.to_html
      end
      
      should 'provide a Tag helper object' do
        assert_kind_of KuduUi::UiGenerators::Tag, @base.tag
        assert_kind_of Hash, @base.tag_hash
      end
      
      should 'set instance variables from passed options' do
        @base.add_options :foo => 'bar'
        
        assert_equal @base.instance_variable_get('@foo'), 'bar'        
      end
      
      should 'raise SnippetOrActionNotFound on #render_action as base itself has no views' do
        assert_raise KuduUi::UiGenerators::SnippetOrActionNotFound do
          @base.render_action :foo do
            'bar'
          end
        end
      end
      
      #TODO: test inheritance behavior, injection of generator method, loading of snippets etc
    end    
  end
end