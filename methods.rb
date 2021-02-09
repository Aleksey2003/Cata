require 'date'
require 'digest'

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
  g1 = "SELECT classes.Name, FirstName, MiddleName, LastName FROM classes_aleksey classes
  JOIN teachers_aleksey teachers ON classes.ResponsibleTeacherID = teachers.ID where classes.ID = #{id}"
  g2 = "SELECT FirstName, MiddleName, LastName FROM teachers_aleksey teachers
  JOIN teachers_classes_aleksey teachers_classes ON teachers.ID = teachers_classes.TeacherID
  JOIN classes_aleksey classes ON teachers_classes.ClassID = classes.ID where classes.ID = #{id}"
  results1 = client.query(g1).to_a
  results2 = client.query(g2).to_a
  results2 = results2.map{|r| "#{r['FirstName']} #{r['MiddleName']} #{r['LastName']}"}.join("\n")
  if results1.count == 0
    "Class ID #{id} was't found"
  else
    "Class Name: #{results1[0]['Name']}\nResponsible teacher: #{results1[0]['FirstName']}  #{results1[0]['MiddleName']} #{results1[0]['LastName']}\nInvolved teachers:\n#{results2}"
  end
end

def get_subject_teachers(id, client)
  s = "SELECT subjects.Name, FirstName, MiddleName, LastName FROM subjects_aleksey subjects
  JOIN teachers_aleksey teachers ON subjects.ID = teachers.SubjectsID WHERE subjects.ID = #{id}"
  results = client.query(s).to_a
  res = results.map{|r| "#{r['FirstName']} #{r['MiddleName']} #{r['LastName']}"}.join("\n")
  p results
  if results.count == 0
    "Subject ID #{id} was't found"
  else
    "Subject: #{results[0]['Name']}\nTeachers:\n#{res}"
  end
end

def get_class_subjects(name, client)
  c = "SELECT s.Name, FirstName, MiddleName, LastName FROM teachers_aleksey t
     JOIN subjects_aleksey s ON t.SubjectsID = s.ID
     JOIN teachers_classes_aleksey t_c ON t.ID = t_c.TeacherID
     JOIN classes_aleksey c ON t_c.ClassID
  WHERE c.Name = '#{name}'"
  results = client.query(c).to_a
  res = results.map{|r| "#{r['Name']} #{r['FirstName']} #{r['MiddleName']}. #{r['LastName']}"}.join("\n")
    if results.count == 0
    "Class #{name} was't found"
  else
    "Class: #{name}\nSubjects:\n#{res}"
  end
end

def get_teachers_list_by_letter(letter, client)
  t = "SELECT FirstName, MiddleName, LastName, s.Name FROM teachers_aleksey t
  JOIN subjects_aleksey s ON t.SubjectsID = s.ID WHERE FirstName RLIKE '#{letter}' OR LastName RLIKE '#{letter}'"
  results = client.query(t).to_a
  res = results.map{|r| "#{r['FirstName'][0]}. #{r['MiddleName'][0]}. #{r['LastName']} (#{r['Name']})"}.join("\n")
  if results.count == 0
    "Teacher with #{letter} in the name was't found"
  else
    res
  end
end

def set_md5(client)
  s = "SELECT * FROM teachers_aleksey"
  results = client.query(s).to_a

  if results.count == 0
    puts "Nothing found"
  else
    results.each do |r|
      id = r['ID']
      md5_str = "#{r['SubjectsID']}#{r['FirstName']}#{r['MiddleName']}#{r['LastName']}#{r['BirthDate']}#{r['Current_age']}"
      md5 = Digest::MD5.hexdigest md5_str
      m = "UPDATE teachers_aleksey SET MD5 = '#{md5}' WHERE ID = '#{id}'"
      results = client.query(m)
    end
  end
end

def get_teachers_by_year(year, client)
  y = "SELECT FirstName, MiddleName, LastName, Current_age FROM teachers_aleksey WHERE Current_age = '#{year}'"
  results = client.query(y).to_a
  res = results.map{|r| "#{r['FirstName']} #{r['MiddleName']} #{r['LastName']}"}.join(', ')
  if results.count == 0
    "There is no such age #{year}"
  else
    "Teachers born in #{results[0]['Current_age']}: #{res}"
  end
end