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
		puts updateDb("title")
	end
	def ptsPossible=(value)
		@ptsPossible = value.to_f
		puts updateDb("possible")
	end
	def ptsEarned=(value)
		@ptsEarned = value.to_f
		puts updateDb("earned")
	end
	def status=(value)
		@status = value
		puts updateDb("status")
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
	def updateDb(attribute)
		if attribute == "title"
			statement = @db.prepare "UPDATE assignments Set title=? WHERE assignmentID=?"
			statement.bind_param 1, @title
			statement.bind_param 2, @id
			results = statement.execute
			return "Title Update to DB"
		elsif attribute == "possible"
			statement = @db.prepare "UPDATE assignments Set possible=? WHERE assignmentID=?"
			statement.bind_param 1, @ptsPossible
			statement.bind_param 2, @id
			results = statement.execute
			return "ptsPossible Update to DB"
		elsif attribute == "earned"
			statement = @db.prepare "UPDATE assignments Set earned=? WHERE assignmentID=?"
			statement.bind_param 1, @ptsEarned
			statement.bind_param 2, @id
			results = statement.execute
			return "ptsEarned Update to DB"
		elsif attribute == "status"
			statement = @db.prepare "UPDATE assignments Set status=? WHERE assignmentID=?"
			statement.bind_param 1, @status
			statement.bind_param 2, @id
			results = statement.execute
			return "Status Update to DB"
		else
			return "Wrong attribute in Assignment.updateDb"
		end
	end
end