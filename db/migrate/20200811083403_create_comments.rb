class CreateComments < ActiveRecord::Migration[6.0]
  def change
  	create_table :comments do |t|
  		t.text :post_id
  		t.text :content
  		
  		t.timestamps
  	end
  end
end
