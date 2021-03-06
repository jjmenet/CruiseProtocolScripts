#function adventureoutdoors
  execute("locations")
  execute("passages")
  execute("adventureevents")
  execute("regions")
  execute("passageshelper")

  function enterlocation(location)
    addvisitedlocation(location)
    player.location = location
    depictcurrentlocation()
    playercommand(locationcommand, player)
  end

  function addknownlocation(location)
    if LocationsList[location] then
      KnownLocationsList[location] = true
    else
      printl("●● DEBUG: location은 LocationList에 존재하는 key여야 합니다. 형식은 string입니다. addknownlocation에 입력된 값: " .. location)
    end
  end

  function addvisitedlocation(location)
    if LocationsList[location] then
      VisitedLocationsList[location] = true
    else
      printl("●● DEBUG: location은 LocationList에 존재하는 key여야 합니다. 형식은 string입니다. addvisitedlocation에 입력된 값: " .. location)
    end
  end

  function depictcurrentlocation()
    local location = player.location
    printplace(LocationsList[location].Name)
  end

  function checkvisitedneighbors(location)
    --[[
    for neighbor, _ in pairs(LocationsList[location].RouteTo) do
      if VisitedLocationsList[neighbor] then return true end
    end
    return false
    ]]--
    return true -- must implement algorithm to make neighbor dynamically <- is this possible?
  end

  function startgamebyenteringinitialposition(location)
    runadventureloop("initial", location)
  end

  function runadventureloop(initial, ...)
    local args = {n=select('#',...),...}
    local commands = {}
    enterlocation(args[1])
    commands.move = "arrival"
    while(true) do
      commands = playercommand(departurecommand, player)
      if commands.move == "arrival" then
      elseif commands.move == "enter" then
        enterlocation(player.location)
      elseif commands.move == "journey" then
        local startpoint = player.location
        local journey = getjourney(player, startpoint, commands.destination, player.journeypreference)
        local journeyresult = runjourneyloop(journey)
        enterlocation(journeyresult.endpoint)
      elseif commands.move == "gameend" then
        printl ("게임을 종료합니다.")
        break
      end
    end
  end

  function runjourneyloop(journey)
    local journeyresult = {}
    local journeyeddistance = 0
    journeyresult.endpoint = journey.endpoint
    local turn = 1
    local favortable = buildjourneyfavortable(journey)
    for turn = 1, journey.maxturns do
      local turnchoice = {}
      if (not player.journeypreference.autocommand) then
        turnchoice = playercommand(journeycommand, player, journey)
      else
        turnchoice.choice = "usual"
        turnchoice.choicestring = "자동 이동"
      end
      printl("/fK/bw□■□■□■□■□■□■□ " .. turn .. " 턴: " .. turnchoice.choicestring .. "□■□■□■□■□■□■□/x")
      local turntable = buildturntable(favortable, turnchoice, journey)
      local turnevent = pickrandomresult(favortable)
      favortable[turnevent] = favortable[turnevent] - 1
      local result = journeyfunctions[turnevent](journey)
      if result and result.abort then
        journeyresult.endpoint = result.endpoint
        break
      end
      journeyeddistance = journeyeddistance + turntable.journeyeddistance
      printl("진행도: " .. journeyeddistance .. "/" .. journey.distance)
      if journeyeddistance >= journey.distance then
        printl("목적지에 도착했습니다!")
        break
      end
    end
    return journeyresult
  end

  function buildjourneyfavortable(journey)
    local favortable = {}
    local e = journey.events
    table.insert(favortable, e.nothing)
    table.insert(favortable, e.lootable)
    table.insert(favortable, e.enemyencounter)
    table.insert(favortable, e.npcencounter)
    table.insert(favortable, e.randomevent)
    table.insert(favortable, e.discover)
    return favortable
  end

  function buildturntable(basefabortable, turnchoice, journey)
    local turntable = {}
    turntable.journeyeddistance = math.floor(journey.playerreach * (1 + math.random(1, 10)/100))
    local choice = turnchoice.choice
    for i, v in ipairs(basefabortable) do
      turntable[i] = v
    end
    if choice == "usual" then
      turntable[3] = math.ceil(1.5 * turntable[3])
      turntable[4] = 2 * turntable[4]
    elseif choice == "loot" then
      turntable[2] = 2 * turntable[2]
      turntable.journeyeddistance = math.floor(turntable.journeyeddistance * (0.5 + math.random(1, 10)/100))
    elseif choice == "alert" then
      turntable[3] = math.ceil(0.5 * turntable[3])
      turntable.journeyeddistance = math.floor(turntable.journeyeddistance * (0.5 + math.random(1, 10)/100))
    elseif choice == "explore" then
      turntable[5] = 2 * turntable[5]
      turntable[6] = 2 * turntable[6]
    elseif choice == "hurry" then
      turntable[3] = 2 * turntable[3]
      turntable.journeyeddistance = 2 * turntable.journeyeddistance
    end
    return turntable
  end

  function makejourneylist()
    local journeylist = {}
    local additionallist = {}
    local journeyliststring = ""
    local location = player.location
    local counter = 1
    for k, v in pairs(KnownLocationsList) do
      if not VisitedLocationsList[k] then
        table.insert(journeylist, tostring(counter))
        table.insert(additionallist, k)
        journeyliststring = journeyliststring .. "[" .. tostring(counter) .. "] " .. LocationsList[k].Name .. " "
        counter = counter + 1
      end
    end
    printl(journeyliststring)
    table.insert(journeylist, "-1")
    printl("[-1] 대기(취소)")
    return journeylist, additionallist
  end

  locationcommand = {}
  locationcommand.references = {"player"}
  locationcommand.returns = {"move"}
  locationcommand.commands = {}
  locationcommand.resetpositiononinitial = false

  function locationcommand:initial()
    self.commands.move = "departure"

    local locationcommandtable = buildlocationtable(self.references.player)
    local playercommand = getplayerchoice("무엇을 하시겠습니까?", locationcommandtable)
    if (playercommand == "departure") then
      return "terminal"
    elseif (playercommand == "menu") then
      return "initial"
    else
      meetnpc(playercommand)
      return "initial"
    end
  end

  function buildlocationtable(player)
    local commandtable = {}
    local p = player
    local l = player.location
    local count = 1
    if LocationsList[l].Npcs then
      for _, v in pairs(LocationsList[l].Npcs) do
        local desc = LocationNpcsList[v].CommandToMeet[world.NPC[v].state]
        table.insert(commandtable, {Number = count, Key = v, Description = desc})
        count = count + 1
      end
    end
    table.insert(commandtable, {Number = nil, Key = "newline"})
    table.insert(commandtable, {Number = -1, Key = "departure", Description = "장소 떠나기"})
    table.insert(commandtable, {Number = -9, Key = "menu", Description = "메뉴 열기"})
    return commandtable
  end

  departurecommand = {}
  departurecommand.references = {"player"}
  departurecommand.returns = {"move", "destination"}
  departurecommand.commands = {}
  departurecommand.resetpositiononinitial = false

  function departurecommand:initial()
    self.commands.move = "standstill"
    self.commands.destination = ""

    local departurechoicetable = {
      {Number = 0, Key = "look", Description = "살펴보기"},
      {Number = 1, Key = "enter", Description = "현재 지역으로 진입"},
      {Number = 2, Key = "journey", Description = "여정"},
      {Number = 3, Key = "direct", Description = "빠른 이동"},
      {Number = 4, Key = "patrol", Description = "순찰"},
      {Number = nil, Key = "newline"},
      {Number = 99, Key = "gameend", Description = "게임 종료"},
    }

    local playercommand = getplayerchoice("무엇을 하시겠습니까?", departurechoicetable)
    --local movelist = makemovelistinlocation()
    --local playercommand = ask("무엇을 하시겠습니까?", table.unpack(movelist))
    if (playercommand == "look") then
      printl(LocationsList[self.references.player.location].Description)
      return "initial"
    elseif (playercommand == "enter") then
      return "enter"
    elseif (playercommand == "journey") then
      return "journey"
    elseif (playercommand == "direct") then
      return "direct" -- NEED IMPLEMENTATION
    elseif (playercommand == "patrol") then
      return "patrol" -- NEED IMPLEMENTATION
    elseif (playercommand == "gameend") then
      self.commands.move = "gameend"
      return "terminal"
    end
  end

  function departurecommand:enter()
    local ans = ask(LocationsList[self.references.player.location].Name .. "(으)로 들어갑니까? [0] 예 [1] 아니오", "0", "1")
    if (ans == "0") then
      self.commands.move = "enter"
      printl(LocationsList[self.references.player.location].Name .. "(으)로 진입합니다.")
      return "terminal"
    else
      return "initial"
    end
  end

  function departurecommand:journey()
    addknownlocation("MongchontoseongStation") -- DEBUG
    addknownlocation("JamsilHighschool") -- DEBUG
    local journeylist, additionallist = makejourneylist()
    local playercommand = ask("어디를 향하시겠습니까?", table.unpack(journeylist))
    if (playercommand == "-1") then
      return "initial"
    else
      self.commands.move = "journey"
      self.commands.destination = additionallist[tonumber(playercommand)]
      printl(LocationsList[self.commands.destination].Name .. "(으)로 떠납니다.")
      return "terminal"
    end
  end

  function departurecommand:direct()
    return "terminal"
  end

  function departurecommand:patrol()
    return "terminal"
  end

  journeycommand = {}
  journeycommand.references = {"player", "journey"}
  journeycommand.returns = {"choice", "choicestring", "jct", "jd"}
  journeycommand.commands = {}
  journeycommand.resetpositiononinitial = false

  function journeycommand:initial()
    self.commands.jct, self.commands.jd = buildjourneycommandtable(self.references.player)

    self.commands.choice = getplayerchoice("어떻게 이동하시겠습니까?", self.commands.jct)
    self.commands.choicestring = self.commands.jd[self.commands.choice]
    if (self.commands.choice == "guide") then
      return "guide"
    elseif (self.references.player.journeypreference.confirm) then
      return "confirm"
    else
      return "terminal"
    end
  end

  function journeycommand:guide()
    local guidetext = "| 설명"
    for _, v in ipairs(self.commands.jct) do
      if v.Guide then
        guidetext = guidetext .. "\n| [" .. v.Number .. "] " .. v.Description .. " - " .. v.Guide
      end
    end
    printlw(guidetext)
    return "initial"
  end

  function journeycommand:confirm()
    local ans = ask("계속 진행합니까? [0] 예 [1] 아니오", "0", "1")
    if (ans == "0") then
      return "terminal"
    else
      return "initial"
    end
  end

  function buildjourneycommandtable(player)
    local commandtable = {}
    local commanddict = {}
    local skills = PlayerSkillHelper.GetUnlockedSkillsByTag("JourneyType")
    for _, v in ipairs(skills) do
      local jt = PlayerSkillList[v].JourneyType
      commandtable[jt.DesignatedNo] = {Number = jt.DesignatedNo, Key = jt.Key, Description = jt.Desc, Guide = jt.Guide}
      commanddict[jt.Key] = jt.Desc
    end
    table.insert(commandtable, {Number = nil, Key = "newline"})
    table.insert(commandtable, {Number = 99, Key = "guide", Description = "설명"})
    return commandtable, commanddict
  end
#end