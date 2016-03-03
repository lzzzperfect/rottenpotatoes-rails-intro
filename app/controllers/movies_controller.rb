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
    @all_ratings = ['G','PG','PG-13','R']
    #@movies= Movie.all #original words

    sort = params[:sort]
    case sort
      when 'title'
        @title_header = {:order => :title}, 'hilite'
        @movies=Movie.order('title ASC')
      when 'release_date'
        @date_header = {:order => :release_date}, 'hilite'
        @movies=Movie.order('release_date ASC')
      else
        params[:ratings] ? @movies=Movie.where(rating: params[:ratings].keys):
                            @movies =Movie.all
    end
    # some more codes here
    #@movies = Movie.all #find_all_by_ratings(ordering)
  end

  def new
    # default: render 'new' template
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
