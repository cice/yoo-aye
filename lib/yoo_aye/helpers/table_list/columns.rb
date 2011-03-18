module YooAye::Helpers
  module TableList::Columns
    def string key, *args
      args = args_clone args
      column key, html_options_in_args(args) do |item|
        view.concat item.send(key).to_s
      end
    end
    
    def datetime key, *args
      helper key, :localize, *args
    end
    
    def helper key, helper, *args
      column key, html_options_in_args(args) do |item|
        view.concat eval_helper(item.send(key), helper, *args_clone(args))
      end
    end
    
    protected
    # As Rails' ActionView Helpers DO modify option hashes passed to them, (which stinks big time)
    # we try to dup any hash within args
    def args_clone args
      args.map do |arg|
        arg.is_a?(Hash) ? arg.dup : arg
      end
    end
    
    def eval_helper value, helper, *args
      view.send helper, value, *args
    end
    
    def datetime_format value, format = nil
      format ||= :default
      view.localize value, :format => format
    end
    
    def options_in_args args
      options = args.last
      options.is_a?(Hash) ? options : {}
    end
    
    def html_options_in_args args
      options_in_args(args).delete :html
    end
  end
end