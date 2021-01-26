def add_subject(name, client)
  escaped = client.escape("('#{name}')")
  q = "insert into subjects_aleksey(Name) VALUES ('#{escaped}')"
  p q
  client.query(q)
end

def finds(id, client)
  f = "select FirstName, MiddleName, LastName, DAYOFMONTH(BirthDate) Day, MONTHNAME(BirthDate) Month from teachers_aleksey where ID = ('#{id}')"
  p f
  client.query(f)
end