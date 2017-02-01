require './category'
require 'sqlite3'

class Course

	def initialize(title, id, minGrade, maxGrade)
		#connectdb
		db = SQLite3::Database.open("enviro.db")
		
		#set properties
		@title = title
		@id = id
		@minGrade = minGrade
		@maxGrade = maxGrade
		@categories = []

		#populate with category objects
		db.results_as_hash = true
		statement = db.prepare "SELECT * FROM categories WHERE courseID=?"
		statement.bind_param 1, @id
		results = statement.execute
		unless results.count == 0
			results.each do |row|
				tempTitle = row['title']
				tempWeight = row['weight']
				tempLost = row['lost']
				tempEarned = row['earned']
				tempId = row['categoryID']
				tempObj = category(tempTitle, tempId, tempWeight, tempLost, tempEarned)
				@categories << tempObj
			end
		end
	end
		#for row in db,
		#  get info of a category
		#  create category object
		#  add object to category array

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

		#prompt for properties
		#assign new catobj
		#append to @categories
	end
	def remCategory(title)
		#find in @categories
		#delete db info
		#delete obj.
	end

end



