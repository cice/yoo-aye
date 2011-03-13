module YooAye
  module Helpers
    class TableList
      module ConvenienceColumns
        def raw key, *args
          column key, *args, &raw_layouter(key)
        end
      
        def datetime key, *args
          options = args.extract_options!
          format = options.delete(:format) || :default
        
          column key, *(args << options), &datetime_layouter(key, format)
        end
      
        def paperclip key, *args
          options = args.extract_options!
          style = options.delete(:style) || :original
        
          column key, *(args << options), &paperclip_layouter(key, style)
        end

        protected
        def raw_layouter key
          view = @view
        
          proc do |item|
            view.concat item.send(key)
          end
        end
      
        def datetime_layouter key, format = :default
          view = @view
        
          proc do |item|
            unless (val = item.send(key)).nil?
              view.concat view.l(val, :format => format)
            end
          end
        end
      
        def paperclip_layouter key, style = :original
          view = @view
        
          proc do |item|
            view.concat view.image_tag(item.send(key).url(style))
          end
        end
      end
      include ConvenienceColumns
    end
  end
end
