require './course'
require './category'
require './assignment'
require './controller'
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

controller = Controller.new