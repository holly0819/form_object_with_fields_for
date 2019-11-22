class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :name
      t.integer :page
      t.references :auther, null: false, foreign_key: true

      t.timestamps
    end
  end
end
