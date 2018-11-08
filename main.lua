local MOD = {}


-- Configuration
-- Is this the first run?  Set on new character creation.
local SDFirstRun = 0

-- What is the minimum dex before you start gaining speed boosts?
local SDMinDex = 12

-- How much speed do you get per dex?
local SDDexSpeed = 2



mods["speedydex"] = MOD

function MOD.on_new_player_created()
  SDconfig()
end

 function MOD.on_minute_passed()
  SDFirstRun, SDMinDex, SDDexSpeed = Mod_speedydex_GetVar()
  if SDFirstRun ~= 1 then SDconfig() end
  Mod_speedydex_Main()
 end

function SDconfig()
  Menu_SDExamples()
  SDFirstRun = 1
  Mod_speedydex_SetVar(SDFirstRun, SDMinDex, SDDexSpeed)
end

function Menu_SDExamples()
  local menu = game.create_uimenu()
  menu.title = "Dexterity Speed Increase"
  menu:addentry(SDMinDex.." Dex: +0 speed") -- menu 0
  for i=0, 3 do -- menu 1-4
    menu:addentry((SDMinDex + i + 1).." Dex: +"..((i + 1)*SDDexSpeed).." speed")
  end
  menu:addentry("Change Minimum Dex")
  menu:addentry("Change Speed per Dex")
  menu:addentry("Done")
  menu:query(true)
  if menu.selected == 5 then -- change minimum dexterity
    SDMinDex = Menu_config(SDMinDex, "Minimum Dexterity", 0, 20, 2)
  elseif menu.selected == 6 then -- change speed per dexterity
    SDDexSpeed = Menu_config(SDDexSpeed, "Speed per Dex", 1, 100, 3)
  end
  if menu.selected ~= 7 then -- repeat menu until "Done" is selected
    Menu_SDExamples()
  end
end
  

function Menu_config(conf_var, var_name, minsize, maxsize, conf_levels)
  --myvar = Menu_config(myvar, "My Variable", 1, 100, 3)
  --this gives a menu to set myvar to a number between 1 and 100, with options +- 1, 10, 100
  local menu = game.create_uimenu()
  menu.title = var_name..": "..conf_var
  for i=0, (conf_levels - 1) do
    menu:addentry("+"..(10 ^ i))
  end
  for i=0, (conf_levels - 1) do
    menu:addentry("-"..(10 ^ i))
  end
  menu:addentry("Done")
  menu:query(true)
  for i=0, (conf_levels - 1) do
    if (menu.selected == i) then
      conf_var = conf_var + (10 ^ i)
    end
  end
  for i=conf_levels, ((conf_levels * 2) - 1) do
    if (menu.selected == i) then
      conf_var = conf_var - (10 ^ (i - conf_levels))
    end
  end
  if (conf_var < minsize) then conf_var = minsize end
  if (conf_var > maxsize) then conf_var = maxsize end
  if (menu.selected ~= (conf_levels * 2)) then -- repeat menu until "Done" is selected
    conf_var = Menu_config(conf_var, var_name, minsize, maxsize, conf_levels)
  end
  return conf_var
end

function Mod_speedydex_Main()
  local dex = player.dex_max
	player:remove_effect(efftype_id("speedydex"))
  if (dex > SDMinDex) then
		player:add_effect((efftype_id("speedydex")), DAYS(1), "num_bp", true, ((dex - SDMinDex)*SDDexSpeed))
  end
end

function Mod_speedydex_SetVar(fr, md, sp)
	player:set_value("SDRun", tostring(fr)) --set_value
	player:set_value("SDDex", tostring(md))
	player:set_value("SDSpd", tostring(sp))
end

function Mod_speedydex_GetVar()
	return tonumber(player:get_value("SDRun")) or SDFirstRun, -- get_value
		tonumber(player:get_value("SDDex")) or 12,
		tonumber(player:get_value("SDSpd")) or 2
end