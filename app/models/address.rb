class Address < ActiveRecord::Base
  belongs_to :user
  validates_numericality_of :zip
  validates_length_of :zip, :is => 5
end

