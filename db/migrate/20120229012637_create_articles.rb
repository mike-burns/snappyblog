class CreateArticles < ActiveRecord::Migration
  def up
    create_table :articles do |t|
      t.timestamps
      t.string :title, :null => false, :default => ''
      t.text :body
    end
  end

  def down
    drop_table :articles
  end
end
