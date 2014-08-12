require 'spec_helper'

describe 'Deactivate user on failed charge' do

  let( :event_data) do
    {
      "id" => "evt_14QjEm4PSbBPalmqEEkgsW3h",
      "created" => 1407865148,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_14QjEm4PSbBPalmqQ6IcqiCh",
          "object" => "charge",
          "created" => 1407865148,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_14QjCr4PSbBPalmqHWWM7FEO",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 8,
            "exp_year" => 2017,
            "fingerprint" => "Ej12RPVUiO53jKxO",
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
            "customer" => "cus_4ZmeAO4cHhuzAq"
          },
          "captured" => false,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_14QjEm4PSbBPalmqQ6IcqiCh/refunds",
            "data" => []
          },
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_4ZmeAO4cHhuzAq",
          "invoice" => nil,
          "description" => "Payment to fail",
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil,
          "receipt_email" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_4Zt0SoHB0ti80L"
    }
  end

  it "deactivate a user with the web hook data from stripe for charge failed", :vcr do
    ana = Fabricate :user, costumer_token: "cus_4ZmeAO4cHhuzAq"
    post "/stripe_events", event_data

    expect(ana.reload).not_to be_active 
  end
end