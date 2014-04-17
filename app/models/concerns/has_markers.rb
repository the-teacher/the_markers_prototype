module HasMarkers
  def self.slug_for str
    str.to_s.to_slug_param(locale: :ru)
  end

  extend ActiveSupport::Concern

  included do
    attr_accessor :mark_with
    attr_reader   :markers_errors

    has_many :marker_relations, as: :holder
    has_many :markers, through: :marker_relations

    before_validation :mark_object, on: :update
    after_save        :mark_object, on: :create

    after_initialize :init_markers_errors

    def set_marker title, opts = {}
      opts.symbolize_keys!
      context_name = opts.delete(:on)

      marker = find_or_create_marker(title, context_name)
      marker_relations.create(marker: marker)
      copy_markers_errors_from marker
    end

    def copy_markers_errors_from marker
      marker.errors.each{ |attr, error| self.markers_errors.add(attr, error) }
    end

    def remove_marker title
      marker = Marker.find_marker(title)
      rel = marker_relations.where(marker: marker).first
      return false unless rel
      rel.destroy
    end

    private

    def init_markers_errors
      @markers_errors = ActiveModel::Errors.new self
    end

    def mark_object
      return true  if  mark_with.blank?
      return false if !mark_with.is_a?(Hash)
      
      mark_with.each_pair do |context, markers|
        markers = markers.map(&:strip).reject(&:blank?)
        markers.each { |marker| set_marker marker, on: context }
      end
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