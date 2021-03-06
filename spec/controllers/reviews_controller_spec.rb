require "spec_helper"

describe ReviewsController do
  describe "POST create" do
    let(:video) { Fabricate :video }

    context "authenticated users" do

      before  { set_current_user }

      context "valid input" do
        it "redirects to video show page" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(response).to redirect_to video
        end 

        it "creates a review" do         
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with the video" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.first.video).to eq(video)
        end

        it "creates a review associated with the signed user" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id, user_id: current_user.id
          expect(Review.first.creator).to eq(current_user)
        end

        it "sets the notice" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id, user_id: current_user.id
          expect(flash[:notice]).to eq("Your review has been added.")
        end
      end

      context "invalid input" do
        before { post :create, review: { rating: 5 }, video_id: video.id, user_id: current_user.id  }
        it "does not create a review" do          
          expect(Review.first).to be_nil
        end

        it "renders video/show template" do
          expect(response).to render_template "videos/show"
        end

        it "sets @video" do
          expect(assigns :video).to eq(video)
        end

        it "sets @reviews" do
          review = Fabricate(:review, video: video)
          expect(assigns :reviews).to match_array([review])
        end

        it "sets notice" do
          expect(flash[:error]).not_to be_nil 
        end

      end
    end

    context "unauthenticated users" do
      it "redirects to sign in path" do
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end