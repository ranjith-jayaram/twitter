class CreateTrends < ActiveRecord::Migration[5.1]
  def change
    create_table :trends do |t|
      t.integer :hashtag_id
      t.integer :micropost_id

      t.timestamps
    end
  end
end
