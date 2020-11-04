class BooksController < ApplicationController

  # GET: /books
  get "/books" do
    @books = Book.all
    erb :"/books/index.html"
  end

  # GET: /books/new
  get "/books/new" do
    redirect "/login" if not logged_in?
    @book = Book.new
    erb :"/books/new.html"
  end

  # POST: /books
  post "/books" do
    redirect "/login" if not logged_in?
    @book = current_user.books.build(title: params[:book][:title], content: params[:book][:content])
    if @book.save
    redirect "/books"
  else
    erb :"/books/new.html"
  end
end

  # GET: /books/5
  get "/books/:id" do
  set_book
    @book = Book.find(params[:id])
    erb :"/books/show.html"
  end

  # GET: /books/5/edit
  get "/books/:id/edit" do
    set_book
    redirect_if_not_authorized
    erb :"/books/edit.html"
  end

  # PATCH: /books/5
  patch "/books/:id" do
    set_book
    redirect_if_not_authorized
    if @book.update(title: params[:book][:title], content:params[:book][:content])
      flash[:success] = "Book successfully updated"
      redirect "/books/#{@post.id}"
    else 
      redirect "/books/:id"
    end  
  end  
 


  # DELETE: /books/5/delete
  delete "/books/:id/delete" do
    set_book
    redirect_if_not_authorized
    @book.destroy

    redirect "/books"
  end

  private

  def set_book
    @book = Book.find_by_id(params[:id])
    if @book.nil?
      flash[:error] = "Couldn't find a Book with id: #{params[:id]}"
      redirect "/books"
    end
  end

  def redirect_if_not_authorized
    if !authorize_book(@book)
      flash[:error] = "You don't have permission to do that action"
      redirect "/books"
    end
  end

  def authorize_book(book)
    current_user == book.author
  end
end

