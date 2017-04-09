class AddDriverRecord < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      t.datetime :timestamp
      t.float :latitude
      t.float :longitude
      t.string  :accuracy
      t.string  :speed
      t.timestamps
      t.belongs_to :driver, index: true
      t.belongs_to :company, index: true
    end
  end
end
