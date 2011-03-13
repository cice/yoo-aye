require 'test_helper'

class DynamicMethodTestClass
  include KuduUi::DynamicMethods
  
  dynamic_method /render_(\w*)/ do |name, arg1, arg2|
    [name, arg1, arg2]
  end
end

class DynamicMethodsTest < ActiveSupport::TestCase
  test "TestClass should have inheritable array 'dynamic_methods'" do
    assert_kind_of Array, DynamicMethodTestClass.dynamic_methods
    t = DynamicMethodTestClass.new
    assert_kind_of Array, t.dynamic_methods
  end
  
  test 'TestClass#render_foo should not raise method missing error' do
    assert_nothing_raised do
      DynamicMethodTestClass.new.render_foo 'a', 'b'
    end
  end
  
  test "After first call, TestClass should respond to dynamic method" do
    DynamicMethodTestClass.new.render_bar 1, 2
    assert_respond_to DynamicMethodTestClass.new, :render_bar
  end
  
  test "Dynamic method should receive captures and arguments" do
    response = DynamicMethodTestClass.new.render_baz 1, 2
    
    assert_equal ['baz', 1, 2], response
  end
  
  test 'Should still raise on other non existing methods' do
    assert_raise NoMethodError do
      DynamicMethodTestClass.new.foobar
    end
  end
end