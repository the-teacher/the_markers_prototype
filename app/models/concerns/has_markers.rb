module HasMarkers
  def self.slug_for str
    str.to_s.to_slug_param(locale: :ru)
  end

  extend ActiveSupport::Concern

  included do
    attr_accessor :mark_with
    has_many :marker_relations, as: :holder
    has_many :markers, through: :marker_relations

    after_save :mark_object

    def mark_object
      return true  if  mark_with.blank?
      return false if !mark_with.is_a?(Hash)
      
      mark_with.each_pair do |context, markers|
        markers = markers.map(&:strip).reject(&:blank?)
        markers.each do |marker|
          set_marker marker, on: context
        end
      end
    end

    def set_marker title, opts = {}
      opts.symbolize_keys!
      context_name = opts.delete(:on)

      marker = find_or_create_marker(title, context_name)
      marker_relations.create(marker: marker)
    end

    def find_or_create_markers_context context_name
      return MarkersContext.find_or_create_default if context_name.blank?

      context = MarkersContext.find_markers_context context_name
      context ? context : MarkersContext.create(title: context_name)
    end

    def find_or_create_marker title, context_name
      marker = Marker.find_marker(title)
      return marker if marker

      context = find_or_create_markers_context(context_name)
      Marker.create(title: title, markers_context: context)
    end
  end
end