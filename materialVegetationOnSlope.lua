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

local materialText, vegetationOnSlopeText, coverageText, estText, waterContentText      --permanent text titles grey

--names of Material and Soil Checkboxes
local rockText, beddingText, jointsText, fracturesText, soilText

--names of Soil and vegatation Textfields
local clayText, siltText, sandText, gravelText, treesText, bushesText, groundcoverText

--names of Water Content radio btn texts
local dryText, moistText, wetText, flowingText, seepText, springText

--water content radio bttn widgets
local radioBtnDry, radioBtnMoist, radioBtnWet, radioBtnFlowing, radioBtnSeep, radioBtnSpring

--material checkbox widgets
local checkBoxRock, checkBoxSoil, checkBoxBedding, checkBoxJoints, checkBoxFractures

--text Fields
local clayField, siltField, sandField, gravelField, treesField, bushesField, groundcoverField

local textPopUp  --text displayed in message alert
local textTitle --text of popup title

local allFieldsFill 			--flag to indicate if all fields are fulled out
local headerGroup               --heder group with buttons
local footerGroup 				--footer group with buttons

local materialRockGroup, materialSoilGroup, vegetationGroup, waterContentRadioGroup1, waterContentRadioGroup2, waterContentMainGroup --grouping of elements

local saveBtn, nextBtn, backBtn --buttons declaration
local scrollView  --scrol view declaration


----------------LOCAL FUNCTIONS--------------------------------------------------------
----------function "nullyfyTextFields"  deletes texts above and below textfields----
local function nullifyTextFields(  )
    --uncheck all check Boxes
    checkBoxRock:setState( { isOn=false } )
    checkBoxSoil:setState( {isOn=false} )
    checkBoxBedding:setState( {isOn=false} )
    checkBoxJoints:setState( {isOn=false} )
    checkBoxFractures:setState( {isOn=false} )

    --if Rock is on - set Rock group checkboxes
    if (g.materialRock == "Rock") then
        checkBoxRock:setState( { isOn=true} )
        if (g.bedding == true) then checkBoxBedding:setState( {isOn=true} ) end
        if (g.joints == true) then checkBoxJoints:setState( {isOn=true} ) end
        if (g.fractures == true) then checkBoxFractures:setState( {isOn=true} ) end
    end


    --if Soil is on - set Soil group  
    if(g.materialSoil == "Soil") then
        checkBoxSoil:setState( {isOn=true} )

        if (g.clay~=nil and g.clay~="") then 
            print("Clay filled "..g.clay)
            clayField.text = g.clay
        end

        if (g.silt~=nil and g.silt~="") then 
            print("Silt filled "..g.silt)
            siltField.text = g.silt
        end

        if (g.sand~=nil and g.sand~="") then 
            print("Sand filled "..g.sand)
            sandField.text = g.sand
        end

        if (g.gravel~=nil and g.gravel~="") then 
            print("Gravel filled "..g.gravel)
            gravelField.text = g.gravel
        end
    end

    --Set vegetation group---------
    if (g.trees~=nil and g.trees~="") then 
        print("Trees filled "..g.trees)
        treesField.text = g.trees
    end

    if (g.bushes~=nil and g.bushes~="") then 
        print("Bushes filled "..g.bushes)
        bushesField.text = g.bushes
    end

    if (g.groundcover~=nil and g.groundcover~="") then 
        print("Groundcover filled "..g.groundcover)
        groundcoverField.text = g.groundcover
    end

    --put radion button in stage saved in variable g.waterContent
    if (g.waterContent ~= nil and g.waterContent ~="") then 
        if (g.waterContent == "Dry") then 
            radioBtnDry:setState( { isOn=true } )
            radioBtnSeep:setState( {isOn=false} )
            radioBtnSpring:setState( {isOn=false} )
            print("Dry is on initially")
        elseif (g.waterContent == "Moist") then
            radioBtnMoist:setState( { isOn=true } )
            radioBtnSeep:setState( {isOn=false} )
            radioBtnSpring:setState( {isOn=false} )
            print("Moist is on initially")
        elseif (g.waterContent == "Wet") then
            radioBtnWet:setState( { isOn=true } )
            radioBtnSeep:setState( {isOn=false} )
            radioBtnSpring:setState( {isOn=false} )
            print("Wet is on initially")
        elseif (g.waterContent == "Flowing (Seep)") then
            radioBtnFlowing:setState( { isOn=true } )
            radioBtnSeep:setState( {isOn=true} )
            print("Flowing (Seep) is on initially")
        elseif (g.waterContent == "Flowing (Spring)") then
            radioBtnFlowing:setState( { isOn=true } )
            radioBtnSpring:setState( {isOn=true} )
            print("Flowing (Spring) is on initially")
        else 
            print( "Unexpected Value in g.waterContent: SMTH WRONG" )
        end
    end

    scrollView:scrollToPosition( {y = 0} )
end
--------------------------------------------------------------------------------------------

--------Pop Up Ok2 BTN Listener for soil group consistency------------------------------
local function ok2BtnListener( event )
    if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 1 ) then
            -- Do nothing; dialog will simply dismiss
        elseif ( i == 2 ) then
            
            -- if SKIP is clicked go to next screen 
            composer.gotoScene( "highwayPavementGroundStatus", {effect = "slideLeft", time = 300} )
        end
    end
end
------------------------------------------------------------

---"checkSoilGroup" function checks if soil is marked and all soil fields are empty--------
local function checkSoilGroup()
    print("Check Soil Group is entered")
    if (checkBoxSoil.isOn) then
        if ( (g.clay==nil or g.clay=="") and (g.silt==nil or g.silt =="") and (g.sand==nil or g.sand=="") and (g.gravel==nil or g.gravel=="") ) then
            textTitle = "Enter Soil Distribution"
            textPopUp = "Entering Soil Distribution is suggested"
            local alert = native.showAlert( textTitle, textPopUp, { "OK" , "SKIP"}, ok2BtnListener )
            return
        end
    else composer.gotoScene( "highwayPavementGroundStatus", {effect = "slideLeft", time = 300} )
    end
end
------------------------------------------------------------------------------------------

--------Pop Up Ok BTN Listener for Rock group------------------------------
local function okBtnListener( event )
    if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 1 ) then
            -- Do nothing; dialog will simply dismiss
        elseif ( i == 2 ) then
            checkSoilGroup()
            return
            -- if SKIP is clicked go to next screen 
            --composer.gotoScene( "newIncident", {effect = "slideLeft", time = 300} )
        end
    end
end
------------------------------------------------------------


-------Function "printScreenVariables" prints out all variable on screen values-------------------
local function printScreenVariables( )
    print("ALL VARIABLES")
    print("ROCK: "..tostring(g.materialRock).." SOIL: "..tostring(g.materialSoil) )
    print("Bedding: "..tostring(g.bedding)..". Joints: "..tostring(g.joints)..". Fractures: "..tostring(g.fractures) )
    print("Clay: "..tostring(g.clay).." Silt: "..tostring(g.silt).." Sand: "..tostring(g.sand).." Gravel: "..tostring(g.gravel) )
    print("Trees: "..tostring(g.trees).." Bushes: "..tostring(g.bushes).." Groundcover: "..tostring(g.groundcover) )
    print("Water Content: "..tostring(g.waterContent))
end
---End Of OK btn listener---------------------------------


------------------END OF LOCAL FUNCTIONS------------------------------------------------


---------------LISTENERS------------------------------------------------------------------
------ CHECK BOXES LISTENER------------------------------------------------
local function onCheckboxRelease( event )
    local switch = event.target
    print( "Checkbox with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )

    --check state if bedding, joints and fracture is trying to check
    --if Rock is not checked on - don't allow to check and return
    if (switch.id == "Bedding" or switch.id == "Joints" or switch.id == "Fractures") then
        if (not checkBoxRock.isOn) then
            switch:setState( {isOn = false} )
            print("Don't allowed to check boxes of rock distribution untill rock itself is checked")
            return
        end
    end

    --Handle if Rock is checked or unchecked-----------------
    if (switch.id == "Rock") then
        if (switch.isOn) then g.materialRock = "Rock"
            else g.materialRock = ""
                checkBoxBedding:setState( {isOn = false} ) 
                checkBoxFractures:setState( {isOn = false} )
                checkBoxJoints:setState( {isOn = false} )
                g.bedding = false
                g.joints = false
                g.fractures = false
        end
        print("Material Rock is: "..g.materialRock)
    end

    --Handle if Soil is checked or unchecked-----------------
    if (switch.id == "Soil") then
        if (switch.isOn) then g.materialSoil = "Soil"
            else g.materialSoil = ""
                clayField.text = ""
                siltField.text = ""
                sandField.text = ""
                gravelField.text = ""
                g.clay = ""
                g.silt = ""
                g.sand = ""
                g.gravel = ""
        end
        print("Material Soil is: "..g.materialSoil)
    end

    --Handle if Bedding is checked or unchecked-----------------
    if (switch.id == "Bedding") then
        if (switch.isOn) then g.bedding = true
            else g.bedding = false
        end
        print("Bedding is: "..tostring(g.bedding))
    end

    --Handle if Joints is checked or unchecked-----------------
    if (switch.id == "Joints") then
        if (switch.isOn) then g.joints = true
            else g.joints = false
        end
        print("Joints is: "..tostring(g.joints))
    end

    --Handle if Fractures is checked or unchecked-----------------
    if (switch.id == "Fractures") then
        if (switch.isOn) then g.fractures = true
            else g.fractures = false
        end
        print("Fractures is: "..tostring(g.fractures))
    end

    printScreenVariables()
end

---END OF CHECKBOX BTN LISTENERS---------------------------------------------------------------------------


----------RADIO BUTTON LISTENER--------------------------------------------
local function onRadioBtnRelease( event )
    
    local switch = event.target
    print( "Radio Btn with ID "..switch.id.." is on: "..tostring(switch.isOn) )

        --if seep is checked assign to flowing and g.waterContent = "Flowing (Seep)"
        if (switch.id == "Seep") then
            g.waterContent = "Flowing (Seep)"
            radioBtnFlowing:setState( {isOn = true} )
            print("Seep is chosen")
        end

        --if spring is checked assign to flowing and g.waterContent = "Flowing (Spring)"
        if (switch.id == "Spring") then
            g.waterContent = "Flowing (Spring)"
            radioBtnFlowing:setState( {isOn = true} )
            print("Spring is chosen")
        end

        --if one of DRY or MOIST or WET is choisen assign g.waterContent and uncheck Seep or Spring
        if (switch.id == "Dry" or switch.id == "Moist" or switch.id == "Wet") then
            g.waterContent = switch.id
            radioBtnSeep:setState( {isOn = false} )
            radioBtnSpring:setState( {isOn = false} )
            print("Dry or Moist or Wet is chosen")
        end

        --if Flowing is chosen g.waterContent = "Flowing (Seep)" automatically and check seep radio btn
        if (switch.id == "Flowing") then
            g.waterContent = "Flowing (Seep)"
            radioBtnSeep:setState( {isOn = true} )
            print("Flowing is chosen (Seep automatically)")
        end

    print( "Water Content now: "..g.waterContent )

end
----------END OF RADIO BTN LISTENER-------------------------------------------


----------------TEXTFIELD LISTENERS-----------------------------------------------------------------------
--Clay text field listener---------------------------------------------------
local function clayFieldListener ( event )

    if (event.phase == "editing") then
        if (checkBoxSoil.isOn) then g.clay = event.text
            else event.text = ""
                clayField.text = ""
        end
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        if (checkBoxSoil.isOn) then 
            g.clay = event.target.text
            print( "Clay: " .. g.clay )
        else print("Clay cant be entered until Soil checkbox is off")
        end
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( siltField)
    end
end

--Silt text field listener---------------------------------------------------
local function siltFieldListener ( event )

    if (event.phase == "editing") then
        if (checkBoxSoil.isOn) then g.silt = event.text
            else event.text = ""
                siltField.text = ""
        end
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        if (checkBoxSoil.isOn) then 
            g.silt = event.target.text
            print( "Silt: " .. g.silt )
        else print("Silt cant be entered until Soil checkbox is off")
        end
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( sandField)
    end
end

--Sand text field listener---------------------------------------------------
local function sandFieldListener ( event )

    if (event.phase == "editing") then
        if (checkBoxSoil.isOn) then g.sand = event.text
            else event.text = ""
                sandField.text = ""
        end
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        if (checkBoxSoil.isOn) then 
            g.sand = event.target.text
            print( "Sand: " .. g.sand )
        else print("Sand cant be entered until Soil checkbox is off")
        end
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( gravelField)
    end
end

--Gravel text field listener---------------------------------------------------
local function gravelFieldListener ( event )

    if (event.phase == "editing") then
        if (checkBoxSoil.isOn) then g.gravel = event.text
            else event.text = ""
                gravelField.text = ""
        end
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        if (checkBoxSoil.isOn) then 
            g.gravel = event.target.text
            print( "Gravel: " .. g.gravel )
        else print("Gravel cant be entered until Soil checkbox is off")
        end
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( treesField)
    end
end

--Trees text field listener---------------------------------------------------
local function treesFieldListener ( event )
    if ( event.phase == "began" ) then
             --lifting up buttons and scroolview
            scrollView:scrollToPosition( {y = -screenH*0.3} ) 
    end

    if (event.phase == "editing") then
        g.trees = event.text
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.trees = event.target.text
        print( "Trees: " .. g.trees )

        --bringing scroolview and buttons back
        scrollView:scrollToPosition( {y = 0} )
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( bushesField)
    end
end

--Bushes text field listener---------------------------------------------------
local function bushesFieldListener ( event )

    if ( event.phase == "began" ) then
             --lifting up buttons and scroolview
            scrollView:scrollToPosition( {y = -screenH*0.3} ) 
    end

    if (event.phase == "editing") then
        g.bushes = event.text
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.bushes = event.target.text
        print( "Bushes: " .. g.bushes )

        --bringing scroolview and buttons back
        scrollView:scrollToPosition( {y = 0} )
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( groundcoverField) 
    end
end

--Groundcover text field listener---------------------------------------------------
local function groundcoverFieldListener ( event )

     if ( event.phase == "began" ) then
             --lifting up buttons and scroolview
            scrollView:scrollToPosition( {y = -screenH*0.3} ) 
    end

    if (event.phase == "editing") then
        g.groundcover = event.text
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.groundcover = event.target.text
        print( "Groundcover: " .. g.groundcover )

        --bringing scroolview and buttons back
        scrollView:scrollToPosition( {y = 0} )
    end 

    if (event.phase == "submitted") then
          native.setKeyboardFocus( nil)
    end
end

------------BUTTON LISTENERS-----------------------------------------------------

-----Next Btn Listener-------------------------------------
local function nextBtnListener( event)
    
    if event.phase == "began" then
        audio.play( click)
    end

    --Goes tto sign up screen-
    if event.phase == "ended" then 
    	print( "Next clicked" )
    
        --check if any of Rock or Soil material is selected-----------
        if ( (g.materialRock == nil or g.materialRock == "") and (g.materialSoil == nil or g.materialSoil =="" )) then
            textTitle = "Material Type is Missing"
            textPopUp = "Check at least one of materials \n (rock or soil or both)"
            local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
            return 
        end

        --check if Water Content is checked if not - warning
        if (g.waterContent == nil or g.waterContent == "") then
            textTitle = "Water Content is Missing"
            textPopUp = "Chose Water Content"
            local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
            return 
        end

        --check if rock is checked and all of rock types are unchecked -  then warning
        if (g.materialRock == "Rock") then 
            if ( (g.bedding == false or g.bedding == nil) and (g.joints == false or g.joints == nil) and (g.fractures == false or g.fractures == nil) ) then
                print("Rock Details are  missing!")
                textTitle = "Select Rock Type"
                textPopUp = "Selection Rock Type is suggested"
                local alert = native.showAlert( textTitle, textPopUp, { "OK" , "SKIP"}, okBtnListener )
                return
            end
        end

        --chekc if soil is checked and all soil fields are empty - then warning
        if (checkBoxSoil.isOn) then
            if ( (g.clay==nil or g.clay=="") and (g.silt==nil or g.silt =="") and (g.sand==nil or g.sand=="") and (g.gravel==nil or g.gravel=="") ) then
                textTitle = "Enter Soil Distribution"
                textPopUp = "Entering Soil Distribution is suggested"
                local alert = native.showAlert( textTitle, textPopUp, { "OK" , "SKIP"}, ok2BtnListener )
                return
            end
        end

        composer.gotoScene( "highwayPavementGroundStatus", {effect = "slideLeft", time = 300} )
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
        composer.gotoScene( "incidentTypeDistribution", {effect = "slideRight", time = 300} )     
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


    ------CREATING MATERIAL ROCK, MATERIAL SOIL, WATER CONTENT RADIO BTN (2 GROUPS), MIAN WATER CONTENT AND VEGETATION ON SLOPE GROUPS---
    materialRockGroup = display.newGroup( )
    materialRockGroup.anchorX, materialRockGroup.anchorY = 0, 0
    materialRockGroup.x, materialRockGroup.y =  screenW*0.08, 0

    materialSoilGroup = display.newGroup( )
    materialSoilGroup.anchorX, materialSoilGroup.anchorY = 0, 0
    materialSoilGroup.x, materialSoilGroup.y =  screenW*0.5, 0

    vegetationGroup = display.newGroup( )
    vegetationGroup.anchorX,vegetationGroup.anchorY = 0, 0
    vegetationGroup.x,vegetationGroup.y =  screenW*0.08, screenH*0.57

    waterContentRadioGroup1 = display.newGroup( )
    waterContentRadioGroup1.anchorX, waterContentRadioGroup1.anchorY = 0, 0
    waterContentRadioGroup1.x, waterContentRadioGroup1.y =  0, 0

    waterContentRadioGroup2 = display.newGroup( )
    waterContentRadioGroup2.anchorX, waterContentRadioGroup2.anchorY = 0, 0
    waterContentRadioGroup2.x, waterContentRadioGroup2.y =  screenW*0.5, 0

    waterContentMainGroup = display.newGroup( )
    waterContentMainGroup.anchorX, waterContentMainGroup.anchorY = 0, 0
    waterContentMainGroup.x, waterContentMainGroup.y =  screenW*0.08, screenH*0.3



	----------------------CREATING TEXT HEADERS--------------------------------------------------------------
	--create Material text header--------------------------------------------------
	materialText = display.newText( "Material", 0, screenH*0, native.systemFontBold, 14)
	materialText.anchorX, materialText.anchorY = 0,0
	materialText:setFillColor( 0.4 )	-- gray
    materialRockGroup:insert(materialText)

    --create "Est. %" text header------------------------------------------------------
    estText = display.newText( "Est. %", screenW*0.2, screenH*0.045, native.systemFont, 14)
    estText.anchorX, estText.anchorY = 0,0
    estText:setFillColor( 0 )    -- black
    materialSoilGroup:insert(estText)
	
    --create Vegetation on Slope text header--------------------------------------------------
    vegetationOnSlopeText = display.newText( "Vegetation On Slope", 0, screenH*0.02, native.systemFontBold, 14)
    vegetationOnSlopeText.anchorX, vegetationOnSlopeText.anchorY = 0,0
    vegetationOnSlopeText:setFillColor( 0.4 )    -- gray
    vegetationGroup:insert(vegetationOnSlopeText)
    
    --create "Coverage" text header------------------------------------------------------
    coverageText = display.newText( "Coverage %", screenW*0.5, screenH*0.015, native.systemFont, 14)
    coverageText.anchorX, coverageText.anchorY = 0,0
    coverageText:setFillColor( 0 )    -- black
    vegetationGroup:insert(coverageText)

    --create "Water Content" text-------------------------------------------------------
    waterContentText = display.newText( "Water Content", 0, screenH*0.015, native.systemFontBold, 14)
    waterContentText.anchorX, waterContentText.anchorY = 0,0
    waterContentText:setFillColor( 0.4 )    -- gray
    waterContentMainGroup:insert(waterContentText)


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
   --Rock checkbox--------------------------
    checkBoxRock = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.04,
        style = "checkbox",
        id = "Rock",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    materialRockGroup:insert(checkBoxRock)

    --Bedding check Box------------------------------
    checkBoxBedding = widget.newSwitch(
    {
        left = screenW*0.05,
        top = screenH*0.11,
        style = "checkbox",
        id = "Bedding",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    materialRockGroup:insert(checkBoxBedding)

    --Joints CheckBox----------------------------------
    checkBoxJoints = widget.newSwitch(
    {
        left = screenW*0.05,
        top = screenH*0.18,
        style = "checkbox",
        id = "Joints",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    materialRockGroup:insert(checkBoxJoints)

    --Fractures CheckBox----------------------------------
    checkBoxFractures = widget.newSwitch(
    {
        left = screenW*0.05,
        top = screenH*0.25,
        style = "checkbox",
        id = "Fractures",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    materialRockGroup:insert(checkBoxFractures)


    --Soil CheckBox----------------------------------
    checkBoxSoil = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.04,
        style = "checkbox",
        id = "Soil",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    materialSoilGroup:insert(checkBoxSoil)
    -------------------------END OF CHECKBOXES CREATION-------------------------------------


    ---------------------CREATE CHECKBOX TEXTS----------------------------------------------
    -----------create Rock text-------------------------------------
    rockText = display.newText( "Rock", screenW*0.08, screenH*0.045, native.systemFont, 14)
    rockText.anchorX, rockText.anchorY = 0,0
    rockText:setFillColor( 0 )    -- black
    materialRockGroup:insert(rockText)

    -----------create Bedding text-------------------------------------
    beddingText = display.newText( "Bedding", screenW*0.12, screenH*0.115, native.systemFont, 14)
    beddingText.anchorX, beddingText.anchorY = 0,0
    beddingText:setFillColor( 0 )    -- black
    materialRockGroup:insert(beddingText)

    -----------create Joints text-------------------------------------
    jointsText = display.newText( "Joints", screenW*0.12, screenH*0.185, native.systemFont, 14)
    jointsText.anchorX, jointsText.anchorY = 0,0
    jointsText:setFillColor( 0 )    -- black
    materialRockGroup:insert(jointsText)

    -----------create Fractures text-------------------------------------
    fracturesText = display.newText( "Fractures", screenW*0.12, screenH*0.255, native.systemFont, 14)
    fracturesText.anchorX, fracturesText.anchorY = 0,0
    fracturesText:setFillColor( 0 )    -- black
    materialRockGroup:insert(fracturesText)

    -----------create Soil text-------------------------------------
    soilText = display.newText( "Soil", screenW*0.08, screenH*0.045, native.systemFont, 14)
    soilText.anchorX, soilText.anchorY = 0,0
    soilText:setFillColor( 0 )    -- black
    materialSoilGroup:insert(soilText)

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
   --Dry Radio Btn--------------------------
    radioBtnDry = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.05,
        style = "radio",
        id = "Dry",
        width = 25,
        height = 25,
        initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    waterContentRadioGroup1:insert(radioBtnDry)

    --Moist Radio Btn--------------------------
    radioBtnMoist = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.11,
        style = "radio",
        id = "Moist",
        width = 25,
        height = 25,
        initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    waterContentRadioGroup1:insert(radioBtnMoist)

    --Wet Radio Btn--------------------------
    radioBtnWet = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.17,
        style = "radio",
        id = "Wet",
        width = 25,
        height = 25,
        initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    waterContentRadioGroup1:insert(radioBtnWet)

    --Flowing Radio Btn--------------------------
    radioBtnFlowing = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.23,
        style = "radio",
        id = "Flowing",
        width = 25,
        height = 25,
        initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    waterContentRadioGroup1:insert(radioBtnFlowing)

    --Seep Radio Btn--------------------------
    radioBtnSeep = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.17,
        style = "radio",
        id = "Seep",
        width = 25,
        height = 25,
        initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    waterContentRadioGroup2:insert(radioBtnSeep)

    --Spring Radio Btn--------------------------
    radioBtnSpring = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.23,
        style = "radio",
        id = "Spring",
        width = 25,
        height = 25,
        initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    waterContentRadioGroup2:insert(radioBtnSpring)
    ----------END OF RADIO BUTTON CREATION-----------------------------------------------------------------------

    ---------CREATE RADIO BTN TEXTS----------------------------------------------------------------------
    --"Dry" radio btn text----------------
    dryText = display.newText( "Dry", screenW*0.09, screenH*0.055, native.systemFont, 14)
    dryText.anchorX, dryText.anchorY = 0,0
    dryText:setFillColor( 0 )    -- black
    waterContentMainGroup:insert(dryText)

    --"Moist" radio btn text----------------
    moistText = display.newText( "Moist", screenW*0.09, screenH*0.115, native.systemFont, 14)
    moistText.anchorX, moistText.anchorY = 0,0
    moistText:setFillColor( 0 )    -- black
    waterContentMainGroup:insert(moistText)

    --"Wet" radio btn text----------------
    wetText = display.newText( "Wet", screenW*0.09, screenH*0.175, native.systemFont, 14)
    wetText.anchorX, wetText.anchorY = 0,0
    wetText:setFillColor( 0 )    -- black
    waterContentMainGroup:insert(wetText)

    --"Flowing" radio btn text----------------
    flowingText = display.newText( "Flowing", screenW*0.09, screenH*0.235, native.systemFont, 14)
    flowingText.anchorX, flowingText.anchorY = 0,0
    flowingText:setFillColor( 0 )    -- black
    waterContentMainGroup:insert(flowingText)

    --"Seep" radio btn text----------------
    seepText = display.newText( "Seep", screenW*0.59, screenH*0.175, native.systemFont, 14)
    seepText.anchorX, seepText.anchorY = 0,0
    seepText:setFillColor( 0 )    -- black
    waterContentMainGroup:insert(seepText)

    --"Spring" radio btn text----------------
    springText = display.newText( "Spring", screenW*0.59, screenH*0.235, native.systemFont, 14)
    springText.anchorX, springText.anchorY = 0,0
    springText:setFillColor( 0 )    -- black
    waterContentMainGroup:insert(springText)


    ---------------------TEXTFIELD TEXTS -----------------------------------------------------------------------
    ------SOIL TEXTFIELD TEXTS
    -----------Clay field  text-------------------------------------
    clayText = display.newText( "Clay", 0, screenH*0.09, native.systemFont, 14)
    clayText.anchorX, clayText.anchorY = 0,0
    clayText:setFillColor( 0 )    -- black
    materialSoilGroup:insert(clayText)

    -----------Silt field  text-------------------------------------
    siltText = display.newText( "Silt", 0, screenH*0.15, native.systemFont, 14)
    siltText.anchorX, siltText.anchorY = 0,0
    siltText:setFillColor( 0 )    -- black
    materialSoilGroup:insert(siltText)

    -----------Sand field  text-------------------------------------
    sandText = display.newText( "Sand", 0, screenH*0.21, native.systemFont, 14)
    sandText.anchorX, sandText.anchorY = 0,0
    sandText:setFillColor( 0 )    -- black
    materialSoilGroup:insert(sandText)

    -----------Gravel field  text-------------------------------------
    gravelText = display.newText( "Gravel", 0, screenH*0.27, native.systemFont, 14)
    gravelText.anchorX, gravelText.anchorY = 0,0
    gravelText:setFillColor( 0 )    -- black
    materialSoilGroup:insert(gravelText)

    ---------END SOIL TEXTFIELD TEXT------------------------------

    --------VEGETATION TEXTFIELD TEXT
    -----------Trees field  text-------------------------------------
    treesText = display.newText( "Trees", screenW*0.08, screenH*0.06, native.systemFont, 14)
    treesText.anchorX, treesText.anchorY = 0,0
    treesText:setFillColor( 0 )    -- black
    vegetationGroup:insert(treesText)

    -----------Bushes field  text-------------------------------------
    bushesText = display.newText( "Bushes/Shrubs", screenW*0.08, screenH*0.12, native.systemFont, 14)
    bushesText.anchorX, bushesText.anchorY = 0,0
    bushesText:setFillColor( 0 )    -- black
    vegetationGroup:insert(bushesText)

    -----------Groundcover field  text-------------------------------------
    groundcoverText = display.newText( "Groundcover", screenW*0.08, screenH*0.18, native.systemFont, 14)
    groundcoverText.anchorX, groundcoverText.anchorY = 0,0
    groundcoverText:setFillColor( 0 )    -- black
    vegetationGroup:insert(groundcoverText)
    -----END OF VEGETATION TEXTFIELD TEXTS
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
    waterContentMainGroup:insert( waterContentRadioGroup1 )
    waterContentMainGroup:insert( waterContentRadioGroup2 )
 
    scrollView:insert( materialRockGroup) 
    scrollView:insert( materialSoilGroup)
    scrollView:insert( waterContentMainGroup)
    scrollView:insert( vegetationGroup)
    scrollView:insert( footerGroup)

	sceneGroup:insert( background )
	sceneGroup:insert( backgroundHead )
	sceneGroup:insert( title )
    sceneGroup:insert( scrollView )
    --sceneGroup:insert( materialRockGroup )
    --sceneGroup:insert( materialSoilGroup)
    --sceneGroup:insert( vegetationGroup )
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

    --------CREATING TEXTFIELDS--------------------------------------------------------------
            --MATERIAL GROUP--
        --Clay textfield----------------------------------------------
        clayField = native.newTextField( screenW*0.23, screenH*0.10, 70, 30 )
        clayField.placeholder = ""
        clayField.inputType = "number"
        clayField:addEventListener( "userInput", clayFieldListener )
        materialSoilGroup:insert(clayField)   --insert text Field in scrool view

        --silt textfield----------------------------------------------
        siltField = native.newTextField( screenW*0.23, screenH*0.16, 70, 30 )
        siltField.placeholder = ""
        siltField.inputType = "number"
        siltField:addEventListener( "userInput", siltFieldListener )
        materialSoilGroup:insert(siltField)   --insert text Field in scrool view

        --Sand textfield----------------------------------------------
        sandField = native.newTextField( screenW*0.23, screenH*0.22, 70, 30 )
        sandField.placeholder = ""
        sandField.inputType = "number"
        sandField:addEventListener( "userInput", sandFieldListener )
        materialSoilGroup:insert(sandField)   --insert text Field in scrool view

        --Gravel textfield----------------------------------------------
        gravelField = native.newTextField( screenW*0.23, screenH*0.28, 70, 30 )
        gravelField.placeholder = ""
        gravelField.inputType = "number"
        gravelField:addEventListener( "userInput", gravelFieldListener )
        materialSoilGroup:insert(gravelField)   --insert text Field in scrool view


        --Trees textfield----------------------------------------------
        treesField = native.newTextField( screenW*0.6, screenH*0.07, 90, 30 )
        treesField.placeholder = ""
        treesField.inputType = "number"
        treesField:addEventListener( "userInput", treesFieldListener )
        vegetationGroup:insert(treesField)   --insert text Field in scrool view

            --VEGETATION GROUP--
        --Bushes/Shrubs textfield----------------------------------------------
        bushesField = native.newTextField( screenW*0.6, screenH*0.13, 90, 30 )
        bushesField.placeholder = ""
        bushesField.inputType = "number"
        bushesField:addEventListener( "userInput", bushesFieldListener )
        vegetationGroup:insert(bushesField)   --insert text Field in scrool view

        --GroundCover textfield----------------------------------------------
        groundcoverField = native.newTextField( screenW*0.6, screenH*0.19, 90, 30 )
        groundcoverField.placeholder = ""
        groundcoverField.inputType = "number"
        groundcoverField:addEventListener( "userInput", groundcoverFieldListener )
        vegetationGroup:insert(groundcoverField)   --insert text Field in scrool view

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
        clayField:removeSelf()
        clayField = nil

        siltField:removeSelf()
        siltField = nil

        sandField:removeSelf()
        sandField = nil

        gravelField:removeSelf()
        gravelField = nil

        treesField:removeSelf()
        treesField = nil

        bushesField:removeSelf()
        bushesField = nil

        groundcoverField:removeSelf()
        groundcoverField = nil

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