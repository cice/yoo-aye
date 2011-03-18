require 'spec_helper'

module YooAye::Helpers
  describe TableList do
    before :each do
      book = Struct.new :title, :author, :published_at, :last_read
      books = [
        book.new("Im Westen Nichts Neues", "Erich Maria Remarque", '1929', DateTime.civil(2006)),
        book.new("Narziss und Goldmund", "Hermann Hesse", '1930', DateTime.civil(2008))
      ]
      
      assign :books, books
    end
    
    it 'renders a table with thead and tbody' do
      render_haml <<-HAML
        = ui.table_list @books do |t|
          - t.column :author do |book|
            = book.author
          - t.column :title, 'Book Title' do |book|
            = book.title
      HAML
      
      rendered.should have_selector('table thead tr th', :count => 2 )
      rendered.should have_selector('table tbody tr', :count => 2)
      rendered.should have_selector('td', :content => 'Narziss und Goldmund')
      rendered.should have_selector('td', :content => 'Erich Maria Remarque')
      rendered.should have_selector('th', :content => 'Author')
      rendered.should have_selector('th', :content => 'Book Title')
    end
    
    it 'uses column keys as classes for td elements' do
      render_haml <<-HAML
        = ui.table_list @books do |t|
          - t.column :author do |book|
            = book.author
          - t.column :title do |book|
            = book.title
      HAML
      
      rendered.should have_selector('th.author', :count => 1)
      rendered.should have_selector('td.author', :count => 2)
    end
    
    it 'provides a string column shortcut' do
      render_haml <<-HAML
        = ui.table_list @books do |t|
          - t.string :author
      HAML
      
      rendered.should have_selector('td.author', :content => 'Hermann Hesse')
    end
    
    it 'provides a datetime column shortcut' do
      render_haml <<-HAML
        = ui.table_list @books do |t|
          - t.datetime :last_read
      HAML
      
      rendered.should have_selector('td.last_read', :content => 'Sun, 01 Jan 2006 00:00:00 +0000')
    end
    
    it 'accepts a format parameter for the datetime shortcut' do
      render_haml <<-HAML
        = ui.table_list @books do |t|
          - t.datetime :last_read, :format => :short
      HAML
      
      rendered.should have_selector('td.last_read', :content => '01 Jan 00:00')
    end
  end
end