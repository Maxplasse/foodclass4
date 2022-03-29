class AddPostedAtToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :posted_at, :datetime
  end
end
