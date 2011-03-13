require 'yoo_aye/helpers/base'

module YooAye
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
      
      protected
      def render_container &block
        render_tag :ul, Tag.blank, &block
      end

      def render_items
        "".tap do |out|
          items.each_with_index do |item, index|
            out << render_item(item, index)
          end
        end.html_safe
      end

      def render_item item, index
        item_attributes = clone_item_attributes
        item_content = layout_item item, index, item_attributes

        render_tag :li, item_content.html_safe, item_attributes.to_hash
      end

      def layout_item item, index, tag
        layouts.sum "" do |layout|
          apply_layout layout, item, index, tag
        end
      end

      def apply_layout layout, item = nil, index = nil, tag = nil
        @view.capture do
          layout.call *arguments_for_layout(layout, item, index, tag)
        end
      end

      def arguments_for_layout layout, item, index, tag
        [item, index, tag].compact[0, layout.arity]
      end

      def locals_for_item item, index, tag
        {
          :item => item,
          :item_counter => index,
          :tag => tag
        }
      end
      
      private
      def clone_item_attributes
        unless layouts.all? {|l| l.arity < 3}
          @item_attributes.dup
        else
          @item_attributes
        end
      end
    end
  end
end

