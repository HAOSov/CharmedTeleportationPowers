SWEP.PrintName = "Orbing Teleportation"
SWEP.Instructions = "Left Click To Disapear (Run Key Down = More quick, Walk Key Down = More Slow), Right Click To Reapear"

SWEP.Spawnable = true
SWEP.Author = "Matspyder"
SWEP.Category = "Charmed Teleportation"

SWEP.Base 			= "weapon_base"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "none"

SWEP.HoldType 				= "normal"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.DrawCrosshair = false;
SWEP.DrawAmmo = false;

SWEP.ViewModel = "models/weapons/c_arms.mdl";
SWEP.WorldModel = "";

SWEP.HoldType 				= "normal"

SWEP.MaxDistanceToAddEntity = 50;

SWEP.TransportedPlayers = {};
SWEP.TransportedEntities = {};

SWEP.FlamingNumber = 5;

SWEP.Sounds = {
	Disapear = Sound("powers/orbing_disapear.wav"),
	DisapearQuick = Sound("powers/flaming_disapear_quick.wav"),
	Apear = Sound("powers/orbing_reapear.wav")
};

function SWEP:StartTeleport(ply)
	ply.LastPosBeforeTeleport = {};
	ply.LastPosBeforeTeleport.Pos = ply:GetPos();
	ply.LastPosBeforeTeleport.Angles = ply:GetAngles();
	local tim = 1.5;
	if(ply:KeyDown(IN_SPEED)) then
		tim = 0.500;
	elseif(ply:KeyDown(IN_WALK)) then
		tim = 2.250;
	end
	timer.Simple(tim,function()
		ply:SetMoveType(MOVETYPE_NOCLIP);
	end)
	ply:GodEnable();
	ply.__InCharmedTeleport = true;
end

function SWEP:EndTeleport(ply)
	ply:SetMoveType(MOVETYPE_WALK);
	timer.Create("Charmed_Teleportation.RemoveGod",1,1,function()
		ply:GodDisable();
	end);
	ply.__InCharmedTeleport = false;
end

function SWEP:CloakingEffect(e)
	e:EmitSound(self.Sounds.Disapear,80);
	e:Freeze(true);
	if(timer.Exists("Charmed_UnOrbing"..e:EntIndex())) then timer.Destroy("Charmed_UnOrbing"..e:EntIndex()); end
	local i = 0;
	while i < 300 do
		local size = math.Rand(0.5,4)
		local part = EffectData();
		part:SetStart(e:GetPos() + Vector(math.Rand(-15,15),math.Rand(-15,15),math.Rand(0,80)))
		part:SetOrigin(e:GetPos() + Vector(math.Rand(-15,15),math.Rand(-15,15),math.Rand(0,80)))
		part:SetEntity(e)
		part:SetScale(size)
		util.Effect("orbs_effect", part)
		i = i+1;
	end
	local y = 0;
	while y < 300 do
		local size = math.Rand(0.5,4)
		local part = EffectData();
		part:SetStart(e:GetPos() + Vector(math.Rand(-15,15),math.Rand(-15,15),math.Rand(0,80)))
		part:SetOrigin(e:GetPos() + Vector(math.Rand(-15,15),math.Rand(-15,15),math.Rand(0,80)))
		part:SetEntity(e)
		part:SetScale(size)
		util.Effect("orbs_effect", part)
		y = y+1;
	end
	local z = 0;
	while z < 300 do
		local size = math.Rand(0.5,4)
		local part = EffectData();
		part:SetStart(e:GetPos() + Vector(math.Rand(-15,15),math.Rand(-15,15),math.Rand(0,80)))
		part:SetOrigin(e:GetPos() + Vector(math.Rand(-15,15),math.Rand(-15,15),math.Rand(0,80)))
		part:SetEntity(e)
		part:SetScale(size)
		util.Effect("orbs_effect", part)
		z = z+1;
	end
	timer.Create("CF2"..e:EntIndex(),0.5,1,function()
		timer.Create("Charmed_Orbing"..e:EntIndex(),0.005,51,function()
			e:SetColor(Color(255,255,255,e:GetColor().a-5));
			e:SetGravity(0.1);
			e:SetPos(e:GetPos()+Vector(0,0,2.5))
		end)
		timer.Create("Charmed_Orbing_RestartGravity"..e:EntIndex(),1.4,1,function()
			e:SetGravity(1);
			e:Freeze(false);
		end)
	end)
end

function SWEP:LongCloakingEffect(e)
	if(timer.Exists("Charmed_UnOrbing"..e:EntIndex())) then timer.Destroy("Charmed_UnOrbing"..e:EntIndex()); end
	e:Ignite(3,1);
	timer.Create("Charmed_Orbing"..e:EntIndex(),0.03,85,function()//255
		e:SetColor(Color(255,255,255,e:GetColor().a-3));
	end)
end

function SWEP:SpeedCloakingEffect(e)
	if(timer.Exists("Charmed_UnOrbing"..e:EntIndex())) then timer.Destroy("Charmed_Orbing"..e:EntIndex()); end
	e:Ignite(0.5,1);
	timer.Create("Charmed_Orbing"..e:EntIndex(),0.001,17,function()//17
		e:SetColor(Color(255,255,255,e:GetColor().a-15));
	end)
end

function SWEP:UncloakingEffect(e)
	if(timer.Exists("Charmed_Orbing"..e:EntIndex())) then timer.Destroy("Charmed_Orbing"..e:EntIndex()); end
	e:Freeze(true);
	timer.Simple(1,function()
		e:EmitSound(self.Sounds.Apear,80);
		local i = 0;
		while i < 300 do
			local size = math.Rand(0.5,4)
			local part = EffectData();
			part:SetStart(e:GetPos() + Vector(math.Rand(-15,15),math.Rand(-15,15),math.Rand(0,80)))
			part:SetOrigin(e:GetPos() + Vector(math.Rand(-15,15),math.Rand(-15,15),math.Rand(0,80)))
			part:SetEntity(e)
			part:SetScale(size)
			util.Effect("orbs_reapear_effect", part)
			i = i+1;
		end
		timer.Create("CF2_Orbing"..e:EntIndex(),0.5,1,function()
			timer.Create("Charmed_UnOrbing"..e:EntIndex(),0.005,51,function()
				e:SetColor(Color(255,255,255,e:GetColor().a+5));
			end)
			timer.Create("Charmed_UnOrbing_Freeze"..e:EntIndex(),1.4,1,function()
				e:Freeze(false);
			end)
		end)
	end)
end

function SWEP:MakeInvisible(ply)
	ply:SetRenderMode(RENDERMODE_TRANSALPHA);
	/*if(self.Owner:KeyDown(IN_SPEED)) then
		ply:EmitSound(self.Sounds.DisapearQuick,80);
		self:SpeedCloakingEffect(ply);
	elseif(self.Owner:KeyDown(IN_WALK)) then
		ply:EmitSound(self.Sounds.Disapear,80);
		self:LongCloakingEffect(ply);
	else*/
		self:CloakingEffect(ply);
	//end
	ply:SetNWBool("CharmedOrbingInvisible",true);
	if(ply:IsPlayer()) then
		ply:GetActiveWeapon():SetRenderMode(RENDERMODE_TRANSALPHA);
		ply:GetActiveWeapon():SetColor(Color(0,0,0,0));
	end
end

function SWEP:MakeVisible(ply)
	self:UncloakingEffect(ply);
	if(ply:IsPlayer())then
		ply:GetActiveWeapon():SetColor(Color(255,255,255,255));
	end
	ply:SetNWBool("CharmedOrbingInvisible",false);
	timer.Destroy("Charmed_Orbing")
end

function SWEP:PrimaryAttack()
	if(not self.Owner.__InCharmedTeleport) then
		self:StartTeleport(self.Owner);
		self:MakeInvisible(self.Owner);
		self:SetNextSecondaryFire(CurTime()+2);
	end
end

function SWEP:SecondaryAttack()
	if(self.Owner.__InCharmedTeleport) then
		self:EndTeleport(self.Owner);
		self:MakeVisible(self.Owner);
		self:SetNextPrimaryFire(CurTime()+2);
	end
end

hook.Add("PlayerDeath","Charmed_Teleportation.PlayerDeath",function(ply, inflictor, attacker)
	if(ply.__InCharmedTeleport) then
		ply:SetColor(255,255,255,255);
		ply.__InCharmedTeleport = false;
		if(timer.Exists("Charmed_Orbing"..ply:EntIndex())) then timer.Destroy("Charmed_Flaming"..ply:EntIndex()); end
		if(timer.Exists("Charmed_UnOrbing"..ply:EntIndex())) then timer.Destroy("Charmed_UnOrbing"..ply:EntIndex()); end
	end
end)

hook.Add("PlayerSilentDeath","Charmed_Teleportation.PlayerSilentDeath",function(ply, inflictor, attacker)
	if(ply.__InCharmedTeleport) then
		ply:SetColor(255,255,255,255);
		ply.__InCharmedTeleport = false;
		if(timer.Exists("Charmed_Orbing"..ply:EntIndex())) then timer.Destroy("Charmed_Orbing"..ply:EntIndex()); end
		if(timer.Exists("Charmed_UnOrbing"..ply:EntIndex())) then timer.Destroy("Charmed_UnOrbing"..ply:EntIndex()); end
	end
end)