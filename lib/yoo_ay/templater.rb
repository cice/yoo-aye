module YooAy
  class Templater
    BRA = "${".freeze
    KET = "}".freeze
    METHODS_TO_KEEP = %w(blank? == ===).freeze
  
    instance_methods.each do |method|
      unless /(\A__|\?\Z)/.match(method) || METHODS_TO_KEEP.include?(method.to_s)
        undef_method method
      end
    end
  
    def id
      __wrap__ 'id'
    end
  
    def to_key
      [id]
    end
  
    def class
      Templater.new "_class", self
    end
  
    def initialize method = nil, parent = nil
      @method = method
      @parent = parent
    end
    
    def method_missing name, *args
      Templater.new name.to_s, self
    end
  
    def to_s
      __wrap__ __chain__
    end
    alias_method :inspect, :to_s
  
    def __chain__
      (@parent ? @parent.__chain__ : []) + [@method]
    end  
  
    protected
    def __wrap__ word
      word = Array(word).compact * "."
      BRA + word + KET
    end
  end
end