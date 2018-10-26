SWEP.PrintName = "Shimmering Teleportation"
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

SWEP.DrawCrosshair = false;
SWEP.DrawAmmo = false;

SWEP.ViewModel = "models/weapons/c_arms.mdl";
SWEP.WorldModel = "";

SWEP.HoldType 				= "normal"

SWEP.MaxDistanceToAddEntity = 50;

SWEP.TransportedPlayers = {};
SWEP.TransportedEntities = {};

SWEP.FadingNumber = 5;

SWEP.Sounds = {
	Disapear = Sound("powers/shimmering_disapear.wav"),
	Apear = Sound("powers/shimmering_reapear.wav")
};

SWEP.TimeNextThink = CurTime();

function SWEP:StartTeleport(ply)
	ply.LastPosBeforeTeleport = {};
	ply.LastPosBeforeTeleport.Pos = ply:GetPos();
	ply.LastPosBeforeTeleport.Angles = ply:GetAngles();
	local tim = 1;
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
	ply:GodDisable();
	ply.__InCharmedTeleport = false;
end

function SWEP:CloakingEffect(e)
	if(timer.Exists("Charmed_UnFading"..e:EntIndex())) then timer.Destroy("Charmed_UnFading"..e:EntIndex()); end
	timer.Create("Charmed_Fading"..e:EntIndex(),0.005,51,function()//51
		e:SetColor(Color(255,255,255,e:GetColor().a-5));
	end)
end

function SWEP:LongCloakingEffect(e)
	if(timer.Exists("Charmed_UnFading"..e:EntIndex())) then timer.Destroy("Charmed_UnFading"..e:EntIndex()); end
	timer.Create("Charmed_Fading"..e:EntIndex(),0.01,255,function()//255
		e:SetColor(Color(255,255,255,e:GetColor().a-1));
	end)
end

function SWEP:SpeedCloakingEffect(e)
	if(timer.Exists("Charmed_UnFading"..e:EntIndex())) then timer.Destroy("Charmed_UnFading"..e:EntIndex()); end
	timer.Create("Charmed_Fading"..e:EntIndex(),0.001,17,function()//17
		e:SetColor(Color(255,255,255,e:GetColor().a-15));
	end)
end

function SWEP:UncloakingEffect(e)
	if(timer.Exists("Charmed_Fading"..e:EntIndex())) then timer.Destroy("Charmed_Fading"..e:EntIndex()); end
	timer.Create("Charmed_UnFading"..e:EntIndex(),0.005,51,function()
		e:SetColor(Color(255,255,255,e:GetColor().a+5));
	end)
end

function SWEP:MakeInvisible(ply)
	ply:SetRenderMode(RENDERMODE_TRANSALPHA);
	ply:EmitSound(self.Sounds.Disapear,80);
	if(self.Owner:KeyDown(IN_SPEED)) then
		self:SpeedCloakingEffect(ply);
	elseif(self.Owner:KeyDown(IN_WALK)) then
		self:LongCloakingEffect(ply);
	else
		self:CloakingEffect(ply);
	end
	ply:SetNWBool("CharmedShimmeringInvisible",true);
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
	ply:SetNWBool("CharmedShimmeringInvisible",false);
	timer.Destroy("Charmed_Fading")
end

function SWEP:PrimaryAttack()
	if(not self.Owner.__InCharmedTeleport) then
		self:StartTeleport(self.Owner);
		self:MakeInvisible(self.Owner);
		self:SetNextSecondaryFire(CurTime()+1);
	end
end

function SWEP:SecondaryAttack()
	if(self.Owner.__InCharmedTeleport) then
		self:EndTeleport(self.Owner);
		self:MakeVisible(self.Owner);
		self:SetNextPrimaryFire(CurTime()+1);
	end
end

function SWEP:Think()
	if(self.Owner:KeyPressed(IN_USE) && self.TimeNextThink <= CurTime()) then
		if(self.Owner.__InCharmedTeleport) then
			self.Owner:EmitSound("physics/wood/wood_crate_impact_hard2.wav");
			timer.Create("Charmed_Fading_Knock",0.35,2,function()
				self.Owner:EmitSound("physics/wood/wood_crate_impact_hard2.wav");
			end)
			self.TimeNextThink=CurTime()+2;
		end
	end
end

hook.Add("PlayerDeath","Charmed_Teleportation.PlayerDeath",function(ply, inflictor, attacker)
	if(ply.__InCharmedTeleport) then
		ply:SetColor(255,255,255,255);
		ply.__InCharmedTeleport = false;
		if(timer.Exists("Charmed_Fading"..ply:EntIndex())) then timer.Destroy("Charmed_Fading"..ply:EntIndex()); end
		if(timer.Exists("Charmed_UnFading"..ply:EntIndex())) then timer.Destroy("Charmed_UnFading"..ply:EntIndex()); end
	end
end)

hook.Add("PlayerSilentDeath","Charmed_Teleportation.PlayerSilentDeath",function(ply, inflictor, attacker)
	if(ply.__InCharmedTeleport) then
		ply:SetColor(255,255,255,255);
		ply.__InCharmedTeleport = false;
		if(timer.Exists("Charmed_Fading"..ply:EntIndex())) then timer.Destroy("Charmed_Fading"..ply:EntIndex()); end
		if(timer.Exists("Charmed_UnFading"..ply:EntIndex())) then timer.Destroy("Charmed_UnFading"..ply:EntIndex()); end
	end
end)