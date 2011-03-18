require 'spec_helper'

module YooAye::Helpers
  describe TableList do
    before :each do
      book = Struct.new :title, :author, :published_at, :last_read
      books = [
        book.new("Im Westen Nichts Neues", "Erich Maria Remarque", '1929', 3.years.ago),
        book.new("Narziss und Goldmund", "Hermann Hesse", '1930', 5.years.ago)
      ]
      
      assign :books, books
    end
    
    it 'renders a table with thead and tbody' do
      render_haml <<-HAML
        = ui.table_list @books do |t|
          - t.column :author do |book|
            = book.author
          - t.column :title do |book|
            = book.title
      HAML
      
      rendered.should have_selector('table thead tr th', :count => 2 )
      rendered.should have_selector('table tbody tr', :count => 2)
      rendered.should have_selector('td', :content => 'Narziss und Goldmund')
      rendered.should have_selector('td', :content => 'Erich Maria Remarque')
    end
  end
end