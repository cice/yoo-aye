require 'spec_helper'

module YooAye::Helpers
  describe Definition do
    before :each do
      assign :items, {
        :one => 'First',
        :two => "Second"
      }
    end
    
    it 'renders a definition list' do
      render_haml <<-HAML
        = ui.definition @items.to_a
      HAML
      
      rendered.should have_selector('dl dt', :content => 'one')
      rendered.should have_selector('dl dt', :content => 'two')
      rendered.should have_selector('dl dd', :content => 'First')
      rendered.should have_selector('dl dd', :content => 'Second')
    end
    
    it 'provides an option to customize rendering of dt and dd' do
      render_haml <<-HAML
        = ui.definition @items.to_a do |d|
          - d.term do |term|
            %em
              = term
          - d.definition do |definition|
            %strong
              = definition
      HAML
      
      rendered.should have_selector('dl dt em', :content => 'one')
      rendered.should have_selector('dl dt em', :content => 'two')
      rendered.should have_selector('dl dd strong', :content => 'First')
      rendered.should have_selector('dl dd strong', :content => 'Second')
    end
    
    it 'provides an item index and tag for custom rendering blocks' do
      render_haml <<-HAML
        = ui.definition @items.to_a do |d|
          - d.term do |term, index, tag|
            - tag.id = "term-\#{index + 1}"
            = term
      HAML
      
      rendered.should have_selector('dl dt#term-1')
      rendered.should have_selector('dl dt#term-2')
    end
  end
end