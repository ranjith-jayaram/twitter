class CreateHashtags < ActiveRecord::Migration[5.1]
  def change
    create_table :hashtags do |t|
      t.string :content

      t.timestamps
    end
    add_index :hashtags, [:created_at]
  end
end
