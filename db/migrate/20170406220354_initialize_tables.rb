class InitializeTables < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.timestamps
    end

    create_table :drivers do |t|
      t.string :name
      t.timestamps
      t.belongs_to :company, index: true
    end

    create_table :fields do |t|
      t.string :name
      t.timestamps
    end
  end
end
