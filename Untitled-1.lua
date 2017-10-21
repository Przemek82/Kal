
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



fodDelay = 10 * 1000 + 1000
-- fodDelay = 40000

-- Uzywaj fod1 tak
fod1uzywaj = true
pk1X = 0
pk1Y = 0
pk2X = 0
pk2Y = 0
pk3X = 0
pk4Y = 0
fod1Time = 0


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
			-- i uzyty klawisz G
			if (arg == 1) then
				pk1X, pk1Y = GetMousePosition()
			elseif (arg == 2)
				pk2X, pk2Y = GetMousePosition()
			elseif (arg == 3)
				pk3X, pk3Y = GetMousePosition()
			end
		end
	end
	
end

function RzucFod1()
	
	Sleep(100)
	ReturnTo(pk1X, pk1Y)
	Sleep(100)

	PressAndReleaseMouseButton(1)

	Sleep(2000)

	PressAndReleaseMouseButton(1)

	Sleep(2000)
	
	ReturnTo(pk2X, pk2Y)
	Sleep(100)

	PressAndReleaseMouseButton(1)

	Sleep(2000)

	PressAndReleaseMouseButton(1)

	Sleep(2000)

	ReturnTo(pk3X, pk3Y)
	Sleep(100)

	PressAndReleaseMouseButton(1)

	fod1Time = GetRunningTime()
	
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