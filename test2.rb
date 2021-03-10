require 'digest'

def candidates(client)
  begin
    s = "CREATE TABLE hle_dev_test_aleksey(
    id INT NOT NULL AUTO_INCREMENT,
    candidate_office_name VARCHAR(250) NULL,
    clean_name VARCHAR(250) NULL,
    sentence VARCHAR(250) NULL,
    PRIMARY KEY (id),
    unique (candidate_office_name)
    )engine=InnoDB"
    client.query(s)
  rescue
    puts 'The table has already been created'
  end

  a = "insert ignore into hle_dev_test_aleksey (candidate_office_name) select candidate_office_name from hle_dev_test_candidates"
  client.query(a)

  tb = "select id, candidate_office_name from hle_dev_test_aleksey where clean_name and sentence is null"
  results = client.query(tb).to_a

  if results.count == 0
    puts "Nothing happened"
  else
    results.each do |r|
      id = r['id']
      res = r['candidate_office_name']
      res = res.gsub('Twp', 'Township').gsub(/Hwy|Highway highway|Hwy hwy/, 'Highway').gsub('Coroner', 'coroner').gsub('Clerk', 'clerk').gsub(/(.*)\/(.*)/){"#{Regexp.last_match[2].lstrip} #{Regexp.last_match[1].downcase}"}.gsub(/(.*)\/(.*)\/(.*)/){"#{Regexp.last_match[3]} #{Regexp.last_match[1].downcase.delete(' county ')} and #{Regexp.last_match[2].downcase}"}.gsub(/(.*),(.*)/){"#{Regexp.last_match[1]} (#{Regexp.last_match[2].lstrip})"}.gsub('Township township', 'Township').gsub('highway', 'Highway').gsub('County county', 'County')

      escaped = client.escape(res)
      update = "UPDATE hle_dev_test_aleksey SET order by clean_name = '#{escaped}' desc WHERE ID = #{id}"
      client.query(update)
      p update

      rs = "The candidate is running for the #{escaped} office."
      upd = "UPDATE hle_dev_test_aleksey SET sentence = '#{rs}' WHERE ID = #{id}"
      client.query(upd)
    end
  end
end