require 'spec_helper'

module YooAye::Helpers
  describe List do
    before :each do
      assign :items, %w(one two three)
    end

    it 'renders a list' do
      render_haml <<-HAML
        = ui.list @items do |l|
          - l.item do |item|
            = item.upcase
      HAML

      rendered.should have_selector('ul')
      rendered.should have_selector('li', :content => 'ONE')
      rendered.should have_selector('li', :count => 3)
    end

    it 'uses attributes on container element' do
      render_haml <<-HAML
        = ui.list [], :class => 'a-list', :id => 'alist' do |l|
          - l.item do |item|
            = item.upcase

      HAML

      rendered.should have_selector('ul#alist.a-list')
    end

    it 'renders generic classes for items' do
      render_haml <<-HAML
        = ui.list @items do |l|
          - l.item.classes << 'some-class'
          - l.item do |item|
            = item.upcase
      HAML

      rendered.should have_selector('li.some-class', :count => 3)
    end

    it 'renders specific classes for items' do
      render_haml <<-HAML
        = ui.list @items do |l|
          - l.item do |item, i, tag|
            - tag.classes << item
            = item.upcase
      HAML

      rendered.should have_selector('li.one', :count => 1)
      rendered.should have_selector('li.two', :count => 1)
      rendered.should have_selector('li.three', :count => 1)
    end
  end
end