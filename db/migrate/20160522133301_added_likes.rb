class AddedLikes < ActiveRecord::Migration
  def change
    add_column :articles, :img, :string
    add_column :articles, :likes, :integer
    add_column :comments, :likes, :integer
  end
end
