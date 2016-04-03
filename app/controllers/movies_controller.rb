class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    # Get the remembered settings
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


      #seting session and filter info
      if (params[:filter] != nil)
        @myFilter = params[:filter].scan(/[\w-]+/)
        session[:filter] = params[:filter]
      else
        if session[:filter].nil?
          if params[:ratings]
            @myFilter = params[:ratings].keys
          else
            @myFilter = all_ratings
          end
          session[:ratings] = params[:ratings]
        else
          if params[:ratings]
            @myFilter = params[:ratings].keys
          else
            @myFilter = session[:filter]
          end
        end

      end

      session[:ratings] = params[:ratings]
      session[:sort] = params[:sort]
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
        if (params[:ratings] or params[:filter] != "[]") # filter ratings
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
