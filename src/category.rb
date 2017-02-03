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
		updateDb("title")
	end
	def weight=(value)
		@weight = value
		updateDb("weight")
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
		inEarned = 0
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
		totalPossible = 0
		earnedPossible = 0
		totalEarned = 0
		puts @assignments.count
		@assignments.each do |assignment|
			puts assignment.status.class
			if assignment.status == 0
				totalPossible += assignment.ptsPossible
			elsif assignment.status == 1
				totalPossible += assignment.ptsPossible
				earnedPossible += assignment.ptsPossible
				totalEarned += assignment.ptsEarned
			else
				puts "Yikes calcLostEarned"
				return 0
			end
		end
		unless totalPossible == 0
			wtPossible = (earnedPossible / totalPossible) * @weight
			@earned = totalEarned / wtPossible
			@lost = (earnedPossible - totalEarned) / wtPossible
			updateDb("lost")
			updateDb("earned")
		end
		return 1
	end

	#assignment menu methods
	def inqAssignments
		unless @assignments.count == 0 
			puts "AssignmentID - Title - Possible - Earned - Status"
			@assignments.each do |assignment|
				puts assignment.id.to_s << ' - ' << assignment.title.to_s << ' - ' << assignment.ptsPossible.to_s << ' - ' << assignment.ptsEarned.to_s << ' - ' << assignment.status.to_s
			end
			puts "Enter 0 to return to menu"
			puts "Enter AssignmentID to inquire on Assignment"
			input = gets.chomp
			unless input.to_i == 0
				@assignments.each do |assignment|
					if input.to_i == assignment.id.to_i
						puts assignment.id.to_s << ' - ' << assignment.title.to_s
						puts "What would you like to change?"
						puts "0 - Nothing"
						puts "1 - Points Possible"
						puts "2 - Points Earned"
						changeInput = gets.chomp
						unless changeInput.to_i == 0
							puts "Enter new amount"
							newAmount = gets.chomp
							if changeInput == 1
								assignment.ptsPossible = newAmount
								calcLostEarned
								return inqAssignments
							elsif changeInput == 2
								assignment.ptsEarned = newAmount
								calcLostEarned
								return inqAssignments
							else
								puts "yikes, value error"
							end
						end
					end
				end
			end
			return giveAssignmentOptions
		end
		puts "no assignments"
		return giveAssignmentOptions
	end
	def giveAssignmentOptions
		puts "What would you like to do?"
		puts "1 - Inquire on Assignments"
		puts "2 - Add a new Assignment"
		puts "3 - Remove a Assignment"
		puts "4 - Return to Menu"
		input = gets.chomp
		handleSelection(input)
	end
	def handleSelection(input)
		if input.to_i == 1
			inqAssignments
			return giveAssignmentOptions
		elsif input.to_i == 2
			addAssignment
			return giveAssignmentOptions
		elsif input.to_i == 3
			remAssignment
			return giveAssignmentOptions
		else
			puts "Returning to Main Menu"
		end
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
	def updateDb(attribute)
		if attribute == "title"
			statement = @db.prepare "UPDATE categories Set title=? WHERE categoryID=?"
			statement.bind_param 1, @title
			statement.bind_param 2, @id
			results = statement.execute
			return "Title Update to DB"
		elsif attribute == "weight"
			statement = @db.prepare "UPDATE categories Set weight=? WHERE categoryID=?"
			statement.bind_param 1, @weight
			statement.bind_param 2, @id
			results = statement.execute
			return "Weight Update to DB"
		elsif attribute == "lost"
			statement = @db.prepare "UPDATE categories Set lost=? WHERE categoryID=?"
			statement.bind_param 1, @lost
			statement.bind_param 2, @id
			results = statement.execute
			return "Lost Update to DB"
		elsif attribute == "earned"
			statement = @db.prepare "UPDATE categories Set earned=? WHERE categoryID=?"
			statement.bind_param 1, @earned
			statement.bind_param 2, @id
			results = statement.execute
			return "Earned Update to DB"
		else
			return "Wrong attribute in Category.updateDb"
		end
	end
end