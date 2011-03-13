module YooAy
  module Helpers
    class TableList < List
      class Column
        attr_accessor :key, :layouts, :tag, :head_layouts


        def initialize key, options = {}
          @key = key
          @layouts = []
          @head_layouts = []
          @tag = Tag.new
          add_options options
        end

        def add_options options
          tag.merge_hash options
        end
        
        def independent_tag
          @tag.dup
        end
      end

      alias_method :row, :item
      attr_accessor :columns


      def type_default
        :simple
      end

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

      def layout_item item, index, row_tag
        additional = layouts.sum "" do |layout|
          apply_layout layout, item, index, row_tag
        end
        
        rendered_columns = @columns.sum "" do |key, column|
          tag = column.independent_tag
          cell_content = render_column item, index, column, tag
          
          render_action :cell, :tag => tag do
            cell_content
          end
        end
        
        rendered_columns + additional
      end

      def render_column item, index, column, tag
        column.layouts.sum "" do |layout|
          apply_layout layout, item, index, tag
        end
      end

      def column key, *args, &block
        options = args.extract_options!
        
        columns[key].tap do |column|
          if head = args.first
            column.head_layouts << layoutify(head)
          end
          column.add_options options
          column.layouts << block if block
        end
      end
      
      
      def head key, &block
        columns[key].tap do |column|
          column.head_layouts << block
        end
      end
      
      def render_head_cells
        "".tap do |out|
          columns.each do |key, column|
            out << render_action(:head, :tag => column.tag) {
              render_head_cell column
            }
          end          
        end
      end
      
      def render_head_cell column        
        column.head_layouts.sum "" do |layout|
          apply_layout layout
        end
      end
    end
  end
end

require 'yoo_ay/helpers/table_list/convenience_columns'
