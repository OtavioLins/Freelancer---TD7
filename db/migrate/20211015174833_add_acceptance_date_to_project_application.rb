# frozen_string_literal: true

class AddAcceptanceDateToProjectApplication < ActiveRecord::Migration[6.1]
  def change
    add_column :project_applications, :acceptance_date, :date
  end
end
