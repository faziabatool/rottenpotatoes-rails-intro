
  class MoviesController < ApplicationController


  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index 

    # get the param or session value for the sort type
    # its value is either 'sortByTitle' or 'sortByReleaseDate'
    sorting_by = params[:sort_by] || session[:sort_by]
    if sorting_by == 'sortByTitle'
      order_by= (:title)
    elsif sorting_by == 'sortByReleaseDate'
      order_by = (:release_date)
    end

    # set the session 
    session[:sort_by] = sorting_by

    # getting all the values of rating from the class Movie.rd
    # to display on the screen (@all_ratings being used in index.html)
    @all_ratings = Movie.ratings

    # get the param or session value for the ratings type
    @ratings = params[:ratings] || session[:ratings] || nil

    if @ratings == nil
      @ratings = {"G" => "1", "PG" => "1", "PG-13" => "1", "R" => "1"}
    end

    # set the session
    session[:ratings] = @ratings

    # when the param and session variables not match
    if params[:sort_by] != session[:sort_by] || params[:ratings] != session[:ratings]
      flash.keep
      redirect_to :sort_by => sorting_by, :ratings => @ratings
    end
    
    # fliter the movies based on the checkbox selected and sort it by the given type
    # order_by will be nil for the first time but it will work just fine
    # @movies = Movie.where("rating in (?)", @ratings.keys).order(order_by)
    @movies = Movie.all
  end

  def new
    # default: render 'new' template`
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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

