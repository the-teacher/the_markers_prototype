class Marker < ActiveRecord::Base
  belongs_to :markers_context

  has_many :marker_relations

  # the_collector
  # has_many :holders, through: :marker_relations

  validates :slug, uniqueness: true
  validates :title, :slug, :markers_context_id, presence: true

  before_validation :prepare_context, on: :create
  before_validation :prepare_slug, on: :create
  
  private

  def prepare_slug
    self.slug = HasMarkers.slug_for(self.title) if slug.blank?
  end

  def prepare_context
    unless markers_context
      self.markers_context = MarkersContext.find_or_create_default
    end
  end
end
