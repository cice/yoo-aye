unless Rails.env.production?
  class JavascriptTestsController < ApplicationController
    def index
      @javascript_tests = JavascriptTest.all
      
      render :layout => false
    end    
    
    def show
      @javascript_test = JavascriptTest.find params[:id]
      
      render :layout => false
    end
  endend