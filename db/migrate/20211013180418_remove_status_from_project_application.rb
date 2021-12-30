# frozen_string_literal: true

class RemoveStatusFromProjectApplication < ActiveRecord::Migration[6.1]
  def change
    remove_column :project_applications, :status, :integer
  end
end
