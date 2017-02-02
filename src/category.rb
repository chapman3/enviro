require './assignment'
require 'sqlite3'

class Category

	def initialize(title, id, courseId, weight, lost, earned, setting)
	
		#set properties
		@title = title
		@id = id
		@courseId = courseId
		@weight = weight.to_f
		@lost = lost.to_f
		@earned = earned.to_f
		@assignments = []

		@db = SQLite3::Database.open("enviro.db")
		if setting == 0
			#category created from db
			puts createAssignmentsFromDb
		elsif setting == 1
			#db empty, allow manual creation
			puts "calcLostEarned status: "
			puts calcLostEarned
			puts addToDb
		end
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
	def getAssignmentId
		return (100*@id)
	end
	def addAssignment
		assignmentId = getAssignmentId + @assignments.count + 1
		puts "Assignment Title?"
		inTitle = gets.chomp
		puts "Points Possible?"
		inPts = gets.chomp
		puts "Assignment Completed? (0 for no, 1 for yes)" 
		inStatus = gets.chomp
		#while inStatus not 0 or 1
		#	puts "Assignment Completed? (0 for no, 1 for yes)" 
		#	inStatus = gets.chomp
		#end
		inEarned = nil
		unless inStatus == 0
			puts "Points Earned?"
			inEarned = gets.chomp
		end
		tempObj = Assignment.new(inTitle, assignmentId, @id, inPts, inEarned, inStatus)
		@assignments << tempObj
		
	end
	def remAssignment(title)
		#find in @assignments
		@assignments.each do |assignment|
			if assignment.title == title
				puts assignment.remFromDb
				@assignments.delete(assignment)
			end
		end
	end
	def calcLostEarned
		puts "made it to calcLostEarned"
		totalPossible = 0
		earnedPossible = 0
		totalEarned = 0
		puts @assignments.count
		@assignments.each do |assignment|
			puts assignment.status.class
			if assignment.status == 0
				puts "am I in 0?"
				totalPossible += assignment.ptsPossible
			elsif assignment.status == 1
				puts "am I in 1?"
				totalPossible += assignment.ptsPossible
				earnedPossible += assignment.ptsPossible
				totalEarned += assignment.ptsEarned
			else
				puts "oops how did this happen?"
				return 0
			end
		end
		puts "totalPossible"
		puts totalPossible
		unless totalPossible == 0
			wtPossible = (earnedPossible / totalPossible) * @weight
			@earned = totalEarned / wtPossible
			@lost = (earnedPossible - totalEarned) / wtPossible
		end
		return 1
	end

	#db operations
	def createAssignmentsFromDb
		#populate with assignment objects
		@db.results_as_hash = true
		statement = db.prepare "SELECT * FROM assignments WHERE categoryID=?"
		statement.bind_param 1, @id
		results = statement.execute
		unless results.count == 0
			results.each do |row|
				tempTitle = row['title'] 
				tempId = row['assignmentID']
				tempPossible = row['possible']
				tempEarned = row['earned']
				tempStatus = row['status']
				tempObj = assignment(tempTitle, tempId, @id, tempPossible, tempEarned, tempStatus)
				@assignments << tempObj
			end
		end
	end
	def addToDb
		statement = @db.prepare "INSERT INTO categories (title, weight, lost, earned, categoryID, courseID) VALUES (?, ?, ?, ?, ?, ?)"
		statement.bind_param 1, @title
		statement.bind_param 2, @weight
		statement.bind_param 3, @lost
		statement.bind_param 4, @earned
		statement.bind_param 5, @id
		statement.bind_param 6, @courseId
		results = statement.execute
		return results
	end
	def remFromDb
		statement = @db.prepare "DELETE * FROM categories WHERE categoryID=?"
		statement.bind_param 1, @id
		results = statement.execute
		return results
	end
	def updateDb

	end
end