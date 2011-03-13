class RoutesController < ApplicationController
  inherit_resources
  defaults :resource_class => RouteInformation
  actions :index
  respond_to :json
  
  protected
  def collection
    @routes ||= RouteInformation.all params[:where]
  end
end