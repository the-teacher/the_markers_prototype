class CreateMarkerRelations < ActiveRecord::Migration
  def change
    create_table :marker_relations do |t|
      t.integer :marker_id

      t.integer :holder_id
      t.string  :holder_type

      t.string :state, default: :active

      t.timestamps
    end
  end
end
