class CreateMarkers < ActiveRecord::Migration
  def change
    create_table :markers do |t|
      t.integer :markers_context_id

      t.string :slug,  default: ""
      t.string :title, default: ""

      t.string :state, default: :active

      t.timestamps
    end
  end
end
