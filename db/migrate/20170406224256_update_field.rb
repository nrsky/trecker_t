class UpdateField < ActiveRecord::Migration[5.0]
  def change
    add_column :fields, :shape, :geometry
  end
end
