class CreateUserFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :user_feedbacks do |t|
      t.integer :grade
      t.string :comment
      t.references :professional, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
