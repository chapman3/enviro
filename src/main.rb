require './course'
require './category'
require './assignment'
require 'sqlite3'

#assignment test
"
assignment = Assignment.new('title', 1, 5, 4, 1)
puts assignment.title
puts assignment.id
puts assignment.ptsPossible
puts assignment.ptsEarned
puts assignment.status
"

course = Course.new('test', 1, 0, 0, 1)
course.addCategory
category = course.categories[0]
category.addAssignment
assignment = category.assignments[0]
puts assignment.ptsEarned
puts "before"
puts category.earned
category.calcLostEarned
puts "after"
puts category.earned