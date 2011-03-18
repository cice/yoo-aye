module YooAye::Helpers
  module TableList::Columns
    def string key, *args
      column key, *args do |item|
        view.concat item.send(key).to_s
      end
    end
    
    def datetime key, *args
      format = options_in_args(args)[:format]
      column key, *args do |item|
        view.concat datetime_format(item.send(key), format)
      end
    end
    
    protected
    def datetime_format value, format = nil
      format ||= :default
      view.localize value, :format => format
    end
    
    def options_in_args args
      options = args.last
      options.is_a?(Hash) ? options : {}
    end
  end
end