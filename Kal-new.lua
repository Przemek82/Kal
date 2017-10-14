-- M1
--	G1	Start
--	G10	Leczenie off
--	G11	Leczenie - cure
--	G12	Leczenie - group cure

-- M2
--	G1	Pozycja Inkaska
--	G2	Pozycja FOD 1
--	G3	Pozycja FOD 2
--	G4	Pozycja Prist 1
--	G5	Pozycja Prist 2
--	G6	Pozycja Prist 3
--	G7	Pozycja Prist 4
--	G8	Pozycja Prist 5
--	G9	Pozycja MA w party
--	G10	MA Active Skill
--	G11	Pozycja Gienek1 PT
--	G12	Pozycja Gienek2 PT

-- M3
--	G1	Uzyj Inkaskiej
--	G2	Uzyj FOD1
--	G3	Uzyj FOD2
--	G4	Rzuc shni na prista 1
--	G5	Rzuc shni na prista 2
--	G6	Rzuc shni na prista 3
--	G7	Rzuc shni na prista 4
--	G8	Rzuc shni na prista 5
--	G9	Uzyj Medytacji
--	G10	Rzuc Buffy


avgGlobalX = 1
avgGlobalY = 1

--pause = true
eXecute = true
msgDelay = 5000
msgTime = 0

inkaskaUse = true
inkaskaTime = 0
inkaskaDelay = 5000
inkaskaX = 64481 
inkaskaY = 48792

--fodDelay = 20 * 60 * 1000 + 1000
fodDelay = 40000

pod1Use = true
fod1X = 40515
fod1Y = 43482
fod1Time = 0

fod2Use = true
fod2X = 16394
fod2Y = 43669
fod2Time = 0

--pristDelay = 2 * 60 * 1000 + 30 * 1000
pristDelay = 5000
pristTime = 0
pristActive = 0

prist1Use = true
prist1X = 27791
prist1Y = 21928

prist2Use = true
prist2X = 42272
prist2Y = 18555

prist3Use = true
prist3X = 49141
prist3Y = 16056

prist4Use = true
prist4X = 60422
prist4Y = 14431

prist5Use = false
prist5X = nil
prist5Y = nil

maTime = 0
maActiveSkillN = 0
maActiveSkillX = 22834
maActiveSkillY = 2545
maActiveSkillTime = 0
skillBarDiff = 2640

groupCureUse = false
groupCureDelay = 5000
groupCureMinDelay = 3100
groupCureTime = 0
groupCureN = 1

cureUse = false
cureDelay = 2600
cureMinDelay = 2250
cureTime = 0
cureCurrent = 2
cureN = 2
cureChar1X = nil
cureChar1Y = nil
cureChar2X = nil
cureChar2Y = nil

medytacjaUse = true
medytacjaDelay = 12 * 60 * 1000 + 30 * 1000 + 3000
medytacjaTime = 0
medytacjaN = 7 --15744

buffyDelay = 28 * 60 * 1000 + 500
buffyMinDelay = 3600
buffyUse = true
buffyTime = 0
--def = 5 --10558
--agi = 6 --13057
--hp = 8 --18305
--speed = 4 --7934
buffyName 	= { "def",	"agi", "hp", "speed"}
buffyNo 	= { 	5,		6,	  8, 	  4} 
buffyTT 	= { 	0,		0,	  0, 	  0} 

buffyActiveCharX = nil
buffyActiveCharY = nil

--currentX = nil
--currentY = nil

function RunScript()

	ClearLCD()
	local msg = GetDate("%X") .. "   Program dziala - " .. GetRunningTime()
	--while not (pause) do
	while true do
		if not (GetMKeyState() == 1) then
			eXecute = false
			--pause = true
			break
		end
		
		for i = 1, 20 do
			if (fod1Use) then
				if (fod1Time + fodDelay < GetRunningTime()) then
					RzucFod1()
				end
			end
			
			if (fod2Use) then
				if (fod2Time + fodDelay < GetRunningTime()) then
					RzucFod2()
				end
			end
			
			if (medytacjaUse) then
				if (medytacjaTime + medytacjaDelay < GetRunningTime()) then
					Medytacja()
				end
			end
			
			if (inkaskaUse) then
				if (inkaskaTime + inkaskaDelay < GetRunningTime()) then
					Inkaska()
				end
			end
			
			if (pristTime + pristDelay < GetRunningTime()) then
				RzucNaPrista()
			end
			
			
			
			if (cureUse) then
				if (maTime < GetRunningTime()) then
					if (cureTime + cureDelay < GetRunningTime()) then
						LeczPojedynczym()
					end
				end
			elseif (groupCureUse) then
				if (maTime < GetRunningTime()) then
					if (groupCureTime + groupCureDelay < GetRunningTime()) then
						GroupCure()
					end
				end
			end
			
			Sleep(50)
		end
	end
end

function LCDMessage(lMsg)
	OutputLCDMessage(lMmsg, 600000)
end

function OnEvent(event, arg)
	
    OutputLogMessage("event = %s, arg = %s, pause = %s, eXecute = %s\n", event, arg, tostring(pause), tostring(eXecute))

	local mkey = GetMKeyState()
	
	if (eXecute == false and mkey == 1) then
		eXecute = true
	elseif (eXecute == false) then
		LCDMessage("Please reurn to the execute state")
	end
	
	if (event == "G_RELEASED" and eXecute) then
		if (mkey == 1) then
			if (arg == 1) then
				RunScript()
				
			elseif (arg == 10) then
				cureUse = false
				groupCureUse = false
				LCDMessage("Cure and GC Dsabled")
			elseif (arg == 11) then
				cureUse = true
				groupCureUse = false
				LCDMessage("Cure Enabled")
			elseif (arg == 12) then
				cureUse = false
				groupCureUse = true
				LCDMessage("Group Cure Enabled")
			end
			
		elseif (mkey == 2) then
			if (arg == 1) then
				-- inkaska
				inkaskaX, inkaskaY = GetMousePosition()
				LCDMessage("Inkaska (" .. inkaskaX .. ", " .. inkaskaY .. ")")
			elseif (arg == 2) then
				-- FOD1
				fod1X, fod1Y = GetMousePosition()
				LCDMessage("FOD1 (" .. fod1X .. ", " .. fod1Y .. ")")
			elseif (arg == 3) then
				-- FOD2
				fod2X, fod2Y = GetMousePosition()
				LCDMessage("FOD2 (" .. fod2X .. ", " .. fod2Y .. ")")
			elseif (arg == 4) then
				-- Prist 1
				prist1X, prist1Y = GetMousePosition()
				LCDMessage("Priest 1 (" .. prist1X .. ", " .. prist1Y .. ")")
			elseif (arg == 5) then
				-- Prist 2
				prist2X, prist2Y = GetMousePosition()
				LCDMessage("Priest 2 (" .. prist2X .. ", " .. prist2Y .. ")")
			elseif (arg == 6) then
				-- Prist 3
				prist3X, prist3Y = GetMousePosition()
				LCDMessage("Priest 3 (" .. prist3X .. ", " .. prist3Y .. ")")
			elseif (arg == 7) then
				-- Prist 4
				prist4X, prist4Y = GetMousePosition()
				LCDMessage("Priest 4 (" .. prist4X .. ", " .. prist4Y .. ")")
			elseif (arg == 8) then
				-- Prist 5
				prist5X, prist5Y = GetMousePosition()
				LCDMessage("Priest 5 (" .. prist5X .. ", " .. prist5Y .. ")")
			elseif (arg == 9) then
				-- PT Buffer Active Char
				buffyActiveCharX, buffyActiveCharY = GetMousePosition()
				LCDMessage("Buffy (" .. buffyActiveCharX .. ", " .. buffyActiveCharY .. ")")
			elseif (arg == 10) then
				-- MA Active Skill
				maActiveSkillX, maActiveSkillY = GetMousePosition()
				LCDMessage("MA Active Skill (" .. maActiveSkillX .. ", " .. maActiveSkillY .. ")")
			elseif (arg == 11) then
				-- PT Hercio
				cureChar1X, cureChar1Y = GetMousePosition()
				LCDMessage("Cure char 1 (" .. cureChar1X .. ", " .. cureChar1Y .. ")")
			elseif (arg == 12) then
				-- PT Freskos
				cureChar2X, cureChar2Y = GetMousePosition()
				LCDMessage("Cure char 2 (" .. cureChar2X .. ", " .. cureChar2Y .. ")")
			end
			
		elseif (mkey == 3) then
			if (arg == 2) then
				fod1Use = true
				RzucFod1()
			elseif (arg == 3) then
				fod2Use = true
				RzucFod2()
			elseif (arg == 4) then
				prist1Use = true
				RzucNaPrista1()
			elseif (arg == 5) then
				prist2Use = true
				RzucNaPrista2()
			elseif (arg == 6) then
				prist3Use = true
				RzucNaPrista3()
			elseif (arg == 7) then
				prist4Use = true
				RzucNaPrista4()
			elseif (arg == 8) then
				prist5Use = true
				RzucNaPrista5()
			elseif (arg == 9) then
				medytacjaUse = true
				Medytacja()
			elseif (arg == 10) then
				buffyUse = true
				Buffy()
			end
		end
	end
	
end

function RzucFod1()
	if (fod1X and fod1Y) then
		ReturnTo(fod1X, fod1Y)
		Sleep(100)
		PressAndReleaseMouseButton(1)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem FOD1"
		LCDMessage(msg)
		fod1Time = GetRunningTime()
	end
end

function RzucFod2()
	if (fod2X and fod2Y) then
		ReturnTo(fod2X, fod2Y)
		Sleep(100)
		--PressAndReleaseMouseButton(1)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem FOD2"
		LCDMessage(msg)
		fod2Time = GetRunningTime()
	end
end

function RzucNaPrista()
	if (pristActive == 0 or pristActive == 5) then
		RzucNaPrista1()
	elseif (pristActive == 1) then
		RzucNaPrista2()
	elseif (pristActive == 2) then
		RzucNaPrista3()
	elseif (pristActive == 3) then
		RzucNaPrista4()
	elseif (pristActive == 4) then
		RzucNaPrista5()
	end
end

function RzucNaPrista1()
	if (prist1Use and prist1X and prist1Y) then
		ReturnTo(prist1X, prist1Y) 
		Sleep(100)
		PressAndReleaseMouseButton(2)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem Prist 1"
		LCDMessage(msg)
		pristTime = GetRunningTime()
		pristActive = 1
	else
		RzucNaPrista2()
	end
end

function RzucNaPrista2()
	if (prist2Use and prist2X and prist2Y) then
		ReturnTo(prist2X, prist2Y) 
		Sleep(100)
		PressAndReleaseMouseButton(2)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem Prist 2"
		LCDMessage(msg)
		pristTime = GetRunningTime()
		pristActive = 2
	else
		RzucNaPrista3()
	end
end

function RzucNaPrista3()
	if (prist3Use and prist3X and prist3Y) then
		ReturnTo(prist3X, prist3Y) 
		Sleep(100)
		PressAndReleaseMouseButton(2)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem Prist 3"
		LCDMessage(msg)
		pristTime = GetRunningTime()
		pristActive = 3
	else
		RzucNaPrista4()
	end
end

function RzucNaPrista4()
	if (prist4Use and prist4X and prist4Y) then
		ReturnTo(prist4X, prist4Y) 
		Sleep(100)
		PressAndReleaseMouseButton(2)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem Prist 4"
		LCDMessage(msg)
		pristTime = GetRunningTime()
		pristActive = 4
	else
		RzucNaPrista5()
	end
end

function RzucNaPrista5()
	if (prist5Use and prist5X and prist5Y) then
		ReturnTo(prist5X, prist5Y) 
		Sleep(100)
		PressAndReleaseMouseButton(2)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem Prist 5"
		LCDMessage(msg)
		pristTime = GetRunningTime()
		pristActive = 5
	else
		RzucNaPrista1()
	end
end

function LeczPojedynczym()
	if not (maActiveSkillN == cureN) then
		if (maActiveSkillX and maActiveSkillY and cureN and skillBarDiff) then
			local cureX = maActiveSkillX
			local cureY = maActiveSkillY + (cureN * skillBarDiff)
			ReturnTo(cureX, cureY)
			Sleep(100)
			PressAndReleaseMouseButton(1)
			maActiveSkillN = cureN
		end
	end
	
	if (maActiveSkillN == cureN) then
		local cureCharX = nil
		local cureCharY = nil
		if (cureCurrent == 2 and cureChar1X and cureChar1Y) then
			cureCharX = cureChar1X
			cureCharY = cureChar1Y
			cureCurrent = 1
		elseif (cureCurrent == 1 and cureChar2X and cureChar2Y) then
			cureCharX = cureChar2X
			cureCharY = cureChar2Y
			cureCurrent = 2
		end
		if (cureCharX and cureCharY) then
			ReturnTo(cureCharX, cureCharY)
			Sleep(100)
			PressAndReleaseMouseButton(2)
			cureTime = GetRunningTime()
			maTime = cureTime + cureMinDelay
		elseif (cureCurrent == 1) then
			cureCurrent = 2
		elseif (cureCurrent == 2) then
			cureCurrent = 1
		end
	end
end

function Medytacja()
	if (maActiveSkillX and maActiveSkillY and medytacjaN and skillBarDiff) then
		local mX = maActiveSkillX
		local mY = maActiveSkillY + (medytacjaN * skillBarDiff)
		ReturnTo(mX, mY)
		Sleep(100)
		PressAndReleaseMouseButton(1)
		local msg = GetDate("%X") .. "Urzylem medytacji"
		LCDMessage(msg)
		medytacjaTime = GetRunningTime()
	end
end

function GroupCure()
	if (maActiveSkillX and maActiveSkillY and groupCureN and skillBarDiff) then
		local mX = maActiveSkillX
		local mY = maActiveSkillY + (groupCureN * skillBarDiff)
		ReturnTo(mX, mY)
		Sleep(100)
		PressAndReleaseMouseButton(1)
		--Sleep(3000)
		groupCureTime = GetRunningTime()
		maTime = groupCureTime + groupCureMinDelay
	end
end

function Inkaska()
	if (inkaskaX and inkaskaY) then
		ReturnTo(inkaskaX, inkaskaY)
		Sleep(100)
		PressAndReleaseMouseButton(1)
		local msg = GetDate("%X") .. "Urzylem inkaskiej"
		LCDMessage(msg)
		inkaskaTime = GetRunningTime()
	end
end

function Buffy()
	if (buffyActiveCharX and buffyActiveCharY and maActiveSkillX and maActiveSkillY and skillBarDiff) then
		for i, bNo in ipairs(buffyNo) do
			--if (buffyTT[i] + buffyDelay < GetRunningTime()) then
				if (maTime > GetRunningTime()) then
					Sleep(maTime - GetRunningTime)
				end
				local cureX = maActiveSkillX
				local cureY = maActiveSkillY + (bNo * skillBarDiff)
				ReturnTo(cureX, cureY)
				Sleep(100)
				--PressAndReleaseMouseButton(1)
				maActiveSkillN = bNo
				
				ReturnTo(maActiveSkillX, maActiveSkillY)
				Sleep(100)
				PressAndReleaseMouseButton(2)
				maTime = GetRunningTime + buffyMinDelay
				--Sleep(3600)
				--buffyTT[i] = GetRunningTime()
				local msg = GetDate("%X") .. "Rzucilem: " .. buffyName[i]
				LCDMessage(msg)
				--break
			--end
			
			--if (i == #buffyNo) then
			--	buffyTime = GetRunningTime()
			--end
		end
		buffyTime = GetRunningTime()
	end
end

function ReturnTo(pointX, pointY)
	local currentX = 0
	local currentY = 0
	local diffX = 0
	local diffY = 0
	local moveX = 1
	local moveY = 1
	local textX = 0
	local testY = 0
	
	Sleep(100)
	currentX, currentY = GetMousePosition()
	diffX = math.floor((pointX - currentX)/avgGlobalX)
	diffY = math.floor((pointY - currentY)/avgGlobalY)
	
	if (diffX < 0) then
		moveX = -1
	end
	
	if (diffY < 0) then
		moveY = -1
	end
	
	diffX = math.abs(diffX)
	diffY = math.abs(diffY)
	if (diffY >= diffX) then
		for i = 0, diffX  do
			MoveMouseRelative(moveX, moveY)
		end
		for i = diffX + 1, diffY do
			MoveMouseRelative(0, moveY)
		end
	else
		for i = 0, diffY do
			MoveMouseRelative(moveX, moveY)
		end
		for i = diffY + 1, diffX do
			MoveMouseRelative(moveX, 0)
		end
	end
	
	Sleep(50)
	testX, testY = GetMousePosition()
	OutputLogMessage("DiffX = %s, DiffY = %s\n", tostring(math.abs(testX - pointX)/avgGlobalX), tostring(math.abs(testY - pointY)/avgGlobalY))
	
	if (hits < 4) then
		if (((math.abs(testX - pointX)/avgGlobalX) > 3) or (math.abs(testY - pointY)/avgGlobalY)) then
			hits = hits + 1
			ReturnTo(pointX, pointY)
		end
	else
		hits = 0
	end
end