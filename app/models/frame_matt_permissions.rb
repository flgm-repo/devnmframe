class FrameMattPermissions < ActiveRecord::Base
  belongs_to :bottom_matt, :class_name => "Matt"
  belongs_to :top_matt, :class_name => "Matt"
  named_scope :allowed, :conditions => {:allowed => true}
  named_scope :not_allowed, :conditions => {:allowed => false}
  named_scope :distinct_bottom_matt, :select => "DISTINCT bottom_matt_id"
  named_scope :distinct_top_matt, :select => "DISTINCT top_matt_id"
  named_scope :by_frame, lambda { |frame| { :conditions => ["frame_id = ?", frame] } }
end
