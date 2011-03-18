module YooAye
  module Util
    class Tag
      class << self
        def blank
          @_blank_tag ||= Tag.new.freeze
        end
      end
    
      attr_accessor :attributes, :parent
      class_inheritable_array :html_attributes
      
      def self.initialize_html_attributes
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
        classes = other_hash.delete(:classes)  || []
        data    = other_hash.delete(:data)     || {}
      
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