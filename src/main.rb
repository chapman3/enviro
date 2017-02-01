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

db = SQLite3::Database.open("enviro.db")
db.results_as_hash = true
statement = db.prepare "SELECT * FROM assignments WHERE categoryID=?"
statement.bind_param 1, 1
results = statement.execute
if results.count == 0
	puts results.count
end