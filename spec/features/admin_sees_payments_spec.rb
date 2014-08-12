require 'spec_helper'

feature 'Admin sees payments' do
  background do
    ana = Fabricate :user, full_name: "Ana", email: "ana@ana.com"
    Fabricate :payment, amount: 999, user: ana  
  end

  scenario "admin can see payments" do
    sign_in Fabricate :admin
    visit admin_payments_path

    expect(page).to have_content("$9.99")
    expect(page).to have_content("Ana")
    expect(page).to have_content("ana@ana.com")
  end

  scenario "user cannot see payments" do
    sign_in Fabricate :user
    visit admin_payments_path

    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Ana")
    expect(page).not_to have_content("ana@ana.com")
    expect(page).to have_content("You are not allowed to visit this area.")
  end
end