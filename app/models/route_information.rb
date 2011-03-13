class RouteInformation
  attr_accessor :path, :verb, :name, :requirements, :segment_keys
  
  extend ActiveModel::Naming
  
  
  def initialize route
    %w(path verb name requirements segment_keys).each do |key|
      send "#{key}=", route.send(key)
    end
  end
  
  def namespace
    controller &&
    match = controller.match(/^(.*)\/[^\/]+$/) &&
    match[1]
  end
  
  def controller
    requirements[:controller]
  end
  
  def action
    requirements[:action]
  end
    
  def as_json options = {}
    {
      :path => path,
      :segments => segments,
      :segment_keys => segment_keys - [:format],
      :name => name,
      :verb => verb
    }.as_json
  end
  
  def segments
    @segments ||= @path.sub("(.:format)",'').split(/\:[^\.\/\?]+/)
  end
  
  class << self    
    def all conditions = {}
      @all ||= ActionDispatch::Routing::Routes.routes.map do |route|
        new route
      end
      
      return @all if conditions.blank?
      conditions = conditions.symbolize_keys.slice :path, :verb, :name, :requirements, :action, :controller
      
      @all.select do |route|
        conditions.to_a.all? do |kv|
          route.send(kv.first) == kv.last
        end
      end
    end
  end    
end