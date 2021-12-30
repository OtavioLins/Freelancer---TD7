# frozen_string_literal: true

class AddUserIdToUserFeedbacks < ActiveRecord::Migration[6.1]
  def change
    add_reference :user_feedbacks, :user, null: false, foreign_key: true
  end
end
