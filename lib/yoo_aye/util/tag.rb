module YooAye
  module Util
    class Tag
      attr_accessor :attributes
      class_inheritable_array :html_attributes
      self.html_attributes = %w(abbr accept accesskey action align alt archive axis background bgcolor border cellpadding cellspacing char charoff charset checked cite classid clear code codebase codetype cols colspan compact content coords datetime declare defer dir disabled enctype face for frame frameborder headers height href hreflang hspace http_equiv id ismap label lang longdesc marginheight marginwidth maxlength media method multiple name nohref noresize noshade nowrap object onblur onchange onclick ondblclick onfocus onkeydown onkeypress onkeyup onload onmousedown onmousemove onmouseout onmouseover onmouseup onreset onselect onsubmit onunload profile prompt readonly rel rev rows rowspan rules scheme scope scrolling selected shape size span src standby start style summary tabindex target text title type usemap valign value valuetype version vlink vspace width)

      class << self
        def blank
          @_blank_tag ||= Tag.new.freeze
        end
        
        def initialize_html_attributes
          html_attributes.each do |html_attr|
            define_method "#{html_attr}=" do |value|
              if value.nil?
                @attributes.delete html_attr
              else
                @attributes[html_attr] = value
              end
            end

            define_method "#{html_attr}" do
              @attributes[html_attr]
            end
          end
        end
      end
      initialize_html_attributes
      
      def initialize options = {}
        @attributes = {
          :classes => [],
          :data => {}
        }
        merge_hash options.symbolize_keys
      end

      def dup
        (super).tap do |duped|
          duped.attributes = duped.attributes.dup
          duped.attributes[:classes] = duped.attributes[:classes].dup
          duped.attributes[:data] = duped.attributes[:data].dup
        end
      end

      def classes
        @attributes[:classes] ||= []
      end

      def data
        @attributes[:data] ||= {}
      end

      def to_hash
        @attributes.dup.tap do |hsh|
          classes = hsh.delete(:classes).reject &:blank?
          hsh[:class] = classes.compact.join(" ") unless classes.blank?
          
          data = hsh.delete :data
          if data.is_a? Hash
            data.each do |key, val|
              hsh[:"data-#{key}"] = val
            end
          end
        end
      end

      def merge other_tag
        classes = @attributes[:classes] + other_tag.attributes[:classes]
        data = @attributes[:data].merge other_tag.attributes[:data]
      
        @attributes.merge! other_tag.attributes
        @attributes[:classes] = classes
        @attributes[:data] = data
      end
    
      def merge_hash other_hash
        other_hash = other_hash.dup
        class_  = other_hash.delete(:class)    || nil  
        classes = other_hash.delete(:classes)  || []
        data    = other_hash.delete(:data)     || {}
        classes += [class_]
      
        @attributes.merge! other_hash
        @attributes[:classes] += classes
        @attributes[:data] = @attributes[:data].merge data
      end
    
      def freeze
        @attributes.freeze
        super      
      end
    end
  end
end