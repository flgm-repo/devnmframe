class Asset < ActiveRecord::Base
  require 'rubygems'
  require 'uuidtools'

  belongs_to :asset_category
  has_many :nameframe_props
  has_many :nameframes, :through => :nameframe_props
  def validate_on_create()
    if self.uuid.nil?
      self.uuid = UUIDTools::UUID.timestamp_create().to_s
    end
  end

end
