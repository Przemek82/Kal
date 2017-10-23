-- Czesc Krzysiu
-- hejka
-- M1
--	G1	Start

-- M2
--	G1	Nic
--	G2	Pozycja FOD 1
--	G3	Nic
--	G4	Pozycja Mag 1 Giant 1 
--	G5	Pozycja Mag 1 Giant 2
--	G6	Pozycja Mag 1 Giant 3
--	G7	Pozycja Mag 1 Giant 4
--	G8	Pozycja Mag 2 Giant 1
--	G9	Pozycja Mag 2 Giant 2
--	G10	Nic
--	G11	Nic
--	G12	Nic

-- M3
--	G1	Nic
--	G2	Uzyj FOD1
--	G3	Nic
--	G4	Mag 1 Rzuc shni na gianta 1
--	G5	Mag 1 Rzuc shni na gianta 2
--	G6	Mag 1 Rzuc shni na gianta 3
--	G7	Mag 1 Rzuc shni na gianta 4
--	G8	Mag 2 Rzuc shni na gianta 1
--	G9	Mag 2 Rzuc shni na gianta 2
--	G10	Rzuc Buffy \ usun

uzadzenie = "kb"
-- uzadzenie = "lhc"

--monitor19
avgGlobalX = 40.985023809524
avgGlobalY = 72.881376984127

-- wirtualka lekarz i tarcza
--avgGlobalX = 68.301785185185
--avgGlobalY = 109.21233333333
hits = 0

eXecute = true



fodDelay = 20 * 60 * 1000 + 1000
-- fodDelay = 40000

-- Uzywaj fod1 tak
fod1uzywaj = true
fod1X = 40515
fod1Y = 43482
fod1Time = 0
-- Uzywaj fod2 tak
fod2Use = false
fod2X = 16394
fod2Y = 43669
fod2Time = 0

giantDelay = 2 * 60 * 1000 + 30 * 1000
-- giantDelay = 5000

-- confifuracja maga1
mag1giantTime = 0
mag1giantActive = 0

mag1giant1Uzywaj = true
mag1giant1X = 27791
mag1giant1Y = 21928

mag1giant2Uzywaj = true
mag1giant2X = 42272
mag1giant2Y = 18555

mag1giant3Uzywaj = true
mag1giant3X = 49141
mag1giant3Y = 16056

mag1giant4Uzywaj = true
mag1giant4X = 60422
mag1giant4Y = 14431

mag1giant5Uzywaj = false
mag1giant5X = nil
mag1giant5Y = nil

-- confifuracja maga2
mag2giantTime = 0
mag2giantActive = 0

mag2giant1Uzywaj = true
mag2giant1X = 27791
mag2giant1Y = 21928

mag2giant2Uzywaj = true
mag2giant2X = 42272
mag2giant2Y = 18555

mag2giant3Uzywaj = false
mag2giant3X = 49141
mag2giant3Y = 16056

mag2giant4Uzywaj = false
mag2giant4X = 60422
mag2giant4Y = 14431

mag2giant5Uzywaj = false
mag2giant5X = nil
mag2giant5Y = nil


function RunScript()
    -- wyczysc ekranik
	ClearLCD()
	
	-- wyswietl informacje ze program dziala
	local msg = GetDate("%X") .. "   Program dziala - " .. GetRunningTime()
	
	-- start petli nieskonczonej
	while true do

		-- jezeli MKey rozny od M1 
		if not (GetMKeyState(uzadzenie) == 1) then

			-- ignoruj klawisze G
			eXecute = false
			
			-- wyskocz a petli nieskonczonej
			break
		end
		-- nie sprawdzaj caly czas M klawisza
		-- wykonaj petle 20 razy i dopiero sprawdz klawisz M
		for i = 1, 20 do
			-- jezeli fod1 ustawione na tak 
			if (fod1uzywaj) then
				-- jezeli fod1 czas ostatniego uzycia
				-- plus czas przeladowania skila
				-- jest mniejsze od czas teraz uzyj fod1
				if (fod1Time + fodDelay < GetRunningTime()) then
					RzucFod1()
				end
			end
			
			if (mag1giantTime + giantDelay < GetRunningTime()) then
				Mag1RzucNaGianta()
			end
			
			if (mag2giantTime + giantDelay < GetRunningTime()) then
				Mag2RzucNaGianta()
			end
			
			Sleep(50)
		end
	end
end

-- wypisz wiadomosc na ekraniku
function LCDMessage(lMsg)
	OutputLCDMessage(lMsg, 600000)
end

-- funkcja wykonywana przez klawisze G i M 
function OnEvent(event, arg)
	
	-- wypisuje logi
    -- OutputLogMessage("event = %s, arg = %s, pause = %s, eXecute = %s\n", event, arg, tostring(pause), tostring(eXecute))

	-- pobierz status klawisza M
	local mkey = GetMKeyState(uzadzenie)
	
	-- jezeli wykonaj klawiszeG ustawione na ignoruj i M1 aktywny 
	if (eXecute == false and mkey == 1) then
		-- ustaw wykonuj klawisze G na tak
		eXecute = true
		-- przy prubie wcisniecia klawisza G i fladze eXecute ustawionej na ignoruj
	elseif (eXecute == false) then
		-- wyswietl komunikat 
		LCDMessage("klawisz G zignorowany")
	end
	
	-- po uzyciu klawisza G i fladze eXecute ustawionej na wykonaj
	-- wykonaj funkcje przypisama do klawisza
	if (event == "G_RELEASED" and eXecute) then

		-- jezeli klawisz M1 aktywny 
		if (mkey == 1) then
			-- i uzyty klawisz G1 
			if (arg == 1) then
				-- wlacz skrypt
				RunScript()
			end

		-- jezeli klawisz M2 aktywny
		elseif (mkey == 2) then
			-- i uzyty klawisz G2 
			if (arg == 2) then
				-- zapisz pozycjekursora na ekranie do  FOD1
				fod1X, fod1Y = GetMousePosition()
				LCDMessage("FOD1 (" .. fod1X .. ", " .. fod1Y .. ")")
			
				-- przypisujemy Magowi1 pozycje Giantow  1-4
			elseif (arg == 4) then
				-- Mag1 Giant1
				mag1giant1X, mag1giant1Y = GetMousePosition()
				LCDMessage("Giant 1 (" .. mag1giant1X .. ", " .. mag1giant1Y .. ")")
			elseif (arg == 5) then
				-- Mag1 Giant2
				mag1giant2X, mag1giant2Y = GetMousePosition()
				LCDMessage("Giant 2 (" .. mag1giant2X .. ", " .. mag1giant2Y .. ")")
			elseif (arg == 6) then
				-- Mag1 Giant3
				mag1giant3X, mag1giant3Y = GetMousePosition()
				LCDMessage("Giant 3 (" .. mag1giant3X .. ", " .. mag1giant3Y .. ")")
			elseif (arg == 7) then
				-- Mag1 Giant4
				mag1giant4X	, mag1giant4Y = GetMousePosition()
				LCDMessage("Giant 4 (" ..mag1giant4X .. ", " .. mag1giant4Y .. ")")
			elseif (arg == 8) then
				-- Mag2 Giant1
				mag2giant1X, mag2giant1Y = GetMousePosition()
				LCDMessage("Giant 1 (" .. mag2giant1X .. ", " .. mag2giant1Y .. ")")
			elseif (arg == 9) then
				-- Mag2 Giant2
				mag2giant2X, mag2giant2Y = GetMousePosition()
				LCDMessage("Giant 2 (" .. mag2giant2X .. ", " .. mag2giant2Y .. ")")
				
			elseif (arg == 10) then
				-- MA Active Skill
				
			elseif (arg == 11) then
				-- PT Herci
				
			elseif (arg == 12) then
				-- PT Freskos
				
			end
			
		elseif (mkey == 3) then
			if (arg == 2) then
				fod1uzywaj = true
				RzucFod1()
			
			elseif (arg == 4) then
				mag1giant1Uzywaj = true
				Mag1RzucNaGianta1()
			elseif (arg == 5) then
				mag1giant2Uzywaj = true
				Mag1RzucNaGianta2()
			elseif (arg == 6) then
				mag1giant3Uzywaj = true
				Mag1RzucNaGianta3()
			elseif (arg == 7) then
				mag1giant4Uzywaj = true
				Mag1RzucNaGianta4()
			elseif (arg == 8) then
				mag2giant1Uzywaj = true
				Mag2RzucNaGianta1()
			elseif (arg == 9) then
				mag2giant2Uzywaj = true
				Mag2RzucNaGianta2()	
			
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
		fod1Time = GetRunningTime()  + math.random( 30*1000 )
	end
end



function Mag1RzucNaGianta()
	if (mag1giantActive == 0 or mag1giantActive == 5) then
		Mag1RzucNaGianta1()
	elseif (mag1giantActive == 1) then
		Mag1RzucNaGianta2()
	elseif (mag1giantActive == 2) then
		Mag1RzucNaGianta3()
	elseif (mag1giantActive == 3) then
		Mag1RzucNaGianta4()
	elseif (mag1giantActive == 4) then
		Mag1RzucNaGianta5()
	end
end

function Mag1RzucNaGianta1()
	if (mag1giant1Uzywaj and mag1giant1X and mag1giant1Y) then
		ReturnTo(mag1giant1X, mag1giant1Y) 
		Sleep(100)
		PressAndReleaseMouseButton(3)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem Giant 1"
		LCDMessage(msg)
		mag1giantTime = GetRunningTime() + math.random( 60*1000 )
		mag1giantActive = 1
	else
		Mag1RzucNaGianta2()
	end
end

function Mag1RzucNaGianta2()
	if (mag1giant2Uzywaj and mag1giant2X and mag1giant2Y) then
		ReturnTo(mag1giant2X, mag1giant2Y) 
		Sleep(100)
		PressAndReleaseMouseButton(3)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem Giant 2"
		LCDMessage(msg)
		mag1giantTime = GetRunningTime() + math.random( 60*1000 )
		mag1giantActive = 2
	else
		Mag1RzucNaGianta3()
	end
end

function Mag1RzucNaGianta3()
	if (mag1giant3Uzywaj and mag1giant3X and mag1giant3Y) then
		ReturnTo(mag1giant3X, mag1giant3Y) 
		Sleep(100)
		PressAndReleaseMouseButton(3)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem Giant 3"
		LCDMessage(msg)
		mag1giantTime = GetRunningTime() + math.random( 60*1000 )
		mag1giantActive = 3
	else
		Mag1RzucNaGianta4()
	end
end

function Mag1RzucNaGianta4()
	if (mag1giant4Uzywaj and mag1giant4X and mag1giant4Y) then
		ReturnTo(mag1giant4X, mag1giant4Y) 
		Sleep(100)
		PressAndReleaseMouseButton(3)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem Giant 4"
		LCDMessage(msg)
		mag1giantTime = GetRunningTime() + math.random( 60*1000 )
		mag1giantActive = 4
	else
		Mag1RzucNaGianta5()
	end
end

function Mag1RzucNaGianta5()
	if (mag1giant5Uzywaj and mag1giant5X and mag1giant5Y) then
		ReturnTo(mag1giant5X, mag1giant5Y) 
		Sleep(100)
		PressAndReleaseMouseButton(3)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem Giant 5"
		LCDMessage(msg)
		mag1giantTime = GetRunningTime() + math.random( 60*1000 )
		mag1giantActive = 5
	else
		Mag1RzucNaGianta1()
	end
end

-- konentarz Mag2
function Mag2RzucNaGianta()
	if (mag2giantActive == 0 or mag2giantActive == 5) then
		Mag2RzucNaGianta1()
	elseif (mag2giantActive == 1) then
		Mag2RzucNaGianta2()
	elseif (mag2giantActive == 2) then
		Mag2RzucNaGianta3()
	elseif (mag2giantActive == 3) then
		Mag2RzucNaGianta4()
	elseif (mag2giantActive == 4) then
		Mag2RzucNaGianta5()
	end
end

function Mag2RzucNaGianta1()
	if (mag2giant1Uzywaj and mag2giant1X and mag2giant1Y) then
		ReturnTo(mag2giant1X, mag2giant1Y) 
		Sleep(100)
		PressAndReleaseMouseButton(3)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem Giant 1"
		LCDMessage(msg)
		mag2giantTime = GetRunningTime() + math.random( 60*1000 )
		mag2giantActive = 1
	else
		Mag2RzucNaGianta2()
	end
end

function Mag2RzucNaGianta2()
	if (mag2giant2Uzywaj and mag2giant2X and mag2giant2Y) then
		ReturnTo(mag2giant2X, mag2giant2Y) 
		Sleep(100)
		PressAndReleaseMouseButton(3)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem Giant 2"
		LCDMessage(msg)
		mag2giantTime = GetRunningTime() + math.random( 60*1000 )
		mag2giantActive = 2
	else
		Mag2RzucNaGianta3()
	end
end

function Mag2RzucNaGianta3()
	if (mag2giant3Uzywaj and mag2giant3X and mag2giant3Y) then
		ReturnTo(mag2giant3X, mag2giant3Y) 
		Sleep(100)
		PressAndReleaseMouseButton(3)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem Giant 3"
		LCDMessage(msg)
		mag2giantTime = GetRunningTime() + math.random( 60*1000 )
		mag2giantActive = 3
	else
		Mag2RzucNaGianta4()
	end
end

function Mag2RzucNaGianta4()
	if (mag2giant4Uzywaj and mag2giant4X and mag2giant4Y) then
		ReturnTo(mag2giant4X, mag2giant4Y) 
		Sleep(100)
		PressAndReleaseMouseButton(3)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem Giant 4"
		LCDMessage(msg)
		mag2giantTime = GetRunningTime() + math.random( 60*1000 )
		mag2giantActive = 4
	else
		Mag2RzucNaGianta5()
	end
end

function Mag2RzucNaGianta5()
	if (mag2giant5Uzywaj and mag2giant5X and mag2giant5Y) then
		ReturnTo(mag2giant5X, mag2giant5Y) 
		Sleep(100)
		PressAndReleaseMouseButton(3)
		--ClearLCD()
		local msg = GetDate("%X") .. " - Rzucilem Giant 5"
		LCDMessage(msg)
		mag2giantTime = GetRunningTime() + math.random( 60*1000 )
		mag2giantActive = 5
	else
		Mag2RzucNaGianta1()
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