unless Rails.env.production?
  class JavascriptTest
    extend ActiveModel::Naming
    attr_accessor :name, :content
    
    def initialize name, content
      @name, @content = name, content
    end
        
    class << self
      def all
        @javascript_tests ||= test_files.map do |filename|
          name = name_from_file(filename)
          content = File.read(filename) 
          
          new(name, content)
        end + [
          new("all", all_tests)
        ]
      end
      
      def find name
        all.find do |test|
          test.name == name
        end
      end
      
      protected
      def all_tests
        test_files.sum("") do |file|
          File.read(file) + "\n"
        end
      end
      
      def name_from_file filename
        /\/([^\/]+)_test\.js$/.match(filename)[1] rescue nil
      end
      
      def test_files
        Dir.glob test_files_path
      end
      
      def test_files_path
        File.join File.dirname(__FILE__), %w(.. .. test javascript ** *_test.js)
      end
    end
  endend