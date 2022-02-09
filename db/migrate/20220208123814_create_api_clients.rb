# frozen_string_literal: true

class CreateApiClients < ActiveRecord::Migration[6.1]
  def change
    create_table :api_clients do |t|
      t.string :username
      t.string :password_digest

      t.timestamps
    end
  end
end
