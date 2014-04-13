class MarkersContext < ActiveRecord::Base
  has_many :markers
  validates :title, :slug, presence: true
  before_validation :prepare_slug, on: :create
  
  def self.find_markers_context context_name
    where(slug:  HasMarkers.slug_for(context_name)).first ||
    where(title: context_name).first
  end

  private

  def prepare_slug
    self.slug = HasMarkers.slug_for(self.title) if slug.blank?
  end

  def self.find_or_create_default
    where(slug: :default).first || create(title: :default)
  end
end
