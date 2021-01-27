require 'date'

def add_subject(name, client)
  escaped = client.escape(name)
  q = "insert into subjects_aleksey(Name) VALUES ('#{escaped}')"
  client.query(q)
end

def finds(id, client)
  f = "select FirstName, MiddleName, LastName, BirthDate from teachers_aleksey where ID = ('#{id}')"
  results = client.query(f).to_a
  if results.count == 0
    puts "Teacher with id #{id} was not found"
  else
    puts "Teacher #{results[0]['FirstName']} #{results[1]['MiddleName']} #{results[2]['LastName']} Born #{Date.parse(results[3]['BirthDate']).strftime("%d %b %Y year, in %A")}"
  end
end

