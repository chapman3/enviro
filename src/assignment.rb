class Assignment

	def initialize(title, id, possible, earned, status)
		#set properties
		@title = title
		@id = id
		@ptsPossible = possible
		@ptsEarned = earned
		@completed = status
	end

	#getters
	def title
		@title
	end
	def id
		@id
	end
	def ptsPossible
		@ptsPossible
	end
	def ptsEarned
		@ptsEarned
	end
	def completed
		@completed
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
	def completed(value)
		@completed = value
	end

end