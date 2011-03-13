# TODO: extend 'respond_to?'
module YooAy
  module Util
    module DynamicMethods
      class DynamicMethod
        attr_accessor :pattern, :definition
      
        # Create new DynamicMethod. Excepts a RegEx pattern as first argument
        # and the method definition as block argument.
        def initialize pattern, &definition
          @pattern, @definition = pattern, definition
        end
      
        # If method hasn't been defined, define method in receiver's class
        def define receiver, name, captures
          return if receiver.respond_to? name
        
          method_definition = definition
          receiver.class.send :define_method, name do |*args|
            instance_exec *(captures + args), &method_definition
          end
        end
      
        # Invoke method with given arguments and block
        def call receiver, name, *args, &block
          receiver.send name, *args, &block
        end
      
        # Define and call method.
        def define_and_call receiver, name, captures, *args, &block
          define receiver, name, captures
          call receiver, name, *args, &block
        end
      end
    
    
      module ClassMethods      
        # Define a dynamic method, accepts a Regex pattern (optionally with captures)
        # and a block which defines the method body.
        # e.g.
        #   dynamic_method /render_(\w+)_(\w+) do |capture1, capture2, argument1, argument2| ; end
        def dynamic_method pattern, &method_definition_block        
          dynamic_methods << DynamicMethod.new(pattern, &method_definition_block)
        end
      end
    
      module InstanceMethods
        def method_missing name, *args, &block #:nodoc:
          match = nil
          matching_method = dynamic_methods.find do |dynamic_method|
            match = dynamic_method.pattern.match name.to_s
          end
        
          if match
            matching_method.define_and_call self, name, match.captures, *args, &block
          else
            method_missing_without_dynamic_methods name, *args, &block
          end
        end
      end
    
      def self.included receiver #:nodoc:
        receiver.send :alias_method, :method_missing_without_dynamic_methods, :method_missing
      
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      
        receiver.send :class_inheritable_array, :dynamic_methods
        receiver.dynamic_methods = []
      end
    end
  end
end