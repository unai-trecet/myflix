require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
    {
      "id" => "evt_2OXuh3ErYuXiFN",
      "created" => 1376650241,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_2OXuTq1Nzbn3p3",
          "object" => "charge",
          "created" => 1376650241,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_2OXuaR8tycGAwO",
            "object" => "card",
            "last4" => "4242",
            "type" => "Visa",
            "exp_month" => 8,
            "exp_year" => 2014,
            "fingerprint" => "fnH6dw4NhbQdLSIX",
            "customer" => "cus_2OXul4nz0N8r3E",
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
            "address_zip_check" => nil
          },
          "captured" => true,
          "balance_transaction" => "txn_2OXugDbsVJlKts",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_2OXul4nz0N8r3E",
          "invoice" => "in_2OXuhQPfpIn0av",
          "description" => nil,
          "dispute" => nil,
          "fee" => 59,
          "fee_details" => [
            {
              "amount" => 59,
              "currency" => "usd",
              "type" => "stripe_fee",
              "description" => "Stripe processing fees",
              "application" => nil
            }
          ]
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_2OXuxCu5NDanEQ"
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_2OXul4nz0N8r3E")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_2OXul4nz0N8r3E")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do
    alice = Fabricate(:user, customer_token: "cus_2OXul4nz0N8r3E")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_2OXuTq1Nzbn3p3")
  end
end
