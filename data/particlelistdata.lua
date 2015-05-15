local json = require( "json" )
local particles = require("libs.helpers.particles")

local particlesEffects = {
    --stars
    ["stars"] = {"stars1"},
    ["stars1"]="images/particles/estrellas/stars1.json",

	["starExplosion"] = {"starsExplosion1", "starsExplosion2"},
    ["starsExplosion1"]="images/particles/estrellasBig/starsExplosion1.json",
	["starsExplosion2"]="images/particles/estrellasBig/starsExplosion2.json",

} 

local particleList={}
particles.loadParticles(particlesEffects)

--[[local particlesEffects={
		    ["kameHameHaEffet"]={
			[1]="images/particles/kamehameha/powerChargeHalo.json",
			[2]="images/particles/kamehameha/powerChargeOrb.json",
			[3]="images/particles/kamehameha/powerChargeRadial1.json",
			[4]="images/particles/kamehameha/powerChargeRay1.json",
			[5]="images/particles/kamehameha/powerChargeRay3.json",
			[6]="images/particles/kamehameha/powerChargeSparks.json",
		    },
		    ["runSmoke"]={
			[1]="runSmoke1.json",
			[2]="runSmoke2.json"
		    }
		}]]--

function particleList.getParticleEffect(identifier)
    if(particlesEffects[identifier]~=nil) then
	return particles.newEmitter(identifier)
    end
    return nil
end

return particleList
