require "rails_helper"

RSpec.describe "Registrations  API", type: :request do
  describe "POST /sign_up" do
    let!(:user) { FactoryBot.attributes_for(:user) }
    before { post "/api/v1/sign_up", params: { user: user } }

    context "When the request is valid" do
      
      it "Create a user success" do
        expect(json["is_success"]).to eq true
      end

      it "Returns status code 200" do
        expect(response).to have_http_status 200
      end
    end

    context "When the request is invalid" do
      let!(:user) { nil }

      it "Return isn't success" do
        expect(json["is_success"]).to eq false
      end

      it "Returns status code 400" do
        expect(response).to have_http_status 400
      end
    end
  end
end
