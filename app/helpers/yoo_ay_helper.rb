module YooAyHelper
  def yoo_ay
    @ui_generator ||= YooAy::Helper.new(self)
  end
  alias_method :ui, :yoo_ay
end