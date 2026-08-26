
local g_pos1;
local g_pos2;
local g_TitleColor = "#cff6600";
local g_ExplainColor = "#cFFCC00";
local g_PurpleColor = "#c9107e1";
local g_BlueColor   = "#c00ccff";
local g_YellowColor = "#cfeff95";
local g_GreenColor	= "#c5bc257";
local g_Stars;		
local g_PetSoul_Index = 0;	
local g_PetSoul_HandbookSelId = 1;	
local g_PetSoul_HandbookBloodLevel = 1;	
local g_PetSoul_Other = 0;


function PetSoul_SuperTooltip_PreLoad()

	this:RegisterEvent("SHOW_PETSOUL_SUPERTOOLTIP");
	this:RegisterEvent("UPDATE_PETSOUL_SUPERTOOLTIP");
	
	
	this:RegisterEvent("SHOW_PETSOUL_SUPERTOOLTIP_HANDBOOK");
	this:RegisterEvent("UPDATE_PETSOUL_SUPERTOOLTIP_HANDBOOK");
	
end

function PetSoul_SuperTooltip_OnLoad()

	g_Stars={
				PetSoul_SuperTooltip_StaticPart_Star1,
				PetSoul_SuperTooltip_StaticPart_Star2,
				PetSoul_SuperTooltip_StaticPart_Star3,
				PetSoul_SuperTooltip_StaticPart_Star4,
				PetSoul_SuperTooltip_StaticPart_Star5,
				PetSoul_SuperTooltip_StaticPart_Star6,
				PetSoul_SuperTooltip_StaticPart_Star7,
				PetSoul_SuperTooltip_StaticPart_Star8,
				PetSoul_SuperTooltip_StaticPart_Star9,
		};
		
	for i=1,9 do
		g_Stars[i]:Hide();
	end;
	
end										

function PetSoul_SuperTooltip_OnEvent(event)

	if(event == "SHOW_PETSOUL_SUPERTOOLTIP") then
		if( arg0 == "1" ) then	
			g_PetSoul_Index = tonumber(arg1)
			g_PetSoul_Other = tonumber(arg6)
			if(PetSoul_SuperTooltip_Update(1)==1) then
				g_pos1, g_pos2 = _PetSoul_SuperTooltip_:PositionSelf(arg2, arg3, arg4, arg5);	
				this:Show();
			end;
			return;
		elseif ( arg0 == "2" ) then	
			if(PetSoul_SuperTooltip_Update(3)==1) then
				g_pos1, g_pos2 = _PetSoul_SuperTooltip_:PositionSelf(arg1, arg2, arg3, arg4);	
				this:Show();
			end;
			return;
		else
			g_PetSoul_Index = 0
			g_PetSoul_Other = 0
			this:Hide();
			return;

		end
	end
	
	if(event == "SHOW_PETSOUL_SUPERTOOLTIP_HANDBOOK") then
		if( arg0 == "1" ) then	
			g_PetSoul_HandbookSelId = tonumber(arg1)
			g_PetSoul_HandbookBloodLevel = tonumber(arg2)
			
			if g_PetSoul_HandbookBloodLevel > 6 or g_PetSoul_HandbookBloodLevel <= 0 then
				g_PetSoul_HandbookBloodLevel = 1
			end
			
			if(PetSoul_SuperTooltip_Update(2)==1) then
				g_pos1, g_pos2 = _PetSoul_SuperTooltip_:PositionSelf(arg3, arg4, arg5, arg6);	
				this:Show();
			end;
			return;
		else
			g_PetSoul_HandbookSelId = 1
			this:Hide();
			return;

		end
	end	
	
	
	if(event == "UPDATE_PETSOUL_SUPERTOOLTIP") then
		if(this:IsVisible()) then
			PetSoul_SuperTooltip_Update(1);
			_PetSoul_SuperTooltip_:PositionSelf(0, 0, g_pos1, g_pos2);
			return;
		end;
	end	
	
	
	if(event == "UPDATE_PETSOUL_SUPERTOOLTIP_HANDBOOK") then
		if(this:IsVisible()) then
			PetSoul_SuperTooltip_Update(2);
			_PetSoul_SuperTooltip_:PositionSelf(0, 0, g_pos1, g_pos2);
			return;
		end;
	end
	
end

function PetSoul_SuperTooltip_Update(showtype)

	-- 先清繝以前显示的文字
	PetSoul_SuperTooltip_ClearText();
		
	local typeDesc = nil
	local szPropertys = nil
	local szTitle, szIconName, szExplain1, szExplain2, szExplain3
	if showtype == 1 then
		szTitle, szIconName, szExplain1, szExplain2, szExplain3 = Pet:LuaFnGetPetSoulPossSkillInfo(g_PetSoul_Index, g_PetSoul_Other);	
	elseif showtype == 2 then ---handbook
		szTitle, szIconName, szExplain1, szExplain2 = Pet:LuaFnGetPetSoulPossSkillInfo_Handbook(g_PetSoul_HandbookSelId,  g_PetSoul_HandbookBloodLevel);	
	elseif showtype == 3 then
		szTitle, szIconName, szExplain1, szExplain2, szExplain3 = Pet:LuaFnGetPetSoulPossSkillInfo(-1, 2);	
	end
	----------------------------------------------------------------------
	--显示静态头
	local toDisplay = "";
		
	if(szTitle ~= "" and szIconName ~= "")then
		toDisplay = toDisplay .."PetSoul_SuperTooltip_PageHeader";
	end
	
	--加上类型描述
	if( typeDesc ~= nil) then 
		toDisplay = toDisplay .. ";PetSoul_SuperTooltip_ShortDesc";
	end
	
	--属性
	if(szPropertys ~= nil) then 
		toDisplay = toDisplay .. ";PetSoul_SuperTooltip_Property";
	end

	--详细解释
	if(szExplain1 ~= "" and szExplain2 ~= "") then 
		toDisplay = toDisplay .. ";PetSoul_SuperTooltip_Explain";
	end

	--显示组件内容
	if(toDisplay=="") then
		this:Hide();
		return 0;
	end;
	
	--AxTrace( 8,0,toDisplay );
	_PetSoul_SuperTooltip_:SetProperty("PageElements",  toDisplay);
		
	----------------------------------------------------------------------
	--显示新的内容
	PetSoul_SuperTooltip_StaticPart_Title:SetText(g_TitleColor..szTitle);
	
	--PetSoul_SuperTooltip_StaticPart_Item1:SetText(SuperTooltips:GetDesc1());
	--PetSoul_SuperTooltip_StaticPart_Item2:SetText(SuperTooltips:GetDesc2());
	--PetSoul_SuperTooltip_StaticPart_Item3:SetText(SuperTooltips:GetDesc3());
	--PetSoul_SuperTooltip_StaticPart_Item4:SetText(SuperTooltips:GetDesc4());
		
	local sPos,_ = string.find(szIconName," ");
	local IconImageSet = string.sub(szIconName, 5, sPos-1);
	local IconIamge = string.sub(szIconName, sPos+7)
	PetSoul_SuperTooltip_StaticPart_Icon:SetImage(IconIamge);
	
	--PetSoul_SuperTooltip_ShortDesc_Text:SetText(typeDesc);
	
	local szExplain = g_ExplainColor..szExplain1.."#r"..szExplain2
	if szExplain3 ~= nil then
		szExplain = szExplain.."#r"..szExplain3
	end
	szExplain = szExplain.."#r".."#{SHXT_20211230_218}"
	PetSoul_SuperTooltip_Explain:SetText(szExplain);
		
	--AxTrace( 8,0,"Show tooltip  "..szExplain);
	
	return 1;
		
end

-------------------------------------------------------------------------------------------------------------------------------
--
-- 清繝显示文本
--
function PetSoul_SuperTooltip_ClearText()
		
	PetSoul_SuperTooltip_StaticPart_Title:SetText("");
	PetSoul_SuperTooltip_StaticPart_Item1:SetText("");
	PetSoul_SuperTooltip_StaticPart_Item2:SetText("");
	PetSoul_SuperTooltip_StaticPart_Item3:SetText("");
	PetSoul_SuperTooltip_StaticPart_Item4:SetText("");
		
	local starNum=9
	for i=1,starNum do
		g_Stars[i]:Hide();
	end;
		
	PetSoul_SuperTooltip_Explain:SetText("");
	PetSoul_SuperTooltip_Property:SetText("");
	PetSoul_SuperTooltip_Manufacturer:SetText("");
		
end
