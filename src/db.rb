
require 'sqlite3'

#create tables and references

db = SQLite3::Database.open("enviro.db")
db.execute( "CREATE TABLE IF NOT EXISTS courses(
												title TEXT, 
												minGrade REAL, 
												maxGrade REAL, 
												courseID INTEGER UNIQUE)")
db.execute( "CREATE TABLE IF NOT EXISTS categories(
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
												completed INTEGER,  
												assignmentID INTEGER,
												categoryID INTEGER, FOREIGN KEY(categoryID) REFERENCES categories(categoryID),
												CHECK (completed IN (0, 1)))")
