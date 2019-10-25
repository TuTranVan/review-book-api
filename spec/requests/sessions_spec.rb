require "rails_helper"

RSpec.describe "Sessions API", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:session) { { email: user.email, password: user.password } }
  let(:auth_token) { { "AUTH-TOKEN" => user.authentication_token } }

  describe "POST /sign_in" do
    before { post "/api/v1/sign_in", params: { sign_in: session } }

    context "When valid params" do
      it "Return login successfully" do
        expect(json["is_success"]).to eq true
      end

      it "Return status code 200" do
        expect(response).to have_http_status 200
      end
    end

    context "When invalid email" do
      let(:session) { { email: nil, password: user.password } }

      it "Return can't load user" do
        expect(json["is_success"]).to eq false
      end

      it "Return status code 500" do
        expect(response).to have_http_status 500
      end
    end

    context "When invalid password" do
      let(:session) { { email: user.email, password: nil } }

      it "Return unauthorized" do
        expect(json["is_success"]).to eq false
      end

      it "Return status code 401" do
        expect(response).to have_http_status 401
      end
    end
  end

  describe "DELETE /log_out" do
    before { delete "/api/v1/log_out", headers: auth_token }

    context "When valid token" do
      it "Return logout successfully" do
        expect(json["is_success"]).to eq true
      end

      it "Return status code 200" do
        expect(response).to have_http_status 200
      end
    end

    context "When invalid token" do
      let(:auth_token) { { "AUTH-TOKEN" => nil } }

      it "Return can't load user" do
        expect(json["is_success"]).to eq false
      end

      it "Return status code 500" do
        expect(response).to have_http_status 500
      end
    end
  end
end
