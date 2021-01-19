def titlesize(name)
   puts name.split.map(&:capitalize).join(" ")
end

titlesize('hello word')