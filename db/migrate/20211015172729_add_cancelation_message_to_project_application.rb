class AddCancelationMessageToProjectApplication < ActiveRecord::Migration[6.1]
  def change
    add_column :project_applications, :cancelation_message, :string
  end
end
