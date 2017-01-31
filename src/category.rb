class Category

	def initialize(title, id, weight, lost, earned, aTable)
		#connectdb
		db = aTable
	
		#set properties
		@title = title
		@id = id
		@weight = weight
		@lost = lost
		@earned = earned
		@assignments = []
		#populate with assignment objects
		#for row in db,
		#  get info of an assignment
		#  create assignment object
		#  add object to assignments array
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