class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def get_params(params)
	hash = {}
	params.each do |key|
		if !(key==:action || key==:controller)
			hash[key]=params[key]	
		end
	end
	return hash
  end
#then do redirect_to movies_path(:options => get_params(params))

  def index
    if session[:ratings]==nil
	params[:ratings]=Hash[Movie.all_ratings.map {|rating| [rating,"1"] }]
	session[:ratings]=params[:ratings]
    end
    
    if params[:ratings]==nil	
	if params.has_key?(:sort)
		redirect_to movies_path(:ratings => session[:ratings], :sort=> params[:sort])
	else 
		redirect_to movies_path(:ratings => session[:ratings])
	end	
    else 
        @checkboxes=params[:ratings]

    	if params.has_key?(:sort)
		@sort=params[:sort].to_s
		@movies = Movie.order(@sort).find(:all, :conditions => { :rating => params[:ratings].keys}) 
		session[:sort]=params[:sort]	
    	elsif session.has_key?(:sort)
		@sort=session[:sort].to_s
		@movies = Movie.order(@sort).find(:all, :conditions => { :rating => params[:ratings].keys}) 
	else      		
		@movies = Movie.find(:all, :conditions => { :rating => params[:ratings].keys})
    	end
	    
	session[:ratings]=params[:ratings]
    	@all_ratings = Movie.all_ratings
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
