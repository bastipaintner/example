class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :time_stamp
      t.references :train, index: true

      t.timestamps null: false
    end
  end
end
