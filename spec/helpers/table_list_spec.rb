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
    
    it 'accepts options for html attributes' do
      render_haml <<-HAML
        = ui.table_list @books do |t|
          - t.column :author, :class => 'an-author' do |book|
            = book.author
      HAML
      
      rendered.should have_selector('th.author.an-author', :count => 1)
      rendered.should have_selector('td.author.an-author', :count => 2)
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
          - t.string :author, :html => {:class => 'an-author'}
      HAML
      
      rendered.should have_selector('td.author.an-author', :content => 'Hermann Hesse')
      rendered.should have_selector('td.author.an-author', :content => 'Erich Maria Remarque')
    end
    
    it 'provides a shortcut column for arbitrary ActionView helpers' do
      view.should_receive(:highlight).with("Im Westen Nichts Neues", 'N')
      view.should_receive(:highlight).with("Narziss und Goldmund", 'N')
   
      render_haml <<-HAML
        = ui.table_list @books do |t|
          - t.helper :title, :highlight, 'N'
          - t.helper :author, :truncate, :length => 5
      HAML
      
      rendered.should have_selector('td.author', :content => 'Er...')
      rendered.should have_selector('td.author', :content => 'He...')
    end
    
    it 'provides a localize column shortcut' do
      render_haml <<-HAML
        = ui.table_list @books do |t|
          - t.localize :last_read, :html => {:class => 'a-date'}
      HAML
      
      rendered.should have_selector('td.last_read.a-date', :content => 'Sun, 01 Jan 2006 00:00:00 +0000')
    end
    
    it 'accepts a format parameter for the localize shortcut' do
      render_haml <<-HAML
        = ui.table_list @books do |t|
          - t.localize :last_read, :format => :short
      HAML
      
      rendered.should have_selector('td.last_read', :content => '01 Jan 00:00', :count => 2)
    end
  end
end