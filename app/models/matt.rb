class Matt < ActiveRecord::Base
  has_many :permissions, :class_name => "FrameMattPermissions", :foreign_key => :top_matt_id
  def matt_address_path
    "#{RAILS_ROOT}/public/assets/matts/#{image}"
  end
  def matt_address_path_core
    "#{RAILS_ROOT}/public/assets/matts/#{core_image}"
  end
end
