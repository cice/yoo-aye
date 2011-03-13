module YooAye
  module Helpers
    class ResourceTable < TableList
      attr_accessor :resource
      
      class << self
        def load_and_inject
          inject
        end
      end
      
      
      def add_options items, resource_name, *args
        super
        
        @resource = resource_name.to_s.classify.constantize
        
        @item_attributes.classes << tag.id.to_s.singularize
        @layouts << proc { |item, index, row|
          row.id = @view.dom_id(item)
          row.classes << @view.dom_class(item)
        }
      end
      
      def render_column item, index, column, tag
        tag.classes << column.key
        
        super
      end
      
      def column key, *args, &block
        super
        options = args.extract_options!
        
        unless args.first
          columns[key].tap do |column|
            column.head_layouts << layoutify(human_attribute_name(key))
          end
        end
      end
      
      def links_to *actions
        column 'links_to', '' do |item|
          actions.each do |action|
            if has_action_helper? action
              @view.instance_eval do
                concat send("link_to_#{action}", item)
              end
            else
              path_args = [action, namespace, item]
            
              @view.instance_eval do
                concat link_to(t('.action'), path_args)
              end
            end
          end
        end
      end
      
      protected
      def human_attribute_name attribute
        @resource.human_attribute_name attribute
      end
      
      def namespace
        @view.controller_namespace
      end
      
      def has_action_helper? action
        @view.respond_to? "link_to_#{action}"
      end
    end
  end
end