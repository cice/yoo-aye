module YooAy
  module Helpers
    class List < Base
      attr_accessor :items, :layouts
      attr_writer :type

      # Designate default type
      def type
        @type || type_default
      end

      def type_default
        :unordered
      end

      def initialize view, controller = nil
        super

        @item_attributes = Tag.new :parent => self
        @layouts = []
      end

      def to_html
        render_container do
          render_items
        end
      end

      def render_container &block
        render_action type, &block
      end

      def render_items
        "".tap do |out|
          items.each_with_index do |item, index|
            out << render_item(item, index)
          end
        end
      end

      def locals_for_item item, index, tag
        {
          :item => item,
          :item_counter => index,
          :tag => tag
        }
      end

      def layout_item item, index, tag
        layouts.sum "" do |layout|
          apply_layout layout, item, index, tag
        end
      end

      def apply_layout layout, item = nil, index = nil, tag = nil
        @view.with_output_buffer do
          layout.call *arguments_for_layout(layout, item, index, tag)
        end
      end

      def arguments_for_layout layout, item, index, tag
        [item, index, tag].compact[0, layout.arity]
      end


      def render_item item, index
        cloned_attributes = unless layouts.all? {|l| l.arity < 3}
          @item_attributes.dup
        else
          @item_attributes
        end

        item_content = layout_item item, index, cloned_attributes

        render_action :item, locals_for_item(item, index, cloned_attributes) do
          item_content
        end

      end

      def add_options items, *args
        super

        @items = items
      end

      def item &block
        if block_given?
          self.layouts << block
        else
          @item_attributes
        end
      end
    end
  end
end
