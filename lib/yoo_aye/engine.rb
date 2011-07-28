require 'yoo_aye'
require 'rails'

module YooAye
  class Engine < Rails::Engine
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
  end
end
