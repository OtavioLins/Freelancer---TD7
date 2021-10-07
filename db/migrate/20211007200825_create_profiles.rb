class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.string :full_name
      t.string :social_name
      t.string :educational_background
      t.string :description
      t.string :prior_experience
      t.date :birth_date
      t.references :professional, null: false, foreign_key: true
      t.references :occupation_area, null: false, foreign_key: true

      t.timestamps
    end
  end
end
