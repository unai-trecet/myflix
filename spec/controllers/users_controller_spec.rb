require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets the @user to a new user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end

    it "renders the :new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    context "valid input" do
      it "create a user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "redirect to the sign in page" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end
    end

    context "invalid input" do
      it "does not create a user" do
        post :create, user: { email: "kevin@example.com" }
        expect(User.count).to eq(0)
      end

      it "renders the :new template" do
        post :create, user: { email: "kevin@example.com" }
        expect(response).to render_template :new
      end
    end
  end
end
