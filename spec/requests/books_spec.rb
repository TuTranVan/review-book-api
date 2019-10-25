require "rails_helper"

RSpec.describe "Books API", type: :request do
  let!(:books) { FactoryBot.create_list(:book, 10) }
  let(:book_id) { books.first.id }

  describe "GET /books" do
    before { get "/api/v1/books" }

    it "Return books" do
      expect(json["data"]["books"].size).to eq books.length
    end

    it "Return status code 200" do
      expect(response).to have_http_status 200
    end
  end

  describe "GET /books/:id" do
    before { get "/api/v1/books/#{book_id}" }

    context "When the book exists" do
      it "Return the book" do
        expect(json["data"]["book"]["id"]).to eq book_id
      end

      it "Return status code 200" do
        expect(response).to have_http_status 200
      end
    end

    context "When the book doesn't exists" do
      let(:book_id) { 100 }

      it "Return a not found message" do
        expect(json["is_success"]).to eq false
      end

      it "Return status code 404" do
        expect(response).to have_http_status 404
      end
    end
  end
end
