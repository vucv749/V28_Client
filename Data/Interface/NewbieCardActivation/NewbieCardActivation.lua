local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_uicmd = 0;
local g_cardId = -1;

local g_NewbieCardActivation_Frame_UnifiedXPosition;
local g_NewbieCardActivation_Frame_UnifiedYPosition;

function NewbieCardActivation_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("NewUserCard_Check_Result");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function NewbieCardActivation_OnLoad()
g_NewbieCardActivation_Frame_UnifiedXPosition	= NewbieCardActivation_Frame:GetProperty("UnifiedXPosition");
g_NewbieCardActivation_Frame_UnifiedYPosition	= NewbieCardActivation_Frame:GetProperty("UnifiedYPosition");
end

function NewbieCardActivation_OnEvent(event)
	if(event == "UI_COMMAND" and not this:IsVisible()) then
		if tonumber(arg0) == 2006
			or tonumber(arg0) == 20100118	--1888财富卡
		then
			objCared = Get_XParam_INT(0);
			g_cardId = Get_XParam_INT(1);
			objCared = Target:GetServerId2ClientId(objCared);
			NewUserCard_SetText(tonumber(arg0));
			this:CareObject(objCared, 1, "NewUserCard");
			NewbieCardActivation_Input:SetProperty("DefaultEditBox", "True");
			this:Show();
			g_uicmd = tonumber(arg0);
		end
	elseif(event == "OBJECT_CARED_EVENT") then
		--AxTrace(0, 0, "arg0:"..arg0.." arg1:"..arg1.." arg2:"..arg2.." objCared:"..objCared);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Guild_Create_Close();
		end

	elseif(event == "NewUserCard_Check_Result")then
		local result = tonumber(arg0)
		if(tonumber(arg0)== 0) then
			NewUserCard_Close();
			return;
		end
		if(tonumber(arg0)== 1 or tonumber(arg0)== 2) then
			NewbieCardActivation_Input:SetProperty("DefaultEditBox", "True");
			NewbieCardActivation_Input:SetSelected( 0, -1 );
			return;
		end
	elseif( event == "ADJEST_UI_POS" ) then
		NewbieCardActivation_ResetPos()

	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		NewbieCardActivation_ResetPos()
		
	end

end

function NewUserCard_Open_Click()
	local cardNum = NewbieCardActivation_Input:GetText();
	if(0 == string.len(cardNum)) then return; end
--王晔华：以后新加物品卡的时候，请模仿SNS卡那样写，给客户端脚本传来cardId，脚本号：809301
--不可以再模仿天龙千里卡、时尚卡、鸭嘴兽卡的做法，使用龚彩云那里的通用脚本打开卡号输入界面，因为这样的做法无法被物品互斥表CardRule.txt所兼容
--此处是没有办法对这3种卡进行兼容，所以仍然保留了原来的做法。
--以后新加非物品卡的时候，参照1888卡即可。TT68738
	local firstbyte = string.byte(cardNum)
	local secondbyte = string.sub(cardNum, 2, 2)
	
	--NewUserCard(cardNum,g_cardId)
	if g_uicmd == 2006 then
		NewUserCard(cardNum,g_cardId,0)	--参数3: 0为物品卡, 1为财富卡
	elseif g_uicmd == 20100118 then
		NewUserCard(cardNum,g_cardId,1)	--参数3: 0为物品卡, 1为财富卡
	end
	
end

function NewUserCard_Close()
	this:Hide();
	this:CareObject(objCared, 0, "NewUserCard");
	g_uicmd = 0;
end

function NewUserCard_SetText(uicmd)
	if uicmd == 2006 then					--物品卡
		NewbieCardActivation_DragTitle:SetText("#{CJ_20080321_01}");
		NewbieCardActivation_Text:SetText("#{CJ_20080321_02}");
	elseif uicmd == 20100118 then	--财富卡
		NewbieCardActivation_DragTitle:SetText("#{TLWS_20200908_16}");
		NewbieCardActivation_Text:SetText("#{TLWS_20200908_17}");
	end
	NewbieCardActivation_Input:SetText("");
end

function NewbieCardActivation_ResetPos()
	NewbieCardActivation_Frame:SetProperty("UnifiedXPosition", g_NewbieCardActivation_Frame_UnifiedXPosition);
	NewbieCardActivation_Frame:SetProperty("UnifiedYPosition", g_NewbieCardActivation_Frame_UnifiedYPosition);

end
