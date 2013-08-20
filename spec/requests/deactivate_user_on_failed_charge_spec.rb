require 'spec_helper'

describe 'Deactivate user on failed charge' do
  let(:event_data) do
    {
      "id" => "evt_2PsoXXvLP4oqPR",
      "created" => 1376958644,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_2PsoapNVLRlwZ0",
          "object" => "charge",
          "created" => 1376958644,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_2Psn0f1647nPdm",
            "object" => "card",
            "last4" => "0341",
            "type" => "Visa",
            "exp_month" => 11,
            "exp_year" => 2017,
            "fingerprint" => "yAdBZN2t9gg2j4Iy",
            "customer" => "cus_2PoX83JgZYSkVA",
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
          "captured" => false,
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_2PoX83JgZYSkVA",
          "invoice" => nil,
          "description" => "payment to fail",
          "dispute" => nil,
          "fee" => 0,
          "fee_details" => []
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_2PsobaFJy5jAqJ"
    }
  end

  it "deactivates a user with the web hook data from stripe for charge failed", :vcr do
    alice = Fabricate(:user, customer_token: "cus_2PoX83JgZYSkVA")
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end
end
