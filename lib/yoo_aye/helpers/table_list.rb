require 'yoo_aye/helpers/list'

module YooAye
  module Helpers
    class TableList < List
      autoload :Column, 'yoo_aye/helpers/table_list/column'
      autoload :Columns, 'yoo_aye/helpers/table_list/columns'

      include Columns

      alias_method :row, :item
      attr_accessor :columns

      def initialize view, controller = nil
        super

        @columns = ActiveSupport::OrderedHash.new do |columns, key|
          key = key.to_sym

          if columns.has_key? key
            columns[key]
          else
            columns[key] = Column.new key
          end
        end
      end

      def column key, *args, &block
        columns[key].tap do |column|
          column.add_options *args
          column.layouts << block if block
        end
      end

      def head key, caption = nil, &block
        caption ||= block
        columns[key].tap do |column|
          column.add_head_layout caption
        end
      end

      protected
      def container_element
        :table
      end

      def item_element
        :tr
      end

      def render_container &items
        super do
          render_tag(:thead, render_head_cells) +
          render_tag(:tbody, &items)
        end
      end

      def layout_item item, index, row_tag
        additional = layouts.sum "" do |layout|
          apply_layout layout, item, index, row_tag
        end

        rendered_columns = @columns.sum "" do |key, column|
          tag = column.independent_tag
          cell_content = render_column item, index, column, tag

          render_tag :td, cell_content, tag.to_hash
        end

        rendered_columns + additional
      end

      def render_column item, index, column, tag
        column.layouts.sum "" do |layout|
          apply_layout layout, item, index, tag
        end
      end

      def render_head_cells
        render_tag item_element do
          "".tap do |out|
            columns.each do |key, column|
              head_cell_content = render_head_cell column
              out << render_tag(:th, head_cell_content, column.tag.to_hash)
            end
          end.html_safe
        end
      end

      def render_head_cell column
        column.head_layouts.sum "" do |layout|
          apply_layout layout
        end.html_safe
      end
    end
  end
end

# require 'yoo_ay/helpers/table_list/convenience_columns'
