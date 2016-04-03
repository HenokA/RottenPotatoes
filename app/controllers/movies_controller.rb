class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'R', 'PG-13', 'PG','NC-17']

    # The logic to fill in session and remember settings
    if (params[:filter] == nil and params[:ratings] == nil and params[:sort] == nil and
      (session[:filter] != nil or session[:ratings] != nil or session[:sort] != nil))
      if (params[:filter] == nil and session[:filter] != nil)
        params[:filter] = session[:filter]
      end
      if (params[:sort] == nil and session[:sort] != nil)
        params[:sort] = session[:sort]
      end
       if (params[:ratings] == nil and session[:ratings] != nil)
        params[:ratings] = session[:ratings]
      end
      flash.keep
      redirect_to movies_path(:filter => params[:filter], :sort => params[:sort], :ratings => params[:ratings])
    else


      #fill session if necessary
      if (params[:filter] != nil)
        @myFilter = params[:filter].scan(/[\w-]+/)
        session[:filter] = params[:filter]
      else
        if session[:filter].nil?
          @myFilter = params[:ratings] ? params[:ratings].keys : @all_ratings
          session[:ratings] = params[:ratings]
        else
          @myFilter = params[:ratings] ? params[:ratings].keys : session[:filter]
        end

      end
      #filling in session
      session[:sort] = params[:sort]
      session[:ratings] = params[:ratings]
      #logic to apply filters
      if (params[:sort] == "title") #TITLE
        if (params[:ratings] or params[:filter] != "[]")
          @movies = Movie.find(:all, :conditions => {:rating => (@myFilter==[] ? @all_ratings : @myFilter)}, :order => "title")
        else
          @movies = Movie.find(:all, :order => "title")
        end
      elsif (params[:sort] == "release_date") #RELEASE DATE
        if (params[:ratings] or params[:filter] != "[]")
          @movies = Movie.find(:all, :conditions => {:rating => (@myFilter==[] ? @all_ratings : @myFilter)}, :order => "release_date")
        else
          @movies = Movie.find(:all, :order => "release_date")
        end
      elsif (params[:sort] == nil)
        if (params[:ratings] or params[:filter] != "[]")
          @movies = Movie.find(:all, :conditions => {:rating => (@myFilter==[] ? @all_ratings : @myFilter)})
        else
          @movies = Movie.all
        end
      end
    end
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
