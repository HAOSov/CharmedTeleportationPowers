SWEP.PrintName = "Flaming Teleportation"
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
	Disapear = Sound("powers/flaming_disapear.wav"),
	DisapearQuick = Sound("powers/flaming_disapear_quick.wav"),
	Apear = Sound("powers/flaming_reapear.wav")
};

function SWEP:StartTeleport(ply)
	ply.LastPosBeforeTeleport = {};
	ply.LastPosBeforeTeleport.Pos = ply:GetPos();
	ply.LastPosBeforeTeleport.Angles = ply:GetAngles();
	local tim = 2;
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
	if(timer.Exists("Charmed_UnFlaming"..e:EntIndex())) then timer.Destroy("Charmed_UnFlaming"..e:EntIndex()); end
	e:Ignite(2,1);
	timer.Create("CF2"..e:EntIndex(),0.5,1,function()
		timer.Create("Charmed_Flaming"..e:EntIndex(),0.005,51,function()
			e:SetColor(Color(255,255,255,e:GetColor().a-5));
		end)
	end)
end

function SWEP:LongCloakingEffect(e)
	if(timer.Exists("Charmed_UnFlaming"..e:EntIndex())) then timer.Destroy("Charmed_UnFlaming"..e:EntIndex()); end
	e:Ignite(3,1);
	timer.Create("Charmed_Flaming"..e:EntIndex(),0.03,85,function()//255
		e:SetColor(Color(255,255,255,e:GetColor().a-3));
	end)
end

function SWEP:SpeedCloakingEffect(e)
	if(timer.Exists("Charmed_UnFlaming"..e:EntIndex())) then timer.Destroy("Charmed_UnFlaming"..e:EntIndex()); end
	e:Ignite(0.5,1);
	timer.Create("Charmed_Flaming"..e:EntIndex(),0.001,17,function()//17
		e:SetColor(Color(255,255,255,e:GetColor().a-15));
	end)
end

function SWEP:UncloakingEffect(e)
	if(timer.Exists("Charmed_Flaming"..e:EntIndex())) then timer.Destroy("Charmed_Flaming"..e:EntIndex()); end
	e:Ignite(1,1);
	timer.Create("CF2_Flaming"..e:EntIndex(),0.5,1,function()
		timer.Create("Charmed_UnFlaming"..e:EntIndex(),0.005,51,function()
			e:SetColor(Color(255,255,255,e:GetColor().a+5));
		end)
	end)
end

function SWEP:MakeInvisible(ply)
	ply:SetRenderMode(RENDERMODE_TRANSALPHA);
	if(self.Owner:KeyDown(IN_SPEED)) then
		ply:EmitSound(self.Sounds.DisapearQuick,80);
		self:SpeedCloakingEffect(ply);
	elseif(self.Owner:KeyDown(IN_WALK)) then
		ply:EmitSound(self.Sounds.Disapear,80);
		self:LongCloakingEffect(ply);
	else
		ply:EmitSound(self.Sounds.Disapear,80);
		self:CloakingEffect(ply);
	end
	ply:SetNWBool("CharmedFlamingInvisible",true);
	if(ply:IsPlayer()) then
		ply:GetActiveWeapon():SetRenderMode(RENDERMODE_TRANSALPHA);
		ply:GetActiveWeapon():SetColor(Color(0,0,0,0));
	end
end

function SWEP:MakeVisible(ply)
	self:UncloakingEffect(ply);
	ply:EmitSound(self.Sounds.Apear,80);
	if(ply:IsPlayer())then
		ply:GetActiveWeapon():SetColor(Color(255,255,255,255));
	end
	ply:SetNWBool("CharmedFlamingInvisible",false);
	timer.Destroy("Charmed_Flaming")
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
		if(timer.Exists("Charmed_Flaming"..ply:EntIndex())) then timer.Destroy("Charmed_Flaming"..ply:EntIndex()); end
		if(timer.Exists("Charmed_UnFlaming"..ply:EntIndex())) then timer.Destroy("Charmed_UnFlaming"..ply:EntIndex()); end
	end
end)

hook.Add("PlayerSilentDeath","Charmed_Teleportation.PlayerSilentDeath",function(ply, inflictor, attacker)
	if(ply.__InCharmedTeleport) then
		ply:SetColor(255,255,255,255);
		ply.__InCharmedTeleport = false;
		if(timer.Exists("Charmed_Flaming"..ply:EntIndex())) then timer.Destroy("Charmed_Flaming"..ply:EntIndex()); end
		if(timer.Exists("Charmed_UnFlaming"..ply:EntIndex())) then timer.Destroy("Charmed_UnFlaming"..ply:EntIndex()); end
	end
end)