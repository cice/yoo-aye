require 'test_helper'

module UiGenerators
  class ListTest < ActionView::TestCase
    include UiGeneratorTestHelper
    
    context 'List generator' do
      setup do
        @generator = KuduUi::UiGenerators::List
        @list = @generator.new _view
      end
          
      should_have_snippets :unordered, :ordered, :item

      should 'have default type :unordered' do
        assert_equal :unordered, @list.type        
      end
    end
    
    context "Generated list" do
      setup do
        render_haml <<-HAML
          = ui.list 'list_id', %w(one two three) do |l|
            - l.item.classes << 'a-list-item'
            - l.item do |item, counter, tag|
              - tag.classes << 'list-' + counter.to_s
              - tag.id = 'item-' + counter.to_s
              %em
                = item
        HAML
      end
      
      should 'render a list containing the items' do
        assert_select 'ul', 1 do
          assert_select 'li', 3
          assert_select 'li.a-list-item', 3
          assert_select 'li.list-0', 1
          assert_select 'li.list-1', 1
          assert_select 'li.list-2', 1
          assert_select 'li#item-0', 1
          assert_select 'li#item-1', 1
          assert_select 'li#item-2', 1
          assert_select 'em', 'one'
          assert_select 'em', 'two'
          assert_select 'em', 'three'
        end
      end
    end
    
    context 'Generated ordered list' do
      setup do
        render_haml <<-HAML
          = ui.list 'list_id', %w(one two three), :type => :ordered do |l|
            - l.item.classes << 'a-list-item'
            - l.item do |item, counter, tag|
              - tag.classes << 'list-' + counter.to_s
              - tag.id = 'item-' + counter.to_s
              %em
                = item
        HAML
      end
      
      should 'render an ordered list' do
        assert_select 'ol', 1
      end
    end
  end
end