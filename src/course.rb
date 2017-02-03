require './category'
require 'sqlite3'

class Course

	def initialize(title, id, minGrade, maxGrade, setting)
		
		#set properties
		@title = title
		@id = id
		@minGrade = minGrade.to_f
		@maxGrade = maxGrade.to_f
		@categories = []

		@db = SQLite3::Database.open("enviro.db")

		if setting == 0
			#course created from db
			puts createCategoriesFromDb
		elsif setting == 1
			#db empty, allow manual creation
			puts "calcMinMax status: "
			puts calcMinMax
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
	def minGrade
		@minGrade
	end
	def maxGrade
		@maxGrade
	end
	def categories
		@categories
	end

	#setters
	def title=(value)
		@title = value
	end

	#class methods
	def getCatId
		return (100*@id)
	end
	def addCategory
		catId = getCatId + @categories.count + 1
		puts "Category Title?"
		inTitle = gets.chomp
		puts "Category Weight?"
		inWeight = gets.chomp
		tempObj = Category.new(inTitle, catId, @id, inWeight, nil, nil, 1)
		@categories << tempObj
	end
	def remCategory(title)
		@categories.each do |cat|
			if cat.title == title
				cat.assignments.each do |assignment|
					cat.remAssignment(assignment.title)
				end
				puts cat.remFromDb
				@categories.delete(cat)
				return 1
			end
		end
		return 0
	end
	def calcMinMax
		min = 0
		max = 100
		@categories.each do |cat|
			cat.calcLostEarned
			min += cat.earned
			max -= cat.lost
		end
		@minGrade = min
		@maxGrade = max
		return 1
	end

	#category menu methods
	def inqCategories
		unless @categories.count == 0 
			puts "CategoryID - Title - Weight - Lost - Earned"
			@categories.each do |cat|
				puts cat.id.to_s << ' - ' << cat.title.to_s << ' - ' << cat.weight.to_s << ' - ' << cat.lost.to_s << ' - ' << cat.earned.to_s
			end
			puts "Enter 0 to return to menu"
			puts "Enter CategoryID to inquire on Category"
			input = gets.chomp
			unless input.to_i == 0
				@categories.each do |cat|
					if input.to_i == cat.id.to_i
						return cat.inqAssignments
					end
				end
			end
			return giveCatOptions	
		end
		puts "no categories"
		return giveCatOptions
	end
	def giveCatOptions
		puts "What would you like to do?"
		puts "1 - Inquire on Categories"
		puts "2 - Add a new Category"
		puts "3 - Remove a Category"
		puts "4 - Return to Menu"
		input = gets.chomp
		handleSelection(input)
	end
	def handleSelection(input)
		if input.to_i == 1
			inqCategories
			return giveCatOptions
		elsif input.to_i == 2
			addCategory
			return giveCatOptions
		elsif input.to_i == 3
			remCategory
			return giveCatOptions
		else
			puts "Returning to Main Menu"
		end
	end

	#db operations
	def createCategoriesFromDb
		#populate objects from db
		#connectdb
		#populate with category objects
		@db.results_as_hash = true
		statement = @db.prepare "SELECT * FROM categories WHERE courseID=?"
		statement.bind_param 1, @id
		results = statement.execute
		unless results.count == 0
			results.each do |row|
				tempTitle = row['title']
				tempWeight = row['weight']
				tempLost = row['lost']
				tempEarned = row['earned']
				tempId = row['categoryID']
				tempObj = category(tempTitle, tempId, @id, tempWeight, tempLost, tempEarned, 0)
				@categories << tempObj
			end
		end
		return 1
	end
	def addToDb
		statement = @db.prepare "INSERT INTO courses (title, minGrade, maxGrade, courseID) VALUES (?, ?, ?, ?)"
		statement.bind_param 1, @title 
		statement.bind_param 2, @minGrade
		statement.bind_param 3, @maxGrade
		statement.bind_param 4, @id
		results = statement.execute
		return results
	end
	def remFromDb
		statement = @db.prepare "DELETE * FROM courses WHERE courseID=?"
		statement.bind_param 1, @id
		results = statement.execute
		return results
	end
	def updateDb(attribute)
		if attribute == "title"
			statement = @db.prepare "UPDATE courses Set title=? WHERE CourseID=?"
			statement.bind_param 1, @title
			statement.bind_param 2, @id
			results = statement.execute
			return "Title Update to DB"
		elsif attribute == "minGrade"
			statement = @db.prepare "UPDATE courses Set minGrade=? WHERE CourseID=?"
			statement.bind_param 1, @minGrade
			statement.bind_param 2, @id
			results = statement.execute
			return "MinGrade Update to DB"
		elsif attribute == "maxGrade"
			statement = @db.prepare "UPDATE courses Set maxGrade=? WHERE CourseID=?"
			statement.bind_param 1, @maxGrade
			statement.bind_param 2, @id
			results = statement.execute
			return "maxGrade Update to DB"
		else
			return "Wrong attribute in Course.updateDb"
		end
	end
end