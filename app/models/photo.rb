class Photo < ActiveRecord::Base
  belongs_to :nameframe
  has_many :photo_customizations, :dependent => :destroy
  has_attachment :content_type => :image,
      :storage => :file_system,
    :size => 500..3.megabytes,
    :processor => :rmagick,
    :resize_to => '800x800>',
    :thumbnails => { :medium => '600x600>', :thumb => '100x100>' }

  before_save :assign_filename
  
  def assign_filename
    self.filename = "" if self.filename.nil?    
  end
  
end
