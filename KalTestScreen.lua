-- buffyName 	= { "def",	"agi", "hp", "speed"}
steps 	= { 5, 10, 50, 100, 200, 300, 400, 500} 
-- buffyTT 	= { 	0,		0,	  0, 	  0} 
avgGlobalX = 1
avgGlobalY = 1

returnPointX = 0
returnPointY = 0

function OnEvent(event, arg)
	
    OutputLogMessage("event = %s, arg = %s\n", event, arg)

	local mkey = GetMKeyState()
	if (event == "G_RELEASED") then
		if (mkey == 3) then
			if (arg == 1) then
				TestMonitor()
			elseif (arg == 2) then
				returnPointX, returnPointY = GetMousePosition()
			elseif (arg == 3) then
				ReturnTo(returnPointX, returnPointY)
			end
		end
	end
	
end

function ReturnTo(pointX, pointY)
	local currentX = 0
	local currentY = 0
	local diffX = 0
	local diffY = 0
	local moveX = 1
	local moveY = 1
	
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
			--Sleep(1)
		end
		for i = diffX + 1, diffY do
			MoveMouseRelative(0, moveY)
			--Sleep(1)
		end
	else
		for i = 0, diffY do
			MoveMouseRelative(moveX, moveY)
			--Sleep(1)
		end
		for i = diffY + 1, diffX do
			MoveMouseRelative(moveX, 0)
			--Sleep(1)
		end
	end
	
	Sleep(100)
	local aX = 0
	local aY = 0
	aX, aY = GetMousePosition()
	OutputLogMessage("DiffX = %s, DiffY = %s\n", tostring(math.abs(aX - pointX)/avgGlobalX), tostring(math.abs(aY - pointY)/avgGlobalY))
	
end

function TestMonitor()
	local newX = 0
	local newY = 0
	local currentX = 0
	local currentY = 0
	local diffX = 0
	local diffY = 0
	local moveX = 1
	local moveY = 1
	local bigsteps = 20
	--local steps = 400
	local directionX = 1
	local directionY = 1
	local avgX = 0
	local avgY = 0
	local startX = 0
	local startY = 0
	startX, startY = GetMousePosition()
	
	avgGlobalX = 0
	avgGlobalY = 0
	
	for i = 1, 8 do
		for j = 1, bigsteps do
			Sleep(100)
			currentX, currentY = GetMousePosition()
			
			if ((currentX > 65535 - moveX) and (directionX == 1)) then
				directionX = -1
			elseif ((currentX < moveX) and (directionX == -1)) then
				directionX = 1
			end
			
			if ((currentY > 65535 - moveY) and (directionY == 1)) then
				directionY = -1
			elseif ((currentY <  moveY) and (directionY == -1)) then
				directionY = 1
			end
			
			for k = 1, steps[i] do
				MoveMouseRelative(directionX, directionY)
				-- Sleep(1)
			end
			
			Sleep(100)
			diffX, diffY = GetMousePosition()
			-- Sleep(50)
			moveX = math.abs(diffX - currentX)
			moveY = math.abs(diffY - currentY)
			newX = moveX / steps[i]
			newY = moveY / steps[i]
			avgX = avgX + newX
			avgY = avgY + newY
			-- diffX = math.floor((newX - currentX)/8.7)
			-- diffY = math.floor((newY - currentY)/46.5)
			--OutputLogMessage("startX = %s, startY = %s, finishX = %s, sinishY = %s, moveX = %s, moveY = %s, moveX/step = %s, moveY/step = %s\n", tostring(currentX), tostring(currentY), tostring(diffX), tostring(diffY), tostring(moveX), tostring(moveY), tostring(newX), tostring(newY))
			--OutputLogMessage("moveX = %s, moveY = %s, moveX/step = %s, moveY/step = %s\n", tostring(moveX), tostring(moveY), tostring(newX), tostring(newY))
		end
		
		OutputLogMessage("avgX = %s, avgY = %s\n", tostring(avgX/bigsteps), tostring(avgY/bigsteps))
		avgGlobalX = avgGlobalX + (avgX/bigsteps)
		avgGlobalY = avgGlobalY + (avgY/bigsteps)
		avgX = 0
		avgY = 0
		-- Sleep(50)
	end
	
	avgGlobalX = avgGlobalX / 8
	avgGlobalY = avgGlobalY / 8
	
	OutputLogMessage("avgGlobalX = %s, avgGlobalY = %s\n", tostring(avgGlobalX), tostring(avgGlobalY))
	
	ReturnTo(startX, startY)
end