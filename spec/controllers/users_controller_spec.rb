require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets the @user to a new user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
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

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3 }
    end

    it "sets @user" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end
end
