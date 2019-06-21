-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )


local scene = composer.newScene()

--Screen size
screenW = display.contentWidth
screenH = display.contentHeight
screenCeneterX = display.contentCenterX
screenCeneterY = display.contentCenterY

-------Local Variables-----------------------------
local g = appGlobalVariables  --reference to global variables


---------------LISTENERS------------------------------------------------------------------

------------BUTTON LISTENERS-----------------------------------------------------
-----SignUp Btn Listener-------------------------------------
local function newIncidentBtnListener( event)
    if event.phase == "began" then
        audio.play( click)
    end
    --Goes tto sign up screen-
    if event.phase == "ended"
        then 
         composer.gotoScene( "incidentMain", {effect = "slideLeft", time = 300} )
    end
end

-----Login Btn Listener-------------------------------------
local function savedIncidentBtnListener( event)
    if event.phase == "began" then
        audio.play( click)
    end
    --Goes tto sign up screen-
    if event.phase == "ended"
        then 
     	composer.gotoScene( "incidentMain", {effect = "slideLeft", time = 300} )    
    end
end


------------------END OF LISTENERS FUNCIONS--------------------------------------------------
	

----------------------START OF SCENE CREATION------------------------------------------------
	function scene:create( event )
	local sceneGroup = self.view
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	
	-- create a white background to fill screen and blue header ------------------
	local background = display.newRect( screenCeneterX, screenCeneterY, screenW*1.2, screenH *1.2)
	background:setFillColor( 1 )	-- white
	local backgroundHead = display.newRect( screenW/2, 0, screenW*1.2, screenH *0.17)
	backgroundHead:setFillColor( 0.1,0.2,0.8,0.8 )	-- blue


	-------------------CREATING LOGO TITLE, and VISIBLE/INVISIBLE IMAGES FOR PASS FIELD--------------
	-- create GISAproject title---------------------------------------------------
	local title = display.newText( "GISAproject", 60, 35, native.systemFont, 16 )
	title:setFillColor( 1 )	-- black

	---create CalTrans LOGO-----------------------------------------------------
	local logo= display.newImageRect("caltranslogo.png",  screenW*0.25,screenW*0.25*201/251 )
	logo.anchorX , logo.anchorY = 0.5, 0.5
	logo.x = screenW/2
	logo.y = screenH/3.5


	-------------------CREATE BUTTONS-----------------------------------------------------------------
	-- Create the New Incident btn--------------------------------------------------
	local newIncidentBtn = widget.newButton(
    {
        label = "NEW INCIDENT",
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        
        onEvent = newIncidentBtnListener,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 200,
        height = 60,
        cornerRadius = 8,
        fillColor = { default={0.8,0.8,1,1}, over={0,0.1,0.2,0.2} },
        strokeColor = { default={0.6,0.4,0.2,1}, over={0.8,0.8,1,1} },
        strokeWidth = 2
    })
    -- Center New Incident the button
	newIncidentBtn.x = screenCeneterX
	newIncidentBtn.y = screenH*0.45

	-- Create the Saved Incident btn-------------------------------------------------
	local savedIncidentBtn = widget.newButton(
    {
        label = "SAVED INCIDENT",
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
       
        onEvent = savedIncidentBtnListener,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 200,
        height = 60,
        cornerRadius = 8,
        fillColor = { default={0.8,0.8,1,1}, over={0,0.1,0.2,0.2} },
        strokeColor = { default={0.6,0.4,0.2,1}, over={0.8,0.8,1,1} },
        strokeWidth = 2
    })
    -- Center savedIncident button
	savedIncidentBtn.x = screenCeneterX
	savedIncidentBtn.y = screenH*0.6
	
	----------------------------END OF CRAETING BUTTONS------------------------------------------------------------------


	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( background )
	sceneGroup:insert( backgroundHead )
	sceneGroup:insert( title )
	sceneGroup:insert( newIncidentBtn )
	sceneGroup:insert( savedIncidentBtn )
	sceneGroup:insert( logo )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
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