require 'test_helper'

module UiGenerators
  class TableListTest < ActionView::TestCase
    include UiGeneratorTestHelper
    
    context 'TableList generator' do
      setup do
        @generator = KuduUi::UiGenerators::TableList
        @list = @generator.new _view
      end
          
      should_have_snippets :simple, :cell, :item

      should 'have default type :simple' do
        assert_equal :simple, @list.type        
      end
    end
    
    context "Generated simple TableList" do
      setup do
        render_haml <<-HAML
          = ui.table_list %w(one two three),'list_id' do |l|
            - l.item.classes << 'a-list-item'
            - l.row.classes << 'a-table-row'
            - l.row do |item, i, tag|
              - tag.id = "item-\#{i}"
              %td.add
                Foo
            - l.column :column_one do |item, counter, tag|
              - tag.classes << 'col1'
              = item.upcase
        HAML
      end
      
      should 'render a list containing the items' do
        assert_select 'table#list_id', 1 do
          assert_select 'tbody' do
            assert_select 'tr', 3
            assert_select 'tr.a-list-item', 3
            assert_select 'tr.a-table-row', 3
            assert_select 'tr#item-0', 1
            assert_select 'tr#item-1', 1
            assert_select 'tr#item-2', 1
            assert_select 'td.col1', 'ONE'
            assert_select 'td.col1', 'TWO'
            assert_select 'td.col1', 'THREE'
            assert_select 'td.add', 3
          end
        end
      end
    end
  end
end