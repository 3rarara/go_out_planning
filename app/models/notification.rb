class Notification < ApplicationRecord

  belongs_to :user
  belongs_to :subject, polymorphic: true

  enum action_type: { commented_to_own_plan: 0, liked_to_own_plan: 1, followed_me: 3, new_message: 4}

end
