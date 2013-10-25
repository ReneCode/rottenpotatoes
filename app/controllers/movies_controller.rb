class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # get sort order from the url-parameter
    order_field = params[:order]
    if order_field == nil
      # if no order set, get the last order from the session
      order_field = session[:order] 
    else
      # store order into the session for the next time
      session[:order] = order_field
    end

    # ratings = { "P"=>1, "G"=1}
    # get only the keys of the params
    @checked_ratings = params[:ratings].keys if (params[:ratings] != nil)
    if @checked_ratings == nil
      # if not set via URL, than get stored ratings
      @checked_ratings = session[:ratings]
      # all ratingss on, if there is no rating stored
      @checked_ratings = Movie.valid_ratings if @checked_ratings == nil
    else
      # store ratings for next call
      session[:ratings] = @checked_ratings
    end
    # query to database
    @movies = Movie.where(rating: @checked_ratings).all(:order => order_field)
    @css_title = 'hilite' if order_field =~ /title/
    @css_release_date = 'hilite' if order_field =~ /release_date/
    # get the list of all valid ratings from the model
    @all_ratings = Movie.valid_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
