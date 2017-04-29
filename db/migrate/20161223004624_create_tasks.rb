class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :memo , limit: 100_000
      t.integer :days

      t.timestamps
    end
  end
end
