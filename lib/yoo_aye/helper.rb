module YooAye
  class Helper
    attr_reader :view, :controller

    def initialize view, controller = nil
      @view, @controller = view, controller || view.controller
    end
  end
end
