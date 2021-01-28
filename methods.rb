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
    puts "Teacher #{results[0]['FirstName']} #{results[0]['MiddleName']} #{results[0]['LastName']} Born #{(results[0]['BirthDate']).strftime("%d %b %Y year, in %A")}"
  end
end

def get_class_info(id, client)
  g = "SELECT classes.Name, FirstName, MiddleName, LastName FROM classes_aleksey classes
         JOIN teachers_classes_aleksey teachers_classes ON classes.ID = teachers_classes.ClassID
         JOIN teachers_aleksey teachers ON classes.ResponsibleTeacherID = teachers.ID
         JOIN teachers ON teachers_classes.TeacherID = teachers.ID
       WHERE teachers.ID = ('#{id}')"
  results = client.query(g).to_a
  if results.count == 0
    puts "Class Name: #{results[0]['classes.Name']}\n\n Responsible teacher: #{results[0]['FirstName']} #{results[0]['MiddleName']} #{results[0]['LastName']} Involved teachers:"
  end
end
