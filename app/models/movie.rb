class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date
  def self.all_ratings
  	allRatings = []
  	Movie.all.each do |movie|
  		if(allRatings.find_index(movie.raitings) == nil)
  			allRatings.push(movie.rating)
  		end
  	end
  	return allRatings
  end
end
