require './course'
require 'sqlite3'

class Controller
	def initialize
		@courses = []
		giveOptions
	end

	#optionMethods
	def showTitles
		unless @courses.count == 0
			@courses.each do |course|
				puts course.title
			end
			return
		end
		puts "no courses"
	end
	def addCourse
		coId = @courses.count + 1
		puts "Course Title?"
		inTitle = gets.chomp
		tempObj = Course.new(inTitle, coId, 0, 0, 1)
		@courses << tempObj
	end
	def remCourse
		puts "Which course should we delete?"
		showTitles
		input = gets.chomp
		@courses.each do |course|
			if course.title = input
				@categories.each do |category|
					course.remCategory(category.title)
				end
				course.remFromDb
				@courses.delete(course)
			end
		end
		giveOptions
	end

	#inputMethods
	def inqCourses
		unless @courses.count == 0 
			puts "CourseID - Title - MinGrade - MaxGrade"
			@courses.each do |course|
				puts course.id.to_s << ' - ' << course.title.to_s << ' - ' << course.minGrade.to_s << ' - ' << course.maxGrade.to_s
			end
			puts "Enter 0 to return to menu"
			puts "Enter CourseID to inquire on Course"
			input = gets.chomp
			unless input.to_i == 0
				@courses.each do |course|
					if input.to_i == course.id.to_i
						return course.inqCategories
					end
				end
			end	
		end
		puts "no courses"
	end
	def giveOptions
		puts "What would you like to do?"
		puts "1 - Inquire on Courses"
		puts "2 - Add a new Course"
		puts "3 - Remove a Course"
		puts "4 - Close Application"
		input = gets.chomp
		handleSelection(input)
	end	
	def handleSelection(input)
		if input.to_i == 1
			inqCourses
			return giveOptions
		elsif input.to_i == 2
			addCourse
			return giveOptions
		elsif input.to_i == 3
			remCourse
			return giveOptions
		elsif input.to_i == 4
			exit(true)
		else
			puts "Yikes"
		end
	end
end