module YooAye
  module Helpers
    class TableList
      class Column
        attr_accessor :key, :layouts, :tag, :head_layouts, :caption

        def initialize key, *args
          @key = key
          @layouts = []
          @head_layouts = nil
          @tag = Util::Tag.new :class => key
          add_options *args
        end

        def add_options *args
          tag.merge_hash args.extract_options!
          
          @caption = if caption = args.first
            caption
          else
            @key.to_s.humanize
          end
        end
        
        def independent_tag
          @tag.dup
        end
        
        def head_layouts
          @head_layouts || [caption]
        end
      end      
    end
  end
end
