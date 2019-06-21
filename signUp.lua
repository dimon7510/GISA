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

local firstNameField, lastNameField, caltransIDField, phoneField, emailField, userNameField, passwordField --text input fields
local firstNameText, lastNameText,  phoneText, emailText, caltransIDText, userNameText, passwordText --small text
local firstNameTextNo, lastNameTextNo,  phoneTextNo, emailTextNo, caltransIDTextNo, userNameTextNo, passwordTextNo --small text
local signUpBtn, cancelBtn, passVisibleBtn --buttons declaration
local scrollView  --scrol view declaration
local passVisibleImg, passInvisibleImg	--icons for pass visible-invisible
local passVisibleFlag = false			--passwpd visible-invisible flag
local allFieldsFill 			--flag to indicate if all fields are fulled out
local footerGroup 				--footer group with buttons

--TEST VARIABLES---------------------
local playerName =nil
local password = nil
local decodeData 	--decoded data from network request

---END TEST VARIABLES-----------------

----------------LOCAL FUNCTIONS--------------------------------------------------------
----------function "nullyfyTextFields"  assignes nil values to text fields and deletes texts above and below textfields----
local function nullifyTextFields(  )
	g.firstName, g.lastName, g.caltransID, g.phone, g.email, g.userName, g.password = nil, nil, nil, nil, nil, nil, nil

	firstNameText.isVisible, firstNameTextNo.isVisible = false, false
	lastNameText.isVisible, lastNameTextNo.isVisible = false, false
	caltransIDText.isVisible, caltransIDTextNo.isVisible = false, false
	phoneText.isVisible, phoneTextNo.isVisible = false, false
	emailText.isVisible, emailTextNo.isVisible = false, false
	userNameText.isVisible, userNameTextNo.isVisible = false, false
	passwordText.isVisible, passwordTextNo.isVisible = false, false
end
------------------END OF LOCAL FUNCTIONS------------------------------------------------


---------------LISTENERS------------------------------------------------------------------
--------Pop Up Ok BTN Listener------------------------------
local function okBtnListener( event )
   --do nothing
end
---End Of OK btn listener---------------------------------


---------TEST LISTENER------------------------------------------------------------------------
local function networkListener( event )
    if ( event.isError ) then
        print( "Network error - download failed: ", event.response )
    elseif ( event.phase == "began" ) then
        print( "Progress Phase: began" )
    elseif ( event.phase == "ended" ) then
        print( "Displaying response image file" )
        myImage = display.newImage( event.response.filename, event.response.baseDirectory, 60, 40 )
        myImage.alpha = 0
        transition.to( myImage, { alpha=1.0 } )
    end
end
--------------END OF TEST LISTENER-----------------------------------------------------------


-------------------------------TEXTFIELD LISTENERS-------------------------------------------------
----------------First Name textfield Listener-----------------------------
local function firstNameFieldListener( event )

	if (event.phase == "editing") then
		firstNameText.isVisible = true	--make small text above visible
		g.firstName = event.target.text
		print( event.target.text )
	end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.firstName = event.target.text
        print( "firstName: " .. g.firstName )
    end 

    if (event.phase == "submitted") then
    	 native.setKeyboardFocus( lastNameField)
    end
end
-----------------------------------------------------------------------

--------Last Name  text field litener--------------------------------
local function lastNameFieldListener( event )

	if (event.phase == "editing") then
		lastNameText.isVisible = true	--make small text above visible
		g.lastName = event.target.text
        print( event.target.text )
	end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.lastName = event.target.text
        print( "lastName: " .. g.lastName )
    end 

    if (event.phase == "submitted") then
    	 native.setKeyboardFocus( caltransIDField)
    end
end
----------------------------------------------------------------------

------Caltrans ID text field listener--------------------------------
local function caltransIDFieldListener( event )

	if (event.phase == "editing") then
		caltransIDText.isVisible = true	--make small text above visible
		g.caltransID = event.target.text
        print( event.target.text )
	end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.caltransID = event.target.text
        print( "caltransID: " .. g.caltransID )
    end 

    if (event.phase == "submitted") then
    	 native.setKeyboardFocus( phoneField)
    end
end
----------------------------------------------------------------------

---------Phone text field listener-------------------------------------
local function phoneFieldListener( event )

	if ( event.phase == "began" ) then
			--lifting up buttons and scroolview
        	scrollView:scrollToPosition( {y = -screenH*0.1} ) 
        	footerGroup.y = footerGroup.y - screenH*0.1
    end

	if (event.phase == "editing") then
		phoneText.isVisible = true	--make small text above visible
		g.phone = event.target.text
        print( event.target.text )
	end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.phone = event.target.text
        print( "phone: " .. g.phone )
           --bringing scroolview and buttons back
	        scrollView:scrollToPosition( {y = 0} )
	        footerGroup.y = screenH
    end 

    if (event.phase == "submitted") then
    	 native.setKeyboardFocus( emailField)
    end
end

------------ Email text field Listener--------------------------------
local function emailFieldListener( event )

	if ( event.phase == "began" ) then
			--lifting up buttons and scroolview
        	scrollView:scrollToPosition( {y = -screenH*0.2} ) 
        	footerGroup.y = footerGroup.y - screenH*0.2
    end

	if (event.phase == "editing") then
		emailText.isVisible = true	--make small text above visible
		g.email = event.target.text
        print( event.target.text )
	end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.email = event.target.text
        print( "email: " .. g.email )
	        --bringing scroolview and buttons back
	        scrollView:scrollToPosition( {y = 0} )
	        footerGroup.y = screenH
    end 

    if (event.phase == "submitted") then
    	 native.setKeyboardFocus( userNameField)
    end
end
-----------------------------------------------------------------------

----------UserName text field Listener----------------------------------
local function userNameFieldListener( event )
	if ( event.phase == "began" ) then
			--lifting up buttons and scroolview
        	scrollView:scrollToPosition( {y = -screenH*0.3} ) 
        	footerGroup.y = footerGroup.y - screenH*0.3
    end

	if (event.phase == "editing") then
		userNameText.isVisible = true	--make small text above visible
		g.userName = event.target.text
        print( event.target.text )
	end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.userName = event.target.text
        print( "userName: " .. g.userName )
       		 --bringing scroolview and buttons back
	        scrollView:scrollToPosition( {y = 0} )
	        footerGroup.y = screenH
    end 

    if (event.phase == "submitted") then
    	 native.setKeyboardFocus( passwordField)
    end
end
------------------------------------------------------------------------

----------Password Text field Listener---------------------------------
local function passwordFieldListener( event )

	if ( event.phase == "began" ) then
			--lifting up buttons and scroolview
        	scrollView:scrollToPosition( {y = -screenH*0.4} ) 
        	footerGroup.y = footerGroup.y - screenH*0.4
    end

	if (event.phase == "editing") then
		passwordText.isVisible = true	--make small text above visible
		g.password = event.target.text
        print( event.target.text )
	end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.password = event.target.text
        print( "password: " .. g.password )
         	--bringing scroolview and buttons back
	        scrollView:scrollToPosition( {y = 0} )
	        footerGroup.y = screenH
    end 

    if (event.phase == "submitted") then
    	 native.setKeyboardFocus( nil )
    end
end
------------------END OF TEXT FIELD LISTENERS-------------------------------------

---------------TEST function called after network request-------------------------
local function signUpCallback(event)
	local textPopUp  --text displayed in message alert
	local textTitle	--text of popup title
	
	-- decodeData = json.decode( event.response )
	if ( event.isError ) then
		print( "Network error!!!!")
		textTitle = "ERROR"
		textPopUp = "Network Error!"
		--print ( "RESPONSE!!!: " .. textResponce)
	else 
		decodeData = json.decode( event.response )

		--print ("code"..decodeData.result)
		--print ("message"..decodeData.message)

		if (decodeData == nil) then
			print( "Unexpected Nil Error!")
			textTitle = "UNEXPECTED NIL ERROR"
			textPopUp = "Try Later"
		elseif	(decodeData.result == 403) then
			print( decodeData.message)
			textTitle = "DATABASE ERROR"
			textPopUp = decodeData.message
		elseif (decodeData.result == 405) then
			print( decodeData.message)
			textTitle = "ERROR"
			textPopUp = decodeData.message.."\nThere is account associated with your caltrans ID."
		elseif (decodeData.result == 406) then
			print( decodeData.message)
			textTitle = "ERROR"
			textPopUp = decodeData.message.."\nChoose another username."
		elseif (decodeData.result == 200) then
			print( decodeData.message)
			textTitle = "SUCCESS"
			textPopUp = decodeData.message.."\nYou can sign in now."
			composer.gotoScene( "login", {effect = "slideRight", time = 300} )
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


------------BUTTON LISTENERS-----------------------------------------------------

-----SignUp Btn Listener-------------------------------------
local function signUpBtnListener( event)
	allFieldsFill = true --assume all fields are filled out

    if event.phase == "began" then
        audio.play( click)
    end

    --Goes tto sign up screen-
    if event.phase == "ended" then 
    	--check if firstname  is empty field
    	print( "Sign Up clicked" )

    	if (g.firstName == nil or  g.firstName =="")  then
    		print( "firstname field =  nil")
    		firstNameTextNo.isVisible = true
    		allFieldsFill = false
    		native.setKeyboardFocus( firstNameField )
    	else 
    		print( "firstname field = " .. g.firstName)
    		firstNameTextNo.isVisible = false
    	end

		--check if lastname is empty field
    	if (g.lastName == nil or g.lastName =="") then
    		print( "lastName field =  nil")
    		lastNameTextNo.isVisible = true
    		allFieldsFill = false
    		native.setKeyboardFocus( lastNameField )
    	else 
    		print( "lastName field = "..g.lastName)
    		lastNameTextNo.isVisible = false
    	end

    	--check if Caltrans ID is empty field
    	if (g.caltransID == nil or g.caltransID == "") then
    		print( "caltrans field =  nil")
    		caltransIDTextNo.isVisible = true
    		allFieldsFill = false
    		native.setKeyboardFocus( caltransIDField )
    	else 
    		print("caltrans ID field = "..g.caltransID)
    		caltransIDTextNo.isVisible = false
    	end

    	--check if phone is empty field
    	if (g.phone == nil or g.phone=="") then
    		print( "phone field =  nil")
    		phoneTextNo.isVisible = true
    		allFieldsFill = false
    		native.setKeyboardFocus( phoneField )
    	else 
    		print("phone field = "..g.phone)
    		phoneTextNo.isVisible = false
    	end

    	--check if email is empty field
    	if (g.email == nil  or g.email == "") then
    		print( "email field =  nil")
    		emailTextNo.isVisible = true
    		allFieldsFill = false
    		native.setKeyboardFocus( emailField )
    	else 
    		print( "email field ="..g.email)
    		emailTextNo.isVisible = false
    	end

    	--check if userName is empty field
    	if (g.userName == nil or g.userName == "")  then
    		print( "userName field =  nil")
    		userNameTextNo.isVisible = true
    		allFieldsFill = false
    		native.setKeyboardFocus( userNameField )
    	else 
    		print( "userName field = ".. g.userName)
    		userNameTextNo.isVisible = false
    	end

    	--check if password is empty field
    	if (g.password == nil or g.password == "") then
    		print( "password field =  nil")
    		passwordTextNo.isVisible = true
    		allFieldsFill = false
    		native.setKeyboardFocus( passwordField )
    	else 
    		print( "password field =".. g.password)
    		passwordTextNo.isVisible = false
    	end

    		-- send sign up data to database and go to login screen if all field are filled out 
    	if allFieldsFill then
    		--SEND DATA TO DATABASE PERSONAL INFORMATION TABLE-

    		-----------TEST CASE---------------------------
    		local URL = "http://gisa2.000webhostapp.com/signUp000.php?userName="..mime.b64(g.userName).."&password="..mime.b64(g.password).."&firstName="..mime.b64(g.firstName).."&lastName="..mime.b64(g.lastName).."&caltransID="..mime.b64(g.caltransID).."&phone="..mime.b64(g.phone).."&email="..mime.b64(g.email)
    		
    		network.request( URL, "GET", signUpCallback )
    		
    		--[[
    		local params = {}
			params.progress = true
 
			network.download(
			    "http://docs.coronalabs.com/images/simulator/image-mask-base2.png",
			    "GET",
			    networkListener,
			    params,
			    "helloCopy.png",
			    "C:\\"
			)
	]]-----------------------


			-------END OF TEST CASE------------------------
			
         	--composer.gotoScene( "login", {effect = "slideRight", time = 300} )
        end
    end
end

-----Cancel Btn Listener-------------------------------------
local function cancelBtnListener( event)
    if event.phase == "began" then
        audio.play( click)
    end

    --Goes tto sign up screen-
    if event.phase == "ended" then
    	nullifyTextFields() --nullifying text field global values
		composer.gotoScene( "login", {effect = "slideRight", time = 300} )     
    end
end

---------PASSWORD VISIBLE/iNVISIBLE btn listener----------------
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
---------------END OF BUTTON LISTENERS------------------------------------------------

------------------END OF LISTENERS FUNCIONS--------------------------------------------------
	

----------------------START OF SCENE CREATION------------------------------------------------
	function scene:create( event )
	local sceneGroup = self.view
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	
	-- create a WHITE BACKGROUND to fill screen and blue header and white footer attached to buttons ------------------
	local background = display.newRect( screenCeneterX, screenCeneterY, screenW*1.2, screenH *1.2)
	background:setFillColor( 1 )	-- white
	--blue header--------------------
	local backgroundHead = display.newRect( screenW/2, 0, screenW*1.2, screenH *0.17)
	backgroundHead:setFillColor( 0.1,0.2,0.8,0.8 )	-- blue

	---CREATE FOOTER GROUP-------------------------------------------------------
	footerGroup = display.newGroup( )
	footerGroup.anchorX, footerGroup.anchorY = 0.5, 0.5
	footerGroup.x, footerGroup.y =  screenW/2, screenH

	--white footer rectangle and insert in footer group-------------------
	local whiteFooter = display.newRect(footerGroup, 0, 0, screenW*1.2, screenH *0.4)
	whiteFooter:setFillColor( 0.1,0.2,0.8, 1 )	-- blue


	--------------CREATE SCROOL WIDJET--------------------------------------
	scrollView = widget.newScrollView(
    {
        top = screenH*0.1,
        left = 0,
        width = screenW,
        height = screenH*0.7,
        listener = scrollListener,
        print( "scroll created" )
    }
	)


	-------------------CREATING LOGO TITLE, and VISIBLE/INVISIBLE IMAGES FOR PASS FIELD--------------
	-- create GISAproject title---------------------------------------------------
	local title = display.newText( "GISAproject", 60, 35, native.systemFont, 16 )
	title:setFillColor( 1 )	-- black

	-- TEST return status text field-----------
	local labelStatus = display.newText( "", 60, 100, native.systemFont, 16 )


	---create Pass Visible Image-----------------------------------------------------
	passVisibleImg= display.newImageRect("passVisible.png",  20, 20 )
	passVisibleImg.anchorX , passVisibleImg.anchorY = 0.5, 0.5
	passVisibleImg.x = screenCeneterX*1.7
	passVisibleImg.y = screenH*0.65
	passVisibleImg.isVisible = false
	scrollView:insert(passVisibleImg)


	---create Pass Invisible Image-----------------------------------------------------
	passInvisibleImg= display.newImageRect("passInvisible.png",  20, 20)
	passInvisibleImg.anchorX , passInvisibleImg.anchorY = 0.5, 0.5
	passInvisibleImg.x = screenCeneterX*1.7
	passInvisibleImg.y = screenH*0.65
	scrollView:insert(passInvisibleImg)


	----------------------CREATING TEXTS ABOVE TEXTFIELDS--------------------------------------------------------------
	--create FirstName text--------------------------------------------------
	firstNameText = display.newText( "First Name", screenCeneterX*0.5, screenH*0, native.systemFont, 12)
	firstNameText.anchorX, firstNameText.anchorY = 0,0
	firstNameText:setFillColor( 0 )	-- black
	firstNameText.isVisible = false  --make invisible
	scrollView:insert(firstNameText)

	------create last Name text above---------------------------------------
	lastNameText = display.newText( "Last Name", screenCeneterX*0.5, screenH*0.1, native.systemFont, 12)
	lastNameText.anchorX, lastNameText.anchorY = 0,0
	lastNameText:setFillColor( 0 )	-- black
	lastNameText.isVisible = false  --make invisible
	scrollView:insert(lastNameText)

	-------create CaltransID text above--------------------------------------
	caltransIDText = display.newText( "CalTrans ID", screenCeneterX*0.5, screenH*0.2, native.systemFont, 12)
	caltransIDText.anchorX, caltransIDText.anchorY = 0,0
	caltransIDText:setFillColor( 0 )	-- black
	caltransIDText.isVisible = false  --make invisible
	scrollView:insert(caltransIDText)

	-------create phone text above------------------------------------------
	phoneText = display.newText( "Phone", screenCeneterX*0.5, screenH*0.3, native.systemFont, 12)
	phoneText.anchorX, phoneText.anchorY = 0,0
	phoneText:setFillColor( 0 )	-- black
	phoneText.isVisible = false  --make invisible
	scrollView:insert(phoneText)

	-----create Email text above--------------------------------------------
	emailText = display.newText( "Email", screenCeneterX*0.5, screenH*0.4, native.systemFont, 12)
	emailText.anchorX, emailText.anchorY = 0,0
	emailText:setFillColor( 0 )	-- black
	emailText.isVisible = false  --make invisible
	scrollView:insert(emailText)

	------create Username text above---------------------------------------
	userNameText = display.newText("Username", screenCeneterX*0.5, screenH*0.5, native.systemFont, 12)
	userNameText.anchorX, userNameText.anchorY = 0,0
	userNameText:setFillColor(0) --black
	userNameText.isVisible = false  --make invisible
	scrollView:insert(userNameText)

	-----create Passsword text above--------------------------------------------
	passwordText = display.newText( "Password", screenCeneterX*0.5, screenH*0.6, native.systemFont, 12)
	passwordText.anchorX, passwordText.anchorY = 0,0
	passwordText:setFillColor( 0 )	-- black
	passwordText.isVisible = false  --make invisible
	scrollView:insert(passwordText)


	----------------------CREATE "CAN NOT BE EMPTY"  TEXT BELOW TEXTFIELDS----------------------------
	--create FirstName can not be empty  text--------------------------------------------------
	firstNameTextNo = display.newText( "First Name can not be empty", screenCeneterX*0.5, screenH*0.073, native.systemFont, 12)
	firstNameTextNo.anchorX, firstNameTextNo.anchorY = 0,0
	firstNameTextNo:setFillColor( 0.9,0.2,0.1 )	-- black
	firstNameTextNo.isVisible = false  --make invisible
	scrollView:insert(firstNameTextNo)

	------create last Name can not be empty text above---------------------------------------
	lastNameTextNo = display.newText( "Last Name can not be empty", screenCeneterX*0.5, screenH*0.173, native.systemFont, 12)
	lastNameTextNo.anchorX, lastNameTextNo.anchorY = 0,0
	lastNameTextNo:setFillColor( 0.9,0.2,0.1 )	-- black
	lastNameTextNo.isVisible = false  --make invisible
	scrollView:insert(lastNameTextNo)

	-------create CaltransID  can not be empty text above--------------------------------------
	caltransIDTextNo = display.newText( "CalTrans ID can not be empty", screenCeneterX*0.5, screenH*0.273, native.systemFont, 12)
	caltransIDTextNo.anchorX, caltransIDTextNo.anchorY = 0,0
	caltransIDTextNo:setFillColor( 0.9,0.2,0.1 )	-- black
	caltransIDTextNo.isVisible = false  --make invisible
	scrollView:insert(caltransIDTextNo)

	-------create phone can not be empty text above------------------------------------------
	phoneTextNo = display.newText( "Phone can not be empty", screenCeneterX*0.5, screenH*0.373, native.systemFont, 12)
	phoneTextNo.anchorX, phoneTextNo.anchorY = 0,0
	phoneTextNo:setFillColor( 0.9,0.2,0.1 )	-- black
	phoneTextNo.isVisible = false  --make invisible
	scrollView:insert(phoneTextNo)

	-----create Email can not be empty text above--------------------------------------------
	emailTextNo = display.newText( "Email can not be empty", screenCeneterX*0.5, screenH*0.473, native.systemFont, 12)
	emailTextNo.anchorX, emailTextNo.anchorY = 0,0
	emailTextNo:setFillColor( 0.9,0.2,0.1 )	-- black
	emailTextNo.isVisible = false  --make invisible
	scrollView:insert(emailTextNo)

	------create UserName can not be empty text above---------------------------------------
	userNameTextNo = display.newText("Username can not be empty", screenCeneterX*0.5, screenH*0.573, native.systemFont, 12)
	userNameTextNo.anchorX, userNameTextNo.anchorY = 0,0
	userNameTextNo:setFillColor(0.9,0.2,0.1) --black
	userNameTextNo.isVisible = false  --make invisible
	scrollView:insert(userNameTextNo)

	-----create Passsword can not be empty text above--------------------------------------------
	passwordTextNo = display.newText( "Password can not be empty", screenCeneterX*0.5, screenH*0.673, native.systemFont, 12)
	passwordTextNo.anchorX, passwordTextNo.anchorY = 0,0
	passwordTextNo:setFillColor( 0.9,0.2,0.1)	-- black
	passwordTextNo.isVisible = false  --make invisible
	scrollView:insert(passwordTextNo)
	----------------------------------END OF CREATING TEXTS----------------------------------------------------------------


	-------------------CREATE BUTTONS-----------------------------------------------------------------
	-- Create the SIGN UP btn-----------------------------------------------
	signUpBtn = widget.newButton(
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
    -- Insert SUGN UP btn in footGroup and position it
	footerGroup:insert(  signUpBtn )
	signUpBtn.x, signUpBtn.y =  0, screenH*(-0.15)

	-- Create the LOGIN btn-------------------------------------------------
	cancelBtn = widget.newButton(
    {
        label = "CANCEL",
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 13,
        onEvent = cancelBtnListener,
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
    -- Insert CANCEL btn in footgroup and position it
	footerGroup:insert(  cancelBtn )
	cancelBtn.x, cancelBtn.y = 0, screenH*(-0.08)


	------------Create Pass Visible/Invisible botton----------------------------------
	passVisibleBtn = widget.newButton(
    {
        onEvent = passVisibleBtnListener,
        emboss = false,
        width = 30,
        height = 30,
        defaultFile = "BLANK_ICON.png"
    })
    -- Center Login button
	passVisibleBtn.x = screenCeneterX*1.7
	passVisibleBtn.y = screenH*0.65
	scrollView:insert(passVisibleBtn)
	
	----------------------------END OF CREATING BUTTONS------------------------------------------------------------------


	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( background )
	sceneGroup:insert( backgroundHead )
	sceneGroup:insert( title )
	sceneGroup:insert( scrollView )
	sceneGroup:insert( footerGroup )
	sceneGroup:insert( labelStatus)   ------from TEST-----


	--sceneGroup:insert( signUpBtn )
	--sceneGroup:insert( cancelBtn )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

		nullifyTextFields() -- nullyfying text field global values

		----------------------------	CREATING  TEXTFIELDS----------------------------------------------------------------
		-----------First Name Textfield----------------------------------------------
		firstNameField = native.newTextField( screenCeneterX, screenH*0.05, 180, 30 )
		firstNameField.placeholder = "First Name"
		firstNameField.inputType = "default"
		firstNameField:addEventListener( "userInput", firstNameFieldListener )
		scrollView:insert(firstNameField)	--insert text Field in scrool view

		-----------Last Name textfield----------------------------------------------
		lastNameField = native.newTextField ( screenCeneterX, screenH*0.15, 180, 30 )
		lastNameField.placeholder = "Last Name"
		lastNameField.inputType = "default"
		lastNameField:addEventListener( "userInput", lastNameFieldListener)
		scrollView:insert(lastNameField)

		-----------caltransID Text Field----------------------------------------------
		caltransIDField = native.newTextField ( screenCeneterX, screenH*0.25, 180, 30 )
		caltransIDField.placeholder = "CalTrans ID"
		caltransIDField.inputType = "default"
		caltransIDField:addEventListener( "userInput", caltransIDFieldListener)
		scrollView:insert(caltransIDField)

		--------------Phone Number TextField--------------------------------------
		phoneField = native.newTextField ( screenCeneterX, screenH*0.35, 180, 30 )
		phoneField.placeholder = "Phone #"
		phoneField.inputType = "phone"
		phoneField:addEventListener( "userInput", phoneFieldListener)
		scrollView:insert(phoneField)

		--------------Email Text Field-------------------------------------------
	 	emailField = native.newTextField ( screenCeneterX, screenH*0.45, 180, 30 )
		emailField.placeholder = "Email"
		emailField.inputType = "email"
		emailField:addEventListener( "userInput", emailFieldListener)
		scrollView:insert(emailField)

		--------------UserName Text field---------------------------------------
		userNameField = native.newTextField ( screenCeneterX, screenH*0.55, 180, 30 )
		userNameField.placeholder = "Username"
		userNameField.inputType = "default"
		userNameField:addEventListener( "userInput", userNameFieldListener)
		scrollView:insert(userNameField)

		--------------Password Text Field----------------------------------------
		passwordField = native.newTextField ( screenCeneterX, screenH*0.65, 180, 30 )
		passwordField.placeholder = "Password"
		passwordField.inputType = "default"
		passwordField:addEventListener( "userInput", passwordFieldListener)
		passwordField.isSecure = true
		scrollView:insert(passwordField)

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
		firstNameField:removeSelf()
		firstNameField = nil

		lastNameField:removeSelf( )
		lastNameField = nil

		caltransIDField:removeSelf( )
		caltransIDField = nil

		phoneField:removeSelf( )
		phoneField = nil

		emailField:removeSelf( )
		emailField = nil

		userNameField:removeSelf()
		userNameField = nil

		passwordField:removeSelf()
		passwordField = nil

		--reseting password view image
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