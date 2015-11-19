local path = ...
local folder = path:match("(.-)[^%.]+$")
local logger = require( folder.."logger" )
local extratable = require( folder.."extratable" ) 
local json = require("json")

local particles = {}
------------------------------------------- Variables
local loadedData
local particleParams
local activeParticles
------------------------------------------- Constants 
------------------------------------------- Functions
local function updateParticles(event)
	if activeParticles then
		for index = #activeParticles, -1, 1 do
			
		end
	end
end
------------------------------------------- Module functions
function particles.loadParticles(data)
	local function addParams(newData)
		loadedData = loadedData or {}
		loadedData = extratable.merge(loadedData, newData)
		
		particleParams = particleParams or {}
		for key, value in pairs(loadedData) do
			if "string" == type(value) then
				particleParams[key] = particles.loadParams(value, system.ResourceDirectory)
			end
		end
	end
	
	if "string" == type(data) then
		local path = system.pathForFile(data, system.ResourceDirectory )
		if pcall(function()
			local languageFile = io.open( data, "r" )
			local savedData = languageFile:read( "*a" )
			addParams(json.decode(savedData))
			io.close(languageFile)
		end) then
			logger.log([[[Particles] Loaded particle file "]]..data..[["]])
		else
			logger.error([[[Particles] Failed to load particle file "]]..data..[["]])
		end
	elseif "table" == type(data) then
		addParams(data)
	end
end

function particles.loadParams( filename, baseDir )
	local path = system.pathForFile( filename, baseDir )
	local particleFile = io.open( path, "r" )
	local data = particleFile:read( "*a" )
	particleFile:close()
	local params = json.decode( data )
	
	if filename:match("/") then
		local assetPath = filename:match("(.-)[^%/]+$")
		params.textureFileName = assetPath..params.textureFileName
	end
	
	return params
end

function particles.newEmitter(particleName)

	particleParams = particleParams or {}
	if particleParams[particleName] then
		local emitter = display.newEmitter(particleParams[particleName])
		return emitter
	elseif loadedData[particleName] then
		local emitterGroup = display.newGroup()
		
		for index = 1, #loadedData[particleName] do
			local emitterParams = particleParams[loadedData[particleName][index]]
	
			local emitter = display.newEmitter(emitterParams)
			emitterGroup:insert(emitter)
		end
		
		return emitterGroup
	else
		logger.error([[[Particles] Particle effect "]]..particleName..[[" was not found]])
	end
end

function particles.start()
	
end

function particles.stop()
	
end

return particles
