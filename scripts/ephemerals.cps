#function ephemerallist

  ephemerallist = {}

  ephemerallist["burn"] = {}
  ephemerallist["burn"][1] = {
    name = "화상",
    display = "/bR/fY火/x",
    dlength = 2,
    description = "매 턴 최대 체력의 5% 화염 피해",
    compactdescription = "매턴화염피해",
    acquireMessage = function(char)
      return char.name .. "의 몸을 화염이 덮친다!"
    end,
    diminishMessage = function(char)
      return char.name .. "의 화상이 사라졌다!"
    end,
    atcountturn = function(char, battle)
      message = message .. "\n화상의 피해가 " .. char.name .. "(을)를 덮친다!"
      inflictdamage(nil, SkillList["SystemBurnDamage"], char, battle, nil)
    end
  }
  ephemerallist["burn"][-1] = {
    display = "/bR/fY火無/x",
    dlength = 4
  }

  ephemerallist["frozen"] = {}
  ephemerallist["frozen"][1] = {
    name = "동상",
    display = "/bB/fW凍/x",
    dlength = 2,
    description = "물리방어력 6단계 감소, 입는 타격 피해 증가",
    compactdescription = "물리취약",
    acquireMessage = function(char)
      return char.name .. "의 몸 곳곳이 얼어붙는다!"
    end,
    diminishMessage = function(char)
      return char.name .. "의 동상이 사라졌다!"
    end
  }
  ephemerallist["frozen"][-1] = {
    display = "/bB/fW凍無/x",
    dlength = 4
  }

  ephemerallist["sleep"] = {}
  ephemerallist["sleep"][1] = {
    name = "졸음",
    display = "/bG/fBzZ/x",
    dlength = 2,
    description = "행동 불가, 피해 입을 시 회복",
    compactdescription = "행동불가",
    acquireMessage = function(char)
      return char.name .. "의 의식이 멀어진다…."
    end,
    diminishMessage = function(char)
      return char.name .. "(은)는 졸음에서 깨어났다!"
    end,
    atcheckcontrollable = function(char, battle)
      message = message .. "\n" .. char.name .. "(은)는 졸고 있다…."
      return false
    end
  }
  ephemerallist["sleep"][-1] = {
    display = "/bG/fBzZ無/x",
    dlength = 4
  }  

  ephemerallist["paralyzed"] = {}
  ephemerallist["paralyzed"][1] = {
    name = "마비",
    display = "/bY/fw痲/x",
    dlength = 2,
    description = "30% 확률로 행동 불가",
    compactdescription = "확률적 행동불가",
    acquireMessage = function(char)
      return char.name .. "의 몸 곳곳이 뻣뻣해진다!"
    end,
    diminishMessage = function(char)
      return char.name .. "의 마비가 풀렸다!"
    end,
    atcheckcontrollable = function(char, battle)
      if math.random(10) <= 3 then
        message = message .. "\n" .. char.name .. "(이)가 예상치 못하게 몸이 저려온다!"
        return false
      else
        message = message .. "\n" .. char.name .. "(은)는 간신히 몸을 가누었다!"
        return true
      end
    end
  }
  ephemerallist["paralyzed"][-1] = {
    display = "/bY/fw痲無/x",
    dlength = 4
  }  

  ephemerallist["stoned"] = {}
  ephemerallist["stoned"][1] = {
    name = "석화",
    display = "/bM/fY石/x",
    dlength = 2,
    description = "물리속도 6단계 감소, 입는 타격 피해 증가",
    compactdescription = "물리속도감소",
    acquireMessage = function(char)
      return char.name .. "의 몸 일부분이 굳는다!"
    end,
    diminishMessage = function(char)
      return char.name .. "(이)가 석화에서 자유로워졌다!"
    end
  }
  ephemerallist["stoned"][-1] = {
    display = "/bM/fY石無/x",
    dlength = 4
  }  

  ephemerallist["blind"] = {}
  ephemerallist["blind"][1] = {
    name = "실명",
    display = "/bw/fk盲/x",
    dlength = 2,
    description = "명증률 6단계 감소",
    compactdescription = "명중률감소",
    acquireMessage = function(char)
      return char.name .. "의 눈 앞이 깜깜해진다!"
    end,
    diminishMessage = function(char)
      return char.name .. "의 실명이 나았다!"
    end
  }
  ephemerallist["blind"][-1] = {
    display = "/bw/fk盲無/x",
    dlength = 4
  }  

  ephemerallist["cursed"] = {}
  ephemerallist["cursed"][1] = {
    name = "저주",
    display = "/bk/fw呪/x",
    dlength = 2,
    description = "매 턴 최대 체력의 10% 암흑 피해",
    compactdescription = "매턴암흑피해",
    acquireMessage = function(char)
      return char.name .. "(은)는 저주받았다!"
    end,
    diminishMessage = function(char)
      return char.name .. "의 저주가 풀렸다!"
    end,
    atcountturn = function(char, battle)
      message = message .. "\n저주가 " .. char.name .. "(을)를 덮친다!"
      inflictdamage(nil, SkillList["SystemCurseDamage"], char, battle, nil)
    end
  }
  ephemerallist["cursed"][-1] = {
    display = "/bk/fw呪無/x",
    dlength = 4
  }  

  ephemerallist["manadepletion"] = {}
  ephemerallist["manadepletion"][1] = {
    name = "마나 고갈",
    display = "/bk/fR魔/x",
    dlength = 2,
    description = "마나 자원 기술 사용 불가능",
    compactdescription = "마나기술봉인",
    diminishMessage = function(char)
      return char.name .. "의 주변에 다시 마나가 감돈다!"
    end
  }

  function ephemeraldisplaywithrank(string, rank)
    local colorstring
    local arrow
    if 1 <= rank and rank <= 3 then
      colorstring = "/bR/fw"
      arrow = "△"
    elseif 4 <= rank then
      colorstring = "/br/fw"
      arrow = "△"
    elseif -3 <= rank and rank <= -1 then
      colorstring = "/bB/fw"
      arrow = "▽"
    elseif rank <= -4 then
      colorstring = "/bb/fw"
      arrow = "▽"
    end
    return colorstring .. string .. arrow .. "/x" .. math.abs(rank)
  end

  basicparameterephemerals = {pAch = "물리공격", pDch = "물리방어", pSch = "물리속도", sAch = "특수공격", sDch = "특수방어", sSch = "특수속도", Acch = "명중률", Evch = "회피율"}

  ephemerallist["pAch"] = {}
  ephemerallist["pAch"][1] = {name = "공격력 증가", display = ephemeraldisplaywithrank("攻", 1),dlength = 5,atgetparam = {param = "physicalAttack",amount = 1.5},incremental={max=6,min=-6}}
  ephemerallist["pAch"][2] = {name = "공격력 증가", display = ephemeraldisplaywithrank("攻", 2),dlength = 5,atgetparam = {param = "physicalAttack",amount = 2},incremental={max=6,min=-6}}
  ephemerallist["pAch"][3] = {name = "공격력 증가", display = ephemeraldisplaywithrank("攻", 3),dlength = 5,atgetparam = {param = "physicalAttack",amount = 2.5},incremental={max=6,min=-6}}
  ephemerallist["pAch"][4] = {name = "공격력 증가", display = ephemeraldisplaywithrank("攻", 4),dlength = 5,atgetparam = {param = "physicalAttack",amount = 3},incremental={max=6,min=-6}}
  ephemerallist["pAch"][5] = {name = "공격력 증가", display = ephemeraldisplaywithrank("攻", 5),dlength = 5,atgetparam = {param = "physicalAttack",amount = 3.5},incremental={max=6,min=-6}}
  ephemerallist["pAch"][6] = {name = "공격력 증가", display = ephemeraldisplaywithrank("攻", 6),dlength = 5,atgetparam = {param = "physicalAttack",amount = 4},incremental={max=6,min=-6}}
  ephemerallist["pAch"][-1] = {name = "공격력 감소", display = ephemeraldisplaywithrank("攻", -1),dlength = 5,atgetparam = {param = "physicalAttack",amount = 0.66},incremental={max=6,min=-6}}
  ephemerallist["pAch"][-2] = {name = "공격력 감소", display = ephemeraldisplaywithrank("攻", -2),dlength = 5,atgetparam = {param = "physicalAttack",amount = 0.5},incremental={max=6,min=-6}}
  ephemerallist["pAch"][-3] = {name = "공격력 감소", display = ephemeraldisplaywithrank("攻", -3),dlength = 5,atgetparam = {param = "physicalAttack",amount = 0.4},incremental={max=6,min=-6}}
  ephemerallist["pAch"][-4] = {name = "공격력 감소", display = ephemeraldisplaywithrank("攻", -4),dlength = 5,atgetparam = {param = "physicalAttack",amount = 0.33},incremental={max=6,min=-6}}
  ephemerallist["pAch"][-5] = {name = "공격력 감소", display = ephemeraldisplaywithrank("攻", -5),dlength = 5,atgetparam = {param = "physicalAttack",amount = 0.29},incremental={max=6,min=-6}}
  ephemerallist["pAch"][-6] = {name = "공격력 감소", display = ephemeraldisplaywithrank("攻", -6),dlength = 5,atgetparam = {param = "physicalAttack",amount = 0.25},incremental={max=6,min=-6}}

  ephemerallist["pDch"] = {}
  ephemerallist["pDch"][1] = {name = "방어력 증가", display = ephemeraldisplaywithrank("防", 1),dlength = 5,atgetparam = {param = "physicalDefense",amount = 1.5},incremental={max=6,min=-6}}
  ephemerallist["pDch"][2] = {name = "방어력 증가", display = ephemeraldisplaywithrank("防", 2),dlength = 5,atgetparam = {param = "physicalDefense",amount = 2},incremental={max=6,min=-6}}
  ephemerallist["pDch"][3] = {name = "방어력 증가", display = ephemeraldisplaywithrank("防", 3),dlength = 5,atgetparam = {param = "physicalDefense",amount = 2.5},incremental={max=6,min=-6}}
  ephemerallist["pDch"][4] = {name = "방어력 증가", display = ephemeraldisplaywithrank("防", 4),dlength = 5,atgetparam = {param = "physicalDefense",amount = 3},incremental={max=6,min=-6}}
  ephemerallist["pDch"][5] = {name = "방어력 증가", display = ephemeraldisplaywithrank("防", 5),dlength = 5,atgetparam = {param = "physicalDefense",amount = 3.5},incremental={max=6,min=-6}}
  ephemerallist["pDch"][6] = {name = "방어력 증가", display = ephemeraldisplaywithrank("防", 6),dlength = 5,atgetparam = {param = "physicalDefense",amount = 4},incremental={max=6,min=-6}}
  ephemerallist["pDch"][-1] = {name = "방어력 감소", display = ephemeraldisplaywithrank("防", -1),dlength = 5,atgetparam = {param = "physicalDefense",amount = 0.66},incremental={max=6,min=-6}}
  ephemerallist["pDch"][-2] = {name = "방어력 감소", display = ephemeraldisplaywithrank("防", -2),dlength = 5,atgetparam = {param = "physicalDefense",amount = 0.5},incremental={max=6,min=-6}}
  ephemerallist["pDch"][-3] = {name = "방어력 감소", display = ephemeraldisplaywithrank("防", -3),dlength = 5,atgetparam = {param = "physicalDefense",amount = 0.4},incremental={max=6,min=-6}}
  ephemerallist["pDch"][-4] = {name = "방어력 감소", display = ephemeraldisplaywithrank("防", -4),dlength = 5,atgetparam = {param = "physicalDefense",amount = 0.33},incremental={max=6,min=-6}}
  ephemerallist["pDch"][-5] = {name = "방어력 감소", display = ephemeraldisplaywithrank("防", -5),dlength = 5,atgetparam = {param = "physicalDefense",amount = 0.29},incremental={max=6,min=-6}}
  ephemerallist["pDch"][-6] = {name = "방어력 감소", display = ephemeraldisplaywithrank("防", -6),dlength = 5,atgetparam = {param = "physicalDefense",amount = 0.25},incremental={max=6,min=-6}}

  ephemerallist["pSch"] = {}
  ephemerallist["pSch"][1] = {name = "물리속도 증가", display = ephemeraldisplaywithrank("敏", 1),dlength = 5,atgetparam = {param = "physicalSpeed",amount = 1.5},incremental={max=6,min=-6}}
  ephemerallist["pSch"][2] = {name = "물리속도 증가", display = ephemeraldisplaywithrank("敏", 2),dlength = 5,atgetparam = {param = "physicalSpeed",amount = 2},incremental={max=6,min=-6}}
  ephemerallist["pSch"][3] = {name = "물리속도 증가", display = ephemeraldisplaywithrank("敏", 3),dlength = 5,atgetparam = {param = "physicalSpeed",amount = 2.5},incremental={max=6,min=-6}}
  ephemerallist["pSch"][4] = {name = "물리속도 증가", display = ephemeraldisplaywithrank("敏", 4),dlength = 5,atgetparam = {param = "physicalSpeed",amount = 3},incremental={max=6,min=-6}}
  ephemerallist["pSch"][5] = {name = "물리속도 증가", display = ephemeraldisplaywithrank("敏", 5),dlength = 5,atgetparam = {param = "physicalSpeed",amount = 3.5},incremental={max=6,min=-6}}
  ephemerallist["pSch"][6] = {name = "물리속도 증가", display = ephemeraldisplaywithrank("敏", 6),dlength = 5,atgetparam = {param = "physicalSpeed",amount = 4},incremental={max=6,min=-6}}
  ephemerallist["pSch"][-1] = {name = "물리속도 감소", display = ephemeraldisplaywithrank("敏", -1),dlength = 5,atgetparam = {param = "physicalSpeed",amount = 0.66},incremental={max=6,min=-6}}
  ephemerallist["pSch"][-2] = {name = "물리속도 감소", display = ephemeraldisplaywithrank("敏", -2),dlength = 5,atgetparam = {param = "physicalSpeed",amount = 0.5},incremental={max=6,min=-6}}
  ephemerallist["pSch"][-3] = {name = "물리속도 감소", display = ephemeraldisplaywithrank("敏", -3),dlength = 5,atgetparam = {param = "physicalSpeed",amount = 0.4},incremental={max=6,min=-6}}
  ephemerallist["pSch"][-4] = {name = "물리속도 감소", display = ephemeraldisplaywithrank("敏", -4),dlength = 5,atgetparam = {param = "physicalSpeed",amount = 0.33},incremental={max=6,min=-6}}
  ephemerallist["pSch"][-5] = {name = "물리속도 감소", display = ephemeraldisplaywithrank("敏", -5),dlength = 5,atgetparam = {param = "physicalSpeed",amount = 0.29},incremental={max=6,min=-6}}
  ephemerallist["pSch"][-6] = {name = "물리속도 감소", display = ephemeraldisplaywithrank("敏", -6),dlength = 5,atgetparam = {param = "physicalSpeed",amount = 0.25},incremental={max=6,min=-6}}

  ephemerallist["sAch"] = {}
  ephemerallist["sAch"][1] = {name = "특수공격력 증가", display = ephemeraldisplaywithrank("特", 1),dlength = 5,atgetparam = {param = "specialAttack",amount = 1.5},incremental={max=6,min=-6}}
  ephemerallist["sAch"][2] = {name = "특수공격력 증가", display = ephemeraldisplaywithrank("特", 2),dlength = 5,atgetparam = {param = "specialAttack",amount = 2},incremental={max=6,min=-6}}
  ephemerallist["sAch"][3] = {name = "특수공격력 증가", display = ephemeraldisplaywithrank("特", 3),dlength = 5,atgetparam = {param = "specialAttack",amount = 2.5},incremental={max=6,min=-6}}
  ephemerallist["sAch"][4] = {name = "특수공격력 증가", display = ephemeraldisplaywithrank("特", 4),dlength = 5,atgetparam = {param = "specialAttack",amount = 3},incremental={max=6,min=-6}}
  ephemerallist["sAch"][5] = {name = "특수공격력 증가", display = ephemeraldisplaywithrank("特", 5),dlength = 5,atgetparam = {param = "specialAttack",amount = 3.5},incremental={max=6,min=-6}}
  ephemerallist["sAch"][6] = {name = "특수공격력 증가", display = ephemeraldisplaywithrank("特", 6),dlength = 5,atgetparam = {param = "specialAttack",amount = 4},incremental={max=6,min=-6}}
  ephemerallist["sAch"][-1] = {name = "특수공격력 감소", display = ephemeraldisplaywithrank("特", -1),dlength = 5,atgetparam = {param = "specialAttack",amount = 0.66},incremental={max=6,min=-6}}
  ephemerallist["sAch"][-2] = {name = "특수공격력 감소", display = ephemeraldisplaywithrank("特", -2),dlength = 5,atgetparam = {param = "specialAttack",amount = 0.5},incremental={max=6,min=-6}}
  ephemerallist["sAch"][-3] = {name = "특수공격력 감소", display = ephemeraldisplaywithrank("特", -3),dlength = 5,atgetparam = {param = "specialAttack",amount = 0.4},incremental={max=6,min=-6}}
  ephemerallist["sAch"][-4] = {name = "특수공격력 감소", display = ephemeraldisplaywithrank("特", -4),dlength = 5,atgetparam = {param = "specialAttack",amount = 0.33},incremental={max=6,min=-6}}
  ephemerallist["sAch"][-5] = {name = "특수공격력 감소", display = ephemeraldisplaywithrank("特", -5),dlength = 5,atgetparam = {param = "specialAttack",amount = 0.29},incremental={max=6,min=-6}}
  ephemerallist["sAch"][-6] = {name = "특수공격력 감소", display = ephemeraldisplaywithrank("特", -6),dlength = 5,atgetparam = {param = "specialAttack",amount = 0.25},incremental={max=6,min=-6}}

  ephemerallist["sDch"] = {}
  ephemerallist["sDch"][1] = {name = "특수방어력 증가", display = ephemeraldisplaywithrank("護", 1),dlength = 5,atgetparam = {param = "specialDefense",amount = 1.5},incremental={max=6,min=-6}}
  ephemerallist["sDch"][2] = {name = "특수방어력 증가", display = ephemeraldisplaywithrank("護", 2),dlength = 5,atgetparam = {param = "specialDefense",amount = 2},incremental={max=6,min=-6}}
  ephemerallist["sDch"][3] = {name = "특수방어력 증가", display = ephemeraldisplaywithrank("護", 3),dlength = 5,atgetparam = {param = "specialDefense",amount = 2.5},incremental={max=6,min=-6}}
  ephemerallist["sDch"][4] = {name = "특수방어력 증가", display = ephemeraldisplaywithrank("護", 4),dlength = 5,atgetparam = {param = "specialDefense",amount = 3},incremental={max=6,min=-6}}
  ephemerallist["sDch"][5] = {name = "특수방어력 증가", display = ephemeraldisplaywithrank("護", 5),dlength = 5,atgetparam = {param = "specialDefense",amount = 3.5},incremental={max=6,min=-6}}
  ephemerallist["sDch"][6] = {name = "특수방어력 증가", display = ephemeraldisplaywithrank("護", 6),dlength = 5,atgetparam = {param = "specialDefense",amount = 4},incremental={max=6,min=-6}}
  ephemerallist["sDch"][-1] = {name = "특수방어력 감소", display = ephemeraldisplaywithrank("護", -1),dlength = 5,atgetparam = {param = "specialDefense",amount = 0.66},incremental={max=6,min=-6}}
  ephemerallist["sDch"][-2] = {name = "특수방어력 감소", display = ephemeraldisplaywithrank("護", -2),dlength = 5,atgetparam = {param = "specialDefense",amount = 0.5},incremental={max=6,min=-6}}
  ephemerallist["sDch"][-3] = {name = "특수방어력 감소", display = ephemeraldisplaywithrank("護", -3),dlength = 5,atgetparam = {param = "specialDefense",amount = 0.4},incremental={max=6,min=-6}}
  ephemerallist["sDch"][-4] = {name = "특수방어력 감소", display = ephemeraldisplaywithrank("護", -4),dlength = 5,atgetparam = {param = "specialDefense",amount = 0.33},incremental={max=6,min=-6}}
  ephemerallist["sDch"][-5] = {name = "특수방어력 감소", display = ephemeraldisplaywithrank("護", -5),dlength = 5,atgetparam = {param = "specialDefense",amount = 0.29},incremental={max=6,min=-6}}
  ephemerallist["sDch"][-6] = {name = "특수방어력 감소", display = ephemeraldisplaywithrank("護", -6),dlength = 5,atgetparam = {param = "specialDefense",amount = 0.25},incremental={max=6,min=-6}}

  ephemerallist["sSch"] = {}
  ephemerallist["sSch"][1] = {name = "특수속도 증가", display = ephemeraldisplaywithrank("迅", 1),dlength = 5,atgetparam = {param = "specialSpeed",amount = 1.5},incremental={max=6,min=-6}}
  ephemerallist["sSch"][2] = {name = "특수속도 증가", display = ephemeraldisplaywithrank("迅", 2),dlength = 5,atgetparam = {param = "specialSpeed",amount = 2},incremental={max=6,min=-6}}
  ephemerallist["sSch"][3] = {name = "특수속도 증가", display = ephemeraldisplaywithrank("迅", 3),dlength = 5,atgetparam = {param = "specialSpeed",amount = 2.5},incremental={max=6,min=-6}}
  ephemerallist["sSch"][4] = {name = "특수속도 증가", display = ephemeraldisplaywithrank("迅", 4),dlength = 5,atgetparam = {param = "specialSpeed",amount = 3},incremental={max=6,min=-6}}
  ephemerallist["sSch"][5] = {name = "특수속도 증가", display = ephemeraldisplaywithrank("迅", 5),dlength = 5,atgetparam = {param = "specialSpeed",amount = 3.5},incremental={max=6,min=-6}}
  ephemerallist["sSch"][6] = {name = "특수속도 증가", display = ephemeraldisplaywithrank("迅", 6),dlength = 5,atgetparam = {param = "specialSpeed",amount = 4},incremental={max=6,min=-6}}
  ephemerallist["sSch"][-1] = {name = "특수속도 감소", display = ephemeraldisplaywithrank("迅", -1),dlength = 5,atgetparam = {param = "specialSpeed",amount = 0.66},incremental={max=6,min=-6}}
  ephemerallist["sSch"][-2] = {name = "특수속도 감소", display = ephemeraldisplaywithrank("迅", -2),dlength = 5,atgetparam = {param = "specialSpeed",amount = 0.5},incremental={max=6,min=-6}}
  ephemerallist["sSch"][-3] = {name = "특수속도 감소", display = ephemeraldisplaywithrank("迅", -3),dlength = 5,atgetparam = {param = "specialSpeed",amount = 0.4},incremental={max=6,min=-6}}
  ephemerallist["sSch"][-4] = {name = "특수속도 감소", display = ephemeraldisplaywithrank("迅", -4),dlength = 5,atgetparam = {param = "specialSpeed",amount = 0.33},incremental={max=6,min=-6}}
  ephemerallist["sSch"][-5] = {name = "특수속도 감소", display = ephemeraldisplaywithrank("迅", -5),dlength = 5,atgetparam = {param = "specialSpeed",amount = 0.29},incremental={max=6,min=-6}}
  ephemerallist["sSch"][-6] = {name = "특수속도 감소", display = ephemeraldisplaywithrank("迅", -6),dlength = 5,atgetparam = {param = "specialSpeed",amount = 0.25},incremental={max=6,min=-6}}

  ephemerallist["Acch"] = {}
  ephemerallist["Acch"][1] = {name = "명중률 증가", display = ephemeraldisplaywithrank("命", 1),dlength = 5,atcheckhit = {param = "Accuracy",amount = 1.33},incremental={max=6,min=-6}}
  ephemerallist["Acch"][2] = {name = "명중률 증가", display = ephemeraldisplaywithrank("命", 2),dlength = 5,atcheckhit = {param = "Accuracy",amount = 1.66},incremental={max=6,min=-6}}
  ephemerallist["Acch"][3] = {name = "명중률 증가", display = ephemeraldisplaywithrank("命", 3),dlength = 5,atcheckhit = {param = "Accuracy",amount = 2},incremental={max=6,min=-6}}
  ephemerallist["Acch"][4] = {name = "명중률 증가", display = ephemeraldisplaywithrank("命", 4),dlength = 5,atcheckhit = {param = "Accuracy",amount = 2.33},incremental={max=6,min=-6}}
  ephemerallist["Acch"][5] = {name = "명중률 증가", display = ephemeraldisplaywithrank("命", 5),dlength = 5,atcheckhit = {param = "Accuracy",amount = 2.66},incremental={max=6,min=-6}}
  ephemerallist["Acch"][6] = {name = "명중률 증가", display = ephemeraldisplaywithrank("命", 6),dlength = 5,atcheckhit = {param = "Accuracy",amount = 3},incremental={max=6,min=-6}}
  ephemerallist["Acch"][-1] = {name = "명중률 감소", display = ephemeraldisplaywithrank("命", -1),dlength = 5,atcheckhit = {param = "Accuracy",amount = 0.75},incremental={max=6,min=-6}}
  ephemerallist["Acch"][-2] = {name = "명중률 감소", display = ephemeraldisplaywithrank("命", -2),dlength = 5,atcheckhit = {param = "Accuracy",amount = 0.6},incremental={max=6,min=-6}}
  ephemerallist["Acch"][-3] = {name = "명중률 감소", display = ephemeraldisplaywithrank("命", -3),dlength = 5,atcheckhit = {param = "Accuracy",amount = 0.5},incremental={max=6,min=-6}}
  ephemerallist["Acch"][-4] = {name = "명중률 감소", display = ephemeraldisplaywithrank("命", -4),dlength = 5,atcheckhit = {param = "Accuracy",amount = 0.43},incremental={max=6,min=-6}}
  ephemerallist["Acch"][-5] = {name = "명중률 감소", display = ephemeraldisplaywithrank("命", -5),dlength = 5,atcheckhit = {param = "Accuracy",amount = 0.38},incremental={max=6,min=-6}}
  ephemerallist["Acch"][-6] = {name = "명중률 감소", display = ephemeraldisplaywithrank("命", -6),dlength = 5,atcheckhit = {param = "Accuracy",amount = 0.33},incremental={max=6,min=-6}}

  ephemerallist["Evch"] = {}
  ephemerallist["Evch"][1] = {name = "회피율 증가", display = ephemeraldisplaywithrank("避", 1),dlength = 5,atcheckhit = {param = "Evasion",amount = 1.33},incremental={max=6,min=-6}}
  ephemerallist["Evch"][2] = {name = "회피율 증가", display = ephemeraldisplaywithrank("避", 2),dlength = 5,atcheckhit = {param = "Evasion",amount = 1.66},incremental={max=6,min=-6}}
  ephemerallist["Evch"][3] = {name = "회피율 증가", display = ephemeraldisplaywithrank("避", 3),dlength = 5,atcheckhit = {param = "Evasion",amount = 2},incremental={max=6,min=-6}}
  ephemerallist["Evch"][4] = {name = "회피율 증가", display = ephemeraldisplaywithrank("避", 4),dlength = 5,atcheckhit = {param = "Evasion",amount = 2.33},incremental={max=6,min=-6}}
  ephemerallist["Evch"][5] = {name = "회피율 증가", display = ephemeraldisplaywithrank("避", 5),dlength = 5,atcheckhit = {param = "Evasion",amount = 2.66},incremental={max=6,min=-6}}
  ephemerallist["Evch"][6] = {name = "회피율 증가", display = ephemeraldisplaywithrank("避", 6),dlength = 5,atcheckhit = {param = "Evasion",amount = 3},incremental={max=6,min=-6}}
  ephemerallist["Evch"][-1] = {name = "회피율 감소", display = ephemeraldisplaywithrank("避", -1),dlength = 5,atcheckhit = {param = "Evasion",amount = 0.75},incremental={max=6,min=-6}}
  ephemerallist["Evch"][-2] = {name = "회피율 감소", display = ephemeraldisplaywithrank("避", -2),dlength = 5,atcheckhit = {param = "Evasion",amount = 0.6},incremental={max=6,min=-6}}
  ephemerallist["Evch"][-3] = {name = "회피율 감소", display = ephemeraldisplaywithrank("避", -3),dlength = 5,atcheckhit = {param = "Evasion",amount = 0.5},incremental={max=6,min=-6}}
  ephemerallist["Evch"][-4] = {name = "회피율 감소", display = ephemeraldisplaywithrank("避", -4),dlength = 5,atcheckhit = {param = "Evasion",amount = 0.43},incremental={max=6,min=-6}}
  ephemerallist["Evch"][-5] = {name = "회피율 감소", display = ephemeraldisplaywithrank("避", -5),dlength = 5,atcheckhit = {param = "Evasion",amount = 0.38},incremental={max=6,min=-6}}
  ephemerallist["Evch"][-6] = {name = "회피율 감소", display = ephemeraldisplaywithrank("避", -6),dlength = 5,atcheckhit = {param = "Evasion",amount = 0.33},incremental={max=6,min=-6}}

  for ekey, eval in pairs(basicparameterephemerals) do
    for k, v in pairs(ephemerallist[ekey]) do
      local p
      local sign = ((k > 0) and "증가" or "감소")
      if v.atgetparam then
        p = v.atgetparam.amount
      elseif v.atcheckhit then
        p = v.atcheckhit.amount
      else
        DEBUGPRINT("Ephemeral " .. v.name .. " " .. k .. "has neither atgetparam and atcheckhit and this is not expected")
        break
      end
      v.description = eval .. sign .. " " .. tostring(math.abs(p - 1) * 100) .. "%" 
      v.compactdescription = v.description
      v.acquireMessage = function(char)
        return char.name .. "의 " .. eval .. "(이)가 " .. sign .. "했다!"
      end
    end
  end

#end

#function applyephemerallist
  applyephemerallist = {}

  applyephemerallist["manadepletion"]={ephemeral="manadepletion"}
  
  applyephemerallist["standardburn"]={ephemeral="burn",rank=1,minDuration=2,maxDuration=5}
  applyephemerallist["additionalburn"]={ephemeral="burn",rank=1,probability=10,minDuration=1,maxDuration=3}
  applyephemerallist["standardfrozen"]={ephemeral="frozen",rank=1,minDuration=2,maxDuration=5}
  applyephemerallist["additionalfrozen"]={ephemeral="frozen",rank=1,probability=10,minDuration=1,maxDuration=3}
  applyephemerallist["standardsleep"]={ephemeral="sleep",rank=1,minDuration=2,maxDuration=5}
  applyephemerallist["additionalsleep"]={ephemeral="sleep",rank=1,probability=10,minDuration=1,maxDuration=3}
  applyephemerallist["standardparalyzed"]={ephemeral="paralyzed",rank=1,minDuration=2,maxDuration=5}
  applyephemerallist["additionalparalyzed"]={ephemeral="paralyzed",rank=1,probability=10,minDuration=1,maxDuration=3}
  applyephemerallist["standardstoned"]={ephemeral="stoned",rank=1,minDuration=2,maxDuration=5}
  applyephemerallist["additionalstoned"]={ephemeral="stoned",rank=1,probability=10,minDuration=1,maxDuration=3}
  applyephemerallist["standardblind"]={ephemeral="blind",rank=1,minDuration=2,maxDuration=5}
  applyephemerallist["additionalblind"]={ephemeral="blind",rank=1,probability=10,minDuration=1,maxDuration=3}
  applyephemerallist["standardcursed"]={ephemeral="cursed",rank=1,minDuration=2,maxDuration=5}
  applyephemerallist["additionalcursed"]={ephemeral="cursed",rank=1,probability=10,minDuration=1,maxDuration=3}

  applyephemerallist["pAup1"]={ephemeral="pAch",rank=1,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["pAup2"]={ephemeral="pAch",rank=2,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["pAdn1"]={ephemeral="pAch",rank=-1,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["pAdn2"]={ephemeral="pAch",rank=-2,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["pDup1"]={ephemeral="pDch",rank=1,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["pDup2"]={ephemeral="pDch",rank=2,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["pDdn1"]={ephemeral="pDch",rank=-1,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["pDdn2"]={ephemeral="pDch",rank=-2,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["pSup1"]={ephemeral="pSch",rank=1,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["pSup2"]={ephemeral="pSch",rank=2,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["pSdn1"]={ephemeral="pSch",rank=-1,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["pSdn2"]={ephemeral="pSch",rank=-2,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["sAup1"]={ephemeral="sAch",rank=1,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["sAup2"]={ephemeral="sAch",rank=2,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["sAdn1"]={ephemeral="sAch",rank=-1,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["sAdn2"]={ephemeral="sAch",rank=-2,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["sDup1"]={ephemeral="sDch",rank=1,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["sDup2"]={ephemeral="sDch",rank=2,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["sDdn1"]={ephemeral="sDch",rank=-1,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["sDdn2"]={ephemeral="sDch",rank=-2,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["sSup1"]={ephemeral="sSch",rank=1,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["sSup2"]={ephemeral="sSch",rank=2,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["sSdn1"]={ephemeral="sSch",rank=-1,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["sSdn2"]={ephemeral="sSch",rank=-2,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["Acup1"]={ephemeral="Acch",rank=1,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["Acup2"]={ephemeral="Acch",rank=2,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["Acdn1"]={ephemeral="Acch",rank=-1,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["Acdn2"]={ephemeral="Acch",rank=-2,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["Evup1"]={ephemeral="Evch",rank=1,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["Evup2"]={ephemeral="Evch",rank=2,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["Evdn1"]={ephemeral="Evch",rank=-1,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}
  applyephemerallist["Evdn2"]={ephemeral="Evch",rank=-2,minDuration=-1,maxDuration=-1,incremental={max=6,min=-6}}

#end