require 'spec_helper'

describe Post do

  describe "get errors form marker" do
    let(:post) { create :filled_post_marked_with_2_markers_on_2_contexts }
    
    it "should has validation errors from marker" do
      post.set_marker "", on: :default
      post.save

      post.markers_errors.count.should eq 2
      MarkerRelation.count.should eq 2
      Marker.count.should eq 2
    end
  end

  describe "unmark object" do
    let(:post) { create :filled_post_marked_with_2_markers_on_2_contexts }

    it "should unmark object" do
      post.markers.count.should   eq 2
      MarkerRelation.count.should eq 2
      Marker.count.should         eq 2

      post.remove_marker("Bruce Willis").should_not eq false

      post.markers.count.should   eq 1
      MarkerRelation.count.should eq 1
      Marker.count.should         eq 2
    end

    it "should unmark object" do
      post.markers.count.should   eq 2
      MarkerRelation.count.should eq 2
      Marker.count.should         eq 2

      post.remove_marker("Unexisted Marker").should eq false

      post.markers.count.should   eq 2
      MarkerRelation.count.should eq 2
      Marker.count.should         eq 2
    end
  end

  describe "mark with API" do
    let(:post) { create :filled_post }

    it "Set group of markers on post" do
      post.update(mark_with: {
        actors: ["Брюс Уиллис", "Эдди Мёрфи", "Sigourney Weaver"],
        stars:  ["Sigourney Weaver", " twenty-cent", "20 '¢' cents"]
      })

      MarkersContext.count.should eq 2
      Marker.count.should         eq 5

      MarkersContext.first.markers.count.should eq 3
      MarkersContext.last.markers.count.should  eq 2
    end
  end

  describe "behaviour of markers with mistaken contexts" do
    let(:post_1) { create :filled_post }
    let(:post_2) { create :filled_post }

    it ":on param should not have an effect on existed marker" do
      post_1.set_marker "Брюс Уиллис", on: :actors
      post_2.set_marker "Брюс Уиллис", on: :starts

      Marker.count.should         eq 1
      MarkersContext.count.should eq 1
    end
  end

  describe "Post/markers create API" do
    let(:post) { create :filled_post_marked_with_2_markers_on_2_contexts }
    
    it "try play with marked post" do
      post
      post.markers.count.should   eq 2
      MarkersContext.count.should eq 2
    end
  end

  describe "Post/markers create API" do
    let(:post) { create :filled_post }

    it "mark on :default context" do
      post.set_marker "Брюс Уиллис"

      post.reload
      post.markers.count.should   eq 1
      MarkersContext.count.should eq 1
    end

    it "mark on :actors context" do
      post.set_marker "Брюс Уиллис", on: :actors

      post.reload
      post.markers.count.should   eq 1

      MarkersContext.count.should eq 1
    end

    it "mark on :actors context" do
      post.set_marker "Брюс Уиллис", on: :actors
      post.set_marker "Брюс Уиллис", on: :actors
      
      post.reload
      post.markers.count.should   eq 1
      MarkersContext.count.should eq 1
    end

    it "mark on :actors context" do
      post.set_marker "Брюс Уиллис", on: :actors
      post.set_marker "Дэми Мур",   on: :actors
      
      post.reload
      post.markers.count.should   eq 2
      MarkersContext.count.should eq 1
    end

    it "mark on :actors, :stars contexts" do
      post.set_marker "Брюс Уиллис", on: :actors
      post.set_marker "Дэми Мур",   on: :stars
      
      post.reload
      post.markers.count.should   eq 2
      MarkersContext.count.should eq 2
    end
  end

  describe "Post/markers relations" do
    let(:post)   { create :filled_post   }
    let(:marker) { create :filled_marker }

    it "no one marker" do
      post.markers.empty?.should eq true
    end

    it "can't to create identical relations" do
      rel = post.marker_relations.new(marker: marker)
      rel.save.should eq true

      rel = post.marker_relations.new(marker: marker)
      rel.save.should eq false

      MarkerRelation.count.should eq 1
    end
  end

  describe "simple validations" do
    let(:post) { build :empty_post }

    it "should have 2 errors" do
      post.save
      post.errors.count.should eq 2
    end

    it "should have 1 error" do
      post.title = :title
      post.save
      post.errors.count.should eq 1
    end
  end

  describe "db cleaner check" do
    3.times do
      it "Post.count should be 1" do
        Post.create(title: :test, content: :content)
        Post.count.should eq 1
      end
    end
  end
end