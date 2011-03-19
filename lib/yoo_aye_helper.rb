module YooAyeHelper
  def self.included klass
    unless klass.method_defined? :ui
      klass.send :alias_method, :ui, :yoo_aye
    end
  end

  def yoo_aye
    @ui_generator ||= YooAye::Helper.new(self)
  end
end