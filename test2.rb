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

  tb = "select id, candidate_office_name from hle_dev_test_aleksey where clean_name is null"
  results = client.query(tb).to_a

  if results.count == 0
    puts "Nothing happened"
  else
    results.each do |r|
      id = r['id']
      res = r['candidate_office_name']
      res = res.gsub(/(?<![,\\\/\p{L}])\p{L}+/){|d| d.downcase}.gsub(/(.*)\/(.*)/){"#{Regexp.last_match[2].lstrip} #{Regexp.last_match[1].downcase}"}.gsub(/(.*)\/(.*)\/(.*)/){"#{Regexp.last_match[3]} #{Regexp.last_match[1].downcase.delete(' county ')} and #{Regexp.last_match[2].downcase}"}.gsub(/(.*),(.*)/){"#{Regexp.last_match[1]} (#{Regexp.last_match[2].lstrip.split.map(&:capitalize).join(" ")})"}.gsub(/County county|county county|County County/, 'County').gsub("clerk/recorder", 'clerk and recorder').gsub(/[.]/, '').gsub(/Park park|park park/, 'park').gsub('/', '').gsub(/Twp|twp|Township township|township/, 'Township').gsub(/Hwy|hwy|Highway highway|hwy hwy|Highway Highway|highway/, 'Highway').gsub('Township Township', 'Township').gsub('53 53', '53').gsub('District186', 'District 186').gsub('District153', 'District 153').gsub('village village', 'village').lstrip

      escaped = client.escape(res)
      update = "UPDATE hle_dev_test_aleksey SET clean_name = '#{escaped}' WHERE ID = #{id}"
      client.query(update)
      p update

      rs = "The candidate is running for the #{escaped} office."
      upd = "UPDATE hle_dev_test_aleksey SET sentence = '#{rs}' WHERE ID = #{id}"
      client.query(upd)
    end
  end
end