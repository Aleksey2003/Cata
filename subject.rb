require "mysql2"
require 'dotenv/load'
require_relative 'methods.rb'

client = Mysql2::Client.new(host: "db09.blockshopper.com", username: ENV['DB_DB09_LGN'], password: ENV['DB_DB09_PWD'])
client.query("use applicant_tests")

#add_subject("fhfe", client)
# finds(1, client)
# puts get_class_info(3, client)
# puts get_subject_teachers(1, client)
# puts get_class_subjects('11-A', client)
puts get_teachers_list_by_letter('a', client)
client.close