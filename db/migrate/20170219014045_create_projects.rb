class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :memo, limit: 100_000

      t.timestamps
    end
  end
end
