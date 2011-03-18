require 'haml'
require 'yoo_aye/util/tag'

module YooAye::Helpers
  class Base
    include YooAye::Util
    
    class << self
      def generator_method_name
        name.demodulize.underscore
      end

      # Instantiates a generator with given arguments and calls #to_html
      def generate view, controller, *args, &block
        new(view, controller).tap do |ui|
          ui.add_options *args
          block[ui]
        end.to_html
      end

      def inject
        YooAye::Helper.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{generator_method_name} *args, &block
            #{self.name}.generate view, controller, *args, &block
          end
        RUBY
      end
    end
    attr_accessor :view, :controller

    def initialize view, controller
      @view, @controller = view, controller
    end

    def tag
      @tag ||= Tag.new
    end

    def tag_hash
      @tag.to_hash
    end

    # Default options behavior: assign hash key/values to instance variables
    def add_options *args
      tag.merge_hash args.extract_options!
    end

    def render_tag *args, &block
      view.content_tag *args, &block
    end

    def to_html
      "#{self.class.name}#to_html"
    end
    
    protected
    def layoutify str
      view = @view
      
      proc do
        view.output_buffer << str
      end
    end
  end
end
