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

    after_initialize :init_markers_errors

    before_validation -> { @markers_errors.clear }
    before_validation :mark_object, on: :update
    before_validation :prepare_markers

    after_save :mark_object, on: :create

    def markers_valid?
      @markers_errors.blank?
    end

    def set_marker marker_title, opts = {}
      opts.symbolize_keys!
      context_name = opts.delete(:on)

      marker = find_or_create_marker(marker_title, context_name)
      marker_relations.create(marker: marker) if marker.valid?
      copy_markers_errors_from marker
    end

    def set_markers markers_with_context = {}
      self.mark_with = markers_with_context
      mark_object
    end

    def remove_marker marker_title
      marker = Marker.find_marker(marker_title)
      rel = marker_relations.where(marker: marker).first
      return false unless rel
      rel.destroy
    end

    private

    def init_markers_errors
      @markers_errors = ActiveModel::Errors.new self
    end

    def copy_markers_errors_from marker
      marker.errors.each{ |attr, error| self.markers_errors.add(attr, error) }
    end

    def prepare_markers
      return true  if  mark_with.blank?
      return false if !mark_with.is_a?(Hash)
      
      mark_with.each_pair do |context_name, markers|
        markers = markers.map(&:strip).reject(&:blank?)

        markers.each do |marker_title|
          marker = find_or_create_marker(marker_title, context_name)
          copy_markers_errors_from marker
        end
      end
    end

    def mark_object
      return false if  new_record?
      return true  if  mark_with.blank?
      return false if !mark_with.is_a?(Hash)

      mark_with.each_pair do |context_name, markers|
        markers = markers.map(&:strip).reject(&:blank?)
        markers.each { |marker| set_marker marker, on: context_name }
      end
    end

    def find_or_create_markers_context context_name
      return MarkersContext.find_or_create_default if context_name.blank?

      context = MarkersContext.find_markers_context context_name
      context ? context : MarkersContext.create(title: context_name)
    end

    def find_or_create_marker marker_title, context_name
      marker = Marker.find_marker(marker_title)
      return marker if marker

      context = find_or_create_markers_context(context_name)
      Marker.create(title: marker_title, markers_context: context)
    end
  end
end