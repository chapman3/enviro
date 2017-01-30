require 'sqlite3'

db = SQLite3::Database.open("enviro.db")
db.execute( "CREATE TABLE IF NOT EXISTS courses(
												title TEXT, 
												minGrade REAL, 
												maxGrade REAL, 
												courseID INTEGER UNIQUE)")
db.execute( "CREATE TABLE IF NOT EXISTS categorys(
												title TEXT, 
												weight REAL, 
												lost REAL, 
												earned REAL, 
												categoryID INTEGER UNIQUE, 
												courseID INTEGER, FOREIGN KEY(courseID) REFERENCES courses(courseID))")
db.execute( "CREATE TABLE IF NOT EXISTS assignments(
												title TEXT, 
												ptsPossible REAL, 
												ptsEarned REAL, 
												completed INTEGER, CHECK (completed IN (0, 1)), 
												categoryID INTEGER, FOREIGN KEY(categoryID) REFERENCES categorys(categoryID))")
