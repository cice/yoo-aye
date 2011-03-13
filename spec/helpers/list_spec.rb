require 'spec_helper'

module YooAye::Helpers
  describe List do
    it 'renders a list' do
      assign :items, %w(one two three)
      
      render_haml <<-HAML
        = ui.list @items do |l|
          - l.item do |item|
            = item.upcase
      HAML
      
      rendered.should have_selector('ul')
      rendered.should have_selector('li', :content => 'ONE')
      rendered.should have_selector('li', :count => 3)
    end
  end
end