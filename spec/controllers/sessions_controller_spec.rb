require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders the new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end

    it "redirects to home page for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "successful sign in" do
      it "stores the user in the session" do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password
        expect(session[:user_id]).to eq(alice.id)
      end

      it "redirects to the home path" do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password
        expect(response).to redirect_to home_path
      end
    end

    context "unsuccessful sign in" do

      before do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password + 'asdasdgas'
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end

      it "does not store the user in the session" do
        expect(session[:user_id]).to be_nil
      end

      it "sets the flash with error message" do
        expect(flash[:error]).not_to be_nil
      end
    end
  end

  describe "GET destroy" do

    before do
      set_current_user
      get :destroy
    end

    it "clears the user in the session" do
      expect(session[:user_id]).to be_nil
    end

    it "sets the notice message" do
      expect(flash[:notice]).not_to be_nil
    end

    it "redirect to the root page" do
      expect(response).to redirect_to root_path
    end
  end
end
