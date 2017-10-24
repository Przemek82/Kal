-- M1
--	G1	Start
--	G10	Leczenie off
--	G11	Leczenie - cure
--	G12	Leczenie - group cure

-- M2  zapisywanie pozycji
--	G1	Pozycja Inkaska - wylaczone
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

--uzadzenie = "kb"
uzadzenie = "lhc"
avgGlobalX = 40.985023809524 
avgGlobalY = 72.881376984127
hits = 0

eXecute = true
msgDelay = 5000
msgTime = 0

inkaskaUse = false
inkaskaTime = 0
inkaskaDelay = 5000
inkaskaX = 64481 
inkaskaY = 48792

fodDelay = 20 * 60 * 1000 + 1000

fod1Use = true
fod1X = 40515
fod1Y = 43482
fod1Time = 0

fod2Use = true
fod2X = 16394
fod2Y = 43669
fod2Time = 0

pristDelay = 2 * 60 * 1000 + 30 * 1000
pristTime = 0
pristActive = 1

prist1Use = false
prist1X = 27791
prist1Y = 21928

prist2Use = false
prist2X = 42272
prist2Y = 18555

prist3Use = false
prist3X = 49141
prist3Y = 16056

prist4Use = false
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
skillBarDiff = 42 * avgGlobalY

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

medytacjaUse = false
medytacjaDelay = 12 * 60 * 1000 + 30 * 1000 + 3000
medytacjaTime = 0
medytacjaN = 7

buffyDelay = 23 * 60 * 1000 + 500
buffyMinDelay = 3600
buffyUse = true
buffyTime = 0

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
	
	while true do
		if not (GetMKeyState(uzadzenie) == 1) then
			eXecute = false
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

			if (buffyUse) then
				if (buffyTime + buffyDelay < GetRunningTime()) then
					Buffy()
				end
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
	OutputLCDMessage(lMsg, 600000)
end

function OnEvent(event, arg)
	
    --OutputLogMessage("event = %s, arg = %s, pause = %s, eXecute = %s\n", event, arg, tostring(pause), tostring(eXecute))

	local mkey = GetMKeyState(uzadzenie)
	
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
				prist1Use = true
				prist1X, prist1Y = GetMousePosition()
				LCDMessage("Priest 1 (" .. prist1X .. ", " .. prist1Y .. ")")

			elseif (arg == 5) then
				-- Prist 2
				prist2Use = true
				prist2X, prist2Y = GetMousePosition()
				LCDMessage("Priest 2 (" .. prist2X .. ", " .. prist2Y .. ")")

			elseif (arg == 6) then
				-- Prist 3
				prist3Use = true
				prist3X, prist3Y = GetMousePosition()
				LCDMessage("Priest 3 (" .. prist3X .. ", " .. prist3Y .. ")")

			elseif (arg == 7) then
				-- Prist 4
				prist4Use = true
				prist4X, prist4Y = GetMousePosition()
				LCDMessage("Priest 4 (" .. prist4X .. ", " .. prist4Y .. ")")

			elseif (arg == 8) then
				-- Prist 5
				prist5Use = true
				prist5X, prist5Y = GetMousePosition()
				LCDMessage("Priest 5 (" .. prist5X .. ", " .. prist5Y .. ")")

			elseif (arg == 9) then
				-- PT Buffer Active Char
				buffyActiveCharX, buffyActiveCharY = GetMousePosition()
				LCDMessage("Buffy (" .. buffyActiveCharX .. ", " .. buffyActiveCharY .. ")")
				OutputLogMessage("DiffX = %s, DiffY = %s\n", tostring(buffyActiveCharX), tostring(buffyActiveCharY))

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
				pristActive = 1
				RzucNaPrista()
			elseif (arg == 5) then
				prist2Use = true
				pristActive = 2
				RzucNaPrista()

			elseif (arg == 6) then
				prist3Use = true
				pristActive = 3
				RzucNaPrista()

			elseif (arg == 7) then
				prist4Use = true
				pristActive = 4
				RzucNaPrista()
				
			elseif (arg == 8) then
				prist5Use = true
				pristActive = 5
				RzucNaPrista()

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
		fod1Time = GetRunningTime() + math.random( 30*1000 )
	end
end

function RzucFod2()
	if (fod2X and fod2Y) then
		ReturnTo(fod2X, fod2Y)
		Sleep(100)
		PressAndReleaseMouseButton(1)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem FOD2"
		LCDMessage(msg)
		fod2Time = GetRunningTime() + math.random( 30*1000 )
	end
end

function RzucNaPrista()
	if (pristActive == 1) then
		RzucLa(prist1Use, prist1X, prist1Y)

	elseif (pristActive == 2) then
		RzucLa(prist2Use, prist2X, prist2Y)

	elseif (pristActive == 3) then
		RzucLa(prist3Use, prist3X, prist3Y)

	elseif (pristActive == 4) then
		RzucLa(prist4Use, prist4X, prist4Y)

	elseif (pristActive == 5) then
		RzucLa(prist5Use, prist5X, prist5Y)
	end
end

function RzucLa(pristUse, pristX, pristY)
	if (pristUse and pristX and pristY) then
		ReturnTo(pristX, pristY) 
		Sleep(100)
		PressAndReleaseMouseButton(3)
		local msg = GetDate("%X") .. " - Rzucilem na Prista: " .. tostring(pristActive)
		LCDMessage(msg)
		pristTime = GetRunningTime() + math.random( 60*1000 )
	end

	Sleep(300)
	
	if (pristActive < 5) then
		pristActive = pristActive + 1
	else
		pristActive = 1
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
			PressAndReleaseMouseButton(3)
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
		medytacjaTime = GetRunningTime() + math.random( 60*1000 )
	end
end

function GroupCure()
	if (maActiveSkillX and maActiveSkillY and groupCureN and skillBarDiff) then
		local mX = maActiveSkillX
		local mY = maActiveSkillY + (groupCureN * skillBarDiff)
		ReturnTo(mX, mY)
		Sleep(100)
		PressAndReleaseMouseButton(1)
		groupCureTime = GetRunningTime() + math.random( 2000 )
		maTime = groupRunningTime + groupCureMinDelay
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
			if (maTime > GetRunningTime()) then
				Sleep(maTime - GetRunningTime())
			end
			local cureX = maActiveSkillX
			local cureY = maActiveSkillY + (bNo * skillBarDiff)
			ReturnTo(cureX, cureY)
			Sleep(100)
			PressAndReleaseMouseButton(1)
			Sleep(100)
			maActiveSkillN = bNo
			
			ReturnTo(buffyActiveCharX , buffyActiveCharY)
			Sleep(100)
			PressAndReleaseMouseButton(3)
			maTime = GetRunningTime() + buffyMinDelay + math.random( 2000 )
			local msg = GetDate("%X") .. "Rzucilem: " .. buffyName[i]
			LCDMessage(msg)
		end
		buffyTime = GetRunningTime() + math.random( 2*60*1000 )
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
	--OutputLogMessage("DiffX = %s, DiffY = %s\n", tostring(math.abs(testX - pointX)/avgGlobalX), tostring(math.abs(testY - pointY)/avgGlobalY))
	
	if (hits < 4) then
		if (((math.abs(testX - pointX)/avgGlobalX) > 3) or (math.abs(testY - pointY)/avgGlobalY) > 3) then
			hits = hits + 1
			ReturnTo(pointX, pointY)
		end
	else
		hits = 0
	end
end