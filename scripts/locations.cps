#function locations
  
  execute("locationnpcs")

  LocationsList = {}
  KnownLocationsList = {}
  VisitedLocationsList = {}

  LocationsList["CheonhoMarket"] = {
    Name = "천호시장",
    Type = "Town",
    Coordinate = {37.540992, 127.127802}
  }

  LocationsList["CheonhoStation"] = {
    Name = "천호역",
    Description = [[높고 낮은 건물과 지하차도가 복잡히 얽힌 사거리이다.
    기둥으로 판단하면, 두 개 지하철 노선이 마주치는 '천호' 역이 지하에 있는 듯하다.
    이 살벌한 지상도 지하보다는 안전한 곳이리라.]],
    Type = "Metro",
    MetroType = "Underground",
    Coordinate = {37.538629, 127.123432}
  }

  LocationsList["GangdonggucheongStation"] = {
    Name = "강동구청역",
    Description = [[사람의 기척도 없이 낡아 해진 교차로의 이곳 저곳에 검은 사각형 기둥이 박혀 있다.
    '강동구청' 이라는 이름의 역이 여기 있었던 것 같다.
    바위와 가로수로 얼기설기 막아둔 입구 저 편은 악마들이 우글우글 하겠지.]],
    Type = "Metro",
    MetroType = "Underground",
    Coordinate = {37.530710, 127.120628}
  }

  LocationsList["MongchontoseongStation"] = {
    Name = "몽촌토성역",
    Type = "Metro",
    MetroType = "Underground",
    Coordinate = {37.517529, 127.112733}
  }

  LocationsList["JamsilHighschool"] = {
    Name = "잠실고등학교",
    Type = "School",
    Coordinate = {37.522652, 127.106187}
  }

  RegisterNpcsToLocations()
#end

#function passages
  PassagesList = {}

  PassagesList["RoadToArena"] = {
    Name = "경기장으로 가는 길",
    Locations = {"CheonhoStation", "MongchontoseongStation"}
  }
#end

#function regions
  RegionsList = {}

  RegionsList["CommonOutside"] = {

  }

  for k, _ in pairs(LocationsList) do
    if not LocationsList[k].IsInside then
      if not LocationsList[k].IsInRegion then LocationsList[k].IsInRegion = {} end
      table.insert(LocationsList[k].IsInRegion, "CommonOutside")
    end 
  end
  
#end

#function passageshelper
  for k, _ in pairs(PassagesList) do
    for _, v in ipairs(PassagesList[k].Locations) do
      if LocationsList[v] then
        if not LocationsList[v].IsInPassage then LocationsList[v].IsInPassage = {} end
        table.insert(LocationsList[v].IsInPassage, k)
      else
        printl("●● DEBUG: PassageList 항목의 Locations table의 값은 LocationList에 존재하는 key여야 합니다. 형식은 string입니다. 입력된 값: " .. v)
      end
    end
  end

  function calculatedistanceinmeter(coor1, coor2)
    if (type(coor1) ~= "table") or (type(coor2) ~= "table") then
      printl("●● DEBUG: calculatedistanceinmeter 함수의 인자로 table이 아닌 값이 입력되었습니다. 입력된 값: " .. coor1 .. ", " .. coor2)
      return -1
    elseif (type(coor1[1]) ~= "number") or (type(coor1[2]) ~= "number") or (type(coor2[1]) ~= "number") or (type(coor2[2]) ~= "number") then
      printl("●● DEBUG: calculatedistanceinmeter 함수의 인자 table에 number가 아닌 값이 입력되었습니다. 입력된 값: " .. coor1[1] .. ", " .. coor1[2] .. ", " .. coor2[1] .. ", " .. coor2[2])
      return -1
    end

    --http://stackoverflow.com/questions/639695/how-to-convert-latitude-or-longitude-to-meters
    local radius = 6378.137
    local d2r = math.pi / 180
    local sdLat = math.sin((coor2[1] - coor1[1]) * d2r / 2)
    local sdLon = math.sin((coor2[2] - coor1[2]) * d2r / 2)
    local a = sdLat * sdLat + math.cos(coor1[1] * d2r) * math.cos(coor2[1] * d2r) * sdLon * sdLon
    return math.ceil(2 * math.atan(math.sqrt(a)/math.sqrt(1-a)) * radius * 1000)
  end

  function makestrayablepolygon(startpoint, endpoint, type, astray)
    --startpoint \isin LocationsList, endpoint \isin LocationsList.
    --astray \isin [0, 1].
    --return value is a table with three or four coordinates. must be counter-clockwise order.
    --(type == 3) implies return value must be a triangle, in which first entry is startpoint's coordinate.
    --(type == 4) implies return value must be a diamond, in which first entry is startpoint's coordinate, third entry is endpoint's coordinate.
    --(type is neither 3 nor 4) just act as type == 3.

    local coordinates = {}
    coordinates[1] = {startpoint.Coordinate[1], startpoint.Coordinate[2]}
    local vector = {(startpoint.Coordinate[2] - endpoint.Coordinate[2])*astray/2, (endpoint.Coordinate[1] - startpoint.Coordinate[1])*astray/2}
    
    if (type == 4) then
      vector = {vector[1] / 2, vector[2] / 2}
      coordinates[3] = endpoint.Coordinate
      local midpoint = {(coordinates[1][1] + coordinates[3][1])/2, (coordinates[1][2] + coordinates[3][2])/2}
      coordinates[2] = {midpoint[1] + vector[1], midpoint[2] + vector[2]}
      coordinates[4] = {midpoint[1] - vector[1], midpoint[2] - vector[2]}
    else
      coordinates[2] = {endpoint.Coordinate[1] + vector[1], endpoint.Coordinate[2] + vector[2]}
      coordinates[3] = {endpoint.Coordinate[1] - vector[1], endpoint.Coordinate[2] - vector[2]}
    end
    return coordinates
  end

  function checklocationisinpolygon(location, polygon)
    --location must be a string, which is a key of LocationsList
    --polygon must be a return value of makestrayablepolygon
    --return value is true iff location coordinate is in the polygon

    local coordinate = LocationsList[location].Coordinate
    local length = #polygon
    polygon[length+1] = polygon[1]
    local edgeccw --vectors for polygon edges counter clockwise pi/4, to check the location is in the left side of the edges
    local vector
    local epsilon = 0.00000001
    for i=1,length do
      edgeccw = {polygon[i+1][2] - polygon[i][2], polygon[i][1] - polygon[i+1][1]}
      vector = {coordinate[1] - polygon[i][1], coordinate[2] - polygon[i][2]}
      if (edgeccw[1] * vector[1] + edgeccw[2] * vector[2] < 0) then
        return false
      end
    end
    return true
  end

  function strayablelocations(polygon, excludes, ifpassvisited)
    --polygon must be a return value of makestrayablepolygon
    --excludes must be a k-v pair of string-bool, which keys are of LocationsList. we do not check excludes location.(i.e., start or end point)
    --return value is a k-v pair of string-bool, which keys are of LocationsList.
    --if ifpassvisited is true, pass visited location(return value does not contains visited locations).

    local locations = {}
    for k, _ in pairs(LocationsList) do
      if (ifpassvisible and VisitedLocationsList[k]) then
      elseif (excludes[k]) then
      else
        local shallowpolygon = shallowcopy(polygon)
        if (checklocationisinpolygon(k, shallowpolygon)) then
          locations[k] = true
        end
      end
    end

    return locations
  end

  journeyfunctions = {}
  function journeyfunctions.nothing(journey)
    printl ("아무 일도 일어나지 않음")
  end
  function journeyfunctions.lootable(journey)
    printl ("아이템 획득 기회")
    AdventureEventHelper.EventHandler["Loot"](AdventureEventHelper.PickRandomEvent(AdventureEventHelper.GetEventsByTag("Loot")))
  end
  function journeyfunctions.enemyencounter(journey)
    printlw ("적과 마주쳤다!")
    AdventureEventHelper.EventHandler["EnemyEncounter"](AdventureEventHelper.PickRandomEvent(AdventureEventHelper.GetEventsByTag("EnemyEncounter")))
  end
  function journeyfunctions.npcencounter(journey)
    printl ("비적대 상대 조우")
  end
  function journeyfunctions.randomencounter(journey)
    printl ("랜덤 이벤트")
  end
  function journeyfunctions.discover(journey)
    printl ("장소 발견")
  end

  journeyfunctions[1] = journeyfunctions.nothing
  journeyfunctions[2] = journeyfunctions.lootable
  journeyfunctions[3] = journeyfunctions.enemyencounter
  journeyfunctions[4] = journeyfunctions.npcencounter
  journeyfunctions[5] = journeyfunctions.randomencounter
  journeyfunctions[6] = journeyfunctions.discover


  function getjourney(player, startpoint, endpoint, preference)
    --player is global player.
    --startpoint and endpoint must be strings, which are keys of LocationsList
    local journey = {}
    journey.startpoint = startpoint
    journey.endpoint = endpoint
    journey.distance = calculatedistanceinmeter(LocationsList[startpoint].Coordinate, LocationsList[endpoint].Coordinate)
    journey.playerreach = player.journeydistance
    journey.turns = math.ceil(journey.distance / journey.playerreach)
    journey.maxturns = preference.maxturns * journey.turns
    journey.events = {}
    journey.events.nothing = preference.nothing * journey.turns
    journey.events.lootable = preference.lootable * journey.turns
    journey.events.enemyencounter = preference.enemyencounter * journey.turns
    journey.events.npcencounter = preference.npcencounter * journey.turns
    journey.events.randomevent = preference.randomevent * journey.turns
    journey.events.discover = preference.discover * journey.turns
    journey.events.discoverablelocations = {}
    local polygon = makestrayablepolygon(LocationsList[startpoint], LocationsList[endpoint], 4, 1)
    local excludeset = {}
    excludeset[startpoint] = true
    excludeset[endpoint] = true
    local strayable = strayablelocations(polygon, excludeset, true)
    printl(LocationsList[startpoint].Name .. "에서 " .. LocationsList[endpoint].Name .. "까지 이동합니다. 턴 수: " .. journey.turns)
    if not next(strayable) then
      printl("접근 가능한 지역은 없습니다.")
    else
      for k, _ in pairs(strayable) do
        journey.events.discoverablelocations[k] = {}
        journey.events.discoverablelocations[k].minturns = math.floor(calculatedistanceinmeter(LocationsList[startpoint].Coordinate, LocationsList[k].Coordinate) / journey.playerreach)
        if (journey.events.discoverablelocations[k].minturns >= journey.turns) then
          journey.events.discoverablelocations[k].minturns = journey.turns - 1
        end
        printl(LocationsList[k].Name .. "에 접근이 가능합니다. 최소 턴 수: " .. journey.events.discoverablelocations[k].minturns) -- DEBUG: implement strayable check
      end
    end
    return journey
  end
#end