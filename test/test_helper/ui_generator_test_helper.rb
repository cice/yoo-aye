require 'cells/assertions_helper'

module UiGeneratorTestHelper
  def self.included base
    base.send :helper, UiGeneratorHelper
  end
  
  def eval_haml haml_string
    Haml::Engine.new(normalize_haml(haml_string)).render(view_instance)
  end
  
  def render_haml haml_string, use_action_view = true
    haml_string = normalize_haml haml_string
    
    @rendered = if use_action_view
      render :inline => haml_string, :type => :haml
    else
      eval_haml haml_string
    end
  end
  
  def view_instance
    self.instance_eval 'binding'
  end
  
  def normalize_haml haml_string
    lines = haml_string.split("\n")
    
    while (first_line = lines.first).blank?
      return if lines.unshift.nil?
    end
    
    tabstops = first_line.match(/^(\s*)/)[1]
    lines.map! do |line|
      line.sub /^#{tabstops}/, ""
    end
    lines.join("\n")
  end
  
  
  def assert_rendered *args
    assert_selekt @rendered, *args
  end
  
  module FunctionalTestHelper
    def self.included base
      super 
      
      base.send :include, UiGeneratorTestHelper
    end
  end
end