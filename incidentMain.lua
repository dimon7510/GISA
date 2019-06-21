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

local dateOfIncidentText, dateOfReportText      --permanent text above dates
            
local dateOfIncidentYearField, dateOfIncidentMonthField, dateOfIncidentDayField --text input fields
local dateOfReportYearField, dateOfReportMonthField, dateOfReportDayField   --text input fields
local districtField, countyField, routeField, postMileField, latitudeField, longitudeField  --text input fields

local districtText, countyText, routeText, postMileText, latitudeText, longitudeText  --texts above input fields

local  districtTextNo, countyTextNo, routeTextNo, latitudeTextNo, longitudeTextNo --small text for field that cannot be empty

local saveBtn, nextBtn, backBtn --buttons declaration
local scrollView  --scrol view declaration

local textPopUp  --text displayed in message alert
local textTitle --text of popup title
local focusIndex --index of which field focus after incorrect date typed

local allFieldsFill 			--flag to indicate if all fields are fulled out
local headerGroup               --heder group with buttons
local footerGroup 				--footer group with buttons


----------------LOCAL FUNCTIONS--------------------------------------------------------
----------function "nullyfyTextFields"  deletes texts above and below textfields----
local function nullifyTextFields(  )
        --extracting and storing date of report from OS----------
    local date = os.date( "*t" )

    if (date ~= nil) then
        g.dateOfReportMonth = tostring(date.month)
        print("Date of report month from OS: "..g.dateOfReportMonth)
        g.dateOfReportDay = tostring(date.day)
        print("Date of report Day from OS: "..g.dateOfReportDay)
        g.dateOfReportYear = tostring(date.year)
        print("Date of report Year from OS: "..g.dateOfReportYear)
        dateOfReportMonthField.text = g.dateOfReportMonth
        dateOfReportDayField.text = g.dateOfReportDay
        dateOfReportYearField.text = g.dateOfReportYear
    else 
        if(g.dateOfReportMonth~=nil and g.dateOfReportMonth~="")then
            print("Date of report Month filled "..g.dateOfReportMonth)
            dateOfReportMonthField.text = g.dateOfReportMonth
        end
        if(g.dateOfReportDay~=nil and g.dateOfReportDay~="")then
            print("Date of report Day filled "..g.dateOfReportDay)
            dateOfReportDayField.text = g.dateOfReportDay
        end
        if(g.dateOfReportYear~=nil and g.dateOfReportYear~="")then
            print("Date of report Year filled "..g.dateOfReportYear)
            dateOfReportYearField.text = g.dateOfReportYear
        end
    end

    --Filling out date of incident if stored------------------
    if(g.dateOfIncidentMonth~=nil and g.dateOfIncidentMonth~="")then
        print("Date of incident Month filled "..g.dateOfIncidentMonth)
        dateOfIncidentMonthField.text = g.dateOfIncidentMonth
    end
    if(g.dateOfIncidentDay~=nil and g.dateOfIncidentDay~="")then
        print("Date of incident Day filled "..g.dateOfIncidentDay)
        dateOfIncidentDayField.text = g.dateOfIncidentDay
    end
    if(g.dateOfIncidentYear~=nil and g.dateOfIncidentYear~="")then
        print("Date of incident Year filled "..g.dateOfIncidentYear)
        dateOfIncidentYearField.text = g.dateOfIncidentYear
    end

    --filling out all other fields if stored---------------------
    if (g.district~=nil and g.district~="")then
        print("District filled "..g.district)
        districtField.text = g.district
    else districtText.isVisible = false end

    if (g.county~=nil and g.county~="")then
        print("County filled "..g.county)
        countyField.text = g.county
    else countyText.isVisible = false end

    if (g.route~=nil and g.route~="")then
        print("Route filled "..g.route)
        routeField.text = g.route
    else routeText.isVisible = false end

    if (g.postMile~=nil and g.postMile~="")then
        print("Post Mile filled "..g.postMile)
        postMileField.text = g.postMile
    else postMileText.isVisible = false end

    if (g.latitude~=nil and g.latitude~="")then
        print("Latitude filled "..g.latitude)
        latitudeField.text = g.latitude
    end

    if (g.longitude~=nil and g.longitude~="")then
        print("Longitude filled "..g.longitude)
        longitudeField.text = g.longitude
    end

    scrollView:scrollToPosition( {y = 0} )
    
    ---making no textes below invisible
    dateOfIncidentTextNo.isVisible, dateOfReportTextNo.isVisible = false, false
    districtTextNo.isVisible, countyTextNo.isVisible, routeTextNo.isVisible = false, false, false
    latitudeTextNo.isVisible, longitudeTextNo.isVisible = false, false
end
--------------------------------------------------------------------------------------------

--------Pop Up Ok BTN Listener------------------------------
local function okBtnListener( event )
    if (focusIndex == 1 ) then native.setKeyboardFocus( dateOfReportMonthField)
    elseif (focusIndex == 2 ) then native.setKeyboardFocus( dateOfReportDayField)
    elseif (focusIndex == 3) then native.setKeyboardFocus( dateOfReportYearField )

    elseif (focusIndex == 4) then native.setKeyboardFocus( dateOfIncidentMonthField) 
    elseif (focusIndex == 5) then native.setKeyboardFocus( dateOfIncidentDayField) 
    elseif (focusIndex == 6) then native.setKeyboardFocus( dateOfIncidentYearField)
    elseif (focusIndex == 7) then native.setKeyboardFocus( districtField)
    elseif (focusIndex == 8) then native.setKeyboardFocus( latitudeField)   
    else printf("Wrong focusindex \n")
    end 
end
---End Of OK btn listener---------------------------------

----------FUNCTION "correctDateValues" checks if day and month values are in range 1-12 and 1-31 and district is in range 1-12---------
local function correctDateValues()
    local reportDay = tonumber( g.dateOfReportDay )
    local reportMonth = tonumber( g.dateOfReportMonth )
    local reportYear = tonumber( g.dateOfReportYear )
    local incidentDay = tonumber( g.dateOfIncidentDay )
    local incidentMonth = tonumber( g.dateOfIncidentMonth )
    local incidentYear = tonumber( g.dateOfIncidentYear )


    ----------------REPORT DATE CHECK--------------------------------------------
        --check correctness of report month and pop up window if incorrect
    if (reportMonth<1 or reportMonth>12) then
        print( "Report Month Incorrect\n")
        textTitle = "Report Month Incorrect"
        textPopUp = "Value of report month \n should be between 1 and 12"
        local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
        focusIndex = 1
        return false
    end

       --check correctness of report Day and pop up window if incorrect-------
            --case of 31 day months
    if (reportMonth==1 or reportMonth==3 or reportMonth==5 or reportMonth==7 or reportMonth==8 or reportMonth==10 or reportMonth==12) then
        print( "Report 31 day month cheking\n")
        if (reportDay<1 or reportDay>31) then 
            textTitle = "Report Day Incorrect"
            textPopUp = "Value of report day \n should be between 1 and 31"
            local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
            focusIndex = 2
            return false
        end
        --case of 30 day month
    elseif (reportMonth==4 or reportMonth==6 or reportMonth==9 or reportMonth==11) then
         print( "Report 30 day month cheking\n")
        if (reportDay<1 or reportDay>30) then 
            textTitle = "Report Day Incorrect"
            textPopUp = "Value of report day \n should be between 1 and 30"
            local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
            focusIndex = 2
            return false
        end
        --case of february
    elseif (reportMonth ==2) then
         print( "Report 29 day month cheking\n")
        if (reportDay<1 or reportDay>29) then 
            textTitle = "Report Day Incorrect"
            textPopUp = "Value of report day \n should be between 1 and 29"
            local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
            focusIndex = 2
            return false
        end
        --case if somethong wrong (not one of 12 month is chosen but should)
    else 
        print( "Report SMTH WRONG WITH MONTHS\n")
        textTitle = "Report Month Strange or Incorrect"
        textPopUp = "Value of report month \n should be between 1 and 12"
        local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
        focusIndex = 1
        return false
    end

    --check correctness of report Year and pop up window if incorrect
    if (reportYear<1000 or reportYear>9999) then
        print( "Report Year Incorrect\n")
        textTitle = "Report year Incorrect"
        textPopUp = "Value of report Year \n should be between 1000 and 9999"
        local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
        focusIndex = 3
        return false
    end

    -------------INCIDENT DATES CHECK---------------------------------------------------
        --check correctness of incident month and pop up window if incorrect
    if (incidentMonth<1 or incidentMonth>12) then
        print( "Incident Month Incorrect\n")
        textTitle = "Incident Month Incorrect"
        textPopUp = "Value of incident month \n should be between 1 and 12"
        local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
        focusIndex = 4
        return false
    end

       --check correctness of incidnet Day and pop up window if incorrect-------
            --case of 31 day months
    if (incidentMonth==1 or incidentMonth==3 or incidentMonth==5 or incidentMonth==7 or incidentMonth==8 or incidentMonth==10 or incidentMonth==12) then
        print( "incident 31 day month cheking\n")
        if (incidentDay<1 or incidentDay>31) then 
            textTitle = "Incident Day Incorrect"
            textPopUp = "Value of incident day \n should be between 1 and 31"
            local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
            focusIndex = 5
            return false
        end
        --case of 30 day month
    elseif (incidentMonth==4 or incidentMonth==6 or incidentMonth==9 or incidentMonth==11) then
         print( "incident 30 day month cheking\n")
        if (incidentDay<1 or incidentDay>30) then 
            textTitle = "Incident Day Incorrect"
            textPopUp = "Value of incident day \n should be between 1 and 30"
            local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
            focusIndex = 5
            return false
        end
        --case of february
    elseif (incidentMonth ==2) then
         print( "incident 29 day month cheking\n")
        if (incidentDay<1 or incidentDay>29) then 
            textTitle = "Incident Day Incorrect"
            textPopUp = "Value of incident day \n should be between 1 and 29"
            local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
            focusIndex = 5
            return false
        end
        --case if somethong wrong (not one of 12 month is chosen but should)
    else 
        print( "incident SMTH WRONG WITH MONTHS\n")
        textTitle = "Incident Month Strange or Incorrect"
        textPopUp = "Value of incident month \n should be between 1 and 12"
        local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
        focusIndex = 4
        return false
    end

     --check correctness of incident Year and pop up window if incorrect
    if (incidentYear<1000 or incidentYear>9999) then
        print( "Incident Year Incorrect\n")
        textTitle = "Incident Year Incorrect"
        textPopUp = "Value of incident year \n should be between 1000 and 9999"
        local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
        focusIndex = 6
        return false
    end

    -------------DISTRICT VALUE CHECK---------------------------------------------------
    local districtValue = tonumber( g.district )
        --check correctness of incident month and pop up window if incorrect
    if (districtValue<1 or districtValue>12) then
        print( "Incorrect District Value\n")
        textTitle = "District Value Incorrect"
        textPopUp = "Value of District field \n should be between 1 and 12"
        local alert = native.showAlert( textTitle, textPopUp, { "OK" }, okBtnListener )
        focusIndex = 7
        return false
    end


return true
end
----------------------------------------------------------------------------------------------------

---------Function "makeMonthDayLength2" converts day and months from ex. 5 to 05
local function makeMonthDayLength2(  )
    print( "extending month entered" )
    if (g.dateOfReportMonth:len()<2) then 
        g.dateOfReportMonth = "0"..g.dateOfReportMonth
        print( "Extended Month of Report - "..g.dateOfReportMonth )
    end
    if (g.dateOfReportDay:len()<2) then 
        g.dateOfReportDay = "0"..g.dateOfReportDay
        print( "Extended Day of report - "..g.dateOfReportDay )
    end
    if (g.dateOfIncidentMonth:len()<2) then 
        g.dateOfIncidentMonth = "0"..g.dateOfIncidentMonth
        print( "Extended Month of Incident - "..g.dateOfIncidentMonth )
    end
    if (g.dateOfIncidentDay:len()<2) then 
        g.dateOfIncidentDay = "0"..g.dateOfIncidentDay
        print( "Extended Day of Incident - "..g.dateOfIncidentDay )
    end
end
------------------END OF LOCAL FUNCTIONS------------------------------------------------


---------------LISTENERS------------------------------------------------------------------

local function locationHandler ( event )
 
    -- Check for error (user may have turned off location services)
    if ( event.errorCode ) then
        native.showAlert( "GPS Location Error", event.errorMessage, {"OK"}, okBtnListener )
        focusIndex = 8
        print( "Location error: " .. tostring( event.errorMessage ) )
    else
        g.latitude = string.format( '%.4f', event.latitude )
        latitudeField.text =  g.latitude
        print ("Latitude entered from GPS: "..g.latitude)
 
        g.longitude = string.format( '%.4f', event.longitude )
        longitudeField.text = g.longitude
        print("Longitude from GPS: "..g.longitude)
 
    end
end
----------------TEXTFIELD LISTENERS-------------------------------------------------
----------------Date of Report Month textfield Listener-----------------------------
local function dateOfReportMonthFieldListener( event )

	if (event.phase == "editing") then
		--dateOfReportMonthText.isVisible = true	--make small text above visible
        local txt = event.text 
		  --check length of month field
        if(string.len(txt)>2)then
            txt=string.sub(txt, 1, 2)
            event.text=txt
            dateOfReportMonthField.text = txt
        end
       g.dateOfReportMonth = txt
       print( txt )
	end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.dateOfReportMonth = event.target.text
        print( "dateOfReportMonth: " .. g.dateOfReportMonth )
    end 

    if (event.phase == "submitted") then
    	 native.setKeyboardFocus( dateOfReportDayField)
    end
end
-----------------------------------------------------------------------

----------------Date of Report Day textfield Listener-----------------------------
local function dateOfReportDayFieldListener( event )

    if (event.phase == "editing") then
       -- dateOfReportDayText.isVisible = true  --make small text above visible
        local txt = event.text 
          --check length of day field
        if(string.len(txt)>2)then
            txt=string.sub(txt, 1, 2)
            print( "corrected txt - "..txt )
            event.text=txt
            dateOfReportDayField.text = txt
        end
       g.dateOfReportDay = txt
       print( txt )
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.dateOfReportDay = event.target.text
        print( "dateOfReportDay: " .. g.dateOfReportDay )
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( dateOfReportYearField)
    end
end
-----------------------------------------------------------------------

----------------Date of Report Year textfield Listener-----------------------------
local function dateOfReportYearFieldListener( event )

    if (event.phase == "editing") then
        --dateOfReportYearText.isVisible = true  --make small text above visible
        local txt = event.text 
          --check length of year field
        if(string.len(txt)>4)then
            txt=string.sub(txt, 1, 4)
            event.text=txt
            dateOfReportYearField.text = txt
        end
       g.dateOfReportYear = txt
       print( txt )
    end

    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.dateOfReportYear = event.target.text
        print( "dateOfReportYear: " .. g.dateOfReportYear )
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( dateOfIncidentMonthField)
    end
end
-----------------------------------------------------------------------

----------------Date of Incident Month textfield Listener-----------------------------
local function dateOfIncidentMonthFieldListener( event )

    if (event.phase == "editing") then
       -- dateOfIncidentMonthText.isVisible = true  --make small text above visible
        local txt = event.text 
          --check length of month field
        if(string.len(txt)>2)then
            txt=string.sub(txt, 1, 2)
            event.text=txt
            dateOfIncidentMonthField.text = txt
        end
       g.dateOfIncidentMonth = txt
       print( txt )
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.dateOfIncidentMonth = event.target.text
        print( "dateOfIncidentMonth: " .. g.dateOfIncidentMonth )
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( dateOfIncidentDayField)
    end
end
-----------------------------------------------------------------------

----------------Date of Incident Day textfield Listener-----------------------------
local function dateOfIncidentDayFieldListener( event )

    if (event.phase == "editing") then
       -- dateOfIncidentDayText.isVisible = true  --make small text above visible
        local txt = event.text 
          --check length of day field
        if(string.len(txt)>2)then
            txt=string.sub(txt, 1, 2)
            event.text=txt
            dateOfIncidentDayField.text = txt
        end
       g.dateOfIncidentDay = txt
       print( txt )
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.dateOfIncidentDay = event.target.text
        print( "dateOfIncidentDay: " .. g.dateOfIncidentDay )
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( dateOfIncidentYearField)
    end
end
-----------------------------------------------------------------------

----------------Date of Incident Year textfield Listener-----------------------------
local function dateOfIncidentYearFieldListener( event )

    if (event.phase == "editing") then
       -- dateOfIncidentYearText.isVisible = true  --make small text above visible
      local txt = event.text 
          --check length of year field
        if(string.len(txt)>4)then
            txt=string.sub(txt, 1, 4)
            event.text=txt
            dateOfIncidentYearField.text = txt
        end
       g.dateOfIncidentYear = txt
       print( txt )
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.dateOfIncidentYear = event.target.text
        print( "dateOfIncidentYear: " .. g.dateOfIncidentYear )
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( districtField)
    end
end
-----------------------------------------------------------------------

----------------District textfield Listener-----------------------------
local function districtFieldListener( event )

    if (event.phase == "editing") then
        districtText.isVisible = true  --make small text above visible
        g.district = event.text
        print( event.text )
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.district = event.target.text
        print( "district: " .. g.district )
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( countyField)
    end
end
-----------------------------------------------------------------------

----------------County textfield Listener-----------------------------
local function countyFieldListener( event )

    if (event.phase == "editing") then
        countyText.isVisible = true  --make small text above visible
        g.county = event.text
        print( event.text )
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.county = event.target.text
        print( "county: " .. g.county )
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( routeField)
    end
end
-----------------------------------------------------------------------

----------------Route textfield Listener-----------------------------
local function routeFieldListener( event )

    if ( event.phase == "began" ) then
             --lifting up buttons and scroolview
            scrollView:scrollToPosition( {y = -screenH*0.1} ) 
           -- footerGroup.y = footerGroup.y - screenH*0.1
    end

    if (event.phase == "editing") then
        routeText.isVisible = true  --make small text above visible
        g.route = event.text
        print( event.text )
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.route = event.target.text
        print( "route: " .. g.route )
        
            --bringing scroolview and buttons back
            scrollView:scrollToPosition( {y = 0} )
            --footerGroup.y = screenH
        
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( postMileField)
    end
end
-----------------------------------------------------------------------

----------------Post Mile textfield Listener-----------------------------
local function postMileFieldListener( event )
     if ( event.phase == "began" ) then
             --lifting up buttons and scroolview
            scrollView:scrollToPosition( {y = -screenH*0.2} ) 
           -- footerGroup.y = footerGroup.y - screenH*0.2
    end

    if (event.phase == "editing") then
        postMileText.isVisible = true  --make small text above visible
        g.postMile = event.text
        print( event.text )
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.postMile = event.target.text
        print( "postMile: " .. g.postMile )
        
             --bringing scroolview and buttons back
            scrollView:scrollToPosition( {y = 0} )
            --footerGroup.y = screenH 
        
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( latitudeField)
    end
end
-----------------------------------------------------------------------

----------------Latitude textfield Listener-----------------------------
local function latitudeFieldListener( event )
    if ( event.phase == "began" ) then
             --lifting up buttons and scroolview
            scrollView:scrollToPosition( {y = -screenH*0.3} ) 
            --footerGroup.y = footerGroup.y - screenH*0.3
    end

    if (event.phase == "editing") then
        latitudeText.isVisible = true  --make small text above visible
        g.latitude = event.text
        print( event.text )
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.latitude = event.target.text
        print( "latitude: " .. g.latitude )
        
            --bringing scroolview and buttons back
            scrollView:scrollToPosition( {y = 0} )
           --footerGroup.y = screenH
        
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( longitudeField)
    end
end
-----------------------------------------------------------------------

----------------Longitude textfield Listener-----------------------------
local function longitudeFieldListener( event )
    if ( event.phase == "began" ) then
             --lifting up buttons and scroolview
            scrollView:scrollToPosition( {y = -screenH*0.4} ) 
            --footerGroup.y = footerGroup.y - screenH*0.4
    end

    if (event.phase == "editing") then
        longitudeText.isVisible = true  --make small text above visible
        g.longitude = event.text
        print( event.text )
    end
 
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        g.longitude = event.target.text
        print( "longitude: " .. g.longitude )
        
             --bringing scroolview and buttons back
            scrollView:scrollToPosition( {y = 0} )
            --footerGroup.y = screenH
        
    end 

    if (event.phase == "submitted") then
         native.setKeyboardFocus( nil)
    end
end
-----------------------------------------------------------------------

------------------END OF TEXT FIELD LISTENERS-------------------------------------


------------BUTTON LISTENERS-----------------------------------------------------

-----Next Btn Listener-------------------------------------
local function nextBtnListener( event)
	allFieldsFill = true --assume all fields are filled out

    if event.phase == "began" then
        audio.play( click)
    end

    --Goes to sign up screen-
    if event.phase == "ended" then 
    	print( "Next clicked" )

        --check if date of report Month or Day or Year is empty field
        if (g.dateOfReportMonth == nil or  g.dateOfReportMonth =="" or g.dateOfReportDay == nil or  g.dateOfReportDay =="" or g.dateOfReportYear == nil or  g.dateOfReportYear =="")  then
                --print report if month is empty
            if (g.dateOfReportMonth == nil or  g.dateOfReportMonth =="") then 
                print( "dateOfReportMonth field =  nil") 
                native.setKeyboardFocus( dateOfReportMonthField )
            end
                --print report if day is empty
            if (g.dateOfReportDay == nil or  g.dateOfReportDay =="") then
                print( "dateOfReportDay field =  nil") 
                native.setKeyboardFocus( dateOfReportDayField ) 
            end   
                --print report if Year is empty  
            if (g.dateOfReportYear == nil or  g.dateOfReportYear =="")  then
                print( "dateOfReportYear field =  nil")
                native.setKeyboardFocus( dateOfReportYearField )
            end

            dateOfReportTextNo.isVisible = true
            allFieldsFill = false
        else 
            print( "dateOfReportMonth field = " .. g.dateOfReportMonth)
            print( "dateOfReportDay field = " .. g.dateOfReportDay)
            print( "dateOfReportYear field = " .. g.dateOfReportYear)
            dateOfReportTextNo.isVisible = false
        end


        --check if date of incident Month, Day or Year  is empty field
        if (g.dateOfIncidentYear == nil or  g.dateOfIncidentYear =="" or g.dateOfIncidentMonth == nil or  g.dateOfIncidentMonth =="" or g.dateOfIncidentDay == nil or  g.dateOfIncidentDay =="") then
                --print report if month is empty
            if (g.dateOfIncidentMonth == nil or  g.dateOfIncidentMonth =="")  then
                print( "dateOfIncidentMonth field =  nil")
                native.setKeyboardFocus( dateOfIncidentMonthField )
            end
                --print report if Day is empty
            if (g.dateOfIncidentDay == nil or  g.dateOfIncidentDay =="")  then
                print( "dateOfIncidentDay field =  nil")
                native.setKeyboardFocus( dateOfIncidentDayField )
            end  
                --print report if year is empty
            if (g.dateOfIncidentYear == nil or  g.dateOfIncidentYear =="")  then
                print( "dateOfIncidentYear field =  nil")
                native.setKeyboardFocus( dateOfIncidentYearField )
            end

            dateOfIncidentTextNo.isVisible = true
            allFieldsFill = false
        else 
            print( "dateOfIncidentMonth field = " .. g.dateOfIncidentMonth)
            print( "dateOfIncidentDay field = " .. g.dateOfIncidentDay)
            print( "dateOfIncidentYear field = " .. g.dateOfIncidentYear)
            dateOfIncidentTextNo.isVisible = false
        end

		--check if District is empty field
    	if (g.district == nil or g.district =="") then
    		print( "district field =  nil")
    		districtTextNo.isVisible = true
    		allFieldsFill = false
    		native.setKeyboardFocus( districtField )
    	else 
    		print( "district field = "..g.district)
    		districtTextNo.isVisible = false
    	end

    	--check if County is empty field
    	if (g.county == nil or g.county == "") then
    		print( "county field =  nil")
    		countyTextNo.isVisible = true
    		allFieldsFill = false
    		native.setKeyboardFocus( countyField )
    	else 
    		print("county field = "..g.county)
    		countyTextNo.isVisible = false
    	end

    	--check if route is empty field
    	if (g.route == nil or g.route=="") then
    		print( "route field =  nil")
    		routeTextNo.isVisible = true
    		allFieldsFill = false
    		native.setKeyboardFocus( routeField )
    	else 
    		print("route field = "..g.route)
    		routeTextNo.isVisible = false
    	end

    	--check if post Mile is empty field assign it ""
    	if (g.postMile == nil) then
    		print( "post Mile =  nil")
    		g.postMile = ""
    	else 
    		print( "Post Mile field ="..g.postMile)
    	end

    	--check if latitude is empty field
    	if (g.latitude == nil or g.latitude == "")  then
    		print( "latitude field =  nil")
    		latitudeTextNo.isVisible = true
    		allFieldsFill = false
    		native.setKeyboardFocus( latitudeField )
    	else 
    		print( "latitude field = ".. g.latitude)
    		latitudeTextNo.isVisible = false
    	end

    	--check if longitude is empty field
    	if (g.longitude == nil or g.longitude == "") then
    		print( "longitude field =  nil")
    		longitudeTextNo.isVisible = true
    		allFieldsFill = false
    		native.setKeyboardFocus( longitudeField )
    	else 
    		print( "longitude field =".. g.longitude)
    		longitudeTextNo.isVisible = false
    	end

    		-- send sign up data to database and go to login screen if all field are filled out 
    	if allFieldsFill then
            if (correctDateValues()) then 	
                makeMonthDayLength2()
                composer.gotoScene( "incidentTypeDistribution", {effect = "slideLeft", time = 300} )
            end
        end
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
        composer.gotoScene( "newIncident", {effect = "slideRight", time = 300} )     
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

	--white footer rectangle and insert in footer group-------------------
	local whiteFooter = display.newRect(footerGroup, 0, 0, screenW*1.2, screenH *0.15)
	whiteFooter:setFillColor( 0.1,0.2,0.8, 1 )	-- blue


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


	-------------------CREATING TITLE-----------------------------------------------
	-- create GISAproject title---------------------------------------------------
	local title = display.newText( "GISAproject", 60, 35, native.systemFont, 16 )
	title:setFillColor( 1 )	-- black



	----------------------CREATING TEXTS ABOVE TEXTFIELDS--------------------------------------------------------------
	--create dateOfReport text--------------------------------------------------
	dateOfReportText = display.newText( "Date of Report", screenCeneterX*0.5, screenH*0, native.systemFont, 12)
	dateOfReportText.anchorX, dateOfReportText.anchorY = 0,0
	dateOfReportText:setFillColor( 0 )	-- black
	--dateOfReportText.isVisible = false  --make invisible
	scrollView:insert(dateOfReportText)

	------create Date of Incident text above---------------------------------------
	dateOfIncidentText = display.newText( "Date of Incident", screenCeneterX*0.5, screenH*0.1, native.systemFont, 12)
	dateOfIncidentText.anchorX, dateOfIncidentText.anchorY = 0,0
	dateOfIncidentText:setFillColor( 0 )	-- black
	--dateOfIncidentText.isVisible = false  --make invisible
	scrollView:insert(dateOfIncidentText)

	-------create District text above--------------------------------------
	districtText = display.newText( "District", screenCeneterX*0.5, screenH*0.2, native.systemFont, 12)
	districtText.anchorX, districtText.anchorY = 0,0
	districtText:setFillColor( 0 )	-- black
	districtText.isVisible = false  --make invisible
	scrollView:insert(districtText)

	-------create County text above------------------------------------------
	countyText = display.newText( "County", screenCeneterX*0.5, screenH*0.3, native.systemFont, 12)
	countyText.anchorX, countyText.anchorY = 0,0
	countyText:setFillColor( 0 )	-- black
	countyText.isVisible = false  --make invisible
	scrollView:insert(countyText)

	-----create Route text above--------------------------------------------
	routeText = display.newText( "Route", screenCeneterX*0.5, screenH*0.4, native.systemFont, 12)
	routeText.anchorX, routeText.anchorY = 0,0
	routeText:setFillColor( 0 )	-- black
	routeText.isVisible = false  --make invisible
	scrollView:insert(routeText)

	------create Post Mile text above---------------------------------------
	postMileText = display.newText("Post Mile", screenCeneterX*0.5, screenH*0.5, native.systemFont, 12)
	postMileText.anchorX, postMileText.anchorY = 0,0
	postMileText:setFillColor(0) --black
	postMileText.isVisible = false  --make invisible
	scrollView:insert(postMileText)

	-----create Latitude text above--------------------------------------------
	latitudeText = display.newText( "Latitude", screenCeneterX*0.5, screenH*0.6, native.systemFont, 12)
	latitudeText.anchorX, latitudeText.anchorY = 0,0
	latitudeText:setFillColor( 0 )	-- black
	--latitudeText.isVisible = false  --make invisible
	scrollView:insert(latitudeText)

    -----create Longitude text above--------------------------------------------
    longitudeText = display.newText( "Longitude", screenCeneterX*0.5, screenH*0.7, native.systemFont, 12)
    longitudeText.anchorX, longitudeText.anchorY = 0,0
    longitudeText:setFillColor( 0 )  -- black
    --longitudeText.isVisible = false  --make invisible
    scrollView:insert(longitudeText)


	----------------------CREATE "CAN NOT BE EMPTY"  TEXT BELOW TEXTFIELDS----------------------------
	--create Date of Report can not be empty  text--------------------------------------------------
	dateOfReportTextNo = display.newText( "Date of Report can not have emty fields", screenCeneterX*0.5, screenH*0.073, native.systemFont, 12)
	dateOfReportTextNo.anchorX, dateOfReportTextNo.anchorY = 0,0
	dateOfReportTextNo:setFillColor( 0.9,0.2,0.1 )	-- black
	dateOfReportTextNo.isVisible = false  --make invisible
	scrollView:insert(dateOfReportTextNo)

	------create Date of incident can not be empty text above---------------------------------------
	dateOfIncidentTextNo = display.newText( "Date if Incident can not have empty fields", screenCeneterX*0.5, screenH*0.173, native.systemFont, 12)
	dateOfIncidentTextNo.anchorX, dateOfIncidentTextNo.anchorY = 0,0
	dateOfIncidentTextNo:setFillColor( 0.9,0.2,0.1 )	-- black
	dateOfIncidentTextNo.isVisible = false  --make invisible
	scrollView:insert(dateOfIncidentTextNo)

	-------create District  can not be empty text above--------------------------------------
	districtTextNo = display.newText( "District can not be empty", screenCeneterX*0.5, screenH*0.273, native.systemFont, 12)
	districtTextNo.anchorX, districtTextNo.anchorY = 0,0
	districtTextNo:setFillColor( 0.9,0.2,0.1 )	-- black
	districtTextNo.isVisible = false  --make invisible
	scrollView:insert(districtTextNo)

	-------create County can not be empty text above------------------------------------------
	countyTextNo = display.newText( "County can not be empty", screenCeneterX*0.5, screenH*0.373, native.systemFont, 12)
	countyTextNo.anchorX, countyTextNo.anchorY = 0,0
	countyTextNo:setFillColor( 0.9,0.2,0.1 )	-- black
	countyTextNo.isVisible = false  --make invisible
	scrollView:insert(countyTextNo)

	-----create Route can not be empty text above--------------------------------------------
	routeTextNo = display.newText( "Route can not be empty", screenCeneterX*0.5, screenH*0.473, native.systemFont, 12)
	routeTextNo.anchorX, routeTextNo.anchorY = 0,0
	routeTextNo:setFillColor( 0.9,0.2,0.1 )	-- black
	routeTextNo.isVisible = false  --make invisible
	scrollView:insert(routeTextNo)

	------create Latitude can not be empty text above---------------------------------------
	latitudeTextNo = display.newText("Latitude can not be empty", screenCeneterX*0.5, screenH*0.673, native.systemFont, 12)
	latitudeTextNo.anchorX, latitudeTextNo.anchorY = 0,0
	latitudeTextNo:setFillColor(0.9,0.2,0.1) --black
	latitudeTextNo.isVisible = false  --make invisible
	scrollView:insert(latitudeTextNo)

	-----create Longitude can not be empty text above--------------------------------------------
	longitudeTextNo = display.newText( "Longitude can not be empty", screenCeneterX*0.5, screenH*0.773, native.systemFont, 12)
	longitudeTextNo.anchorX, longitudeTextNo.anchorY = 0,0
	longitudeTextNo:setFillColor( 0.9,0.2,0.1)	-- black
	longitudeTextNo.isVisible = false  --make invisible
	scrollView:insert(longitudeTextNo)
	----------------------------------END OF CREATING TEXTS----------------------------------------------------------------


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

    --insert footer group in scrool view
    scrollView:insert(footerGroup)

	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( background )
	sceneGroup:insert( backgroundHead )
	sceneGroup:insert( title )
	sceneGroup:insert( scrollView )
	--sceneGroup:insert( footerGroup )
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

		----------------------------	CREATING  TEXTFIELDS----------------------------------------------------------------
		-----------Date of Report Month Textfield----------------------------------------------
		dateOfReportMonthField = native.newTextField( screenCeneterX*0.4, screenH*0.05, 40, 30 )
		dateOfReportMonthField.placeholder = "MM"
		dateOfReportMonthField.inputType = "number"
		dateOfReportMonthField:addEventListener( "userInput", dateOfReportMonthFieldListener )
		scrollView:insert(dateOfReportMonthField)	--insert text Field in scrool view

		-----------Date of Report Day textfield----------------------------------------------
		dateOfReportDayField = native.newTextField ( screenCeneterX*0.8, screenH*0.05, 40, 30 )
		dateOfReportDayField.placeholder = "DD"
		dateOfReportDayField.inputType = "number"
		dateOfReportDayField:addEventListener( "userInput", dateOfReportDayFieldListener)
		scrollView:insert(dateOfReportDayField)

		-----------Date of Report Year Text Field----------------------------------------------
		dateOfReportYearField = native.newTextField ( screenCeneterX*1.5, screenH*0.05, 80, 30 )
		dateOfReportYearField.placeholder = "YYYY"
		dateOfReportYearField.inputType = "number"
		dateOfReportYearField:addEventListener( "userInput", dateOfReportYearFieldListener)
		scrollView:insert(dateOfReportYearField)

        -----------Date of Incident Month Textfield----------------------------------------------
        dateOfIncidentMonthField = native.newTextField( screenCeneterX*0.4, screenH*0.15, 40, 30 )
        dateOfIncidentMonthField.placeholder = "MM"
        dateOfIncidentMonthField.inputType = "number"
        dateOfIncidentMonthField:addEventListener( "userInput", dateOfIncidentMonthFieldListener )
        scrollView:insert(dateOfIncidentMonthField)   --insert text Field in scrool view

        -----------Date of Incident Day textfield----------------------------------------------
        dateOfIncidentDayField = native.newTextField ( screenCeneterX*0.8, screenH*0.15, 40, 30 )
        dateOfIncidentDayField.placeholder = "DD"
        dateOfIncidentDayField.inputType = "number"
        dateOfIncidentDayField:addEventListener( "userInput", dateOfIncidentDayFieldListener)
        scrollView:insert(dateOfIncidentDayField)

        -----------Date of Incident Year Text Field----------------------------------------------
        dateOfIncidentYearField = native.newTextField ( screenCeneterX*1.5, screenH*0.15, 80, 30 )
        dateOfIncidentYearField.placeholder = "YYYY"
        dateOfIncidentYearField.inputType = "number"
        dateOfIncidentYearField:addEventListener( "userInput", dateOfIncidentYearFieldListener)
        scrollView:insert(dateOfIncidentYearField)

        -----------District Text Field----------------------------------------------
        districtField = native.newTextField ( screenCeneterX, screenH*0.25, 180, 30 )
        districtField.placeholder = "District"
        districtField.inputType = "number"
        districtField:addEventListener( "userInput", districtFieldListener)
        scrollView:insert(districtField)

		--------------County Number TextField--------------------------------------
		countyField = native.newTextField ( screenCeneterX, screenH*0.35, 180, 30 )
		countyField.placeholder = "County"
		countyField.inputType = "default"
		countyField:addEventListener( "userInput", countyFieldListener)
		scrollView:insert(countyField)

		--------------Route Text Field-------------------------------------------
	 	routeField = native.newTextField ( screenCeneterX, screenH*0.45, 180, 30 )
		routeField.placeholder = "Route"
		routeField.inputType = "default"
		routeField:addEventListener( "userInput", routeFieldListener)
		scrollView:insert(routeField)

		--------------Post Mile Text field---------------------------------------
		postMileField = native.newTextField ( screenCeneterX, screenH*0.55, 180, 30 )
		postMileField.placeholder = "Post Mile"
		postMileField.inputType = "default"
		postMileField:addEventListener( "userInput", postMileFieldListener)
		scrollView:insert(postMileField)

		--------------Latitude Text Field----------------------------------------
	    latitudeField = native.newTextField ( screenCeneterX, screenH*0.65, 180, 30 )
		latitudeField.placeholder = "Latitude"
		latitudeField.inputType = "decimal"
		latitudeField:addEventListener( "userInput", latitudeFieldListener)
		scrollView:insert(latitudeField)

        --------------Longitude Text Field----------------------------------------
        longitudeField = native.newTextField ( screenCeneterX, screenH*0.75, 180, 30 )
        longitudeField.placeholder = "Longitude"
        longitudeField.inputType = "decimal"
        longitudeField:addEventListener( "userInput", longitudeFieldListener)
        scrollView:insert(longitudeField)

        nullifyTextFields() -- nullyfying text field global values

    elseif phase == "did" then
        -- Called when the scene is now on screen

        -- Activate location listener
        Runtime:addEventListener( "location", locationHandler )
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

        --Remove latitude - longitude listener
        Runtime:removeEventListener( "location", locationHandler )

		----------Removing textfields---------------
		dateOfIncidentMonthField:removeSelf()
		dateOfIncidentMonthField = nil

		dateOfIncidentDayField:removeSelf( )
		dateOfIncidentDayField = nil

		dateOfIncidentYearField:removeSelf( )
		dateOfIncidentYearField = nil

        dateOfReportMonthField:removeSelf()
        dateOfReportMonthField = nil

        dateOfReportDayField:removeSelf( )
        dateOfReportDayField = nil

        dateOfReportYearField:removeSelf( )
        dateOfReportYearField = nil

		districtField:removeSelf( )
		districtField = nil

		countyField:removeSelf( )
		countyField = nil

		routeField:removeSelf()
		routeField = nil

		postMileField:removeSelf()
		postMileField = nil

        latitudeField:removeSelf()
        latitudeField = nil

        longitudeField:removeSelf()
        longitudeField = nil

		
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