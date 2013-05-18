require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "authenticated users" do
      let(:current_user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }

      before do
        session[:user_id] = current_user.id
      end

      context "valid reviews" do
        it "redirects to the video page" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video
          expect(response).to redirect_to video_path(video)
        end

        it "creates the review for that video" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video
          expect(video.reviews.count).to eq(1)
        end

        it "creates the review for the current sign user" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video
          expect(video.reviews.first.user).to eq(current_user)
        end
      end

      context "invalid reviews" do
        it "render the show template" do
          post :create, review: {rating: 3}, video_id: video
          expect(response).to render_template 'videos/show'
        end

        it "does not create the review" do
          post :create, review: {rating: 3}, video_id: video
          expect(Review.count).to eq(0)
        end

        it "sets @video" do
          post :create, review: {rating: 3}, video_id: video
          expect(assigns(:video)).to eq(video)
        end

        it "sets @reviews" do
          review1 = Fabricate(:review, video: video)
          review2 = Fabricate(:review, video: video)
          post :create, review: {rating: 3}, video_id: video
          expect(assigns(:reviews)).to match_array([review1, review2])
        end
      end
    end

    context "unauthenticated users" do
      it "redirects to the sign in path" do
        video = Fabricate(:video)
        post :create, review: {rating: 3}, video_id: video
        expect(response).to redirect_to sign_in_path
      end

      it "should not create the review" do
        video = Fabricate(:video)
        post :create, review: Fabricate.attributes_for(:review), video_id: video
        expect(Review.count).to eq(0)
      end
    end
  end
end
