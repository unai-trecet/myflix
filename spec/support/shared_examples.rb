shared_examples "require_sign_in" do
  it "redirect to sign in page" do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "require_token" do
  it "generates a random token when the object is created" do
    expect(object).to be_present
  end
end