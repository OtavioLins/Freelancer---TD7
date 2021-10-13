class AddSituationToProjectApplication < ActiveRecord::Migration[6.1]
  def change
    add_column :project_applications, :situation, :integer, default: 0
  end
end
