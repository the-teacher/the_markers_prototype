class Marker < ActiveRecord::Base
  belongs_to :markers_context

  has_many :marker_relations

  # the_collector
  # has_many :holders, through: :marker_relations

  validates :slug, uniqueness: true
  validates :title, :markers_context_id, presence: true
  validate  :slug_cant_be_blank

  before_validation :prepare_context, on: :create
  before_validation :prepare_slug, on: :create

  def self.find_marker title
    where(slug:  HasMarkers.slug_for(title)).first ||
    where(title: title).first
  end

  private

  def prepare_slug
    self.slug = HasMarkers.slug_for(self.title) if slug.blank?
  end

  def prepare_context
    unless markers_context
      self.markers_context = MarkersContext.find_or_create_default
    end
  end

  def slug_cant_be_blank
    if self.slug.blank?
      errors.add(:slug, I18n.t("activerecord.errors.models.marker.attributes.slug.blank", title: self.title))
    end
  end
end
