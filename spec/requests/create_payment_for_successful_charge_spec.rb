require 'spec_helper'

describe "Create payment on successful ccharge" do

  let(:event_data) do
    {
      "id" => "evt_14QJ614PSbBPalmqTIHQwNb4",
      "created" => 1407764661,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_14QJ614PSbBPalmqpX3bafs4",
          "object" => "charge",
          "created" => 1407764661,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_14QJ5y4PSbBPalmqRjhV00uJ",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 8,
            "exp_year" => 2017,
            "fingerprint" => "FCwrYTzZ1JfOeTDW",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "customer" => "cus_4ZS0yy1cZjrsGs"
          },
          "captured" => true,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_14QJ614PSbBPalmqpX3bafs4/refunds",
            "data" => []
          },
          "balance_transaction" => "txn_14QJ614PSbBPalmqvH6Wltwl",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_4ZS0yy1cZjrsGs",
          "invoice" => "in_14QJ614PSbBPalmqMMGJiAGV",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil,
          "receipt_email" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_4ZS0Un35GhCnly"
    } 
  end

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post '/stripe_events', event_data 
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    ana = Fabricate :user, costumer_token: "cus_4ZS0yy1cZjrsGs"
    post '/stripe_events', event_data 

    expect(Payment.first.user).to eq(ana)
  end

  it "creates the payment with the amount", :vcr do
    ana = Fabricate :user, costumer_token: "cus_4ZS0yy1cZjrsGs"
    post '/stripe_events', event_data 

    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with refrence id", :vcr do
    ana = Fabricate :user, costumer_token: "cus_4ZS0yy1cZjrsGs"
    post '/stripe_events', event_data 

    expect(Payment.first.reference_id).to eq("ch_14QJ614PSbBPalmqpX3bafs4")
  end
end