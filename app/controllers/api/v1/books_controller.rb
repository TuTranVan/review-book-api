class Api::V1::BooksController < ApplicationController
  before_action :load_book, only: :show

  def index
    @books = Book.all
    books_serialize = parse_json @books

    json_response "Index books successfully", true, { books: books_serialize }, :ok
  end

  def show
    book_serialize = parse_json @book
    json_response "Show book successfully", true, { book: book_serialize }, :ok
  end

  private

  def load_book
    @book = Book.find_by id: params[:id]
    return if @book
    json_response "Can't get book", false, {}, :not_found
  end
end
