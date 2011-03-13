module YooAy::Helpers
  class Tag
    
    class << self
      def blank
        @_blank_tag ||= Tag.new.freeze
      end
    end
    
    attr_accessor :attributes, :parent
    HtmlAttributes = %w(abbr accept accesskey action align alt archive axis background bgcolor border cellpadding
      cellspacing char charoff charset checked cite classid clear code codebase codetype cols colspan compact content
      coords datetime declare defer dir disabled enctype face for frame frameborder headers height href hreflang hspace
      http_equiv id ismap label lang longdesc marginheight marginwidth maxlength media method multiple name nohref
      noresize noshade nowrap object onblur onchange onclick ondblclick onfocus onkeydown onkeypress onkeyup onload
      onmousedown onmousemove onmouseout onmouseover onmouseup onreset onselect onsubmit onunload profile prompt
      readonly rel rev rows rowspan rules scheme scope scrolling selected shape size span src standby start style
      summary tabindex target text title type usemap valign value valuetype version vlink vspace width).freeze


    HtmlAttributes.each do |html_attr|
      define_method "#{html_attr}=" do |value|
        if value.nil?
          @attributes.delete html_attr.to_sym
        else
          @attributes[html_attr.to_sym] = value
        end
      end

      define_method "#{html_attr}" do
        @attributes[html_attr.to_sym]
      end
    end

    def initialize options = {}
      @attributes = {
        :classes => [],
        :data => {}
      }

      options.each do |key, value|
        instance_variable_set :"@#{key}", value
      end
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
        hsh[:class] = classes.join(" ") unless classes.blank?
      end
    end

    def merge other_tag
      classes = @attributes[:classes] + other_tag.attributes[:classes]
      data = @attributes[:data].merge other_tag.attributes[:data]
      
      @attributes.merge other_tag.attributes
      @attributes[:classes] = classes
      @attributes[:data] = data
    end
    
    def merge_hash hsh
      classes = hsh.delete(:classes) || []
      data = hsh.delete(:data) || {}
      
      @attributes.merge hsh
      @attributes[:classes] += classes
      @attributes[:data].merge! data
    end
    
    def freeze
      @attributes.freeze
      super      
    end
  end
end
