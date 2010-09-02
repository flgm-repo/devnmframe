class Ornament < ActiveRecord::Base
  has_many :nameframes
  def ornament_path
    "#{RAILS_ROOT}/public/assets/ornaments_mask/#{file_name}"
  end
  def ornament_outline_path
    "#{RAILS_ROOT}/public/assets/ornaments_mask_outline/#{file_name}"
  end
end
