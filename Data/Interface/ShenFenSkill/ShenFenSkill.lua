-- …Ì∑›ΩÁ√Ê

local g_ShenFenSkill_CurIdentityId = -1
local g_ShenFenSkill_CurSkillId = -1

local ShenFenSkill_NoJob = {}
local ShenFenSkill_HaveJob = {}
local ShenFenSkill_CurJob = {}
local ShenFenSkill_JobName = {}
local ShenFenSkill_JobLevel = {}
local ShenFenSkill_JobExp = {}
local ShenFenSkill_Btn = {}

--…Ì∑›–‘±Ì
local ShenFen_Name = {
[1] = "#{YCGZ_231225_124}",
[2] = "#{YCGZ_231225_125}", 
[3] = "#{YCGZ_231225_126}",
[4] = "#{YCGZ_231225_128}", 
};

-- ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
local g_ShenFenSkill_Frame_UnifiedXPosition;
local g_ShenFenSkill_Frame_UnifiedYPosition;

function ShenFenSkill_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OPEN_SHENFEN_PAGE");
	
	this:RegisterEvent("UNIT_ABILITYEXP");
	this:RegisterEvent("UPDATE_LIFESKILL_PAGE");

	this:RegisterEvent("TOGLE_SKILL_BOOK");
	this:RegisterEvent("TOGLE_COMMONSKILL_PAGE");
	this:RegisterEvent("TOGLE_LIFE_PAGE");
	this:RegisterEvent("UPDATE_SHENFEN");
	this:RegisterEvent("CLOSE_SKILL_BOOK");
	this:RegisterEvent("JOIN_NEW_MENPAI");

	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	this:RegisterEvent("ADJEST_UI_POS")

	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

function ShenFenSkill_OnLoad()

	ShenFenSkill_JobName[1] = ShenFenSkill_Job1_NameText
	ShenFenSkill_JobName[2] = ShenFenSkill_Job2_NameText
	ShenFenSkill_JobName[3] = ShenFenSkill_Job3_NameText
	ShenFenSkill_JobName[4] = ShenFenSkill_Job4_NameText
	
	ShenFenSkill_CurJob[1] = ShenFenSkill_Job1_Image
	ShenFenSkill_CurJob[2] = ShenFenSkill_Job2_Image
	ShenFenSkill_CurJob[3] = ShenFenSkill_Job3_Image
	ShenFenSkill_CurJob[4] = ShenFenSkill_Job4_Image
	
	ShenFenSkill_NoJob[1] = ShenFenSkill_Job1_Not
	ShenFenSkill_NoJob[2] = ShenFenSkill_Job2_Not
	ShenFenSkill_NoJob[3] = ShenFenSkill_Job3_Not
	ShenFenSkill_NoJob[4] = ShenFenSkill_Job4_Not
	
	ShenFenSkill_HaveJob[1] = ShenFenSkill_Job1_Info2
	ShenFenSkill_HaveJob[2] = ShenFenSkill_Job2_Info2
	ShenFenSkill_HaveJob[3] = ShenFenSkill_Job3_Info2
	ShenFenSkill_HaveJob[4] = ShenFenSkill_Job4_Info2
	
	ShenFenSkill_JobLevel[1] = ShenFenSkill_Job1_ForceLevelText
	ShenFenSkill_JobLevel[2] = ShenFenSkill_Job2_ForceLevelText
	ShenFenSkill_JobLevel[3] = ShenFenSkill_Job3_ForceLevelText
	ShenFenSkill_JobLevel[4] = ShenFenSkill_Job4_ForceLevelText
	
	ShenFenSkill_JobExp[1] = ShenFenSkill_Job1_ForceSleightText
	ShenFenSkill_JobExp[2] = ShenFenSkill_Job2_ForceSleightText
	ShenFenSkill_JobExp[3] = ShenFenSkill_Job3_ForceSleightText
	ShenFenSkill_JobExp[4] = ShenFenSkill_Job4_ForceSleightText

	ShenFenSkill_Btn[1] = ShenFenSkill_Job1_Use
	ShenFenSkill_Btn[2] = ShenFenSkill_Job2_Use
	ShenFenSkill_Btn[3] = ShenFenSkill_Job3_Use
	ShenFenSkill_Btn[4] = ShenFenSkill_Job4_Use

	ShenFenSkill_SetTabColor();

	-- ±£¥ÊΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
	g_ShenFenSkill_Frame_UnifiedXPosition	= ShenFenSkill_Frame : GetProperty("UnifiedXPosition");
	g_ShenFenSkill_Frame_UnifiedYPosition	= ShenFenSkill_Frame : GetProperty("UnifiedYPosition");

end
-- OnEvent
function ShenFenSkill_OnEvent(event)

	if ( event == "OPEN_SHENFEN_PAGE" ) then
		local selfUnionPos = Variable:GetVariable("SkillUnionPos");
		if(selfUnionPos ~= nil) then
			ShenFenSkill_Frame:SetProperty("UnifiedPosition", selfUnionPos);
		end
		
		ShenFenSkill_Update();
	
		this:Show();
	
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99858302 ) then	
		local selfUnionPos = Variable:GetVariable("SkillUnionPos");
		if(selfUnionPos ~= nil) then
			ShenFenSkill_Frame:SetProperty("UnifiedPosition", selfUnionPos);
		end
		
		ShenFenSkill_Update();
	
		this:Show();
	
	elseif ( event == "UPDATE_SHENFEN" and this:IsVisible()) then
		ShenFenSkill_Update();
		
	elseif ( event == "UNIT_ABILITYEXP" and this:IsVisible()) then
		g_ShenFenSkill_CurIdentityId = Player:GetData("IBIDENTITYID")
		ShenFenSkill_UpdateIdentityAttr( g_ShenFenSkill_CurIdentityId )
		
	elseif ( event == "UPDATE_LIFESKILL_PAGE" and this:IsVisible()) then
		g_ShenFenSkill_CurIdentityId = Player:GetData("IBIDENTITYID")
		ShenFenSkill_UpdateIdentityAttr( g_ShenFenSkill_CurIdentityId )
		
	elseif ( event == "TOGLE_LIFE_PAGE" ) then
		ShenFenSkill_Close();
	elseif ( event == "TOGLE_COMMONSKILL_PAGE" ) then
		ShenFenSkill_Close();
	elseif ( event == "CLOSE_SKILL_BOOK" ) then
		ShenFenSkill_Close();
	elseif ( event == "TOGLE_SKILL_BOOK" ) then
		ShenFenSkill_Close();

	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	elseif (event == "ADJEST_UI_POS" ) then
		ShenFenSkill_Frame_On_ResetPos()

	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ShenFenSkill_Frame_On_ResetPos()

	end
end

function ShenFenSkill_Update()
		
	g_ShenFenSkill_CurIdentityId = Player:GetData("IBIDENTITYID")
	if ShenFen_Name[g_ShenFenSkill_CurIdentityId] == nil or ShenFenSkill_Btn[g_ShenFenSkill_CurIdentityId] == nil then
		ShenFenSkill_Close();
		return
	end
	
	for i = 1, table.getn(ShenFen_Name) do
		ShenFenSkill_UpdateIdentityAttr( i )			
	end	
	
	ShenFenSkill_AutoAttack : SetCheck(0);
	ShenFenSkill_LifeSkill : SetCheck(0);
	ShenFenSkill_CommonlySkill : SetCheck(0);
	ShenFenSkill_ActionSkill : SetCheck(0);
	ShenFenSkill_ShenFenSkill : SetCheck(1);

end

function ShenFenSkill_UpdateIdentityAttr( nIdx )

	if ShenFen_Name[nIdx] == nil 
		or ShenFenSkill_Btn[nIdx] == nil 
		or ShenFenSkill_JobName[nIdx] == nil 
		or ShenFenSkill_NoJob[nIdx] == nil
		or ShenFenSkill_HaveJob[nIdx] == nil  
		or ShenFenSkill_JobLevel[nIdx] == nil 
		or ShenFenSkill_JobExp[nIdx] == nil
		or ShenFenSkill_CurJob[nIdx] == nil  
		then
		return
	end
	
	if ShenFen_Name[g_ShenFenSkill_CurIdentityId] == nil 
		or ShenFenSkill_Btn[g_ShenFenSkill_CurIdentityId] == nil 
		or ShenFenSkill_JobName[g_ShenFenSkill_CurIdentityId] == nil 
		or ShenFenSkill_NoJob[g_ShenFenSkill_CurIdentityId] == nil 
		or ShenFenSkill_HaveJob[g_ShenFenSkill_CurIdentityId] == nil 
		or ShenFenSkill_JobLevel[g_ShenFenSkill_CurIdentityId] == nil 
		or ShenFenSkill_JobExp[g_ShenFenSkill_CurIdentityId] == nil
		or ShenFenSkill_CurJob[g_ShenFenSkill_CurIdentityId] == nil
		then
		return
	end
	
	ShenFenSkill_JobName[nIdx] : SetText( ShenFen_Name[nIdx] )
	
	if g_ShenFenSkill_CurIdentityId == nIdx then
	-- µ±«∞…Ì∑›
		ShenFenSkill_NoJob[nIdx] : Hide()
		ShenFenSkill_HaveJob[nIdx] : Show()
		
		ShenFenSkill_CurJob[nIdx] : Show()
		ShenFenSkill_Btn[nIdx] : Show()

		g_ShenFenSkill_CurSkillId = Player:GetData("IBIDENTITYSKILLID")
		if g_ShenFenSkill_CurSkillId ~= nil and g_ShenFenSkill_CurSkillId ~= -1 then
		
			-- …Ì∑›µ»º∂
			local nlevel = Player : GetAbilityInfo(g_ShenFenSkill_CurSkillId, "level");
			ShenFenSkill_JobLevel[nIdx] : SetText( "#cfff263"..tonumber(nlevel) );
				
			--  Ï¡∑∂»
			local max_exp;
			if nlevel > 11 or nlevel < 1 then
				max_exp = "8"
			else
				max_exp = LifeAbility : GetLifeAbility_LimitExp(g_ShenFenSkill_CurSkillId, nlevel);
			end
			local strName = Player : GetAbilityInfo(g_ShenFenSkill_CurSkillId, "skillexp");
			local str = "#cfff263"..strName.."/"..max_exp
			ShenFenSkill_JobExp[nIdx] : SetText( str );
			
		end
	else
		ShenFenSkill_CurJob[nIdx] : Hide()
		ShenFenSkill_Btn[nIdx] : Hide()
		
		local SkillId = NpcShop:GetAbilityIdByIBIdentityId(nIdx)
		if SkillId ~= nil and SkillId ~= -1 then
		-- ‘¯æ≠º§ªÓπ˝
			-- …Ì∑›µ»º∂
			local nlevel = Player : GetAbilityInfo(SkillId, "level");
			if nlevel == nil then	
			
				ShenFenSkill_NoJob[nIdx] : Show()
				ShenFenSkill_HaveJob[nIdx] : Hide()
				
			else
			
				ShenFenSkill_NoJob[nIdx] : Hide()
				ShenFenSkill_HaveJob[nIdx] : Show()
				
				ShenFenSkill_JobLevel[nIdx] : SetText( "#cfff263"..tonumber(nlevel) );
				
				--  Ï¡∑∂»
				local max_exp;
				if nlevel > 11 or nlevel < 1 then
					max_exp = "8"
				else
					max_exp = LifeAbility : GetLifeAbility_LimitExp(SkillId, nlevel);
				end
				local strName = Player : GetAbilityInfo(SkillId, "skillexp");
				local str = "#cfff263"..strName.."/"..max_exp
				ShenFenSkill_JobExp[nIdx] : SetText( str );
			end
			
		end
	end
	
end

function ShenFenSkill_Button_Clicked()

	if g_ShenFenSkill_CurSkillId == -1 then
		return
	end
	
	PushEvent("OPEN_COMPOSE_SHENFEN", g_ShenFenSkill_CurSkillId)

end

function ShenFenSkill_Common_Page_Switch()
	OpenCommonSkillPage();
	ShenFenSkill_OnClose();
	ShenFenSkill_AutoAttack : SetCheck(0);
	ShenFenSkill_CommonlySkill : SetCheck(0);
	ShenFenSkill_LifeSkill : SetCheck(0);
	ShenFenSkill_ActionSkill : SetCheck(0);
	ShenFenSkill_ShenFenSkill : SetCheck(1);
end

function ShenFenSkill_Action_Page_Switch()
	local menpai = Player:GetData("MEMPAI");
	if(menpai == 9) then 
		ShenFenSkill_CommonlySkill : SetCheck(0);
		ShenFenSkill_LifeSkill : SetCheck(0);
		ShenFenSkill_ActionSkill : SetCheck(0);
		ShenFenSkill_ShenFenSkill : SetCheck(1);
		PushDebugMessage("NhÓ cÚn khÙng cÛ B·i nhßp mÙn Ph·i.");
		return; 
	end;
	OpenSkillBook();
	ShenFenSkill_OnClose();
	ShenFenSkill_AutoAttack : SetCheck(0);
	ShenFenSkill_CommonlySkill : SetCheck(0);
	ShenFenSkill_LifeSkill : SetCheck(0);
	ShenFenSkill_ActionSkill : SetCheck(0);
	ShenFenSkill_ShenFenSkill : SetCheck(1);
end

function ShenFenSkill_Life_Page_Switch()
	OpenLifePage();
	ShenFenSkill_OnClose();
	ShenFenSkill_AutoAttack : SetCheck(0);
	ShenFenSkill_CommonlySkill : SetCheck(0);
	ShenFenSkill_LifeSkill : SetCheck(0);
	ShenFenSkill_ActionSkill : SetCheck(0);
	ShenFenSkill_ShenFenSkill : SetCheck(1);
end

function ShenFenSkill_AutoAttack_Page_Switch()
	local myLevel = Player:GetData("LEVEL")
	if myLevel >= 30 then
		PushEvent("TRIGGER_ZIDONGZHANDOU","config")
		ShenFenSkill_OnClose()
	else
		PushDebugMessage("#{ZDZD_200724_54}")
	end
	ShenFenSkill_AutoAttack : SetCheck(0)
	ShenFenSkill_CommonlySkill : SetCheck(0)
	ShenFenSkill_LifeSkill : SetCheck(0)
	ShenFenSkill_ActionSkill : SetCheck(0);
	ShenFenSkill_ShenFenSkill : SetCheck(1)
end

function ShenFenSkill_SetTabColor()

	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = ShenFenSkill_CommonlySkill,
								ShenFenSkill_ActionSkill,
								ShenFenSkill_LifeSkill,
								ShenFenSkill_ShenFenSkill,
							};

	local TAB_TEXT = {
		[0] = "SΩ C§p",
		"MÙn ph·i",
		"Cuµc sØng",
		"Minh Hµi",
	};

	tab[0]:SetText(noselColor..TAB_TEXT[0]);
	tab[1]:SetText(noselColor..TAB_TEXT[1]);
	tab[2]:SetText(noselColor..TAB_TEXT[2]);
	tab[3]:SetText(selColor..TAB_TEXT[3]);
end

function ShenFenSkill_OnClose()
	Variable:SetVariable("SkillUnionPos", ShenFenSkill_Frame:GetProperty("UnifiedPosition"), 1);
	ShenFenSkill_Close();
end

function ShenFenSkill_Close()
	this:Hide();
end

--================================================
-- ª÷∏¥ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
--================================================
function ShenFenSkill_Frame_On_ResetPos()

	ShenFenSkill_Frame : SetProperty("UnifiedXPosition", g_ShenFenSkill_Frame_UnifiedXPosition);
	ShenFenSkill_Frame : SetProperty("UnifiedYPosition", g_ShenFenSkill_Frame_UnifiedYPosition);

end
