class CreateProjectApplications < ActiveRecord::Migration[6.1]
  def change
    create_table :project_applications do |t|
      t.string :motivation
      t.string :expected_conclusion
      t.integer :weekly_hours
      t.decimal :expected_payment
      t.references :project, null: false, foreign_key: true
      t.references :professional, null: false, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
