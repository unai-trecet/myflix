require 'spec_helper'

describe VideosController do
  describe "GET show" do
    let(:alice) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    before { set_current_user(alice) }

    it "sets @video for authenticated users" do
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "sets @reviews for the authenticated user" do
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 1 }
    end
  end

  describe "POST search" do
    context "authenticated user" do
      before { set_current_user }

      it "sets @results to the search results" do
        futurama = Fabricate(:video, title: "Futurama")
        post :search, search_term: 'rama'
        expect(assigns(:results)).to eq([futurama])
      end

      it "renders the :search template" do
        futurama = Fabricate(:video, title: "Futurama")
        post :search, search_term: 'rama'
        expect(response).to render_template :search
      end
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :search, search_term: 'rama' }
    end
  end
end
