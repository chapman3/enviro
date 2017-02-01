class Assignment

	def initialize(title, id, possible, earned, status)
		#set properties
		@title = title
		@id = id
		@ptsPossible = possible
		@ptsEarned = earned
		@status = status
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

end