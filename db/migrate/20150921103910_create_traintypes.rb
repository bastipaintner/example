class CreateTraintypes < ActiveRecord::Migration
  def change
    create_table :traintypes do |t|
      t.string :name, unique: true

      t.timestamps null: false
    end
  end
end
