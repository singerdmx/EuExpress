class AddSlugToUser < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    add_index :users, :slug
    add_column :users, :uniqueness, :string
    add_column :users, :true, :string
  end
end
