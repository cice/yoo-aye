require 'yoo_ay/dynamic_methods'

module YooAy
  class Helper
    attr_reader :view, :controller

    def initialize view, controller = nil
      @view, @controller = view, controller || view.controller
    end

  end
  
  module Helpers
    autoload :Base,           'yoo_ay/helpers/base'
    autoload :Tag,            'yoo_ay/helpers/tag'
    autoload :List,           'yoo_ay/helpers/list'
    autoload :TableList,      'yoo_ay/helpers/table_list'
    autoload :ResourceTable,  'yoo_ay/helpers/resource_table'
    
    [List, TableList, ResourceTable].each do |generator|
      generator.load_and_inject
    end
  end
end
