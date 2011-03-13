require 'haml/engine'

module YooAy::Helpers
  class SnippetOrActionNotFound < Exception ; end

  class Base
    class_attribute :snippets

    class << self
      def load_and_inject
        inject
        self.snippets = {}
        load_snippets
      end

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
        YooAy::Helper.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{generator_method_name} *args, &block
            #{self.name}.generate view, controller, *args, &block
          end
        RUBY
      end

      def snippet_files
        Rails.application.paths.app.views.to_a.sum([]) do |template_dir|
          snippet_files_in_dir template_dir
        end
      end

      def snippet_files_in_dir template_dir
        Dir.glob template_dir + "/ui_snippets/" + name.demodulize.underscore + "/*.html.haml"
      end

      def load_snippets
        snippet_files.each do |file|
          action = file.match(/\/([^\/]+)\.html\.haml\Z/).captures.first.to_sym
          self.snippets[action] = Haml::Engine.new File.read(file)
        end
      end
    end

    def initialize view, controller
      @view, @controller = view, controller
      @tag = Tag.new
    end

    def tag
      @tag
    end

    def tag_hash
      @tag.to_hash
    end

    # Default options behavior: assign hash key/values to instance variables
    def add_options *args
      options = args.extract_options!

      @tag.merge_hash options
    end

    def render_action action, locals = {}, &block
      if snippets && snippet = snippets[action.to_sym]
        snippet.render self, locals, &block
      else
        raise SnippetOrActionNotFound, action.to_s
      end
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
