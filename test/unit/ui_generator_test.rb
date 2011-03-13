require 'test_helper'


class UiGeneratorTest < ActiveSupport::TestCase
  class MockView ; attr_accessor :controller ; end
    
  test 'Initializer should set controller from view if not passed' do
    view = MockView.new
    view.controller = :a_controller
    
    generator = KuduUi::UiGenerator.new view
    
    assert_equal :a_controller, generator.controller
  end
  
  test 'UiGenerator should respond to :list' do
    generator = KuduUi::UiGenerator.new 0,0
    
    assert generator.respond_to?(:list)
  end
  
  test 'UiGenerator should respond to :table_list' do
    generator = KuduUi::UiGenerator.new 0,0
    
    assert generator.respond_to?(:table_list)
  end
  
  test 'UiGenerator should respond to :resource_table' do
    generator = KuduUi::UiGenerator.new 0,0
    
    assert generator.respond_to?(:resource_table)
  end
end