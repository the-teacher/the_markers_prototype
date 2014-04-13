module HasMarkers
  def self.slug_for str
    str.to_s.to_slug_param(locale: :ru)
  end

  extend ActiveSupport::Concern

  included do
    has_many :marker_relations, as: :holder
    has_many :markers, through: :marker_relations

    def mark_with title, opts = {}
      opts.symbolize_keys!
      context_name = opts.delete(:on)

      marker = find_or_create_marker(title, context_name)
      marker_relations.create(marker: marker)
    end

    def find_or_create_markers_context context_name
      return MarkersContext.find_or_create_default if context_name.blank?

      context = MarkersContext.where(slug:  HasMarkers.slug_for(context_name)).first ||
                MarkersContext.where(title: context_name).first

      context ? context : MarkersContext.create(title: context_name)
    end

    def find_or_create_marker title, context_name
      marker = Marker.where(slug:  HasMarkers.slug_for(title)).first ||
               Marker.where(title: title).first

      return marker if marker

      context = find_or_create_markers_context(context_name)
      Marker.create(title: title, markers_context: context)
    end
  end
end