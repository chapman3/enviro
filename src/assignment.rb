class Assignment

	def initialize(title, id, catId, possible, earned, status)
		@db = SQLite3::Database.open("enviro.db")
		#set properties
		@title = title
		@id = id
		@catId = catId
		@ptsPossible = possible.to_f
		@ptsEarned = earned.to_f
		@status = status.to_f
		puts addToDb
	end

	#getters
	def title
		@title
	end
	def id
		@id
	end
	def catId
		@catId
	end
	def ptsPossible
		@ptsPossible
	end
	def ptsEarned
		@ptsEarned
	end
	def status
		@status
	end

	#setters
	def title=(value)
		@title = value
	end
	def ptsPossible=(value)
		@ptsPossible = value
	end
	def ptsEarned=(value)
		@ptsEarned = value
	end
	def status=(value)
		@status = value
	end

	#db operations
	def addToDb
		statement = @db.prepare "INSERT INTO assignments (title, possible, earned, status, assignmentID, categoryID) VALUES (?, ?, ?, ?, ?, ?)"
		statement.bind_param 1, @title
		statement.bind_param 2, @ptsPossible
		statement.bind_param 3, @ptsEarned
		statement.bind_param 4, @status
		statement.bind_param 5, @id
		statement.bind_param 6, @catId
		results = statement.execute
		return results
	end
	def remFromDb
		statement = @db.prepare "DELETE * FROM assignments WHERE assignmentID=?"
		statement.bind_param 1, @id
		results = statement.execute
		return results
	end
	def updateDb

	end
end