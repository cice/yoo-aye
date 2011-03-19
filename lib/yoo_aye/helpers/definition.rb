require 'yoo_aye/helpers/list'

module YooAye
  module Helpers
    class Definition < List

      def term options = {}, &block
        term_tag.merge_hash options
        term_layouts << block
      end

      def definition options = {}, &block
        definition_tag.merge_hash options
        definition_layouts << block
      end

      def add_options items, *args
        super items.to_a, *args
      end

      protected
      def term_layouts
        @term_layouts ||= []
      end

      def definition_layouts
        @definition_layouts ||= []
      end

      def term_tag
        @term_tag ||= Tag.new
      end

      def definition_tag
        @definition_tag ||= Tag.new
      end

      def container_element
        :dl
      end

      def render_item item, index
        term, definition = item.to_a.map(&:to_s)

        render_term(term, index, term_tag.dup) +
        render_definition(definition, index, definition_tag.dup)
      end

      def render_term content, index, tag
        content = layout_item content, index, tag, term_layouts unless term_layouts.blank?
        render_tag :dt, content, tag.to_hash
      end

      def render_definition content, index, tag
        content = layout_item content, index, tag, definition_layouts unless definition_layouts.blank?
        render_tag :dd, content, tag.to_hash
      end
    end
  end
end
