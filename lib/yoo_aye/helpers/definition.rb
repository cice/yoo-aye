require 'yoo_aye/helpers/list'

module YooAye
  module Helpers
    class Definition < List
      
      def term &block
        term_layouts << block
      end
      
      def definition &block
        definition_layouts << block
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
