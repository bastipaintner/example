class CreateTrains < ActiveRecord::Migration
  def change
    create_table :trains do |t|
      t.string :name, unique: true
      t.references :traintype, index: true
      t.string :ip_address, unique: true

      t.timestamps null: false
    end
  end
end
