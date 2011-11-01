require 'action_view'

module YooAye::Helpers
  module TableList::Columns
    extend ActiveSupport::Concern
    
    def string key, *args
      column key, html_options_in_args(args) do |item|
        view.concat get_item_value(item, key).to_s
      end
    end

    def helper key, helper, *args
      column key, html_options_in_args(args) do |item|
        view.concat eval_helper(get_item_value(item, key), helper, *args_for_helper(args))
      end
    end

    included do
      ActionView::Helpers.instance_methods.each do |helper_name|
        next if method_defined?(helper_name)
        
        define_method helper_name do |key, *args|
          helper key, helper_name, *args
        end
      end
    end
    
    protected
    def method_missing name, key, *args, &block
      helper key, name, *args, &block
    end
    
    def get_item_value item, key
      return item if key == :self
      
      keys = key.to_s.split('.')
      
      keys.inject item do |associated_item, key|
        associated_item.try key
      end
    end

    private
    def args_for_helper args
      args = args.dup

      options = args.pop
      if options.is_a?(Hash)
        # Rails' ActionView Helpers DO modify option hashes passed to them, (which stinks big time)
        # so we have to dup options hashes for Rails' helpers.
        options = options.except :html
      end

      if options
        args + [options]
      else
        args
      end
    end

    def eval_helper value, helper, *args
      view.send helper, value, *args
    end

    def options_in_args args
      options = args.last
      options.is_a?(Hash) ? options : {}
    end

    def html_options_in_args args
      options_in_args(args)[:html]
    end
  end
end