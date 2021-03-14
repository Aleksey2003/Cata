require 'nokogiri'
require 'open-uri'
require 'digest'

Nokogiri::HTML.parse(URI.open('https://www.cdc.gov/coronavirus/2019-ncov/covid-data/covidview/01152021/specimens-tested.html'))

def scraping(client)
  begin
  t = "create table covid_test_charts_aleksey(
  id int auto_increment,
  Week int null,
  'Total Spec Tested (includes age unknown)' int null,
  'Total % Pos (includes age unknown)' float null,
  '0-4 years Spec Tested' int null,
  '0-4 years % Pos' float null,
  '5-17 years Spec Tested' int null,
  '5-17 years % Pos' float null,
  '18-49 years Spec Tested' int null,
  '18-49 years % Pos' float null,
  '50-64 years Spec Tested' int null,
  '50-64 years % Pos' float null,
  '65+ years Spec Tested' int null,
  '65+ years % Pos' float null,
  primary key (id)
  )engine=InnoDB"
  client.query(t)
  rescue
    puts 'The table has already been created'
  end
end