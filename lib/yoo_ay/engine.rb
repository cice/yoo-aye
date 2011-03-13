require 'yoo_ay'
require 'rails'

module YooAy
  class Engine < Rails::Engine
    # class_attribute :paths
    
    def root
      File.expand_path '../../../', __FILE__
    end
    
    def path_to *paths
      File.join root, paths.flatten
    end
    
    def sass_imports_path
      path_to %w(app stylesheets imports)
    end
    
    def sass_ui_path
      path_to %w(app stylesheets ui)
    end    
    
    initializer "yoo_ay.setup_js_load_paths", :after => 'sprockets_rails.initialize' do |app|
      app.paths.app.sprockets_lib << path_to(%w(app javascripts lib))
      app.paths.app.sprockets << path_to(%w(app javascripts))
    end
    
    initializer "yoo_ay.setup_paths", :before => :set_load_path do |app|
      app.config.autoload_paths += [path_to(%w(app helpers))]
      
      app.paths.app.views << path_to(%w(app views))
    end
    
    initializer "yoo_ay.setup_sass_paths" do |app|
      Sass::Plugin.options[:load_paths] ||= []
      Sass::Plugin.options[:load_paths] << sass_imports_path
      Sass::Plugin.add_template_location sass_ui_path, File.join(Sass::Plugin.options[:css_location], 'yoo_ay')
    end    
  end
end
