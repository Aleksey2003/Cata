require "mysql2"
require 'dotenv/load'

client = Mysql2::Client.new(host: "db09.blockshopper.com", username: ENV['DB_DB09_LGN'], password: ENV['DB_DB09_PWD'])

client.query("use applicant_tests")
results = client.query("SELECT FirstName, MiddleName, LastName FROM teachers_aleksey").to_a

p results