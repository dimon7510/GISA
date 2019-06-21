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

local incidentTypeText, distributionText      --permanent text titles

--names of Incident types
local rockFallText, toppleText, slideText, spreadText, flowText, compoundText, erosionText, surfacialSloughingText, scouredToeText, washoutText
--checkboxes of incident types widgets
local checkBoxRockFall, checkBoxTopple, checkBoxSlide, checkBoxSpread, checkBoxFlow, checkBoxCompound
local checkBoxErosion, checkBoxSurfacialSloughing, checkBoxScouredToe, checkBoxWashout

--radio btn of distribution widgets
local radioBtnAdvancing, radioBtnRetrogressing, radioBtnEnlarging, radioBtnWidening, radioBtnMoving, radioBtnConfined

--names of Distributions
local advancingText, retrogressingText, enlargingText, wideningText, movingText, confinedText
            
local saveBtn, nextBtn, backBtn --buttons declaration

local textPopUp  --text displayed in message alert
local textTitle --text of popup title

local allFieldsFill 			--flag to indicate if all fields are fulled out
local headerGroup               --heder group with buttons
local footerGroup 				--footer group with buttons


----------------LOCAL FUNCTIONS--------------------------------------------------------
----------function "nullyfyTextFields"  deletes texts above and below textfields----
local function nullifyTextFields(  )

    --put radion button in stage saved in variable g.distribution
    if (g.distribution ~= nil and g.distribution ~="") then 
        if (g.distribution == "Advancing") then 
            radioBtnAdvancing:setState( { isOn=true } )
            print("Advascing is on initially")
        elseif (g.distribution == "Retrogressing") then
            radioBtnRetrogressing:setState( { isOn=true } )
            print("Retrogressing is on initially")
        elseif (g.distribution == "Enlarging") then
            radioBtnEnlarging:setState( { isOn=true } )
            print("Enlarging is on initially")
        elseif (g.distribution == "Widening") then
            radioBtnWidening:setState( { isOn=true } )
            print("Widening is on initially")
        elseif (g.distribution == "Moving") then
            radioBtnMoving:setState( { isOn=true } )
            print("Moving is on initially")
        elseif (g.distribution == "Confined") then 
            radioBtnConfined:setState( { isOn=true } )
            print("Confined is on initially")
        else 
            print( "Unexpected Value in g.distribution: SMTH WRONG" )
        end
    end

    --put checkboxes in stage saved in vaiable tabl g.incidentType
        --uncheck all check Boxes
    checkBoxRockFall:setState( { isOn=false } )
    checkBoxTopple:setState( { isOn=false } )
    checkBoxSlide:setState( { isOn=false } )
    checkBoxSpread:setState( { isOn=false } )
    checkBoxFlow:setState( { isOn=false } )
    checkBoxCompound:setState( { isOn=false } )
    checkBoxErosion:setState( { isOn=false } )
    checkBoxSurfacialSloughing:setState( { isOn=false } )
    checkBoxScouredToe:setState( { isOn=false } )
    checkBoxWashout:setState( { isOn=false } )
    for index, data in ipairs(g.incidentType) do
        if (data == "(Rock) Fall") then checkBoxRockFall:setState( { isOn=true } ) end
        if (data == "Topple") then checkBoxTopple:setState( { isOn=true } ) end
        if (data == "Slide") then checkBoxSlide:setState( { isOn=true } ) end
        if (data == "Spread") then checkBoxSpread:setState( { isOn=true } ) end
        if (data == "Flow") then checkBoxFlow:setState( { isOn=true } ) end
        if (data == "Compound") then checkBoxCompound:setState( { isOn=true } ) end
        if (data == "Erosion") then checkBoxErosion:setState( { isOn=true } ) end
        if (data == "Surfacial Sloughing") then checkBoxSurfacialSloughing:setState( { isOn=true } ) end
        if (data == "Scoured Toe") then checkBoxScouredToe:setState( { isOn=true } ) end
        if (data == "Washout") then checkBoxWashout:setState( { isOn=true } ) end
    end

end
--------------------------------------------------------------------------------------------

--------Pop Up Ok BTN Listener------------------------------
local function okBtnListener( event )
   
end
------------------------------------------------------------

-------Function "printIncidentType" prints out all incidents checked-------------------
local function printIncidentType( )
    print("INCIDENT TYPES")
    for index, data in ipairs(g.incidentType) do
        print( index.." "..data )
    end

   -- print("Rockfall: "..tostring(checkBoxRockFall.isOn) )
end
---End Of OK btn listener---------------------------------


------------------END OF LOCAL FUNCTIONS------------------------------------------------


---------------LISTENERS------------------------------------------------------------------
------ CHECK BOXES LISTENER------------------------------------------------
local function onCheckboxRelease( event )
    local switch = event.target
    print( "Checkbox with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )

    --check state of check box: 1) if on - enter in incidentType Table
    --2) if of - delete from incidentType table
    if (switch.isOn == true) then
        g.incidentType[#g.incidentType+1] = switch.id
        print("Input in array: "..tostring(switch.isOn))
    else
            --delete from incedentType table if checkbox uncheked
            local existInCheckbox = false
        for index, data in ipairs(g.incidentType) do
            if (switch.id == data) then 
                table.remove(g.incidentType, index)
                existInCheckbox = true
                print( "deleting from checkbox array: "..index.." "..data )
            end
        end
        if(not existInCheckbox) then print( "Smth. wrong: trying to uncheck (delete) not existing entry in table" ) end
    end  --end of if statement
    printIncidentType()
end
------end of Check Box Listener-------------------------------------------------------

----------RADIO BUTTON LISTENER--------------------------------------------
local function onRadioBtnRelease( event )
    local switch = event.target
    print( "Radio Btn with ID "..switch.id.." is on: "..tostring(switch.isOn) )
        --assign to distribution proper value
    g.distribution = switch.id
    print( "Distribution now: "..g.distribution )
end
----------end of Radio Btn Listener-------------------------------------------
---END OF CHECKBOX AND RADIO BTN LISTENERS---------------------------------------------------------------------------




------------BUTTON LISTENERS-----------------------------------------------------

-----Next Btn Listener-------------------------------------
local function nextBtnListener( event)
    
    if event.phase == "began" then
        audio.play( click)
    end

    --Goes tto sign up screen-
    if event.phase == "ended" then 
    	print( "Next clicked" )
    

        --check if any of checkbox is selected-----------
        if (table.getn(g.incidentType)==0) then
            textTitle = "Incident Type Missing"
            textPopUp = "Check at least one incident type"
            local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
            return 
        end

        --check if radio btn is selected-----------------
        if  (g.distribution==nil or g.distribution=="") then
            textTitle = "Distribution ius not selected"
            textPopUp = "Select Distribution"
            local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
            return 
        end

        composer.gotoScene( "materialVegetationOnSlope", {effect = "slideLeft", time = 300} )
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
        composer.gotoScene( "incidentMain", {effect = "slideRight", time = 300} )     
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

	--blue footer rectangle and insert in footer group-------------------
	local whiteFooter = display.newRect(footerGroup, 0, 0, screenW*1.2, screenH *0.15)
	whiteFooter:setFillColor( 0.1,0.2,0.8, 1 )	-- blue


	-------------------CREATING TITLE-----------------------------------------------
	-- create GISAproject title---------------------------------------------------
	local title = display.newText( "GISAproject", 60, 35, native.systemFont, 16 )
	title:setFillColor( 1 )	-- black


    ------CREATING INCIDENT AND DISTRIBUTION GROUPS---------------------------------
    incidentGroup = display.newGroup( )
    incidentGroup.anchorX, incidentGroup.anchorY = 0, 0
    incidentGroup.x, incidentGroup.y =  screenW*0.08, screenH*0.1

    distributionGroup = display.newGroup( )
    distributionGroup.anchorX, distributionGroup.anchorY = 0, 0
    distributionGroup.x, distributionGroup.y =  screenW*0.55, screenH*0.1


	----------------------CREATING TEXT HEADERS--------------------------------------------------------------
	--create Incidnet Type text header--------------------------------------------------
	incidentTypeText = display.newText( "Incident Type", 0, screenH*0, native.systemFontBold, 14)
	incidentTypeText.anchorX, incidentTypeText.anchorY = 0,0
	incidentTypeText:setFillColor( 0.4 )	-- gray
    incidentGroup:insert(incidentTypeText)
	
    --create Distribution text header--------------------------------------------------
    distributionText = display.newText( "Distribution", 0, screenH*0, native.systemFontBold, 14)
    distributionText.anchorX, distributionText.anchorY = 0,0
    distributionText:setFillColor( 0.4 )    -- gray
    distributionGroup:insert(distributionText)


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
   

   ---------------------Create All CheckBox widjets--------------------------------------------------------
   --RockFall checkbox--------------------------
    checkBoxRockFall = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.05,
        style = "checkbox",
        id = "(Rock) Fall",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    incidentGroup:insert(checkBoxRockFall)

    --Topple check Box------------------------------
    checkBoxTopple = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.12,
        style = "checkbox",
        id = "Topple",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    incidentGroup:insert(checkBoxTopple)

    --Slide CheckBox----------------------------------
    checkBoxSlide = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.19,
        style = "checkbox",
        id = "Slide",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    incidentGroup:insert(checkBoxSlide)

    --Spread CheckBox----------------------------------
    checkBoxSpread = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.26,
        style = "checkbox",
        id = "Spread",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    incidentGroup:insert(checkBoxSpread)

    --Flow CheckBox----------------------------------
    checkBoxFlow = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.33,
        style = "checkbox",
        id = "Flow",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    incidentGroup:insert(checkBoxFlow)

    --Compound CheckBox----------------------------------
    checkBoxCompound = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.40,
        style = "checkbox",
        id = "Compound",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    incidentGroup:insert(checkBoxCompound)

    --Erosion CheckBox----------------------------------
    checkBoxErosion = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.47,
        style = "checkbox",
        id = "Erosion",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    incidentGroup:insert(checkBoxErosion)

    --Surfacial Sloughing CheckBox----------------------------------
    checkBoxSurfacialSloughing = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.54,
        style = "checkbox",
        id = "Surfacial Sloughing",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    incidentGroup:insert(checkBoxSurfacialSloughing)

    --Scoured Toe CheckBox----------------------------------
    checkBoxScouredToe = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.61,
        style = "checkbox",
        id = "Scoured Toe",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    incidentGroup:insert(checkBoxScouredToe)

    --Washout CheckBox----------------------------------
    checkBoxWashout = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.68,
        style = "checkbox",
        id = "Washout",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    incidentGroup:insert(checkBoxWashout)
    -------------------------END OF CHECKBOXES CREATION-------------------------------------


    ---------------------CREATE CHECKBOX TEXTS----------------------------------------------
    -----------create Rock Fall text-------------------------------------
    rockFallText = display.newText( "(Rock) Fall", screenW*0.08, screenH*0.055, native.systemFont, 14)
    rockFallText.anchorX, rockFallText.anchorY = 0,0
    rockFallText:setFillColor( 0 )    -- black
    incidentGroup:insert(rockFallText)

    -----------create Topple text-------------------------------------
    toppleText = display.newText( "Topple", screenW*0.08, screenH*0.125, native.systemFont, 14)
    toppleText.anchorX, toppleText.anchorY = 0,0
    toppleText:setFillColor( 0 )    -- black
    incidentGroup:insert(toppleText)

    -----------create Slide text-------------------------------------
    slideText = display.newText( "Slide", screenW*0.08, screenH*0.195, native.systemFont, 14)
    slideText.anchorX, slideText.anchorY = 0,0
    slideText:setFillColor( 0 )    -- black
    incidentGroup:insert(slideText)

    -----------create Spread text-------------------------------------
    spreadText = display.newText( "Spread", screenW*0.08, screenH*0.265, native.systemFont, 14)
    spreadText.anchorX, spreadText.anchorY = 0,0
    spreadText:setFillColor( 0 )    -- black
    incidentGroup:insert(spreadText)

    -----------create Flow text-------------------------------------
    flowText = display.newText( "Flow", screenW*0.08, screenH*0.335, native.systemFont, 14)
    flowText.anchorX, flowText.anchorY = 0,0
    flowText:setFillColor( 0 )    -- black
    incidentGroup:insert(flowText)

    -----------create Compound text-------------------------------------
    compoundText = display.newText( "Compound", screenW*0.08, screenH*0.405, native.systemFont, 14)
    compoundText.anchorX, compoundText.anchorY = 0,0
    compoundText:setFillColor( 0 )    -- black
    incidentGroup:insert(compoundText)

    -----------create Erosion text-------------------------------------
    erosionText = display.newText( "Erosion", screenW*0.08, screenH*0.475, native.systemFont, 14)
    erosionText.anchorX, erosionText.anchorY = 0,0
    erosionText:setFillColor( 0 )    -- black
    incidentGroup:insert(erosionText)

    -----------create Surfacial Sloughing text-------------------------------------
    surfacialSloughingText = display.newText( "Surfacial Sloughing", screenW*0.08, screenH*0.545, native.systemFont, 14)
    surfacialSloughingText.anchorX, surfacialSloughingText.anchorY = 0,0
    surfacialSloughingText:setFillColor( 0 )    -- black
    incidentGroup:insert(surfacialSloughingText)

    -----------create Scoured Toe text-------------------------------------
    scouredToeText = display.newText( "Scoured Toe", screenW*0.08, screenH*0.615, native.systemFont, 14)
    scouredToeText.anchorX, scouredToeText.anchorY = 0,0
    scouredToeText:setFillColor( 0 )    -- black
    incidentGroup:insert(scouredToeText)

    -----------create Washout text-------------------------------------
    washoutText = display.newText( "Washout", screenW*0.08, screenH*0.685, native.systemFont, 14)
    washoutText.anchorX, washoutText.anchorY = 0,0
    washoutText:setFillColor( 0 )    -- black
    incidentGroup:insert(washoutText)
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
   --Advancing Radio Btn--------------------------
    radioBtnAdvancing = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.05,
        style = "radio",
        id = "Advancing",
        width = 25,
        height = 25,
        initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    distributionGroup:insert(radioBtnAdvancing)

    --Retrogressing Radio Btn--------------------------
    radioBtnRetrogressing = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.12,
        style = "radio",
        id = "Retrogressing",
        width = 25,
        height = 25,
        --initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    distributionGroup:insert(radioBtnRetrogressing)

    --Enlarging Radio Btn--------------------------
    radioBtnEnlarging = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.19,
        style = "radio",
        id = "Enlarging",
        width = 25,
        height = 25,
        --initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    distributionGroup:insert(radioBtnEnlarging)

    --Widening Radio Btn--------------------------
    radioBtnWidening = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.26,
        style = "radio",
        id = "Widening",
        width = 25,
        height = 25,
        --initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    distributionGroup:insert(radioBtnWidening)

    --Moving Radio Btn--------------------------
    radioBtnMoving = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.33,
        style = "radio",
        id = "Moving",
        width = 25,
        height = 25,
        --initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    distributionGroup:insert(radioBtnMoving)

    --Confined Radio Btn--------------------------
    radioBtnConfined = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.40,
        style = "radio",
        id = "Confined",
        width = 25,
        height = 25,
        --initialSwitchState = false,
        onRelease = onRadioBtnRelease,
        sheet = radioBtnSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    distributionGroup:insert(radioBtnConfined)
    -------------------------END OF RADIO BTN CREATION-------------------------------------------


    ---------------------RADIO BUTTON TEXTS------------------------------------------------------
    -----------Advancing Radio Btn text-------------------------------------
    advancingText = display.newText( "Advancing", screenW*0.08, screenH*0.055, native.systemFont, 14)
    advancingText.anchorX, advancingText.anchorY = 0,0
    advancingText:setFillColor( 0 )    -- black
    distributionGroup:insert(advancingText)

    -----------Retrogressing Radio Btn text-------------------------------------
    retrogressingText = display.newText( "Retrogressing", screenW*0.08, screenH*0.125, native.systemFont, 14)
    retrogressingText.anchorX, retrogressingText.anchorY = 0,0
    retrogressingText:setFillColor( 0 )    -- black
    distributionGroup:insert(retrogressingText)

     -----------Enlarging Radio Btn text-------------------------------------
    enlargingText = display.newText( "Enlarging", screenW*0.08, screenH*0.195, native.systemFont, 14)
    enlargingText.anchorX, enlargingText.anchorY = 0,0
    enlargingText:setFillColor( 0 )    -- black
    distributionGroup:insert(enlargingText)

     -----------Widening Radio Btn text-------------------------------------
    wideningText = display.newText( "Widening", screenW*0.08, screenH*0.265, native.systemFont, 14)
    wideningText.anchorX, wideningText.anchorY = 0,0
    wideningText:setFillColor( 0 )    -- black
    distributionGroup:insert(wideningText)

     -----------Moving Radio Btn text-------------------------------------
    movingText = display.newText( "Moving", screenW*0.08, screenH*0.335, native.systemFont, 14)
    movingText.anchorX, movingText.anchorY = 0,0
    movingText:setFillColor( 0 )    -- black
    distributionGroup:insert(movingText)

     -----------Confined Radio Btn text-------------------------------------
    confinedText = display.newText( "Confined", screenW*0.08, screenH*0.405, native.systemFont, 14)
    confinedText.anchorX, confinedText.anchorY = 0,0
    confinedText:setFillColor( 0 )    -- black
    distributionGroup:insert(confinedText)

    ----------------------END OF RADIO BUTTON TEXTST---------------------------------------------


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
	sceneGroup:insert( background )
	sceneGroup:insert( backgroundHead )
	sceneGroup:insert( title )
	sceneGroup:insert( footerGroup )
    sceneGroup:insert( incidentGroup )
    sceneGroup:insert( distributionGroup)
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

        nullifyTextFields(  ) --nullifying textfields and assigning to stored values

    elseif phase == "did" then
        -- Called when the scene is now on screen

        printIncidentType()
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