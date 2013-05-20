require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of the logged in user" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects to the sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do
    context "with authenticated users" do

      let(:alice) { Fabricate(:user) }
      before { session[:user_id] = alice.id }

      it "redirects to the my queue page" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end

      it "it creates the queue item associated with the video" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end

      it "it creates the queue item associated with the current user" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(alice)
      end

      it "it does not create queue item if the video is already in queue" do
        monk = Fabricate(:video)
        Fabricate(:queue_item, video: monk, user: alice)
        post :create, video_id: monk.id
        expect(QueueItem.count).to eq(1)
      end

      it "puts the video to the last position" do
        monk = Fabricate(:video)
        south_park = Fabricate(:video)
        Fabricate(:queue_item, video: monk, user: alice, position: 1)
        post :create, video_id: south_park.id
        south_park_queue_item = QueueItem.where(video_id: south_park.id).first
        expect(south_park_queue_item.position).to eq(2)
      end
    end

    context "with unauthenticated uses" do
      it "redirects to the sign in page for unauthenticated users" do
        post :create, video_id: 4
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
