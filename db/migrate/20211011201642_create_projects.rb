class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :description
      t.string :skills
      t.decimal :hour_value
      t.date :date_limit
      t.integer :work_regimen, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
