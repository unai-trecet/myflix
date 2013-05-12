require 'spec_helper'

describe Category do
  it { should have_many(:videos)}

  describe "#recent_videos" do
    it "returns videos in a descending order for created_at" do
      comedies = Category.create!(name: "Comedies")
      family_guy = Video.create!(title: "Family Guy", category: comedies, created_at: 1.day.ago, description: "Talking dog")
      south_park = Video.create!(title: "South Park", category: comedies, description: "Hippy Kids")
      expect(comedies.recent_videos).to eq([south_park, family_guy])
    end

    it "returns all videos if there are less than 6 videos" do
      comedies = Category.create!(name: "Comedies")
      south_park = Video.create!(title: "South Park", category: comedies, description: "Hippy Kids")
      family_guy = Video.create!(title: "Family Guy", category: comedies, created_at: 1.day.ago, description: "Talking dog")
      expect(comedies.recent_videos.size).to eq(2)
    end

    it "returns the last 6 if there are more than 6 videos" do
      comedies = Category.create!(name: "Comedies")
      7.times { Video.create!(title: "foo", description: "something", category: comedies) }
      expect(comedies.recent_videos.size).to eq(6)
    end

    it "returns the latest 6 videos" do
      comedies = Category.create!(name: "Comedies")
      6.times { Video.create!(title: "foo", description: "something", category: comedies) }
      todays_show = Video.create(title: "todays show", description: "blah", category: comedies, created_at: 1.day.ago)
      expect(comedies.recent_videos).not_to include(todays_show)
    end

    it "returns empty array if there are no videos" do
      comedies = Category.create!(name: "Comedies")
      expect(comedies.recent_videos).to eq([])
    end
  end
end
