class NameframeProp < ActiveRecord::Base
  belongs_to :asset
  belongs_to :asset_category
  belongs_to :nameframe
end
