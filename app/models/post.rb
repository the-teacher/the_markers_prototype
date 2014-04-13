class Post < ActiveRecord::Base
  include HasMarkers
  validates :title, :content, presence: true
end