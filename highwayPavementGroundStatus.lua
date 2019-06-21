-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )

--TEST INITIALIZATION--------
--local mime = require("mime")
--local json = require("json")
-----END TEST---------------


local scene = composer.newScene()

--Screen size
screenW = display.contentWidth
screenH = display.contentHeight
screenCeneterX = display.contentCenterX
screenCeneterY = display.contentCenterY

-------Local Variables-----------------------------
local g = appGlobalVariables  --reference to global variables

local highwayText, pavementGroundText      --permanent text titles grey

--names of Highway status radio Buttons
local openText, shoulderClosedText, lanesClosedText, onewayClosedText, twowayClosedText

--names of Pavement status checkboxes
local pavementCracksText, indentedByRocksText

--names of Highway and Pavement Status text Fields
local lanesText, lengthText, horizontalDispText, verticalDispText, depthOfCrackText, settlementText, bulgeText

--Highway Status radio Button widgets
local radioBtnOpen, radioBtnShoulderClosed, radioBtnLanesClosed, radioBtnOnewayClosed, radioBtnTwowayClosed

--Pavement status checkbox widgets
local checkBoxPavementCracks, checkBoxIndentedByRocks

--text Fields
local lanesField, lengthField, horizontalDispField, verticalDispField, depthOfCrackField, settlementField, bulgeField

local textPopUp  --text displayed in message alert
local textTitle --text of popup title

local headerGroup               --heder group with buttons
local footerGroup 				--footer group with buttons

local highwayStatusGroup, pavementStatusGroup --grouping of elements

local saveBtn, nextBtn, backBtn --buttons declaration
local scrollView  --scrol view declaration

local focusIndex --index of what to do in "OK" btn listener


----------------LOCAL FUNCTIONS--------------------------------------------------------
----------function "nullyfyTextFields"  deletes texts above and below textfields----
local function nullifyTextFields(  )
    
    --uncheck all check Boxes
    checkBoxPavementCracks:setState( { isOn=false } )
    checkBoxIndentedByRocks:setState( {isOn=false} )

    --put checkboxes in state from variable g.pavementGroundCracks and g.indentedByRocks
    if (g.pavementGroundCracks == true) then checkBoxPavementCracks:setState( {isOn=true} ) end
    if (g.indentedByRocks == true) then checkBoxIndentedByRocks:setState( {isOn=true} ) end
    
    --put radio btn in stage from g.highwayStatus
    if (g.highwayStatus ~= nil and g.highwayStatus ~= "") then
        if (g.highwayStatus == "Open") then radioBtnOpen:setState( {isOn = true} ) 
        elseif (g.highwayStatus == "Shoulder Closed") then radioBtnShoulderClosed:setState( {isOn = true} )
        elseif (g.highwayStatus == "Lane(s) Closed") then radioBtnLanesClosed:setState( {isOn = true} )
        elseif (g.highwayStatus == "One-way Closed") then radioBtnOnewayClosed:setState( {isOn = true} ) 
        elseif (g.highwayStatus == "Two-way Closed") then radioBtnTwowayClosed:setState( {isOn = true} ) 
        else radioBtnOpen:setState( {isOn = false} )
            radioBtnShoulderClosed:setState( {isOn = false} )
            radioBtnLanesClosed:setState( {isOn = false} )
            radioBtnOnewayClosed:setState( {isOn = false} )
            radioBtnTwowayClosed:setState( {isOn = false} )
            print( "Unexpected Value in g.highwayStatus: SMTH WRONG" )
        end
    end

    --Setting Up Textfield Values------------------------------------
        --if Lane(s) Closed is checked then set lane textfield value
    if (radioBtnLanesClosed.isOn) then 
        if (g.closedLanes~=nil and g.closedLanes~="") then
            print("Closed lanes filled "..g.closedLanes)
            lanesField.text = g.closedLanes
        end
    end

        --if Pavement/Ground Cracks checkbox is on set length, 
        --horisontal disp, vertical disp, and depth values
     if (checkBoxPavementCracks.isOn) then 
        if (g.crackLength~=nil and g.crackLength~="") then
            print("Crack length filled "..g.crackLength)
            lengthField.text = g.crackLength
        end

        if (g.crackHorizontalDisp~=nil and g.crackHorizontalDisp~="") then
            print("Crack Horizontal Disp filled "..g.crackHorizontalDisp)
            horizontalDispField.text = g.crackHorizontalDisp
        end

        if (g.crackVerticalDisp~=nil and g.crackVerticalDisp~="") then
            print("Crack Vertical Disp filled "..g.crackVerticalDisp)
            verticalDispField.text = g.crackVerticalDisp
        end

        if (g.crackDepth~=nil and g.crackDepth~="") then
            print("Crack Depth filled "..g.crackDepth)
            depthOfCrackField.text = g.crackDepth
        end
    end

        --setting up settlement and bulge textfield values
    if (g.settlement~=nil and g.settlement~="") then
        print("Settlement filled "..g.settlement)
        settlementField.text = g.settlement
    end

    if (g.bulge~=nil and g.bulge~="") then
        print("Bulge filled "..g.bulge)
        bulgeField.text = g.bulge
    end

    scrollView:scrollToPosition( {y = 0} )
end
--------------------------------------------------------------------------------------------


--------Pop Up Ok BTN Listener for Rock group------------------------------
local function okBtnListener( event )
    native.setKeyboardFocus( lanesField )
end
------------------------------------------------------------

--------Pop Up Ok2 BTN Listener for soil group consistency------------------------------
local function ok2BtnListener( event )
    if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 1 ) then
            --if "OK" is clicked set focus to needed field
            if (focusIndex == 1) then native.setKeyboardFocus(lengthField)
            elseif (focusIndex == 2) then native.setKeyboardFocus( horizontalDispField )
            elseif (focusIndex == 3) then native.setKeyboardFocus( verticalDispField )
            elseif (focusIndex == 4) then native.setKeyboardFocus(depthOfCrackField)
            else print( "SMTH Wrong - Unexpected value in focusInex variable" )
            end
        elseif ( i == 2 ) then
            -- if SKIP is clicked go to next screen 
            composer.gotoScene( "waterDrainageImpacted", {effect = "slideLeft", time = 300} )
        end
    end
end
--------------------------------------------------------------------------------------------


-------Function "printScreenVariables" prints out all variable on screen values-------------------
local function printScreenVariables( )
    print("ALL VARIABLES")
    print("Highway Status: "..tostring(g.highwayStatus).." Closed Lanes: "..tostring(g.closedLanes) )
    print("Pavement Ground Cracks: "..tostring(g.pavementGroundCracks)..". Indented by Rocks: "..tostring(g.indentedByRocks))
    print("length: "..tostring(g.crackLength)..", horizontal disp: "..tostring(g.crackHorizontalDisp)..", vertical disp: "..tostring(g.crackVerticalDisp)..", depth: "..tostring(g.crackDepth))
    print("Settlement: "..tostring(g.settlement).." Bulge: "..tostring(g.bulge) )
end
---End Of "printScreenVariables" function ---------------------------------


------------------END OF LOCAL FUNCTIONS------------------------------------------------


---------------LISTENERS------------------------------------------------------------------

----------RADIO BUTTON LISTENER--------------------------------------------
local function onRadioBtnRelease( event )
    local switch = event.target
    print( "Radio Btn with ID "..switch.id.." is on: "..tostring(switch.isOn) )
        --assign to g.highwayStatus proper value
    g.highwayStatus = switch.id
    print( "Highway Status now now: "..g.highwayStatus )

    --check if "Lane(s) closed" unchecked - delete Lanes field and g.closedLanes variable
    if (switch.id ~= "Lane(s) Closed"  ) then
        print("Lane closed unchecked!!!!!")
        g.closedLanes = ""
        lanesField.text = ""
    end

end
----------end of Radio Btn Listener-------------------------------------------

------ CHECK BOXES LISTENER------------------------------------------------
local function onCheckboxRelease( event )

    local switch = event.target
    print( "Checkbox with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )

    --Handle if Pavement/Ground Status is checked or unchecked-----------------
    if (switch.id == "Pavement/Ground Cracks") then
        if (switch.isOn) then g.pavementGroundCracks = true
                --if "Pavement/Ground Cracks" unchecked - delete textfields of dimentions ans variables
            else g.pavementGroundCracks = false
                g.crackLength = ""
                g.crackHorizontalDisp = ""
                g.crackVerticalDisp = ""
                g.crackDepth = ""
                lengthField.text = ""
                horizontalDispField.text = ""
                verticalDispField.text = ""
                depthOfCrackField.text = ""
        end
        print("Pavement/Ground Status is: "..tostring(g.pavementGroundCracks) )
    end

     --Handle if Indented By Rocks is checked or unchecked-----------------
    if (switch.id == "Indented by Rocks") then
        if (switch.isOn) then g.indentedByRocks = true
            else g.indentedByRocks = false
        end
        print("Indented by Rocks is: "..tostring(g.indentedByRocks) )
    end

    printScreenVariables()
end

---END OF CHECKBOX BTN LISTENERS---------------------------------------------------------------------------


----------------TEXTFIELD LISTENERS-----------------------------------------------------------------------
--Lanes text field listener---------------------------------------------------
local function lanesFieldListener ( event )

    if (event.phase == "editing") then
        if (radioBtnLanesClosed.isOn) then g.closedLanes = event.text
            else event.text = ""
            lanesField.text = ""
        end
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        if (radioBtnLanesClosed.isOn) then 
            g.closedLanes = event.target.text
            print( "Closed Lanes: " .. g.closedLanes )
        else print("Lanes can't be entered until Lane(s) Closed radio Btn is off")
        end
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( nil )
    end
end

--Crack Length text field listener---------------------------------------------------
local function lengthFieldListener ( event )
    if ( event.phase == "began" ) then
             --lifting up buttons and scroolview
            scrollView:scrollToPosition( {y = -screenH*0.3} ) 
    end

     if (event.phase == "editing") then
        if (checkBoxPavementCracks.isOn) then g.crackLength = event.text
            else event.text = ""
               lengthField.text = ""
        end
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        if (checkBoxPavementCracks.isOn) then 
            g.crackLength = event.target.text
            print( "Crack Length: " .. g.crackLength )
        else print("Crack Length can not be entered until Pavement/Ground checkbox is off")
        end

        --bringing scroolview and buttons back
        scrollView:scrollToPosition( {y = 0} )
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( horizontalDispField )
    end
end

--Horisontal Disposition text field listener---------------------------------------------------
local function horizontalDispFieldListener ( event )
    
    if ( event.phase == "began" ) then
             --lifting up buttons and scroolview
            scrollView:scrollToPosition( {y = -screenH*0.3} ) 
    end

    if (event.phase == "editing") then
        if (checkBoxPavementCracks.isOn) then g.crackHorizontalDisp = event.text
            else event.text = ""
               horizontalDispField.text = ""
        end
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        if (checkBoxPavementCracks.isOn) then 
            g.crackHorizontalDisp = event.target.text
            print( "Crack Horizontal Disp: " .. g.crackHorizontalDisp )
        else print("Crack Horisontal Disp can not be entered until Pavement/Ground checkbox is off")
        end

        --bringing scroolview and buttons back
        scrollView:scrollToPosition( {y = 0} )
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( verticalDispField )
    end
end

--Vertical Disposition text field listener---------------------------------------------------
local function verticalDispFieldListener ( event )
    if ( event.phase == "began" ) then
             --lifting up buttons and scroolview
            scrollView:scrollToPosition( {y = -screenH*0.3} ) 
    end

    if (event.phase == "editing") then
        if (checkBoxPavementCracks.isOn) then g.crackVerticalDisp = event.text
            else event.text = ""
               verticalDispField.text = ""
        end
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        if (checkBoxPavementCracks.isOn) then 
            g.crackVerticalDisp = event.target.text
            print( "Crack Vertical Disp: " .. g.crackVerticalDisp )
        else print("Crack Vertical Disp can not be entered until Pavement/Ground checkbox is off")
        end

        --bringing scroolview and buttons back
        scrollView:scrollToPosition( {y = 0} )
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( depthOfCrackField )
    end
end

--Depth of Crack text field listener---------------------------------------------------
local function depthOfCrackFieldListener ( event )
    if ( event.phase == "began" ) then
             --lifting up buttons and scroolview
            scrollView:scrollToPosition( {y = -screenH*0.3} ) 
    end

    if (event.phase == "editing") then
        if (checkBoxPavementCracks.isOn) then g.crackDepth = event.text
            else event.text = ""
               depthOfCrackField.text = ""
        end
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        if (checkBoxPavementCracks.isOn) then 
            g.crackDepth = event.target.text
            print( "Crack Depth: " .. g.crackDepth )
        else print("Crack Depth can not be entered until Pavement/Ground checkbox is off")
        end

        --bringing scroolview and buttons back
        scrollView:scrollToPosition( {y = 0} )
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( settlementField )
    end
end

--Settlement text field listener---------------------------------------------------
local function settlementFieldListener ( event )

    if ( event.phase == "began" ) then
             --lifting up buttons and scroolview
            scrollView:scrollToPosition( {y = -screenH*0.5} ) 
    end

    if (event.phase == "editing") then
        g.settlement = event.text
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.settlement = event.target.text
        print( "Settlement: " .. g.settlement )

        --bringing scroolview and buttons back
        scrollView:scrollToPosition( {y = 0} )
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( bulgeField )
    end
end

--Bulge text field listener---------------------------------------------------
local function bulgeFieldListener ( event )
    if ( event.phase == "began" ) then
             --lifting up buttons and scroolview
            scrollView:scrollToPosition( {y = -screenH*0.5} ) 
    end

    if (event.phase == "editing") then
        g.bulge = event.text
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.bulge = event.target.text
        print( "Bulge: " .. g.bulge )

        --bringing scroolview and buttons back
        scrollView:scrollToPosition( {y = 0} )
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( nil )
    end
end

--------------------END OF TEXTFIELD LISTENERS-------------------------------------


------------BUTTON LISTENERS-----------------------------------------------------
-----Next Btn Listener-------------------------------------
local function nextBtnListener( event)
    
    if event.phase == "began" then
        audio.play( click)
    end

    --Goes tto sign up screen-
    if event.phase == "ended" then 
    	print( "Next clicked" )
    
        --check if radio btn "Lane(s) closed" is selected and number of lanes field is empty-----------
        if (radioBtnLanesClosed.isOn) then 
            if ( g.closedLanes==nil or g.closedLanes=="") then
                textTitle = "Lanes Field is Empty"
                textPopUp = "Enter Amount of Closed Lanes"
                local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
                return 
            end
        end

        --check if "Pavement/Ground Cracks" checkbox is checked and one ore more dimetion of crack fields is empty - then warning
        if (checkBoxPavementCracks.isOn) then 
            if ( g.crackLength==nil or g.crackLength=="" ) then
                print("Crack length is misssing!")
                textTitle = "One or more crack dimentions are missing!"
                textPopUp = "Enter Crack Length"
                local alert = native.showAlert( textTitle, textPopUp, { "OK" , "SKIP"}, ok2BtnListener )
                focusIndex = 1
                return
            end

            if ( g.crackHorizontalDisp==nil or g.crackHorizontalDisp=="" ) then
                print("Crack horisontal Disp is misssing!")
                textTitle = "One or more crack dimentions are missing!"
                textPopUp = "Enter Crack Horisontal Disposition"
                local alert = native.showAlert( textTitle, textPopUp, { "OK" , "SKIP"}, ok2BtnListener )
                focusIndex = 2
                return
            end

            if ( g.crackVerticalDisp==nil or g.crackVerticalDisp=="" ) then
                print("Crack Vertical Disp is misssing!")
                textTitle = "One or more crack dimentions are missing!"
                textPopUp = "Enter Crack Vertical Disposition"
                local alert = native.showAlert( textTitle, textPopUp, { "OK" , "SKIP"}, ok2BtnListener )
                focusIndex = 3
                return
            end

            if ( g.crackDepth==nil or g.crackDepth=="" ) then
                print("Crack depth is misssing!")
                textTitle = "One or more crack dimentions are missing!"
                textPopUp = "Enter Crack Depth"
                local alert = native.showAlert( textTitle, textPopUp, { "OK" , "SKIP"}, ok2BtnListener )
                focusIndex = 4
                return
            end
        end

        composer.gotoScene( "waterDrainageImpacted", {effect = "slideLeft", time = 300} )
    end 

end
-----End if Next BTN Listener--------------------------------------------------------

--------Save Btn Listener-------------------------------------
local function saveBtnListener( event)
    if event.phase == "began" then
        audio.play( click)
    end

    --Goes tto sign up screen-
    if event.phase == "ended" then
		--composer.gotoScene( "login", {effect = "slideRight", time = 300} )     
    end
end


--------Back Btn Listener-------------------------------------
local function backBtnListener( event)
    if event.phase == "began" then
        audio.play( click)
    end

    --Goes tto sign up screen-
    if event.phase == "ended" then
        composer.gotoScene( "materialVegetationOnSlope", {effect = "slideRight", time = 300} )     
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
	footerGroup.x, footerGroup.y =  screenW/2, screenH*0.9

	--blue footer rectangle and insert in footer group-------------------
	local whiteFooter = display.newRect(footerGroup, 0, 0, screenW*1.2, screenH *0.15)
	whiteFooter:setFillColor( 0.1,0.2,0.8, 1 )	-- blue


	-------------------CREATING TITLE-----------------------------------------------
	-- create GISAproject title---------------------------------------------------
	local title = display.newText( "GISAproject", 60, 35, native.systemFont, 16 )
	title:setFillColor( 1 )	-- black

    --------------CREATE SCROOL WIDJET--------------------------------------
    scrollView = widget.newScrollView(
    {
        top = screenH*0.1,
        left = 0,
        width = screenW,
        height = screenH,
        listener = scrollListener,
        print( "scroll created" )
    }
    )


    ------CREATING HIGHWAY STATUS AND PAVEMENT STATUS GROUPS---------------------------------
    highwayStatusGroup = display.newGroup( )
    highwayStatusGroup.anchorX, highwayStatusGroup.anchorY = 0, 0
    highwayStatusGroup.x, highwayStatusGroup.y =  screenW*0.08, 0

    pavementStatusGroup = display.newGroup( )
    pavementStatusGroup.anchorX,pavementStatusGroup.anchorY = 0, 0
    pavementStatusGroup.x,pavementStatusGroup.y =  screenW*0.08, screenH*0.33


	----------------------CREATING TEXT HEADERS--------------------------------------------------------------
	--create Highway Status text header--------------------------------------------------
	highwayText = display.newText( "Highway Status", 0, screenH*0, native.systemFontBold, 14)
	highwayText.anchorX, highwayText.anchorY = 0,0
	highwayText:setFillColor( 0.4 )	-- gray
    highwayStatusGroup:insert(highwayText)
	
    --create Pavement/Groiund Status text header--------------------------------------------------
    pavementGroundText = display.newText( "Pavement/Ground Status", 0, screenH*0, native.systemFontBold, 14)
    pavementGroundText.anchorX, pavementGroundText.anchorY = 0,0
    pavementGroundText:setFillColor( 0.4 )    -- gray
    pavementStatusGroup:insert(pavementGroundText)
    --------------------------------------------------------------------------------------------------------------


    -----------CREATE CHECK BOXES BUTTONS---------------------------------------------------------------------------------------
    -- Image sheet options and declaration of Check Box
    local optionsCheckBox = {
        width = 100,
        height = 100,
        numFrames = 2,
        sheetContentWidth = 200,
        sheetContentHeight = 100
    }
   local checkBoxSheet = graphics.newImageSheet( "checkBox2.png", optionsCheckBox )
   

   ---------------------CREATE CHECKBOX WIDGETS--------------------------------------------------------
   --Pavement/Ground Cracks checkbox--------------------------
    checkBoxPavementCracks = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.035,
        style = "checkbox",
        id = "Pavement/Ground Cracks",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    pavementStatusGroup:insert(checkBoxPavementCracks)

    --Indented by Rocks check Box------------------------------
    checkBoxIndentedByRocks = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.425,
        style = "checkbox",
        id = "Indented by Rocks",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    pavementStatusGroup:insert(checkBoxIndentedByRocks)

    -------------------------END OF CHECKBOXES CREATION-------------------------------------


    ---------------------CREATE CHECKBOX TEXTS----------------------------------------------
    -----------create Pavement/Ground Cracks checkbox text-------------------------------------
    pavementCracksText = display.newText( "Pavement/Ground Cracks", screenW*0.08, screenH*0.04, native.systemFont, 14)
    pavementCracksText.anchorX, pavementCracksText.anchorY = 0,0
    pavementCracksText:setFillColor( 0 )    -- black
    pavementStatusGroup:insert(pavementCracksText)

    -----------create Indented by Rocks checkbox text-------------------------------------
    indentedByRocksText = display.newText( "Indented By Rocks", screenW*0.08, screenH*0.43, native.systemFont, 14)
    indentedByRocksText.anchorX, indentedByRocksText.anchorY = 0,0
    indentedByRocksText:setFillColor( 0 )    -- black
    pavementStatusGroup:insert(indentedByRocksText)

    ----------------------------------END OF CHECKBOX TEXTS------------------------------------------------------


    ---------------------------------CREATE RADIO BUTTONS------------------------------------------------------
    -- Image sheet options and declaration of Radio Buttons-
    local optionsRadioBtn = {
        width = 100,
        height = 100,
        numFrames = 2,
        sheetContentWidth = 200,
        sheetContentHeight = 100
    }
   local radioBtnSheet = graphics.newImageSheet( "radioButton.png", optionsRadioBtn )

    ---------------------------Create Radio Button Widgets---------------------------------------
    --Open Radio Btn--------------------------
    radioBtnOpen = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.035,
        style = "radio",
        id = "Open",
        width = 25,
        height = 25,
        initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    highwayStatusGroup:insert(radioBtnOpen)

    --Shoulder Closed Radio Btn--------------------------
    radioBtnShoulderClosed = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.095,
        style = "radio",
        id = "Shoulder Closed",
        width = 25,
        height = 25,
        initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    highwayStatusGroup:insert(radioBtnShoulderClosed)

    --Lane(s) Closed Radio Btn--------------------------
    radioBtnLanesClosed = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.155,
        style = "radio",
        id = "Lane(s) Closed",
        width = 25,
        height = 25,
        initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    highwayStatusGroup:insert(radioBtnLanesClosed)

    --One-Way Closed Radio Btn--------------------------
    radioBtnOnewayClosed = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.215,
        style = "radio",
        id = "One-way Closed",
        width = 25,
        height = 25,
        initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    highwayStatusGroup:insert(radioBtnOnewayClosed)

    --Two-way Closed Radio Btn--------------------------
    radioBtnTwowayClosed = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.275,
        style = "radio",
        id = "Two-way Closed",
        width = 25,
        height = 25,
        initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    highwayStatusGroup:insert(radioBtnTwowayClosed)

    --------------------END OF RADIO BUTTONS CREATION-------------------------------------------------------


    ---------CREATE RADIO BTN TEXTS----------------------------------------------------------------------
    --"Open" radio btn text----------------
    openText = display.newText( "Open", screenW*0.09, screenH*0.04, native.systemFont, 14)
    openText.anchorX, openText.anchorY = 0,0
    openText:setFillColor( 0 )    -- black
    highwayStatusGroup:insert(openText)
   
    --"Shoulder Closed" radio btn text----------------
    shoulderClosedText = display.newText( "Shoulder Closed", screenW*0.09, screenH*0.10, native.systemFont, 14)
    shoulderClosedText.anchorX, shoulderClosedText.anchorY = 0,0
    shoulderClosedText:setFillColor( 0 )    -- black
    highwayStatusGroup:insert(shoulderClosedText)

    --"Lane(s) Closed" radio btn text----------------
    lanesClosedText = display.newText( "Lane(s) closed", screenW*0.09, screenH*0.16, native.systemFont, 14)
    lanesClosedText.anchorX, lanesClosedText.anchorY = 0,0
    lanesClosedText:setFillColor( 0 )    -- black
    highwayStatusGroup:insert(lanesClosedText)

    --"One-way closed" radio btn text----------------
    onewayClosedText = display.newText( "One-way Closed", screenW*0.09, screenH*0.22, native.systemFont, 14)
    onewayClosedText.anchorX, onewayClosedText.anchorY = 0,0
    onewayClosedText:setFillColor( 0 )    -- black
    highwayStatusGroup:insert(onewayClosedText)

    --"Two-way Closed" radio btn text----------------
    twowayClosedText = display.newText( "Two-way closed", screenW*0.09, screenH*0.28, native.systemFont, 14)
    twowayClosedText.anchorX, twowayClosedText.anchorY = 0,0
    twowayClosedText:setFillColor( 0 )    -- black
    highwayStatusGroup:insert(twowayClosedText)

    ------------------------END OF RADIO BTN TEXT CREATION-----------------------------------------------------


    ---------------------TEXTFIELD TEXTS -----------------------------------------------------------------------
    -----------Lanes field  text-------------------------------------
    lanesText = display.newText( "Lanes", screenW*0.65, screenH*0.16, native.systemFont, 14)
    lanesText.anchorX, lanesText.anchorY = 0,0
    lanesText:setFillColor( 0 )    -- black
    highwayStatusGroup:insert(lanesText)

    -----------Length field  text-------------------------------------
    lengthText = display.newText( "feet, Length", screenW*0.35, screenH*0.09, native.systemFont, 14)
    lengthText.anchorX, lengthText.anchorY = 0,0
    lengthText:setFillColor( 0 )    -- black
    pavementStatusGroup:insert(lengthText)

    -----------Horizontal Disp field  text-------------------------------------
    horizontalDispText = display.newText( "inches, Horisontal Disp.", screenW*0.35, screenH*0.15, native.systemFont, 14)
    horizontalDispText.anchorX, horizontalDispText.anchorY = 0,0
    horizontalDispText:setFillColor( 0 )    -- black
    pavementStatusGroup:insert(horizontalDispText)

    -----------Vertical Disp field  text-------------------------------------
    verticalDispText = display.newText( "inches, Vertical Disp.", screenW*0.35, screenH*0.21, native.systemFont, 14)
    verticalDispText.anchorX, verticalDispText.anchorY = 0,0
    verticalDispText:setFillColor( 0 )    -- black
    pavementStatusGroup:insert(verticalDispText)

    -----------Depth of Crack field  text-------------------------------------
    depthOfCrackText = display.newText( "inches, Depth of Crack", screenW*0.35, screenH*0.27, native.systemFont, 14)
    depthOfCrackText.anchorX, depthOfCrackText.anchorY = 0,0
    depthOfCrackText:setFillColor( 0 )    -- black
    pavementStatusGroup:insert(depthOfCrackText)

    -----------Settlement field  text-------------------------------------
    settlementText = display.newText( "Settlement, inches", screenW*0.08, screenH*0.33, native.systemFont, 14)
    settlementText.anchorX, settlementText.anchorY = 0,0
    settlementText:setFillColor( 0 )    -- black
    pavementStatusGroup:insert(settlementText)

    -----------Bulge field  text-------------------------------------
    bulgeText = display.newText( "Bulge, inches", screenW*0.08, screenH*0.39, native.systemFont, 14)
    bulgeText.anchorX, bulgeText.anchorY = 0,0
    bulgeText:setFillColor( 0 )    -- black
    pavementStatusGroup:insert(bulgeText)

    ------------------END OF TEXTFIELD TEXTS--------------------------------------------------------------


	-------------------CREATE BUTTONS-----------------------------------------------------------------
	-- Create the BACK btn-----------------------------------------------
	backBtn = widget.newButton(
    {
        label = "BACK",
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 13,
        onEvent = backBtnListener,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 75,
        height = 30,
        cornerRadius = 2,
        fillColor = { default={0.8,0.8,1,1}, over={0,0.1,0.2,0.2} },
        strokeColor = { default={0.6,0.4,0.2,1}, over={0.8,0.8,1,1} },
        strokeWidth = 2
    })
    -- Insert BACK btn in footGroup and position it
	footerGroup:insert(  backBtn )
	backBtn.x, backBtn.y =  screenW*(-0.25), -25

	-- Create the SAVE btn-------------------------------------------------
	saveBtn = widget.newButton(
    {
        label = "SAVE",
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 13,
        onEvent = saveBtnListener,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 75,
        height = 30,
        cornerRadius = 2,
        fillColor = { default={0.8,0.8,1,1}, over={0,0.1,0.2,0.2} },
        strokeColor = { default={0.6,0.4,0.2,1}, over={0.8,0.8,1,1} },
        strokeWidth = 2
    })
    -- Insert SAVE btn in footgroup and position it
	footerGroup:insert(  saveBtn )
	saveBtn.x, saveBtn.y = 0, -25

-- Create the NEXT btn-------------------------------------------------
    nextBtn = widget.newButton(
    {
        label = "NEXT",
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 13,
        onEvent = nextBtnListener,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 75,
        height = 30,
        cornerRadius = 2,
        fillColor = { default={0.8,0.8,1,1}, over={0,0.1,0.2,0.2} },
        strokeColor = { default={0.6,0.4,0.2,1}, over={0.8,0.8,1,1} },
        strokeWidth = 2
    })
    -- Insert SAVE btn in footgroup and position it
    footerGroup:insert(  nextBtn )
    nextBtn.x, nextBtn.y =  screenW*(0.25), -25
	
	----------------------------END OF CREATING BUTTONS------------------------------------------------------------------


	-- all objects must be added to group (e.g. self.view)
    scrollView:insert( highwayStatusGroup) 
    scrollView:insert( pavementStatusGroup)
    scrollView:insert( footerGroup)
    
	sceneGroup:insert( background )
	sceneGroup:insert( backgroundHead )
	sceneGroup:insert( title )
    sceneGroup:insert( scrollView )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

    --------CREATING TEXTFIELDS--------------------------------------------------------------
        --Lanes textfield----------------------------------------------
        lanesField = native.newTextField( screenW*0.5, screenH*0.17, 80, 30 )
        lanesField.placeholder = ""
        lanesField.inputType = "number"
        lanesField:addEventListener( "userInput", lanesFieldListener )
        highwayStatusGroup:insert(lanesField)   --insert text Field in scrool view

        --Length textfield----------------------------------------------
        lengthField = native.newTextField( screenW*0.2, screenH*0.10, 80, 30 )
        lengthField.placeholder = ""
        lengthField.inputType = "number"
        lengthField:addEventListener( "userInput", lengthFieldListener )
        pavementStatusGroup:insert(lengthField)   --insert text Field in scrool view

        --Horisontal Disposition textfield----------------------------------------------
        horizontalDispField = native.newTextField( screenW*0.2, screenH*0.16, 80, 30 )
        horizontalDispField.placeholder = ""
        horizontalDispField.inputType = "number"
        horizontalDispField:addEventListener( "userInput", horizontalDispFieldListener )
        pavementStatusGroup:insert(horizontalDispField)   --insert text Field in scrool view

        --Vertical Disposition textfield----------------------------------------------
        verticalDispField = native.newTextField( screenW*0.2, screenH*0.22, 80, 30 )
        verticalDispField.placeholder = ""
        verticalDispField.inputType = "number"
        verticalDispField:addEventListener( "userInput", verticalDispFieldListener )
        pavementStatusGroup:insert(verticalDispField)   --insert text Field in scrool view

        --Depth of Crack textfield----------------------------------------------
        depthOfCrackField = native.newTextField( screenW*0.2, screenH*0.28,80, 30 )
        depthOfCrackField.placeholder = ""
        depthOfCrackField.inputType = "number"
        depthOfCrackField:addEventListener( "userInput", depthOfCrackFieldListener )
        pavementStatusGroup:insert(depthOfCrackField)   --insert text Field in scrool view

        --Settlement textfield----------------------------------------------
        settlementField = native.newTextField( screenW*0.5, screenH*0.34, 80, 30 )
        settlementField.placeholder = ""
        settlementField.inputType = "number"
        settlementField:addEventListener( "userInput", settlementFieldListener )
        pavementStatusGroup:insert(settlementField)   --insert text Field in scrool view

        --Bulge textfield----------------------------------------------
        bulgeField = native.newTextField( screenW*0.5, screenH*0.40, 80, 30 )
        bulgeField.placeholder = ""
        bulgeField.inputType = "number"
        bulgeField:addEventListener( "userInput", bulgeFieldListener )
        pavementStatusGroup:insert(bulgeField)   --insert text Field in scrool view

        ------------------------END OF TEXTFIELDS CREATION------------------------------------------
        nullifyTextFields()


    elseif phase == "did" then
        -- Called when the scene is now on screen

        printScreenVariables()
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
        lanesField:removeSelf()
        lanesField = nil

        lengthField:removeSelf()
        lengthField = nil

        horizontalDispField:removeSelf()
        horizontalDispField = nil

        verticalDispField:removeSelf()
        verticalDispField = nil

        depthOfCrackField:removeSelf()
        depthOfCrackField = nil

        settlementField:removeSelf()
        settlementField = nil

        bulgeField:removeSelf()
        bulgeField = nil

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