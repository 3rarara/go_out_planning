class ConvertToProgressiveJob < ApplicationJob
  queue_as :default

  def perform(plan_id)
    plan = Plan.find_by(id: plan_id)
    return unless plan&.plan_image&.attached?

    image_blob = plan.plan_image.blob
    image_blob.open do |tempfile|
      MiniMagick::Tool::Convert.new do |convert|
        convert.interlace "plane"
        convert << tempfile.path
        convert << tempfile.path # 同じファイルを上書きすることで、プログレッシブに変換された画像が保存される
      end
    end
  end
end