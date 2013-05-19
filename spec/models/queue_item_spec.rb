require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe "#video_title" do
    it "returns the title of the video" do
      video = Fabricate(:video, title: "South Park")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("South Park")
    end
  end

  describe "#rating" do
    it "returns the rating of the review if the user has review on the video" do
      alice = Fabricate(:user)
      monk = Fabricate(:video)
      review = Fabricate(:review, user: alice, video: monk, rating: 4)
      queue_item = Fabricate(:queue_item, user: alice, video: monk)
      expect(queue_item.rating).to eq(4)
    end

    it "returns nil if the user does not have review on the video" do
      alice = Fabricate(:user)
      monk = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: alice, video: monk)
      expect(queue_item.rating).to be_nil
    end
  end

  describe "#category_name" do
    it "returns the name of category of the video" do
      dramas = Fabricate(:category, name: "dramas")
      monk = Fabricate(:video, category: dramas)
      queue_item = Fabricate(:queue_item, video: monk)
      expect(queue_item.category_name).to eq("dramas")
    end
  end

  describe "#category" do
    it "returns the category of the video" do
      dramas = Fabricate(:category, name: "dramas")
      monk = Fabricate(:video, category: dramas)
      queue_item = Fabricate(:queue_item, video: monk)
      expect(queue_item.category).to eq(dramas)
    end
  end
end
