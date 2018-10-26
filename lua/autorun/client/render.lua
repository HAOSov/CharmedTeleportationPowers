// @CarterAddonPack
hook.Add("RenderScreenspaceEffects","Charmed_Teleportation.Teleport.RenderScreenspaceEffects",
	function()
		if(LocalPlayer():GetNWBool("CharmedShimmeringInvisible",false)) then
			if(LocalPlayer():GetNWBool("CharmedFlammingInvisible")) then LocalPlayer():SetNWBool("CharmedFlammingInvisible"); end;
			-- Color Modify - The "Bluish" overlay
			DrawColorModify(
				{
					["$pp_colour_addr"] = 0.5,
					["$pp_colour_addg"] = 0.5,
					["$pp_colour_addb"] = 0.5,
					["$pp_colour_brightness"] = -0.6,
					["$pp_colour_contrast"] = 0.93,
					["$pp_colour_colour"] = 0.19,
					["$pp_colour_mulr"] = 0.9,
					["$pp_colour_mulg"] = 0.9,
					["$pp_colour_mulb"] = 0.9,
				}
			);
			-- Makes view blurry
			DrawMotionBlur(0.1,0.7,0.001);
			-- Draw blurred edges @aVoN
			//render.SetMaterial(BlurEdges);
			render.UpdateScreenEffectTexture();
			render.DrawScreenQuad();
		end

		if(LocalPlayer():GetNWBool("CharmedFlamingInvisible",false)) then
			if(LocalPlayer():GetNWBool("CharmedShimmeringInvisible")) then LocalPlayer():SetNWBool("CharmedShimmeringInvisible"); end;
			-- Color Modify - The "Bluish" overlay
			DrawColorModify(
				{
					["$pp_colour_addr"] = 0.5,
					["$pp_colour_addg"] = 0.3,
					["$pp_colour_addb"] = 0.3,
					["$pp_colour_brightness"] = -0.6,
					["$pp_colour_contrast"] = 0.8,
					["$pp_colour_colour"] = 0.19,
					["$pp_colour_mulr"] = 0.9,
					["$pp_colour_mulg"] = 0.9,
					["$pp_colour_mulb"] = 0.9,
				}
			);
			-- Makes view blurry
			DrawMotionBlur(0.1,0.7,0.001);
			-- Draw blurred edges @aVoN
			//render.SetMaterial(BlurEdges);
			render.UpdateScreenEffectTexture();
			render.DrawScreenQuad();
		end
		if(LocalPlayer():GetNWBool("CharmedOrbingInvisible",false)) then
			if(LocalPlayer():GetNWBool("CharmedShimmeringInvisible")) then LocalPlayer():SetNWBool("CharmedShimmeringInvisible"); end;
			-- Color Modify - The "Bluish" overlay
			DrawColorModify(
				{
					["$pp_colour_addr"] = 0.3,
					["$pp_colour_addg"] = 0.4,
					["$pp_colour_addb"] = 0.7,
					["$pp_colour_brightness"] = -0.6,
					["$pp_colour_contrast"] = 0.8,
					["$pp_colour_colour"] = 0.19,
					["$pp_colour_mulr"] = 0.9,
					["$pp_colour_mulg"] = 0.9,
					["$pp_colour_mulb"] = 0.9,
				}
			);
			-- Makes view blurry
			DrawMotionBlur(0.1,0.7,0.001);
			-- Draw blurred edges @aVoN
			//render.SetMaterial(BlurEdges);
			render.UpdateScreenEffectTexture();
			render.DrawScreenQuad();
		end
	end
);

hook.Add("DrawPhysgunBeam", "Charmed_Teleportation.DrawPhysgunBeam", function(ply, physgun, enabled, target)
	local IsCharmedTeleport = ply:GetNWBool("CharmedShimmeringInvisible", false) or ply:GetNWBool("CharmedFlammingInvisible", false) or target:GetNWBool("CharmedShimmeringInvisible", false) or target:GetNWBool("CharmedFlammingInvisible", false);
	if(IsCharmedTeleport) then return false; end;
end);

hook.Add( "HUDPaint", "Charmed_Teleportation.HUDPaint", function()
	local ply = LocalPlayer();
	//if(ply.__InCharmedTeleport) then
		draw.RoundedBox(6,surface.ScreenWidth()/2+440,surface.ScreenHeight()/2+200,175,75,Color(0,0,0,100));
		draw.DrawText("MAGIC", "DermaDefaultBold", ScrW() * 0.5+460, ScrH() * 0.5 + 250, Color(255,220,50,255));
		draw.DrawText("100", "DermaLarge", ScrW() * 0.5+525, ScrH() * 0.5 + 225, Color(255,220,50,255));
	//end
end);

function CharmedOptions()
	spawnmenu.AddToolCategory("Settings","CharmedTeleportationServer","CharmedTeleportation Server Settings");
	spawnmenu.AddToolMenuOption("Settings","CharmedTeleportationServer","CharmedTeleportationServerSettings", "Settings", "", "", "");
end

hook.Add( "AddToolMenuTabs", "Charmed_Teleportation.AddToolMenuTabs", CharmedOptions);