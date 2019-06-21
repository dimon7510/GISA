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

local waterDrainageText, impactedText, mayBeImpactedText      --permanent text titles

--names of  Water/Drainage checkboxes
local cloggedInletText, compromisedDrainsText, surfaceRunoffText, torrentSurgeFloodText

--names of Impacted checkboxes
local adjacentUtilitieText, adjacentPropertiesText, adjacentStructuresText

--checkboxes of Water/Drainage Groupe
local checkBoxCloggedInlet, checkBoxCompromisedDrains, checkBoxSurfaceRunoff, checkBoxTorrentSurgeFlood

--checkBoxes of Impacted Groupe
local checkBoxUtilitiesImpacted, checkBoxUtilitiesMayBeImpacted, checkBoxPropertiesImpacted, checkBoxPropertiesMayBeImpacted
local checkBoxStructuresImpacted, checkBoxStructuresMayBeImpacted

local textPopUp  --text displayed in message alert
local textTitle --text of popup title

local headerGroup               --heder group with buttons
local footerGroup               --footer group with buttons

local waterDrainageGroup, impactedGroup --grouping of elements


----------------LOCAL FUNCTIONS--------------------------------------------------------
----------function "nullyfyTextFields"  deletes texts above and below textfields----
local function nullifyTextFields(  )
    --[[
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
]]
end
--------------------------------------------------------------------------------------------

--------Pop Up Ok BTN Listener------------------------------
local function okBtnListener( event )
   
end
-------End Of OK btn listener---------------------------------

-------Function  "printVariables" prints out Water/Drainage checked boxes and impacted variable values-------
local function printVariables( )
    print("WATER DRAINAGE Checked")
    for index, data in ipairs(g.waterDrainage) do
        print( index.." "..data )
    end

    print( "IMPACTED VALUES" )
    print("Adjacent Utilities: "..tostring(g.adjacentUtilities) )
    print( "Adjacent Properties: "..tostring(g.adjacentProperties) )
    print( "Adjacent Structures: "..tostring(g.adjacentStructures).."\n" )
end
----------End Of "printVariables" function----------------------------------------------------------------

------------------END OF LOCAL FUNCTIONS------------------------------------------------


---------------LISTENERS------------------------------------------------------------------
------ CHECK BOXES LISTENER------------------------------------------------
local function onCheckboxRelease( event )
    local switch = event.target
    print( "Checkbox with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )

    --check if checkbox from Water/Drainage groupe is checked
    if (switch.id == "Clogged Inlet" or switch.id == "Compromised Drains" or switch.id =="Surface Runoff" or switch.id == "Torrent, Surge, Flood") then 
        
        --check state of check box: 1) if on - enter in g.waterDrainage Table
        --2) if of - delete from g.waterDrainage table
        if (switch.isOn == true) then
            g.waterDrainage[#g.waterDrainage+1] = switch.id
            print("Input in array: "..tostring(switch.isOn))
        else
                --delete from incedentType table if checkbox uncheked
                local existInCheckbox = false
            for index, data in ipairs(g.waterDrainage) do
                if (switch.id == data) then 
                    table.remove(g.waterDrainage, index)
                    existInCheckbox = true
                    print( "deleting from checkbox array: "..index.." "..data )
                end
            end
            if(not existInCheckbox) then print( "Smth. wrong: trying to uncheck (delete) not existing entry in table" ) end
        end  --end of if statement

    else

        --case when checkbox from Impacted group was checked
            --adjacent utilities impacted case
        if (switch.id == "Utilities Impacted") then
            if (switch.isOn) then 
                g.adjacentUtilities = switch.id
                if (checkBoxUtilitiesMayBeImpacted.isOn) then checkBoxUtilitiesMayBeImpacted:setState( {isOn = false} ) end
            else if (not checkBoxUtilitiesMayBeImpacted.isOn) then g.adjacentUtilities = "" end
            end
        end

          --adjacent utilities may be impacted case
        if (switch.id == "Utilities May Be Impacted") then
            if (switch.isOn) then 
                g.adjacentUtilities = switch.id
                if (checkBoxUtilitiesImpacted.isOn) then checkBoxUtilitiesImpacted:setState( {isOn = false} ) end
            else if (not checkBoxUtilitiesImpacted.isOn) then g.adjacentUtilities = "" end
            end
        end
        --***********************************************************************************************************

    end
    printVariables()
end
------end of Check Box Listener-------------------------------------------------------
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
    
--[[
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
        ]]
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
        composer.gotoScene( "highwayPavementGroundStatus", {effect = "slideRight", time = 300} )     
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


    ------CREATING WATER/DRAINAGE AND IMPACTED GROUPS---------------------------------
    waterDrainageGroup = display.newGroup( )
    waterDrainageGroup.anchorX, waterDrainageGroup.anchorY = 0, 0
    waterDrainageGroup.x, waterDrainageGroup.y =  screenW*0.08, screenH*0.1

    impactedGroup = display.newGroup( )
    impactedGroup.anchorX, impactedGroup.anchorY = 0, 0
    impactedGroup.x, impactedGroup.y =  screenW*0.08, screenH*0.5


	----------------------CREATING TEXT HEADERS--------------------------------------------------------------
	--create Water/Drainage text header--------------------------------------------------
	waterDrainageText = display.newText( "Water/Drainage", 0, screenH*0, native.systemFontBold, 14)
	waterDrainageText.anchorX, waterDrainageText.anchorY = 0,0
	waterDrainageText:setFillColor( 0.4 )	-- gray
    waterDrainageGroup:insert(waterDrainageText)
	
    --createImpated text headers--------------------------------------------------
        --Impacted header
    impactedText = display.newText( "Impacted", 0, screenH*0, native.systemFontBold, 14)
    impactedText.anchorX, impactedText.anchorY = 0,0
    impactedText:setFillColor( 0.4 )    -- gray
    impactedGroup:insert(impactedText)

        --May Be Impacted header
    mayBeImpactedText = display.newText( "May be Impacted", screenW*0.3, screenH*0, native.systemFontBold, 14)
    mayBeImpactedText.anchorX, mayBeImpactedText.anchorY = 0,0
    mayBeImpactedText:setFillColor( 0.4 )    -- gray
    impactedGroup:insert(mayBeImpactedText)


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
   -----WATER/DRAINAGE Groupe Check Boxes------------
   --Clogged Inlet checkbox--------------------------
    checkBoxCloggedInlet = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.05,
        style = "checkbox",
        id = "Clogged Inlet",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    waterDrainageGroup:insert(checkBoxCloggedInlet)

    --Compromised Draines checkbox--------------------------
    checkBoxCompromisedDrains = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.12,
        style = "checkbox",
        id = "Compromised Drains",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    waterDrainageGroup:insert(checkBoxCompromisedDrains)

    --Surface Runoff checkbox--------------------------
    checkBoxSurfaceRunoff = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.19,
        style = "checkbox",
        id = "Surface Runoff",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    waterDrainageGroup:insert(checkBoxSurfaceRunoff)

    --Torrent, Surge, Flood checkbox--------------------------
    checkBoxTorrentSurgeFlood = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.26,
        style = "checkbox",
        id = "Torrent, Surge, Flood",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    waterDrainageGroup:insert(checkBoxTorrentSurgeFlood)
    ---------END OF WATER/DRAINAGE CHECKBOXES----------------------------------------------


    --------IMPACTED GROUP CHECKBOXES-----------------------------------------------------
    --Adjacent Utilities Impacted checkbox--------------------------
    checkBoxUtilitiesImpacted = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.05,
        style = "checkbox",
        id = "Utilities Impacted",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    impactedGroup:insert(checkBoxUtilitiesImpacted)

    --Adjacent Properties Impacted checkbox--------------------------
    checkBoxPropertiesImpacted = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.12,
        style = "checkbox",
        id = "Properties Impacted",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    impactedGroup:insert(checkBoxPropertiesImpacted)

    --Adjacent Stuctures Impacted checkbox--------------------------
    checkBoxStructuresImpacted = widget.newSwitch(
    {
        left = 0,
        top = screenH*0.19,
        style = "checkbox",
        id = "Structures Impacted",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    impactedGroup:insert(checkBoxStructuresImpacted)

    --Adjacent Utilities Maybe Impacted  checkbox--------------------------
    checkBoxUtilitiesMayBeImpacted = widget.newSwitch(
    {
        left = screenW*0.35,
        top = screenH*0.05,
        style = "checkbox",
        id = "Utilities May Be Impacted",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    impactedGroup:insert(checkBoxUtilitiesMayBeImpacted)

    --Adjacent Properties Maybe Impacted  checkbox--------------------------
    checkBoxPropertiesMayBeImpacted = widget.newSwitch(
    {
        left = screenW*0.35,
        top = screenH*0.12,
        style = "checkbox",
        id = "Properties May Be Impacted",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    impactedGroup:insert(checkBoxPropertiesMayBeImpacted)

    --Adjacent Structures Maybe Impacted  checkbox--------------------------
    checkBoxStructuresMayBeImpacted = widget.newSwitch(
    {
        left = screenW*0.35,
        top = screenH*0.19,
        style = "checkbox",
        id = "Structures May Be Impacted",
        width = 25,
        height = 25,
        onRelease = onCheckboxRelease,
        sheet = checkBoxSheet,
        frameOff = 1,
        frameOn = 2
    }
    )
    impactedGroup:insert(checkBoxStructuresMayBeImpacted)
    --End of IMPACTED group checkboxes creation--------------------------------

    -------------------------END OF CHECKBOXES CREATION-------------------------------------


    ---------------------CREATE CHECKBOX TEXTS----------------------------------------------
    -----------create Clogged Inlet text-------------------------------------
    cloggedInletText = display.newText( "Clogged Inlet", screenW*0.08, screenH*0.055, native.systemFont, 14)
    cloggedInletText.anchorX, cloggedInletText.anchorY = 0,0
    cloggedInletText:setFillColor( 0 )    -- black
    waterDrainageGroup:insert(cloggedInletText)

    -----------create Compromised Drains text-------------------------------------
    compromisedDrainsText = display.newText( "Compromised Drains", screenW*0.08, screenH*0.125, native.systemFont, 14)
    compromisedDrainsText.anchorX, compromisedDrainsText.anchorY = 0,0
    compromisedDrainsText:setFillColor( 0 )    -- black
    waterDrainageGroup:insert(compromisedDrainsText)

    -----------create Suraface Runoff text-------------------------------------
    surfaceRunoffText = display.newText( "Surface Runoff", screenW*0.08, screenH*0.195, native.systemFont, 14)
    surfaceRunoffText.anchorX, surfaceRunoffText.anchorY = 0,0
    surfaceRunoffText:setFillColor( 0 )    -- black
    waterDrainageGroup:insert(surfaceRunoffText)

    -----------create Torrent, Surge, Flood text-------------------------------------
    torrentSurgeFloodText = display.newText( "Torrent, Surge, Flood", screenW*0.08, screenH*0.265, native.systemFont, 14)
    torrentSurgeFloodText.anchorX, torrentSurgeFloodText.anchorY = 0,0
    torrentSurgeFloodText:setFillColor( 0 )    -- black
    waterDrainageGroup:insert(torrentSurgeFloodText)

    -----------create Adjacent Utilities text-------------------------------------
    adjacentUtilitieText = display.newText( "Adjacent Utilities", screenW*0.5, screenH*0.055, native.systemFont, 14)
    adjacentUtilitieText.anchorX, adjacentUtilitieText.anchorY = 0,0
    adjacentUtilitieText:setFillColor( 0 )    -- black
    impactedGroup:insert(adjacentUtilitieText)

    -----------create Adjacent Properties text-------------------------------------
    adjacentPropertiesText = display.newText( "Adjacent Properties", screenW*0.5, screenH*0.125, native.systemFont, 14)
    adjacentPropertiesText.anchorX, adjacentPropertiesText.anchorY = 0,0
    adjacentPropertiesText:setFillColor( 0 )    -- black
    impactedGroup:insert(adjacentPropertiesText)

    -----------create Adjacent Structures text-------------------------------------
    adjacentStructuresText = display.newText( "Adjacent Structures", screenW*0.5, screenH*0.195, native.systemFont, 14)
    adjacentStructuresText.anchorX, adjacentStructuresText.anchorY = 0,0
    adjacentStructuresText:setFillColor( 0 )    -- black
    impactedGroup:insert(adjacentStructuresText)

    ----------------------------------END OF CHECKBOX TEXTS------------------------------------------------------



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
    sceneGroup:insert( waterDrainageGroup )
    sceneGroup:insert( impactedGroup)
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

        nullifyTextFields(  ) --nullifying textfields and assigning to stored values

    elseif phase == "did" then
        -- Called when the scene is now on screen

        printVariables()
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