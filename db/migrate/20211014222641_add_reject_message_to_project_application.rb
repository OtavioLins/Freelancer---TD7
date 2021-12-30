# frozen_string_literal: true

class AddRejectMessageToProjectApplication < ActiveRecord::Migration[6.1]
  def change
    add_column :project_applications, :reject_message, :string
  end
end
