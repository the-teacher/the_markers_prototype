class CreateMarkersContexts < ActiveRecord::Migration
  def change
    create_table :markers_contexts do |t|
      t.string :slug,  default: ""
      t.string :title, default: ""

      t.boolean :public, default: true

      # nested set
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth

      t.timestamps
    end
  end
end
