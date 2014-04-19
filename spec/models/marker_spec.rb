require 'spec_helper'

describe Marker do
  describe "Default scope for new marker" do
    let(:marker_1){ build(:empty_marker) }
    let(:marker_2){ build(:empty_marker) }

    it "should create new markers" do
      marker_1.title = "Брюс Уиллис"
      marker_1.save.should eq true

      marker_2.title = "Дэми Мур"
      marker_2.save.should eq true

      Marker.count.should eq 2
      MarkersContext.count.should eq 1
    end
  end

  describe "Markers mast have different slugs" do
    let(:marker_1){ build(:marker) }
    let(:marker_2){ build(:marker) }

    it "Identical markers with identical slugs is bad" do
      marker_1.save.should eq true
      marker_2.save.should eq false
    end

    it "Identical markers with different slugs is good" do
      marker_1.save.should eq true

      marker_2.slug = :some_slug
      marker_2.save.should eq true
    end
  end

  describe "25 markers" do
    it "should have 25 markers" do
      markers = create_list(:filled_marker, 10)
      Marker.count.should eq 10

      # puts
      # Marker.all.each do |m|
      #   puts "Marker: #{ m.slug } => #{ m.title }"
      # end

      MarkersContext.count.should eq 1
    end
  end

  describe "simple validations" do
    let(:marker) { build :empty_marker }

    it "should have 2 errors" do
      marker.save
      marker.errors.count.should eq 2
    end

    it "should have 0 error" do
      marker.title = :title
      marker.slug  = :slug
      marker.save
      marker.errors.count.should eq 0
    end
  end
end
