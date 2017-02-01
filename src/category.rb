require './assignment'

class Category

	def initialize(title, id, weight, lost, earned)
		#connectdb
		db = SQLite3::Database.open("enviro.db")
	
		#set properties
		@title = title
		@id = id
		@weight = weight
		@lost = lost
		@earned = earned
		@assignments = []

		#populate with assignment objects
		db.results_as_hash = true
		statement = db.prepare "SELECT * FROM assignments WHERE categoryID=?"
		statement.bind_param 1, @id
		results = statement.execute
		results.each do |row|
			tempTitle = row['title'] 
			tempId = row['assignmentID']
			tempPossible = row['possible']
			tempEarned = row['earned']
			tempStatus = row['status']
			tempObj = assignment(tempTitle, tempId, tempPossible, tempEarned, tempStatus)
			@assignments << tempObj
	end

	#getters
	def title
		@title
	end
	def id
		@id
	end
	def weight
		@weight
	end
	def lost
		@lost
	end
	def earned
		@earned
	end
	def assignments
		@assignments
	end

	#setters
	def title=(value)
		@title = value
	end
	def weight=(value)
		@weight = value
	end

	#class methods
	def addAssignment
		#prompt for title, ptsPossible, ptsEarned, status
		#assign new catobj
		#append to @categories
	end
	def remAssignment(title)
		#find in @categories
		#delete db info
		#delete obj.
	end
end

end