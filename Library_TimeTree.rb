def createTreeFromHere(absoluteDateNode)
  #puts absoluteDateNode
  #puts absoluteDateNode.class #gives us ms, s, min, hour, etc

  currentNodeName = absoluteDateNode.name
  for i in (absoluteDateNode.name.length).downto(4)
    # puts "Value of local variable is #{i}"

    if i == 18
      #This is a millisecond
      thisMillisecond = Millisecond.merge(name: currentNodeName)
      # puts thisMillisecond.name

      thisSecond = Second.merge(name: thisMillisecond.name[0..thisMillisecond.name.length-5])

      thisMillisecond.datetimeParent = thisSecond

      #chop to second
      currentNodeName = thisSecond.name
    elsif i == 15
      # puts "#this is second"
      # puts "Second currentNodeName: #{currentNodeName}"
      thisSecond = Second.merge(name: currentNodeName)
      # puts "thisSecond.name: #{thisSecond.name}"
      # puts thisSecond
      thisMinute = Minute.merge(name: thisSecond.name[0..thisSecond.name.length-3])
      # puts "thisMinute.name: #{thisMinute.name}"
      thisSecond.datetimeParent = thisMinute
      #chop to minute
      currentNodeName = thisMinute.name
    elsif i == 13
      # puts "#this is minute"
      # puts currentNodeName

      thisMinute = Minute.merge(name: currentNodeName)
      # puts thisMinute

      thisHour = Hour.merge(name: thisMinute.name[0..thisMinute.name.length-3])

      thisMinute.datetimeParent = thisHour
      #chop to hour
      currentNodeName = thisHour.name
    elsif i == 11
      # puts "#this is an hour"
      # puts currentNodeName

      thisHour = Hour.merge(name: currentNodeName)
      thisDay = Day.merge(name: thisHour.name[0..thisHour.name.length-4])

      thisHour.datetimeParent = thisDay
      #chop to day
      currentNodeName = thisDay.name
    elsif i == 8
      # puts "#this is a day"
      # puts currentNodeName

      thisDay = Day.merge(name: currentNodeName)
      thisMonth = Month.merge(name: (thisDay.name[0..thisDay.name.length-3]))

      thisDay.datetimeParent = thisMonth
      #chop to month
      currentNodeName = thisMonth.name
    elsif i == 6
      # puts" #this is a Month"
      # puts currentNodeName

      thisMonth = Month.merge(name: currentNodeName)
      # puts thisMonth
      # puts thisMonth.name[0..thisMonth.name.length-3].to_i.floor2(1).to_s
      thisYear = Year.merge(name: (thisMonth.name[0..thisMonth.name.length-3]))

      thisMonth.datetimeParent = thisYear
      #chop to decade
      currentNodeName = thisYear.name
    elsif i == 4
      # puts "#Go from year to root"
      # puts currentNodeName
      # puts "Hit 4: #{currentNodeName}"

      thisYear = Year.merge(name: currentNodeName)
      thisDecade = Decade.merge(name: "#{currentNodeName.to_i.floor2(1).to_s}s")
      thisCentury = Century.merge(name: thisDecade.name.to_i.floor2(2).to_s)
      thisabsolutedatetimeroot = AbsoluteDateTimeRoot.merge(name: "AbsoluteDateTimeRoot")

      
      # puts "thisYear.name: #{thisYear.name}"
      # puts "thisDecade.name: #{thisDecade.name}"
      # puts "thisCentury.name: #{thisCentury.name}"

      #thisDecade = Decade.merge(name: (thisMonth.name[0..thisMonth.name.length-3].to_i.floor2(1).to_s))
      # This is a decade. connect to decade, century, and root
      # thisDecade = currentNodeName
      # thisMonth =  Month.merge(name: thisDay[0..thisDay.length-3])
      # thisYear = Year.merge(name: thisDay[0..thisDay.length-5])
      # thisDecade = Decade.merge(name: (thisDay[0..thisDay.length-5].to_i.floor2(1).to_s))
      # thisCentury = Century.merge(name: thisDay[0..thisDay.length-5].to_i.floor2(2).to_s)
      # thisabsolutedatetimeroot = AbsoluteDateTimeRoot.merge(name: "AbsoluteDateTimeRoot")


      # absoluteDateNode.datetimeParent = thisMonth
      # thisMonth.datetimeParent = thisYear
      # thisYear.datetimeParent = thisDecade
      thisYear.datetimeParent = thisDecade
      thisDecade.datetimeParent = thisCentury
      thisCentury.datetimeParent = thisabsolutedatetimeroot

  else
      # puts "Not a recognized date."

      # if absoluteDateNode.name
      #   workingdate = absoluteDateNode.name
      #   if workingdate[0..workingdate.length-3].length
      #   if 
    end
  end
  

  # Traverse up the tree until you hit century. Merge as you go. Names should be unique like:
  # Century: 1900
  # Decade: 1920
  # Year: 1921
  # Month: 1921-01
  # Day: 1921-01-05
  # Hour: 1921-01-05_15
  # Minute: 1921-01-05_1533
  # Second: 1921-01-05_153354
  # Millisecond: 1921-01-05_153354.382

  # What is the scope? Easily determined by the length(?) Class(?)
  # Parse out the information we have from the name
  # 


  #if ms
    #create relationship to Second
    # ms.datetimeParent = Second.findby(name: "")
    #if second
      # create relationship to Minute
      #if minute

end