class MarkerRelation < ActiveRecord::Base
  validates :holder_id, :holder_type, :marker_id, presence: true
  validates_uniqueness_of :marker_id, scope: [:holder_id, :holder_type]

  belongs_to :holder, polymorphic: true
  belongs_to :marker
end
