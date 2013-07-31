class Movie < ActiveRecord::Base

def self.all_ratings
	#All on Ruby effort (AR methods always return ActiveRecord objects)

	#return all.map {|movie| movie.rating}.uniq	
	return all.group_by {|movie| movie.rating}.keys


	#All DB effort should be done by hand. Returns array of hashes 
		#each element is a hash that represents a row
		#example injecting "SELECT DISTINCT rating,id FROM movies"
		# would return [{"rating"=>"G", "id"=>1} {"rating"=>"R", "id"=>2}]

	#return connection.select_all("SELECT DISTINCT rating FROM movies").map{|ah| ah.values[0]}


	#Mix, injecting only the DISTINCT and selecting rating by mapping in Ruby

	#return select("DISTINCT rating").map(&:rating)	

end

end
