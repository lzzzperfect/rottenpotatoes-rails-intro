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
    redirect = true
    if(params["ratings"] != nil)
      session["ratings"] = params["ratings"]
      redirect = false
    end
    if(params["sort"] != nil)
      session["sort"] = params["sort"]
      redirect = false
    end
    @ratings_hash = session["ratings"]
    @sort=session["sort"]

    if(@ratings_hash != nil)
      @movies = Movie.where(rating: @ratings_hash.keys).order(@sort!= nil ? "#{@sort} ASC" : "")
    else
      @movies=Movie.all#(:order => @sort != nil ? "#{@sort} ASC" :"")
    end
    @all_ratings=Movie.select(:rating).map(&:rating).uniq

    if((@ratings_hash !=nil || @sort != nil) && redirect == true)
      redirect_to movies_path :sort=>@sort, :ratings=>@ratings_hash
    end

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
