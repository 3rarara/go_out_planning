class Notification < ApplicationRecord

  belongs_to :user
  belongs_to :subject, polymorphic: true

  enum action_type: { new_plan: 0, commented_to_own_plan: 1, liked_to_own_plan: 2, followed_me: 3, new_message: 4}

end
