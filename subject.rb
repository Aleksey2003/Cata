require "mysql2"
require 'dotenv/load'
require_relative 'methods.rb'

client = Mysql2::Client.new(host: "db09.blockshopper.com", username: ENV['DB_DB09_LGN'], password: ENV['DB_DB09_PWD'])
client.query("use applicant_tests")

add_subject("fhfe", client)
finds(1, client)

client.close