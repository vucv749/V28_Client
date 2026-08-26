local SELFEQUIP_TAB_TEXT = {}
local XIULIAN_BOOKS = {}
local XIULIAN_MIJI = {}
local XIULIAN_MIJI_TEXT = {}

local XIULIAN_BOOK_SELECT = 1;
local XIULIAN_MIJI_SELECT = -1;

local MIJI_CAN_SELECT = false;

-- 界面的默认相对位置
local g_Xiulian_Frame_UnifiedXPosition;
local g_Xiulian_Frame_UnifiedYPosition;

-------------------------------------------
--统一化下页签显示隐藏 目前固定顺序 新增改序号 每个页签都需要添加
local g_Page = {
	[1] = {Text = "#{INTERFACE_XML_877}",		NeedCheck = 0,Tip = ""},
	[2] = {Text = "#{INTERFACE_XML_882}",		NeedCheck = 0,Tip = ""},
	[3] = {Text = "#{INTERFACE_XML_854}",		NeedCheck = 0,Tip = ""},
	[4] = {Text = "#{WH_xml_XX(95)}",			NeedCheck = 0,Tip = ""},
	[5] = {Text = "#{XL_XML_35}",				NeedCheck = 0,Tip = ""},
	[6] = {Text = "#{TalentMP_20210804_57}",	NeedCheck = 1,Tip = ""},
	[7] = {Text = "#{SZXT_221216_22}",			NeedCheck = 0,Tip = "#{SZXT_221216_23}"},
	[8] = {Text = "#{SBFW_20230707_1}",		NeedCheck = 1,Tip = "#{SBFW_20230707_2}"},
	[9] = {Text = "#{DWJJ_240329_153}",  	 	NeedCheck = 0,Tip = ""},
	[10] = {Text = "#{DFJC_250709_1}",		NeedCheck = 0,Tip = ""},
	[11] = {Text = "#{GRYM_221213_22}",  	 	NeedCheck = 0,Tip = ""},
	[12] = {Text = "#{INTERFACE_XML_496}",		NeedCheck = 0,Tip = ""},
}
local g_PageButton = {}
local g_PageTip = {}
local g_PageMask = {}
local g_MaxPage = 12
local g_PageCount = 12
local g_PageOrder = {}


function Xiulian_PreLoad()
	
	-- 打开界面
	this:RegisterEvent("OPEN_XIULIAN_PAGE");
	
	--离开场景，自动关睜
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("UNIT_XIULIAN");
	this:RegisterEvent("UINT_POWER");
	
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

	this:RegisterEvent("UPDATE_EXTERIOR_TIP")

end

function Xiulian_OnLoad()
    
	XIULIAN_BOOKS[1] = Xiulian_XinfaSkill_1
	XIULIAN_BOOKS[2] = Xiulian_XinfaSkill_2
	XIULIAN_BOOKS[3] = Xiulian_XinfaSkill_3
	XIULIAN_BOOKS[4] = Xiulian_XinfaSkill_4

	XIULIAN_MIJI[1] = Xiulian_ZhaoshiSkill_1
	XIULIAN_MIJI[2] = Xiulian_ZhaoshiSkill_2
	XIULIAN_MIJI[3] = Xiulian_ZhaoshiSkill_3
	XIULIAN_MIJI[4] = Xiulian_ZhaoshiSkill_4
	XIULIAN_MIJI[5] = Xiulian_ZhaoshiSkill_5
	XIULIAN_MIJI[6] = Xiulian_ZhaoshiSkill_6
	
	XIULIAN_MIJI_TEXT[1] = Xiulian_ZhaoshiSkill_level1
	XIULIAN_MIJI_TEXT[2] = Xiulian_ZhaoshiSkill_level2
	XIULIAN_MIJI_TEXT[3] = Xiulian_ZhaoshiSkill_level3
	XIULIAN_MIJI_TEXT[4] = Xiulian_ZhaoshiSkill_level4
	XIULIAN_MIJI_TEXT[5] = Xiulian_ZhaoshiSkill_level5
	XIULIAN_MIJI_TEXT[6] = Xiulian_ZhaoshiSkill_level6

	-- 保存界面的默认相对位置
	g_Xiulian_Frame_UnifiedXPosition	= Xiulian_Frame : GetProperty("UnifiedXPosition");
	g_Xiulian_Frame_UnifiedYPosition	= Xiulian_Frame : GetProperty("UnifiedYPosition");

	g_PageButton[1] = Xiulian_SelfEquip
	g_PageButton[2] = Xiulian_SelfData
	g_PageButton[3] = Xiulian_Pet
	g_PageButton[4] = Xiulian_Wuhun
	g_PageButton[5] = Xiulian_Xiulian
	g_PageButton[6] = Xiulian_Talent
	g_PageButton[7] = Xiulian_Lingyu
	g_PageButton[8] = Xiulian_Weapon2
	g_PageButton[9] = Xiulian_DWJinJie
	g_PageButton[10] = Xiulian_Peak
	g_PageButton[11] = Xiulian_Profile
	g_PageButton[12] = Xiulian_OtherInfo

	
	g_PageMask[1] = Xiulian_SelfEquip_Mask
	g_PageMask[2] = Xiulian_SelfData_Mask
	g_PageMask[3] = Xiulian_Pet_Mask
	g_PageMask[4] = Xiulian_Wuhun_Mask
	g_PageMask[5] = Xiulian_Xiulian_Mask
	g_PageMask[6] = Xiulian_Talent_Mask
	g_PageMask[7] = Xiulian_Lingyu_Mask
	g_PageMask[8] = Xiulian_Weapon2_Mask
	g_PageMask[9] = Xiulian_DWJinJie_Mask
	g_PageMask[10] = Xiulian_Peak_Mask
	g_PageMask[11] = Xiulian_Profile_Mask
	g_PageMask[12] = Xiulian_OtherInfo_Mask
	
	g_PageTip[1] = Xiulian_SelfEquip_tips
	g_PageTip[2] = Xiulian_SelfData_tips
	g_PageTip[3] = Xiulian_Pet_tips
	g_PageTip[4] = Xiulian_Wuhun_tips
	g_PageTip[5] = Xiulian_Xiulian_tips
	g_PageTip[6] = Xiulian_Talent_tips
	g_PageTip[7] = Xiulian_Lingyu_tips
	g_PageTip[8] = Xiulian_Weapon2_tips
	g_PageTip[9] = Xiulian_DWJinJie_tips
	g_PageTip[10] = Xiulian_Peak_tips
	g_PageTip[11] = Xiulian_Profile_tips
	g_PageTip[12] = Xiulian_OtherInfo_tips
	

end

-- OnEvent
function Xiulian_OnEvent(event)

	if ( event == "OPEN_XIULIAN_PAGE" ) then
	    
	    if(this:IsVisible()) then
			this:Hide();
			return;
		end
		
	    local selfUnionPos = Variable:GetVariable("SelfUnionPos");
	    if(selfUnionPos ~= nil) then
		    Xiulian_Frame:SetProperty("UnifiedPosition", selfUnionPos);
    	end

	    XIULIAN_BOOK_SELECT = 1;
			XIULIAN_MIJI_SELECT = -1;
			this:Show();
			Xiulian_Update()
		
			Xiulian_SetTabState()
			Xiulian_ShowPage()
			Xiulian_UpdateRedPoint()
	end
	
	if( event == "PLAYER_LEAVE_WORLD") then
		this:Hide();
		return;
	end
	
	if( event == "UNIT_XIULIAN" ) then

	    for i = 1, 4 do
			local theAction = EnumAction(i - 1, "xiulianbook")
			if(theAction:GetID() ~= 0) then
				XIULIAN_BOOKS[i] : SetActionItem(theAction:GetID())
			end
		end
		Xiulian_JingJie_Selected_Update()
		Xiulian_Skill_Clicked_Update()
		Xiulian_SetSelectState()
	end
	
	if(event == "UINT_POWER" ) then
		--设置功力
		Xiulian_Gongli_Text:SetText("#{XL_XML_87}") 
		local nPower =  Player:GetData("POWER")
	    Xiulian_Vigor:SetText(nPower.."/100") 	
	end

	-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		Xiulian_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置	
		Xiulian_Frame_On_ResetPos()
	end

	if event == "UPDATE_EXTERIOR_TIP" and this:IsVisible() then
		Xiulian_UpdateRedPoint()
	end

end

function Xiulian_SelfEquip_Page_Switch()
    
	Variable:SetVariable("SelfUnionPos", Xiulian_Frame:GetProperty("UnifiedPosition"), 1);

	OpenEquip(1);
	this:Hide();
end

function Xiulian_Pet_Switch()
	Variable:SetVariable("SelfUnionPos", Xiulian_Frame:GetProperty("UnifiedPosition"), 1);

	TogglePetPage();
	this:Hide();
end

function Xiulian_SelfData_Switch()
	Variable:SetVariable("SelfUnionPos", Xiulian_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("self")
end

-- function Xiulian_Blog_Switch()

-- 	local strCharName =  Player:GetName();
-- 	local strAccount =  Player:GetData("ACCOUNTNAME")
-- 	Blog:OpenBlogPage(strAccount,strCharName,true);

-- end

function Xiulian_Xiulian_Switch()
    Xiulian_Xiulian:SetCheck(1)
end

function Xiulian_Other_Info_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Xiulian_Frame:GetProperty("UnifiedPosition"), 1);
	OtherInfoPage()
end

function Xiulian_Wuhun_Switch()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		Xiulian_Wuhun : SetCheck(0)
		Xiulian_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Xiulian_Frame:GetProperty("UnifiedPosition"), 1);	
	ToggleWuhunPage();
	this:Hide();
end

function Xiulian_Talent_Switch()
	if DataPool:Lua_CheckOpenTalent() == 1 then
		Variable:SetVariable("SelfUnionPos", Xiulian_Frame:GetProperty("UnifiedPosition"), 1);
		ToggleTalentPage();
		this:Hide();
	else
		Xiulian_Talent : SetCheck(0)
		Xiulian_ClearPage()
	end

end

--切换个人牴示界面
function Xiulian_Profile_Switch()
	Variable:SetVariable("SelfUnionPos", Xiulian_Frame:GetProperty("UnifiedPosition"), 1);	
	Exterior:LuaFnExteriorPlayerOpenProfileUI()		
end

function Xiulian_Page_LingYu()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{SZXT_221216_116}")
		Xiulian_LingYu:SetCheck(0)
		Xiulian_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Xiulian_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleLingYuPage()
end

function Xiulian_Page_ShenBing()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		Xiulian_Weapon2:SetCheck(0)
		Xiulian_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Xiulian_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleShenBingPage()
end

function Xiulian_Page_DWJinJie()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		--PushDebugMessage("#{SZXT_221216_116}")
		Xiulian_DWJinJie:SetCheck(0)
		Xiulian_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Xiulian_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleFeaturesPage()
end

function Xiulian_SetTabState()
	Xiulian_SelfEquip:SetCheck(0)
	Xiulian_SelfData:SetCheck(0)
	-- Xiulian_Blog:SetCheck(0)
	Xiulian_Pet:SetCheck(0)
	Xiulian_Xiulian:SetCheck(1)
	Xiulian_OtherInfo:SetCheck(0)
end


function Xiulian_Xinfa_Clicked(nIndex)
	if(nIndex < 3) then
		XIULIAN_BOOK_SELECT = nIndex
		XIULIAN_MIJI_SELECT = -1
		Xiulian_JingJie_Selected_Update()
	elseif nIndex == 3 then
	    PushDebugMessage("#{XL_090707_50}")
	else
		return 
	end
end
--===============================================
-- 更新 
--===============================================
function Xiulian_Update()
	for i = 1, 4 do
		local theAction = EnumAction(i - 1, "xiulianbook")
		if(theAction:GetID() ~= 0) then
			XIULIAN_BOOKS[i] : SetActionItem(theAction:GetID())
		end
	end
    Xiulian_JingJie_Selected_Update()
    --设置功力
    Xiulian_Gongli_Text:SetText("#{XL_XML_87}") 
    local nPower =  Player:GetData("POWER")
	Xiulian_Vigor:SetText(nPower.."/100") 	
end

--===============================================
-- 关睜 
--===============================================
function Xiulian_Close_Cilcked()
		this:Hide()
end

function Xiulian_OnHidden()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end

function Xiulian_Skill_Clicked(nIndex)
	if MIJI_CAN_SELECT == false then
		return
	end
	if(XIULIAN_BOOK_SELECT == 1) then
	   if (nIndex ~= 6)  then
         XIULIAN_MIJI_SELECT  = nIndex
	   else
	     XIULIAN_MIJI_SELECT  = -1
	   end
	elseif(XIULIAN_BOOK_SELECT == 2)  then
	     XIULIAN_MIJI_SELECT  = nIndex + 5
	else
         XIULIAN_MIJI_SELECT = -1
	end
	Xiulian_Skill_Clicked_Update()
end

function  Xiulian_Skill_Clicked_Update()
	Xiulian_SetSelectState()
    	--刷新中间图标
	if (XIULIAN_MIJI_SELECT ~= -1)   then
        --PushDebugMessage("Refresh XiuLian MiJi--"..XIULIAN_MIJI_SELECT)
		local	theAction = EnumAction(XIULIAN_MIJI_SELECT-1, "xiulianmiji")
		Xiulian_SkillIcon : SetActionItem(theAction:GetID())
		local XiuLianMiJiName = Player:GetXiuLianMiJiInfo(XIULIAN_MIJI_SELECT-1,"Name");
		local XiuLianMiJiJingJie = Player:GetXiuLianMiJiInfo(XIULIAN_MIJI_SELECT-1,"JingJie")
		local XiuLianMiJiLevel = Player:GetXiuLianMiJiInfo(XIULIAN_MIJI_SELECT-1,"Level")
		local CurMaxLevel = Player:GetXiuLianMiJiInfo(XIULIAN_MIJI_SELECT-1,"MaxLevel")
		local XiuLianMiJiExplain = Player:GetXiuLianMiJiInfo(XIULIAN_MIJI_SELECT-1,"Explain")
		
		local StrJingJie = "#{XL_XML_32}".."#{XL_XML_85}"..XiuLianMiJiJingJie.."#{XL_XML_86}"
		local StrDengJi = "#{XL_XML_33}"..XiuLianMiJiLevel.."/"..CurMaxLevel
		
		Xiulian_SkillName:SetText(XiuLianMiJiName);
		Xiulian_SkillJingjie:SetText(StrJingJie);
		Xiulian_SkillLevel:SetText(StrDengJi);
		local strCondition
		if(XIULIAN_BOOK_SELECT == 1) then
			if(Player:GetData("LEVEL") >= 70) then
				strCondition = "\n#G#{XL_XML_30}" 
			else
				strCondition = "\n#cff0000#{XL_XML_30}" 
			end
		else
			local XiuLianBook1Level = Player:GetXiuLianBookInfo(0,"Level")
			if (XiuLianBook1Level >= 3) then
				strCondition = "\n#G#{XL_XML_34}" 
			else
				strCondition = "\n#cff0000#{XL_XML_34}"
			end
		end 
		Xiulian_SkillInfo:SetText(XiuLianMiJiExplain.."\n#{XL_XML_31}"..strCondition);
		
	else
		if(XIULIAN_BOOK_SELECT == -1)	then
			Xiulian_SkillIcon : SetActionItem(-1)
		end
	end
	

end

--===============================================
-- 选择修炼境界后刷新 
--===============================================
function  Xiulian_JingJie_Selected_Update()

    if XIULIAN_BOOK_SELECT == 1  then
		for i = 1, 5 do
			local theAction = EnumAction(i - 1, "xiulianmiji")
			if theAction ~= 0 then
				XIULIAN_MIJI[i] : SetActionItem(theAction:GetID())
				local CurMaxLevel  = Player:GetXiuLianMiJiInfo(i - 1,"MaxLevel")
				local XiuLianMiJiLevel = Player:GetXiuLianMiJiInfo(i - 1,"Level")
				if (CurMaxLevel == nil) or (XiuLianMiJiLevel == nil) then
					MIJI_CAN_SELECT =false
					return
				else
					MIJI_CAN_SELECT =true
				end
				XIULIAN_MIJI_TEXT[i]:SetText(XiuLianMiJiLevel.."/"..CurMaxLevel);
			end
		end
		XIULIAN_MIJI[6] : SetActionItem(-1)
		XIULIAN_MIJI_TEXT[6]:SetText("");
	elseif XIULIAN_BOOK_SELECT == 2  then
	    for i = 1, 6 do
			local theAction = EnumAction(i + 5 - 1, "xiulianmiji")
			if theAction ~= 0 then
		        XIULIAN_MIJI[i] : SetActionItem(theAction:GetID())
		        local CurMaxLevel = Player:GetXiuLianMiJiInfo(i + 5 - 1,"MaxLevel")
		        local XiuLianMiJiLevel = Player:GetXiuLianMiJiInfo(i + 5 - 1,"Level")
		        if (CurMaxLevel == nil) or (XiuLianMiJiLevel == nil) then
		        	MIJI_CAN_SELECT =false
					return
		        else
		        	MIJI_CAN_SELECT =true
				end
		        XIULIAN_MIJI_TEXT[i]:SetText(XiuLianMiJiLevel.."/"..CurMaxLevel);
			end
		end
	else
		for i=1, 6 do
	        XIULIAN_MIJI[i] : SetActionItem(-1)
	        XIULIAN_MIJI_TEXT[i]:SetText("")
		end
	end
	Xiulian_SetSelectState() 
    	--刷新中间图标
	if (XIULIAN_BOOK_SELECT ~= -1)   then
		local theAction = EnumAction(XIULIAN_BOOK_SELECT-1, "xiulianbook")
		Xiulian_SkillIcon : SetActionItem(theAction:GetID())
		--PushDebugMessage("BOOK ID is --"..theAction:GetID())
		local XiuLianBookName = Player:GetXiuLianBookInfo(XIULIAN_BOOK_SELECT-1,"Name");
		local XiuLianBookLevel = Player:GetXiuLianBookInfo(XIULIAN_BOOK_SELECT-1,"Level")
		local XiuLianBookExplain = Player:GetXiuLianBookInfo(XIULIAN_BOOK_SELECT-1,"Explain")
		
	
		local StrJingJie = "#{XL_XML_29}".."#{XL_XML_85}"..XiuLianBookLevel.."#{XL_XML_86}"
	
		Xiulian_SkillName:SetText(XiuLianBookName);
		Xiulian_SkillJingjie:SetText(StrJingJie);
		Xiulian_SkillLevel:SetText("");
		local strCondition
		if(XIULIAN_BOOK_SELECT == 1) then
			if(Player:GetData("LEVEL") >= 70) then
				strCondition = "\n#G#{XL_XML_30}" 
			else
				strCondition = "\n#cff0000#{XL_XML_30}" 
			end
		else
			local XiuLianBook1Level = Player:GetXiuLianBookInfo(0,"Level")
			if (XiuLianBook1Level >= 3) then
				strCondition = "\n#G#{XL_XML_34}" 
			else
				strCondition = "\n#cff0000#{XL_XML_34}"
			end
		end 
		Xiulian_SkillInfo:SetText(XiuLianBookExplain.."\n#{XL_XML_31}"..strCondition);
	else
	    Xiulian_SkillIcon : SetActionItem(-1)
	end
	
end
--===============================================
-- 设置选中状态 
--===============================================
function Xiulian_SetSelectState()

  	for i=1, 2 do 
  	  if(i == XIULIAN_BOOK_SELECT) then
  	       XIULIAN_BOOKS[i]:SetPushed(1)
  	  else
  	       XIULIAN_BOOKS[i]:SetPushed(0)
  	  end
	end 
	for i=1, 6 do
		if((XIULIAN_MIJI_SELECT <= 5 and i==XIULIAN_MIJI_SELECT) or (XIULIAN_MIJI_SELECT > 5 and i == XIULIAN_MIJI_SELECT - 5)) then
			XIULIAN_MIJI[i]:SetPushed(1);
		else
			XIULIAN_MIJI[i]:SetPushed(0);
		end
	end 
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Xiulian_Frame_On_ResetPos()

	Xiulian_Frame : SetProperty("UnifiedXPosition", g_Xiulian_Frame_UnifiedXPosition);
	Xiulian_Frame : SetProperty("UnifiedYPosition", g_Xiulian_Frame_UnifiedYPosition);

end

function Xiulian_ShowPage()

	for i = 1, g_MaxPage do
		g_PageButton[i]:Hide()
	end
	local nPageNumber = tonumber(Variable:GetVariable("PageNumber"));
	Xiulian_ClearPage()
	if nPageNumber ~= nil and nPageNumber ~= 0 then
		g_PageButton[nPageNumber]:SetCheck(1)
		for i = 1, g_MaxPage do
			if i ~= nPageNumber then
				g_PageButton[i]:SetCheck(0)
			end
		end
	end
	
	g_PageOrder = {}
	g_PageCount = 0
	for i = 1, g_MaxPage do
		if Xiulian_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)	
			g_PageOrder[g_PageCount] = i
			
			if Xiulian_IsPageEnable(i) == 1 then
				g_PageButton[g_PageCount]:Enable()
				g_PageMask[g_PageCount]:Hide()
			else
				g_PageButton[g_PageCount]:Disable()
				g_PageMask[g_PageCount]:Show()
				g_PageMask[g_PageCount]:SetToolTip(g_Page[i].Tip)
			end
		end
	end
end

function Xiulian_OnPageClicked(idx)
	Variable:SetVariable("PageNumber", tostring(idx), 1);
	idx = g_PageOrder[idx]
	if idx == 1 then--??
		Xiulian_SelfEquip_Page_Switch()
	elseif idx == 2 then--??
		Xiulian_SelfData_Switch()
	elseif idx == 3 then--??
		Xiulian_Pet_Switch()
	elseif idx == 4 then--??
		Xiulian_Wuhun_Switch()
	elseif idx == 5 then--??
		Xiulian_Xiulian_Switch()
		Xiulian_ClearPage()
	elseif idx == 6 then--??
		Xiulian_Talent_Switch()
	elseif idx == 7 then--??
		Xiulian_Page_LingYu()
	elseif idx == 8 then--??
		Xiulian_Page_ShenBing()
	elseif idx == 9 then--????
		Xiulian_Page_DWJinJie()
	elseif idx == 10 then--??
		Xiulian_Page_Peak()
	elseif idx == 11 then--??
		Xiulian_Profile_Switch()
	elseif idx == 12 then--??
		Xiulian_Other_Info_Page_Switch()
	end
end

function Xiulian_CheckPage(idx)
	if idx == 1 then--??
		return 1
	elseif idx == 2 then--??
		return 1
	elseif idx == 3 then--??
		return 1
	elseif idx == 4 then--??
		return 1
	elseif idx == 5 then--??
		return 1
	elseif idx == 6 then--??
		return DataPool:Lua_CheckIsShowTalent()
	elseif idx == 7 then--??
		return 1
	elseif idx == 8 then--??
		return 1
	elseif idx == 9 then--????
		return 1
	elseif idx == 10 then--??
	
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 11 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 15 then
			return 1
		end
	elseif idx == 12 then--??
		return 1
	end
	return 0
end

function Xiulian_IsPageEnable(idx)
	if idx == 1 then--??
		return 1
	elseif idx == 2 then--??
		return 1
	elseif idx == 3 then--??
		return 1
	elseif idx == 4 then--??
		return 1
	elseif idx == 5 then--??
		return 1
	elseif idx == 6 then--??
		return 1
	elseif idx == 7 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 8 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 65 then
			return 1
		end
	elseif idx == 9 then--????
		return 1
	elseif idx == 10 then--??
	
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 11 then--??
		return 1
	elseif idx == 12 then--??
		return 1
	end
	return 0
end

function Xiulian_ClearPage()
	Variable:SetVariable("PageNumber", tostring(0), 1)
end

--更新分页红点
function Xiulian_UpdateRedPoint()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end

function Xiulian_Page_Peak()
	Variable:SetVariable("SelfUnionPos", Xiulian_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePeak()
	this:Hide();
end
