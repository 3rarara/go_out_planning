class ViewCount < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :plan

  validates :user, uniqueness: { scope: :plan_id }, if: -> { user.present? }
  validates :user_or_ip, uniqueness: { scope: :plan_id }, if: -> { user.nil? }
end
