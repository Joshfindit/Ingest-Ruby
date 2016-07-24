def createBirthdayNode(name, date)
  thisBirthdayDate = Time.parse(date)

  thisBirthdayAgent = Agent.merge(name: name)

  thisBirthday = Artefact.create
  thisBirthday.name = "#{name}'s Birthday"
  thisBirthday.save

  thisBirthdayDay = Day.merge(name: thisBirthdayDate.strftime("%Y%m%d"))
  thisBirthday.occurredAt = thisBirthdayDay
  
  thisBirthday.subject = thisBirthdayAgent


  #puts "Name: #{thisBirthdayDay.name}"
  #puts "Name Length: #{thisBirthdayDay.name.length}"
  createTreeFromHere(thisBirthdayDay)
end


def createNowNode()
  timenow = Time.now
  thismillisecond = Millisecond.create

  thismillisecond.unixtime_millisecond = timenow
  thismillisecond.millisecond = timenow.strftime "%Y%m%d_%H%M%S.%L"
  thismillisecond.name = thismillisecond.millisecond
  thismillisecond.save

  # thissecond = Second.merge(name: timenow.strftime("%Y%m%d_%H%M%S"))
  # thisminute = Minute.merge(name: timenow.strftime("%Y%m%d_%H%M"))
  # thishour = Hour.merge(name: timenow.strftime("%Y%m%d_%H"))
  # thisday = Day.merge(name: timenow.strftime("%Y%m%d"))
  # thismonth = Month.merge(name: timenow.strftime("%Y%m"))
  # thisyear = Year.merge(name: timenow.strftime("%Y"))
  # thisdecade = Decade.merge(name: timenow.strftime("%Y").to_i.floor2(1).to_s)
  # thiscentury = Century.merge(name: timenow.strftime("%Y").to_i.floor2(2).to_s)
  # thisabsolutedatetimeroot = AbsoluteDateTimeRoot.merge(name: "AbsoluteDateTimeRoot")

  # thismillisecond.datetimeParent = thissecond
  # thissecond.datetimeParent = thisminute
  # thisminute.datetimeParent = thishour
  # thishour.datetimeParent = thisday
  # thisday.datetimeParent = thismonth
  # thismonth.datetimeParent = thisyear
  # thisyear.datetimeParent = thisdecade
  # thisdecade.datetimeParent = thiscentury
  # thiscentury.datetimeParent = thisabsolutedatetimeroot

  #thissecond.datetimeParent(Minute.create)
  createTreeFromHere(thismillisecond)
end


def createHourNode(passedDatetime)
  if passedDatetime.respond_to?(:gmtime)
    puts "Is already datetime"
    puts confirmedDatetime = passedDatetime
  else
    if confirmedDatetime = Time.parse(passedDatetime)
      puts "Is now datetime"# successfully got time from passedDatetime
    else
      puts "Couldn't get datetime"
      return false
    end  
  end

  puts "creating node"
  hournode = Hour.create()
  hournode.name = confirmedDatetime.strftime("%Y%m%d_%H")
  hournode.save

  hournode.datetimeParent(Day.merge({name:confirmedDatetime.strftime("%Y%m%d")}))

  puts Hour.find(hournode.uuid)

  #return hournode
end


def populateObjects()

# Create the date tree (manually for now)

dateNodeRoot = AbsoluteDateNode.create
dateNodeRoot.name = "dateNodeRoot"
dateNodeRoot.save

hournode = Hour.create()
hournode.name = "2015-02-16T1700"
hournode.save

# Create 2 "document" artefacts of one sentence each

# Create 2 "Audiosegment" artefacts (1: 1 day ago, 2: 1 day ago + 7 seconds)
# # Add "Path" as "http://host.ca/artefact/uuid"
# # Include the metadata from the previous file splitting tool

# # Create an "Audio_segment" artefact that links to both previous segments and is named with the origional filename

# # Create 3 notes that link to a single artefact
# # Each links to [:CREATED_AT] (1: Now - 1 hour, 2: Now - 14min, 3: Now)
# # The first links again via [:EDITED_AT] (Now)

# # 

############################ for the writing app:
# # WITH count(*) as dummy
# jazzLounge = Room.new
# jazzLounge.name = "Jazz Lounge"
# jazzLounge.desc = "A warmly lit lounge with plush chairs pushed arm to arm. The stage is empty, and a mic stands as though waiting for destiny."
# jazzLounge.save

# northSide = Room.new
# northSide.name = "North side of town"
# northSide.desc = "You look out in the direction of the horizon, but all you see is gleaming buildings."
# northSide.save

# doorToOutside = Door.new #Door in the Jazz Club
# doorToOutside.name = "Out"
# doorToOutside.save
# doorToOutside.room = jazzLounge
# doorToOutside.roomTo = northSide

# doorBack = Door.new #Door in North Side
# doorBack.name = "Jazz"
# doorBack.desc = "The door to the Jazz Club"
# doorBack.save
# doorBack.room = northSide
# doorBack.roomTo = jazzLounge


# #   // Create morty
# # CREATE (n:Person {name:"morty", username:"morty", desc:"Warm and fuzzy", wearing:"A conical hat"})
# # //RETURN n.uuid

# # //MATCH (a:Person {name:"morty", username:"morty", desc:"Warm and fuzzy", wearing:"A conical hat"})
# # //CREATE UNIQUE (a)<-[:CONTAINS]-(leaf { name:'D' })
# # //RETURN a

# player = Person.new
# player.name = "morty"
# player.desc = "Meek"
# player.username = "morty"
# # player.Ofail = 'trys to take Morty.. They want me /that/ bad.'
# # player.Okill = 'HaH HaH HaH! I am god! You think you can kill me????.... Hey... no fair...'
# # player.Ause = 'thi [v(n)] tried to use me'
# # player.Ahear = 'thi v[n] listened to me!'
# player.alias = 'friend'
# # player.use = 'There is no socially acceptable way to use that.'
# # player.Ouse = 'tried to use Morty'
# # player.listen2 = '*poke*Morty*'
# # player.Ahear2 = ':hath been poked and emits a customary "Eek!"'
# # player.listen4 = '*foof*'
# # player.Ahear4 = '"Woohoo! (It is sort of a yayish thing to say)'
# player.scent = "You gradually feel more energized, content and comforted. Things seem right with the world."
# player.sound = "You hear a profound silence, in the same way that you listen to the silence at the end of a drumming performance, and appreciate this very Zen experience."
# player.taste = "You taste what seems to be [wrand(tastes())]."
# # player.touch = "Neither words nor actions can articulate what is felt at the heart of it all."
# # player.Otouch = 'touched Morty.'
# # player.Atouch = 'thi %n touched me'
# # player.Functions = '#44140 #69 #61865 #200 #26066 #57679 #71748 #11788 #67 #4303 #44859 #68 #4040 #78157'
# # player.XH = ['Desc', "I'm tired of being god... *sigh*"]
# # player.XQ = ['1000p', 'herb-master']
# # player.XZ = ['tastes', 'strawberry_icing_sugar the_heart_of_a_Lindt_Lindor_that_is_melting_on_the_skin_of_a_lover sweet_apple_crumble,_fresh_from_the_oven']
# # player.VA = 'Infobation (v): mental masturbation, with information as the stimulant... Like a university teacher that feels pleasure at being more knowledgable about things than others, or the newbie hacker that gets off on breaking into a datastore'
# # player.Hspeech = 'Sitting comfortably on Morty,'
# # player.haven = "I'm hiding! Can't find me!"
# player.details = "Subtitle of the description?"
# player.homeRoom = jazzLounge.uuid
# player.save
# player.room = jazzLounge

# # # WITH count(*) as dummy

# table = Thing.new
# table.name = "Table"
# table.desc = "A large balsawood table. Do not place items on the table. It weighs 5 grams."
# table.save
# table.room = jazzLounge

# burritos = Thing.new
# burritos.name = "Burritos"
# burritos.desc = "a soft-shelled taco, but in a cylander. It tastes good"
# burritos.save
# burritos.room = jazzLounge

# tacos = Thing.new
# tacos.name = "Tacos"
# tacos.desc = "cook some meat, you add in some lettuce, LOTS of sour cream (LOTS and LOTS and LOTS and LOTS. You add in some tomatoes, some meat. You take a shell and then you put everything in it. Yipee! It tastes good!"
# tacos.save
# tacos.room = jazzLounge

# gingerale = Thing.new
# gingerale.name = "Gingerale"
# gingerale.desc = "Fizzy. Tastes good. I drink it 24/7"
# gingerale.save
# gingerale.room = jazzLounge

# emojis = Thing.new
# emojis.name = "Emojis"
# emojis.desc = "👀"
# emojis.save
# emojis.room = jazzLounge

# popcicle = Thing.new
# popcicle.name = "Mint Icecream Popcicle"
# popcicle.desc = ""
# popcicle.save
# popcicle.room = jazzLounge

# kittens = Thing.new
# kittens.name = "kittens"
# kittens.desc = "fuzzy fluffy kittens playing on the floor"
# kittens.save
# kittens.room = jazzLounge

# spaghetti = Thing.new
# spaghetti.name = "Spaghetti and Meatballs"
# spaghetti.desc = "tastes like meat and deadness"
# spaghetti.save
# spaghetti.room = jazzLounge


# rainbow = Thing.new
# rainbow.name = "Rainbow"
# rainbow.desc = "A floating thing in the sky with colours"
# rainbow.save
# rainbow.room = jazzLounge

# ketchup = Thing.new
# ketchup.name = "ketchup"
# ketchup.desc = ""
# ketchup.save
# ketchup.room = jazzLounge

# # # WITH count(*) as dummy

# # MATCH (a)
# # WHERE a.name = 'morty'
# # CREATE p =(a)-[:HOLDING]->(n:Thing {name:"Wand", desc:"A thin stick, slightly warped from use."})
# # # //RETURN p

# wand = Thing.new
# wand.name = "Wand"
# wand.desc = "A thin stick, slightly warped from use."
# player.held << wand

# MATCH (a)
# WHERE a.name = 'Jazz Lounge'
# CREATE p = (a)-[:CONTAINS]->(n:Door {name:"Out", aliases:["o"], desc:"the way out"})-[:DOOR_TO]->(d:Room {name:"North side of town", desc:"You look out in the direction of the horizon, but all you see is gleaming buildings."})-[:CONTAINS]->(n2:Door {name:"Jazz Club", aliases:["jazz", "club"], desc:"The door to the Jazz Club"})-[:DOOR_TO]->(a)
# # //RETURN p

# WITH count(*) as dummy

# # // Jazz lounge is contained by the North Side of Town, which is contained in New Orleans, with is contained in Louisiana < United States < North America < Earth < Solar system < Galactic Cluster < Universe
# MATCH (a)
# WHERE a.name = 'North side of town'
# MERGE (q:Room {name:"Universe", desc:"This is the Universe. It's big. Get over it."})-[:CONTAINS]->(db:Door {name:"Earth's Local Galactic Group", aliases:["galactic", "zoom", "narrow", "local group"], desc: ""})-[:DOOR_TO]->(o:Room {name:"Earth's Local Galactic Group", desc:""})-[:CONTAINS]->(da:Door {name:"Milky Way Galaxy", aliases:["galaxy", "zoom", "narrow"], desc: ""})-[:DOOR_TO]->(n:Room {name:"Milky Way Galaxy", desc:""})-[:CONTAINS]->(dc:Door {name:"Earth's Local Solar System", aliases:["solar system", "solar", "earth", "zoom", "narrow"], desc: ""})-[:DOOR_TO]->(m:Room {name:"Earth's Local Solar system", desc:""})-[:CONTAINS]->(dd:Door {name:"Earth", aliases:["narrow"], desc: ""})-[:DOOR_TO]->(l:Room {name:"Earth", desc:""})-[:CONTAINS]->(de:Door {name:"North America", aliases:["NA"], desc: ""})-[:DOOR_TO]->(k:Room {name:"North America", desc:""})-[:CONTAINS]->(df:Door {name:"United States", aliases:["USA"], desc: ""})-[:DOOR_TO]->(d:Room {name:"United States", desc:""})-[:CONTAINS]->(dg:Door {name:"Louisiana", aliases:[], desc: ""})-[:DOOR_TO]->(e:Room {name:"Louisiana", desc:""})-[:CONTAINS]->(dh:Door {name:"New Orleans", aliases:[], desc: ""})-[:DOOR_TO]->(f:Room {name:"New Orleans", desc:"The city of New Orleans"})-[:CONTAINS]->(di:Door {name:"The North side of town", aliases:["north side", "north"], desc: ""})-[:DOOR_TO]->(a)
# MERGE (a)-[:CONTAINS]->(oa:Door {name:"Out", aliases:["Broaden"], desc: ""})-[:DOOR_TO]->(f)-[:CONTAINS]->(ob:Door {name:"Out", aliases:["Broaden"], desc: ""})-[:DOOR_TO]->(e)-[:CONTAINS]->(oc:Door {name:"Out", aliases:["Broaden"], desc: ""})-[:DOOR_TO]->(d)-[:CONTAINS]->(od:Door {name:"Out", aliases:["Broaden"], desc: ""})-[:DOOR_TO]->(k)-[:CONTAINS]->(oe:Door {name:"Out", aliases:["Broaden"], desc: ""})-[:DOOR_TO]->(l)-[:CONTAINS]->(of:Door {name:"Out", aliases:["Broaden"], desc: ""})-[:DOOR_TO]->(m)-[:CONTAINS]->(og:Door {name:"Out", aliases:["Broaden"], desc: ""})-[:DOOR_TO]->(n)-[:CONTAINS]->(oh:Door {name:"Out", aliases:["Broaden"], desc: ""})-[:DOOR_TO]->(o)-[:CONTAINS]->(oi:Door {name:"Out", aliases:["Broaden"], desc: ""})-[:DOOR_TO]->(q)
# # // (:Door {name:"", aliases:[], desc: ""})-[:DOOR_TO]->(:Room {name:"", desc: ""})-[:CONTAINS]->(:Door {name:"", aliases:[], desc: ""})-[:DOOR_TO]->(:Room)
# # // -[:CONTAINS]->(:Door {name:"", aliases:[], desc: ""})-[:DOOR_TO]->
# WITH count(*) as dummy

# MATCH (a), (b)
# WHERE a.name = 'Jazz Lounge' AND b.name = 'morty'
# CREATE UNIQUE (a)-[r:CONTAINS]->(b)
# # //RETURN r
# WITH count(*) as dummy



# WITH count(*) as dummy





# MATCH (n { name: 'morty' })


# SET n.Ofail = 'trys to take Morty.. They want me /that/ bad.'
# SET n.Okill = 'HaH HaH HaH! I am god! You think you can kill me????.... Hey... no fair...'
# SET n.Ause = 'thi [v(n)] tried to use me'
# SET n.Ahear = 'thi v[n] listened to me!'
# SET n.Alias = 'friend'
# SET n.use = 'There is no socially acceptable way to use that.'
# SET n.Ouse = 'tried to use Morty'
# //SET n.Aconnect = '_fpage_ :quietly stirs and wakens;friends;thi Was on: [get(*cauli/last)];thi Is now: [time()].;thi Cauli has been idle for [idle(*cauli)]seconds.;thi Cauli is at '[namelist(loc(*cauli))]' ([loc(*cauli)]).;thi Dont forget to set the schedule for #88264: xe-xm!'
# SET n.listen2 = '*poke*Morty*'
# SET n.Ahear2 = ':hath been poked and emits a customary "Eek!"'
# SET n.listen4 = '*foof*'
# SET n.Ahear4 = '"Woohoo! (It is sort of a yayish thing to say)'
# SET n.scent = "You bring your nose close to Morty's body and inhale deeply. The light scents of a cool breeze on a warm summer night in New Orleans, a salivating hand made home-baked meal finishing on the stove, a lightning strike in a light drizzle, unspoiled forest earth, and a subtle variety of herbs permeate your being. You gradually feel more energized, content and comforted. Things seem right with the world."
# SET n.sound = "You hear a profound silence, in the same way that you listen to the silence at the end of a Taiko drumming performance, and appreciate this very Zen experience."
# SET n.taste = "You take a big lick somewhere on my body (I will let you decide where), and taste what seems to be [wrand(tastes())]."
# SET n.touch = "You feel the depths of my soul as though I had the power to let you in. Neither words nor actions can articulate what is felt at the heart of it all."
# SET n.Otouch = 'touched Morty.'
# SET n.Atouch = 'thi %n touched me'
# SET n.Functions = '#44140 #69 #61865 #200 #26066 #57679 #71748 #11788 #67 #4303 #44859 #68 #4040 #78157'
# SET n.XA = ['oldfriend', '(Melanie) Alisa Alissa Anna* Apollana April Arizhel Aural Badger Barbi Black_Panther Brianna Caribou Cauliflower Claudia Constructor Cynalia Darkman DeadPoet Dega Eddie_J EnSoniq Eternal Fireball Fredd Garth GlaCieR Guilty Isabella Jadey Jevan']
# SET n.XH = ['Desc', "I'm tired of being god... *sigh*"]
# SET n.XQ = ['1000p', 'herb-master']
# SET n.XX = ['Keys', 'Admin Key: #70392. Friend Key: #70153. Guest Key: 70262.']
# SET n.XZ = ['tastes', 'strawberry_icing_sugar the_heart_of_a_Lindt_Lindor_that_is_melting_on_the_skin_of_a_lover sweet_apple_crumble,_fresh_from_the_oven']
# SET n.VA = 'Infobation (v): mental masturbation, with information as the stimulant... Like a university teacher that feels pleasure at being more knowledgable about things than others, or the newbie hacker that gets off on breaking into a datastore'
# SET n.Hspeech = 'Sitting comfortably on Morty,'
# SET n.haven = "I'm hiding! Can't find me!"
# SET n.details = "Friend (n); One who can be trusted and is attached to another by affection or esteem"

# //RETURN n
# WITH count(*) as dummy

# MATCH (n) RETURN n LIMIT 100


# // Create a door out of the jazz lounge
# // CREATE (n {name:"North", aliases:["n","north"], desc:"the way out"})
# // RETURN n

# // Create the door link
# // MATCH (a),(b)
# // WHERE a.name = 'North' AND b.name = 'Jazz Lounge'
# // CREATE (b)-[r:CONTAINS]->(a)
# // RETURN r

# // Create the doorway room
# //CREATE (n {name:"doorway", desc:"just for coding purposes"}) RETURN n

# //MATCH (a),(b),(c)
# //WHERE a.name = 'North' AND b.name = 'South' AND c.name = 'doorway'
# //CREATE (b)-[r:CONNECTED]->(c)<-[r2:CONNECTED]-(a)
# //RETURN r, r2

end
