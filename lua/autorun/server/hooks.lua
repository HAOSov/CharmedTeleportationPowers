hook.Add("PlayerSwitchWeapon", "Charmed_Teleportation.PlayerSwitchWeapon",function(ply,old,new)
	if(ply.__InCharmedTeleport)then
		old:SetColor(Color(255,255,255,255));
		new:SetRenderMode(RENDERMODE_TRANSALPHA);
		new:SetColor(Color(255,255,255,0));
	end
end)

hook.Add("PlayerCanHearPlayersVoice", "Charmed_Teleportation.PlayerCanHearPlayersVoice",function(listener,talker)
	if(talker.__InCharmedTeleport)then return false; end;
end)

hook.Add("OnPlayerChat", "Charmed_Teleportation.OnPlayerChat", function(ply)
	if(ply.__InCharmedTeleport) then return false; end;
end)

hook.Add("PlayerUse", "Charmed_Teleportation.PlayerUse", function(ply,ent)
	if(ply.__InCharmedTeleport) then
		return false;
	end
end)