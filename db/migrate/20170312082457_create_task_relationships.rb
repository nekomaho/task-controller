class CreateTaskRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :task_relationships do |t|
      t.integer :previous_id
      t.integer :next_id

      t.timestamps
    end
    add_index :task_relationships, :previous_id
    add_index :task_relationships, :next_id
    add_index :task_relationships, [:previous_id,:next_id],unique: true
  end
end
