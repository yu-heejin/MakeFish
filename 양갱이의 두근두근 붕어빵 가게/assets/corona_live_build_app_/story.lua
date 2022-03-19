-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view

	soundBGM( 4 )
	local size = 50
	if G.index == 2 then
		soundBGM( 7 )
		size = 30
	elseif  G.index == 3 then
		soundBGM( 6 )
		size = 30
	end

	local UIGroup = display.newGroup()
	local UI = {}

	if G.index == 1 then
		UI[1] = display.newRect(UIGroup, display.contentWidth/2, display.contentHeight/2, display.contentWidth, display.contentHeight)
		UI[1]:setFillColor(0)
	elseif G.index == 2 then
		UI[1] = display.newImage(UIGroup, "content/cartoon/sadback.png")
	else
		UI[1] = display.newImage(UIGroup, "content/cartoon/goodback.png")
	end
	UI[1].x, UI[1].y = display.contentWidth*0.5, display.contentHeight*0.5
 
	if G.index == 2 then
		UI[2] = display.newRoundedRect(UIGroup, display.contentWidth/2, display.contentHeight/2, display.contentWidth*0.8, display.contentHeight*0.95, 70)
	elseif G.index == 3 then
		UI[2] = display.newRoundedRect(UIGroup, display.contentWidth/2, display.contentHeight/2, display.contentWidth*0.9, display.contentHeight*0.75, 70)
	end
	
	local page = display.newGroup()
	local j = 1
	local s = {}
	local deltaX = 0
	local deltaY = 0

	if G.index ==  1 then
		local skip = display.newText(page, "SKIP", 1700, 200, G.fontBold, 70)

		local function skipTap( event )
			resetG()
			composer.gotoScene("mainGame")
		end

		skip:addEventListener("tap", skipTap )
	end

	if storyData[G.index].properties["x"] ~= nil then
		deltaX = tonumber(storyData[G.index].properties["x"])
	end
	if storyData[G.index].properties["y"] ~= nil then
		deltaY = tonumber(storyData[G.index].properties["y"])
	end
	sceneGroup:insert(UIGroup)
	local doing = 0
	local function story( event )
		if doing == 0 then
			doing = 1
			if storyData[G.index].child[j].properties["type"] == "image" then
				s[j] = display.newImage(page, storyData[G.index].child[j].value)
				s[j].x, s[j].y = display.contentWidth/2 + deltaX, display.contentHeight/2 + deltaY
				j = j + 1
				sceneGroup:insert(page)
				doing = 0
			elseif storyData[G.index].child[j].properties["type"] == "script" then
				local x = tonumber(storyData[G.index].child[j].properties["x"]) + deltaX
				local y = tonumber(storyData[G.index].child[j].properties["y"]) + deltaY
				local width = tonumber(storyData[G.index].child[j].properties["width"])
				local height = tonumber(storyData[G.index].child[j].properties["height"])
				local tempString = storyData[G.index].child[j].value
				print(tempString)
				local typingCount = 1
				local typingS = {}
				local color
				if storyData[G.index].child[j].properties["color"] == "w" then
					color = 1
				else
					color = 0
				end
				local function typing(event)
					display.remove(typingS)
					typingS = display.newText(page, tempString:sub(1, typingCount), x, y, width, height,
					G.fontLight, size)
					typingS.anchorX = 0
					typingS.anchorX = 0
					typingS:setFillColor(color)
					

					typingCount = typingCount + 1
				end
				timer.performWithDelay(1, typing, #tempString)
				j = j + 1
				sceneGroup:insert(page)
				doing = 0
			elseif storyData[G.index].child[j].properties["type"] == "Bold" then
				print("0")
				local x = tonumber(storyData[G.index].child[j].properties["x"]) + deltaX
				local y = tonumber(storyData[G.index].child[j].properties["y"]) + deltaY
				local width = tonumber(storyData[G.index].child[j].properties["width"])
				local height = tonumber(storyData[G.index].child[j].properties["height"])

				local tempString = storyData[G.index].child[j].value
				print(tempString)
				local typingCount = 1
				local typingS = {}
				if storyData[G.index].child[j].properties["color"] == "w" then
					color = 1
				else
					color = 0
				end
				local function typing(event)
					display.remove(typingS)
					typingS = display.newText(page, tempString:sub(1, typingCount), x, y, width, height, G.fontBold, size)
					typingS.anchorX = 0
					typingS:setFillColor(color)

					typingCount = typingCount + 1
				end
				timer.performWithDelay(1, typing, #tempString)
				j = j + 1
				sceneGroup:insert(page)
				doing = 0
			elseif storyData[G.index].child[j].properties["type"] == "Rect" then
				local rect = display.newRect(page, display.contentWidth/2, display.contentHeight/2, display.contentWidth, display.contentHeight)
				rect:setFillColor(0)
				rect.alpha = 0
				transition.fadeIn(rect, { time = 1000, onComplete =  function(  )
								rect.alpha = 1
							end})
				sceneGroup:insert(page)
				doing = 0
				j = j + 1
			elseif storyData[G.index].child[j].properties["type"] == "end" then
				if G.index ==  1 then
					local back = widget.newButton( 
						{
							defaultFile = "icon/back.png",  
							overFile = "icon/back2.png",
							width = 300*1.5, height = 120*1.5,
							onRelease = function(  )
								resetG()
								composer.gotoScene("mainGame")
							end
						} 
					)
					back.x, back.y = 1750, 900
					back.rotation = 180
					sceneGroup:insert(back)
					j = j + 1
				elseif G.index == 2 then
					local back = widget.newButton( 
						{
							defaultFile = "icon/back.png",  
							overFile = "icon/back2.png",
							width = 300*1.5, height = 120*1.5,
							onRelease = function(  )
								resetG()
								composer.gotoScene("replay")
							end
						} 
					)
					back.x, back.y = 1750, 900
					sceneGroup:insert(back)
					j = j + 1
				else
					local back = widget.newButton( 
						{
							defaultFile = "icon/back.png",  
							overFile = "icon/back2.png",
							width = 300*1.5, height = 120*1.5,
							onRelease = function(  )
								resetG()
								composer.gotoScene("endingCradit")
							end
						} 
					)
					back.x, back.y = 1750, 900
					sceneGroup:insert(back)
					j = j + 1
				end
			else
				print("?")
			end

		end
	end
	
	sceneGroup:addEventListener("tap", story)

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

	elseif phase == "did" then
		
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
		composer.removeScene("story")
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene