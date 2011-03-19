require 'yoo_aye/helpers/base'

module YooAye
  module Helpers
    class List < Base
      attr_accessor :items, :layouts

      def initialize view, controller = nil
        super

        @item_attributes = Tag.new
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
      def container_element
        :ul
      end
      
      def item_element
        :li
      end
      
      def render_container &block
        render_tag container_element, tag_hash, &block
      end

      def render_items
        "".tap do |out|
          items.each_with_index do |item, index|
            out << render_item(item, index)
          end
        end.html_safe
      end

      def render_item item, index
        render_tag item_element, *arguments_for_render_item(item, index)
      end
      
      def arguments_for_render_item item, index
        item_attributes = clone_item_attributes
        [
          layout_item(item, index, item_attributes),
          item_attributes.to_hash
        ]
      end

      def layout_item item, index, tag, layouts = self.layouts
        layouts.sum "" do |layout|
          apply_layout layout, item, index, tag
        end.html_safe
      end

      def apply_layout layout, item = nil, index = nil, tag = nil
        case layout
        when String
          layout
        when Proc
          @view.capture do
            layout.call *arguments_for_layout(layout, item, index, tag)
          end
        else
          ""
        end
      end

      def arguments_for_layout layout, item, index, tag
        [item, index, tag].compact[0, layout.arity]
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

