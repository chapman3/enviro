class Course

	def initialize(title, id, minGrade, maxGrade, cTable)
		#connectdb
		db = cTable
		
		#set properties
		@title = title
		@id = id
		@minGrade = minGrade
		@maxGrade = maxGrade
		@categories = []
		#populate with category objects
		#for row in db,
		#  get info of a category
		#  create category object
		#  add object to category array
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

end



