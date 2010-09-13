class SiteContent < ActiveRecord::Base
  belongs_to :section
  has_attachment :storage => :file_system,
    :processor => :rmagick,
    :resize_to => [70,90]
  before_destroy :set_content_type

  def set_content_type
    self.filename = "" if self.filename.nil?
    self.save
  end
end
