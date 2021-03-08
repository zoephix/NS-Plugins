--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (limefruit.net)

	© Copyright 2020: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

PLUGIN.name = "Welcome"
PLUGIN.desc = "Implements NutScript 1.0 color correction."
PLUGIN.author = "Zoephix"

nut.config.add("colorCorrection", false, "Whether or not color correction is enabled.", nil, {
	category = "appearance"
})

nut.config.add("sadColors", true, "Whether or not the sad color scheme is enabled.", nil, {
	category = "appearance"
})

if (CLIENT) then
	function PLUGIN:ModifyColorCorrection(color)
		if (not nut.config.get("sadColors", true)) then
			color["$pp_colour_brightness"] = color["$pp_colour_brightness"] + 0.02
			color["$pp_colour_contrast"] = 1
			color["$pp_colour_addr"] = 0
			color["$pp_colour_addg"] = 0
			color["$pp_colour_addb"] = 0
			color["$pp_colour_mulr"] = 0
			color["$pp_colour_mulg"] = 0
			color["$pp_colour_mulb"] = 0
		end
	end

	function PLUGIN:RenderScreenspaceEffects()
		if (not nut.config.get("colorCorrection")) then return end

		local brightness = 0.01
		local color2 = 0.25
		local curTime = CurTime()

		if (nut.fadeStart and nut.fadeFinish) then
			brightness = 1 - math.TimeFraction(nut.fadeStart, nut.fadeFinish, curTime)

			if (curTime > nut.fadeFinish) then
				nut.fadeStart = nil
				nut.fadeFinish = nil
			end
		end

		if (nut.fadeColorStart and nut.fadeColorFinish) then
			color2 = (1 - math.TimeFraction(nut.fadeColorStart, nut.fadeColorFinish, curTime)) * 0.7

			if (curTime > nut.fadeColorFinish) then
				nut.fadeColorStart = nil
				nut.fadeColorFinish = nil
			end
		end

		local color = {}
		color["$pp_colour_addr"] = 0
		color["$pp_colour_addg"] = 0
		color["$pp_colour_addb"] = 0
		color["$pp_colour_brightness"] = brightness * -1
		color["$pp_colour_contrast"] = 1.25
		color["$pp_colour_colour"] = math.Clamp(0.7 - color2, 0, 1)
		color["$pp_colour_mulr"] = 0
		color["$pp_colour_mulg"] = 0
		color["$pp_colour_mulb"] = 0

		hook.Run("ModifyColorCorrection", color)

		DrawColorModify(color)

		local drunk = LocalPlayer():getNetVar("drunk", 0)

		if (drunk > 0) then
			DrawMotionBlur(0.075, drunk, 0.025)
		end
	end
end
