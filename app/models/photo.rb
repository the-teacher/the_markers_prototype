class Photo < ActiveRecord::Base
  include HasMarkers
  validates :title, :file, presence: true
end
