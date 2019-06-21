-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )

--TEST INITIALIZATION--------
local mime = require("mime")
local json = require("json")
-----END TEST---------------

local scene = composer.newScene()

--Screen size
screenW = display.contentWidth
screenH = display.contentHeight
screenCeneterX = display.contentCenterX
screenCeneterY = display.contentCenterY

-------Local Variables-----------------------------
local g = appGlobalVariables  --reference to global variables

local userNameField, passwordField --text input fields
local userNameText, passwordText --small text
local passVisibleFlag = false			--passwpd visible-invisible flag
local passVisibleImg, passInvisibleImg	--icons for pass visible-invisible

local textPopUp  --text displayed in message alert
local textTitle	--text of popup title


---------------LISTENERS------------------------------------------------------------------

--------Pop Up Ok BTN Listener------------------------------
local function okBtnListener( event )
   --do nothing
end
---End Of OK btn listener---------------------------------

---------------Listener function called after network request-------------------------
local function loginCallback(event)
		
	-- decodeData = json.decode( event.response )
	if ( event.isError ) then
		print( "Network error!!!!")
		textTitle = "ERROR"
		textPopUp = "Network Error!"
		--print ( "RESPONSE!!!: " .. textResponce)
	else 
		decodeData = json.decode( event.response )

		if (decodeData == nil) then
			print( "Unexpected  NIL Error")
			textTitle = "UNEXPECTED NIL ERROR"
			textPopUp = "Try Later"
		elseif	(decodeData.result == 403) then
			print( decodeData.message)
			textTitle = "DATABASE ERROR"
			textPopUp = decodeData.message
		elseif (decodeData.result == 404) then
			print( decodeData.message)
			textTitle = "ERROR"
			textPopUp = decodeData.message.."\n Try again."
		elseif (decodeData.result == 200) then
			print( decodeData.message)
			textTitle = "SUCCESS"
			textPopUp = decodeData.message.."\nYou can start new Incident."
			g.signedIn = true
			g.caltransID = decodeData.ID
			print( "CaltransID "..g.caltransID )
			composer.gotoScene( "newIncident", {effect = "slideRight", time = 300} )
			return
		else
			print( "Unexpected Error")
			textTitle = "UNEXPECTED ERROR"
			textPopUp = "Try Later"
		end
	end

	
	print ("response finish")

	local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
	-- do with data what you want...
	--return true
end
-----------End of TEST function----------------------------------------
--Textfield listeners-------------------------------------------------
--------usermname text litener----------
local function userNameFieldListener( event )

	if (event.phase == "editing") then
		userNameText.isVisible = true	--make small text above visible
		g.userName = event.target.text
        print( event.target.text )
	end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.userName = event.target.text
        print( event.target.text )
    end 

    if (event.phase == "submitted") then
    	 native.setKeyboardFocus( passwordField )
    end
end
----------password text litener
local function passwordFieldListener( event )

	if (event.phase == "editing") then
		passwordText.isVisible = true	--make small text above visible
		g.password = event.target.text
        print( event.target.text )
	end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.password = event.target.text
        print( event.target.text )
    end   

    if (event.phase == "submitted") then
    	 native.setKeyboardFocus( nil )
    end
end

------------BUTTON LISTENERS-----------------------------------------------------

-----SignUp Btn Listener-------------------------------------
local function signUpBtnListener( event)
    if event.phase == "began" then
        audio.play( click)
    end
    --Goes tto sign up screen-
    if event.phase == "ended"
        then 
         composer.gotoScene( "signUp", {effect = "slideLeft", time = 300} )
    end
end

-----Login Btn Listener-------------------------------------
local function loginBtnListener( event)
    if event.phase == "began" then
        audio.play( click)
    end
    --Goes tto sign up screen-
    if event.phase == "ended" then 
    	if (g.password == '' or g.userName == '' or g.password == nil or g.userName == nil) then
    		textTitle = "ERROR"
    		textPopUp = "A Username and password are required"
    		local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
    	else
        local URL = "http://gisa2.000webhostapp.com/login000.php?userName="..mime.b64(g.userName).."&password="..mime.b64(g.password)
    		
    	network.request( URL, "GET", loginCallback )
     	--composer.gotoScene( "signUp", {effect = "slideLeft", time = 300} )  
     	end  
    end
end

-----Skip Btn Listener-------------------------------------
local function skipBtnListener( event)
    if event.phase == "began" then
        audio.play( click)
    end
    --Goes tto sign up screen-
    if event.phase == "ended"
        then 
     composer.gotoScene( "newIncident", {effect = "slideLeft", time = 300} )
    end
end

---------Passwird visible/invisible btn listener----------------
local function passVisibleBtnListener( event )
	if event.phase == "began" then
        audio.play( click)
        if (passVisibleFlag) then
        	passVisibleImg.isVisible = false
        	passInvisibleImg.isVisible=true
        	passVisibleFlag = not (passVisibleFlag)
        	passwordField.isSecure = true
        else
        	passVisibleImg.isVisible = true
        	passInvisibleImg.isVisible = false
        	passVisibleFlag = not (passVisibleFlag)
        	passwordField.isSecure = false
        end

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

	---create Pass Visible Image-----------------------------------------------------
	passVisibleImg= display.newImageRect("passVisible.png",  20, 20 )
	passVisibleImg.anchorX , passVisibleImg.anchorY = 0.5, 0.5
	passVisibleImg.x = screenCeneterX*1.3
	passVisibleImg.y = screenH*0.5
	passVisibleImg.isVisible = false


	---create Pass Invisible Image-----------------------------------------------------
	passInvisibleImg= display.newImageRect("passInvisible.png",  20, 20)
	passInvisibleImg.anchorX , passInvisibleImg.anchorY = 0.5, 0.5
	passInvisibleImg.x = screenCeneterX*1.3
	passInvisibleImg.y = screenH*0.5

	-------------------CREATE BUTTONS-----------------------------------------------------------------
	-- Create the SKIP btn--------------------------------------------------
	local skipBtn = widget.newButton(
    {
        label = "SKIP",
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        
        onEvent = skipBtnListener,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 200,
        height = 40,
        cornerRadius = 8,
        fillColor = { default={0.8,0.8,1,1}, over={0,0.1,0.2,0.2} },
        strokeColor = { default={0.6,0.4,0.2,1}, over={0.8,0.8,1,1} },
        strokeWidth = 2
    })
    -- Center SKIP the button
	skipBtn.x = screenCeneterX
	skipBtn.y = screenH*0.15

	-- Create the LOGIN btn-------------------------------------------------
	local loginBtn = widget.newButton(
    {
        label = "LOGIN",
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 13,
        onEvent = loginBtnListener,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 80,
        height = 30,
        cornerRadius = 2,
        fillColor = { default={0.8,0.8,1,1}, over={0,0.1,0.2,0.2} },
        strokeColor = { default={0.6,0.4,0.2,1}, over={0.8,0.8,1,1} },
        strokeWidth = 2
    })
    -- Center Login button
	loginBtn.x = screenCeneterX*1.7
	loginBtn.y = screenH*0.4
	

	-- Create the SIGN UP btn-----------------------------------------------
	local 	signUpBtn = widget.newButton(
    {
        label = "SIGN UP",
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 13,
        onEvent = signUpBtnListener,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 80,
        height = 30,
        cornerRadius = 2,
        fillColor = { default={0.8,0.8,1,1}, over={0,0.1,0.2,0.2} },
        strokeColor = { default={0.6,0.4,0.2,1}, over={0.8,0.8,1,1} },
        strokeWidth = 2
    })
    -- Center Sign Up button
	signUpBtn.x = screenCeneterX*1.7
	signUpBtn.y = screenH*0.5


	-- Create the PassVisible btn-------------------------------------------------
	local passVisibleBtn = widget.newButton(
    {
        onEvent = passVisibleBtnListener,
        emboss = false,
        width = 30,
        height = 30,
        defaultFile = "BLANK_ICON.png"
    })
    -- Center Login button
	passVisibleBtn.x = screenCeneterX*1.3
	passVisibleBtn.y = screenH*0.5


	----------------------------END OF CRAETING BUTTONS------------------------------------------------------------------

	----------------------CREATING TEXTS ABOVE TEXTFIELDS--------------------------------------------------------------
	-- create userName text---------------------------------------------------
	userNameText = display.newText( "UserName", screenCeneterX*0.4, screenH*0.36, native.systemFont, 12)
	userNameText:setFillColor( 0 )	-- black
	userNameText.isVisible = false  --make invisible

	-- create password text---------------------------------------------------
	passwordText = display.newText( "Password", screenCeneterX*0.4, screenH*0.46, native.systemFont, 12)
	passwordText:setFillColor( 0 )	-- black
	passwordText.isVisible = false

	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( background )
	sceneGroup:insert( backgroundHead )
	sceneGroup:insert( title )
	sceneGroup:insert( skipBtn )
	sceneGroup:insert( loginBtn )
	sceneGroup:insert( signUpBtn )
	sceneGroup:insert( userNameText )
	sceneGroup:insert( passwordText)
	sceneGroup:insert( passVisibleBtn)
	sceneGroup:insert( passVisibleImg)
	sceneGroup:insert( passInvisibleImg)
	sceneGroup:insert( logo )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

		----------------------------	CRAETING  TEXTFIELDS----------------------------------------------------------------
		-----------UserName Textfield--------------------------------------
		userNameField = native.newTextField( screenCeneterX*0.7, screenH*0.4, 180, 30 )
		userNameField.placeholder = "Username"
		userNameField.inputType = "default"
		userNameField:addEventListener( "userInput", userNameFieldListener )

		--------Password Textfield-------------------------------------
		passwordField= native.newTextField( screenCeneterX*0.7, screenH*0.5, 180, 30 )
		passwordField.placeholder = "Password"
		passwordField.inputType = "default"
		passwordField:addEventListener( "userInput", passwordFieldListener )
		passwordField.isSecure = true

		sceneGroup:insert( userNameField )
		sceneGroup:insert( passwordField )

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

		----------Removing textfields---------------
		userNameField:removeSelf()
		userNameField = nil

		passwordField:removeSelf()
		passwordField = nil

		--making password visible button invisible
		passVisibleImg.isVisible = false
		passInvisibleImg.isVisible = true

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