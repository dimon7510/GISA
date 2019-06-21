-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )

json = require("json")


-- include Corona's "widget" library
local widget = require "widget"
local composer = require "composer"

----Global variables all variables for all fields
appGlobalVariables = {signedIn = false, userName, password,
					firstName, lastName, caltransID, phone, email,

					dateOfIncidentYear, dateOfIncidentMonth, dateOfIncidentYearDay,
					dateOfReportYear, dateOfReportMonth, dateOfReportDay, 
					district, county, route, postMile, latitude, longitude,

					incidentType = {}, distribution,

					materialRock, materialSoil,
					bedding, joints, fractures,
					clay, silt, sand, gravel,
					trees, bushes, groundcover,
					waterContent,

					highwayStatus, closedLanes,
					pavementGroundCracks, crackLength, crackHorizontalDisp, crackVerticalDisp, crackDepth,
					settlement, bulge, indentedByRocks,

					waterDrainage = {},
					adjacentUtilities, adjacentProperties, adjacentStructures
					}
--Screen size
screenW = display.contentWidth
screenH = display.contentHeight
screenCeneterX = display.contentCenterX
screenCeneterY = display.contentCenterY




-- event listeners for tab buttons:
local function onFirstView( event )
	composer.gotoScene( "login" )
end


onFirstView()	-- show fist login screen
