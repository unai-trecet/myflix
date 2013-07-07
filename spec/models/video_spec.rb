require 'spec_helper'

describe Video do
  it { should belong_to(:category)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}
  it { should have_many(:reviews).order("created_at DESC")}

  describe "search_by_title" do
    it "returns an empty array if there is no match" do
      futurama = Video.create(title: "Futurama", description: "Space Travel!")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel!")
      expect(Video.search_by_title("hello")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      futurama = Video.create(title: "Futurama", description: "Space Travel!")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel!")
      expect(Video.search_by_title("Futurama")).to eq([futurama])
    end

    it "returns an array of one video for a partial match" do
      futurama = Video.create(title: "Futurama", description: "Space Travel!")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel!")
      expect(Video.search_by_title("urama")).to eq([futurama])
    end

    it "returns an array of all matches ordered by created_at" do
      futurama = Video.create(title: "Futurama", description: "Space Travel!", created_at: 1.day.ago)
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel!")
      expect(Video.search_by_title("Futur")).to eq([back_to_future, futurama])
    end

    it "returns an empty array for a search with an empty string" do
      futurama = Video.create(title: "Futurama", description: "Space Travel!", created_at: 1.day.ago)
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel!")
      expect(Video.search_by_title("")).to eq([])
    end
  end

  describe "#rating" do
    let(:video) { Fabricate(:video) }

    it "gives rating nil without reviews" do
      video.rating.should be_nil
    end

    it "gives average rating of one review" do
      video.reviews.create(rating: 4, content: "asd")
      video.rating.should == 4
    end

    it "gives average rating of reviews" do
      video.reviews.create(rating: 4, content: "asd")
      video.reviews.create(rating: 1, content: "asd")
      video.rating.should == 2.5
    end

    it "gives average rating of reviews considering decimals" do
      video.reviews.create(rating: 4, content: "asd")
      video.reviews.create(rating: 1, content: "asd")
      video.reviews.create(rating: 5, content: "asd")
      video.rating.should == 3.3
    end
  end
end
