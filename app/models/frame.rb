class Frame < ActiveRecord::Base
  has_many :permissions, :class_name => "FrameMattPermissions"
  def self.allowed_bottom_matts
    FrameMattPermissions.find_all_by_allowed_and_frame_id_and_bottom_matt_id(true, Frame.find_by_uuid(session[:frame_selection]), nil)
  end

  def frame_address_path(size)
   if size == "small"
    frame = {:path => "#{RAILS_ROOT}/public/assets/frames/small/#{file_name}", :margin => 170, :top_border_size => 85,:right_border_size => 87, :bottom_border_size => 87, :left_border_size => 83}
   elsif size == "medium"
    frame = {:path => "#{RAILS_ROOT}/public/assets/frames/medium/#{file_name}", :margin => 155, :top_border_size => 80,:right_border_size => 80, :bottom_border_size => 78, :left_border_size => 82}
   else
    frame = {:path => "#{RAILS_ROOT}/public/assets/frames/large/#{file_name}", :margin => 189, :top_border_size => 90,:right_border_size => 90, :bottom_border_size => 90, :left_border_size => 91}
   end
  end
  def example_image_path
    "/assets/matts/#{example_image}"
  end
end

