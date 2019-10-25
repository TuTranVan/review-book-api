require "rails_helper"

RSpec.describe "Reviews API", type: :request do
  #index
  let!(:book) { FactoryBot.create(:book) }
  let!(:reviews) { 10.times { FactoryBot.create(:review, book: book) } }

  let!(:user) { FactoryBot.create(:user) }
  let(:auth_token) { { "AUTH-TOKEN" => user.authentication_token } }
  
  let!(:review) { FactoryBot.create(:review, user: user) }
  let(:book_id) { review.book_id }
  let(:review_id) { review.id }

  describe "GET books/:id/reviews" do
    before { get "/api/v1/books/#{book.id}/reviews" }

    it "Return reviews" do
      expect(json["data"]["reviews"].size).to eq reviews
    end

    it "Return status code 200" do
      expect(response).to have_http_status 200
    end
  end

  describe "GET /books/:book_id/reviews/:id" do
    before { get "/api/v1/books/#{book_id}/reviews/#{review_id}" }

    context "When the review exists" do
      it "Return the review" do
        expect(json["data"]["review"]["id"]).to eq review_id
      end

      it "Return status code 200" do
        expect(response).to have_http_status 200
      end
    end

    context "When the review doesn't exists" do
      let(:review_id) { 100 }

      it "Return a not found message" do
        expect(json["is_success"]).to eq false
      end

      it "Return status code 404" do
        expect(response).to have_http_status 404
      end
    end
  end

  describe "POST /books/:book_id/reviews" do
    let(:review) { FactoryBot.build(:review, book: book, user: user) }
    before { post "/api/v1/books/#{book.id}/reviews", 
      params: { review: review.attributes }, headers: auth_token }
      
    context "When the request is valid" do
      it "Create a review success" do
        expect(json["is_success"]).to eq true
      end

      it "Returns status code 200" do
        expect(response).to have_http_status 200
      end
    end

    context "When the auth-token is valid" do
      let(:auth_token) { { "AUTH-TOKEN" => nil } }

      it "Return unauthorized" do
        expect(json["is_success"]).to eq false
      end

      it "Returns status code 401" do
        expect(response).to have_http_status 401
      end
    end
  end

  describe "DELETE /books/:book_id/reviews/:id" do
    before { delete "/api/v1/books/#{book_id}/reviews/#{review_id}", headers: auth_token }

    context "When request is valid" do
      it "Return destroy successfully" do
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

      it "Return status code 401" do
        expect(response).to have_http_status 401
      end
    end

    context "When invalid review" do
      let(:review_id) { 100 }

      it "Return destroy fail" do
        expect(json["is_success"]).to eq false
      end

      it "Return status code 404" do
        expect(response).to have_http_status 404
      end
    end
  end
end
