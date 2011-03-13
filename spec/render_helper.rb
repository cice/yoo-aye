require 'active_support/all'
require 'action_view'
require 'haml'
require 'haml/template'

module RenderHelper
  attr_accessor :rendered
  
  def render_haml haml_string
    haml_string = normalize_haml haml_string
    
    @rendered = view.capture do
      view.render :inline => haml_string, :type => :haml
    end
  end
  
  def assign name, value
    view.assign name => value
  end
  
  protected
  def view
    @view
  end
  
  def initialize_view
    @view = ActionView::Base.new
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
end