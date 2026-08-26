-- 时装配饰镶嵌界面

local Dress_Enchase_CoseArray = {5000,6000,7000,8000}
local g_objCared = -1
local Dress_Gem_Buttons={}
local Dress_GEM_QUALITY = {}
local Dress_GEM_EFFECT ={}
local MAX_OBJ_DISTANCE =3.0
local Dress_Gem_Cost = {5000,6000,7000,8000}
local lastDress =-1
local lastDress_Peishi =-1
local lastDress_Xiangqianfu =-1

local g_Dress_Enchase_Frame_UnifiedPosition;

function Dress_Enchase_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UPDATE_DRESS_ENCHASE")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");	
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("ENABLE_DRESS_ENCHASE_PREVIEW");
	this:RegisterEvent("DISABLE_DRESS_ENCHASE_PREVIEW");
	this:RegisterEvent("OPEN_STALL_SALE");
	this:RegisterEvent("PROGRESSBAR_SHOW");
	this:RegisterEvent("CLOSE_DRESS_ENCHASE");	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("OPEN_DRESSPREVIEW")
end

function Dress_Enchase_OnLoad()
	--Dress_Gem_Buttons表示xml里配置的对应控件
	Dress_Gem_Buttons[1] = Dress_Enchase_Item
	Dress_Gem_Buttons[2] = Dress_Enchase_Gem1;
	Dress_Gem_Buttons[3] = Dress_Enchase_Gem2;

	--Dress_GEM_QUALITY表示button里放入的物品
	Dress_GEM_QUALITY[1] = -1;		-- 时装
	Dress_GEM_QUALITY[2] = -1;		-- 配饰
	Dress_GEM_QUALITY[3] = -1;		-- 镶嵌符
	
	Dress_GEM_EFFECT[1] = Dress_Enchase_Effect1;
	Dress_GEM_EFFECT[2] = Dress_Enchase_Effect2;
	Dress_GEM_EFFECT[3] = Dress_Enchase_Effect3;
	
	g_Dress_Enchase_Frame_UnifiedPosition=Dress_Enchase_Frame:GetProperty("UnifiedPosition");
end

function Dress_Enchase_OnEvent(event)
	if(event == "UI_COMMAND" and tonumber(arg0)==20091029) then
		this:Show()
		
		-- 关闭“镶嵌预览”试衣间
		if (IsWindowShow("DressEnchase_Fitting")) then
			DressEnchasing:RestoreDressEnchaseFitting()
			CloseWindow("DressEnchase_Fitting", true)
		end

		PushEvent( "CLOSE_DRESSPREVIEW") 	
		PushEvent( "CLOSE_GEMEFFECTPREVIEW")
		-- 禁用“镶嵌预览”按钮
		Dress_Enchase_Preview:Disable()		
		
		Dress_Enchase_Effect1:Hide()
		Dress_Enchase_Effect2:Hide()
		Dress_Enchase_Effect3:Hide()
		
		g_objCared = -1;
		local xx = Get_XParam_INT(0);
		g_objCared = DataPool : GetNPCIDByServerID(xx);
		if g_objCared == -1 then				
				return;
		end
		BeginCareObject_Dress_Enchase(g_objCared)
		return

	-- 开始摆摊，不能进行镶嵌
	elseif ( event == "OPEN_STALL_SALE" ) then
		if this:IsVisible() then
			Dress_Enchase_OnHiden();
		end
		return
	
	-- 读进度条中，不能进行镶嵌
	elseif ( event == "PROGRESSBAR_SHOW" ) then
		if this:IsVisible() then
			Dress_Enchase_OnHiden();
		end
		return
		
	-- 某些功能互斥，需要关闭该界面
	elseif ( event == "CLOSE_DRESS_ENCHASE" ) then
		if this:IsVisible() then
			Dress_Enchase_OnHiden();
		end
		return

	elseif(event == "UPDATE_DRESS_ENCHASE") then
		Dress_Enchase_Update(arg0,arg1)

		-- 更换了时装或者配饰，关闭“镶嵌预览”试衣间
		if (IsWindowShow("DressEnchase_Fitting")) and ( (tonumber(arg0) == 1) or (tonumber(arg0) == 2) ) then
			DressEnchasing : RestoreDressEnchaseFitting()
			CloseWindow("DressEnchase_Fitting", true)
		end	
		return

	elseif(event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= g_objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Dress_Enchase_OnHiden()
		end
		return

	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 3) then---xml里配置的是D3
			Dress_Enchase_Resume_Gem(25);									-- 取消时装
		elseif(arg0~=nil and tonumber(arg0) == 5) then
			Dress_Enchase_Resume_Gem(26)									-- 取下配饰
		elseif(arg0~=nil and tonumber(arg0) == 7) then
			Dress_Enchase_Resume_Gem(27)									-- 取下镶嵌符
		end
		return

	elseif( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		lastDress = -1
		lastDress_Peishi =	-1
		lastDress_Xiangqianfu = -1

	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		Dress_Enchase_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))

	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		Dress_Enchase_CurrentlyJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

	-- 镶嵌成功，禁用“镶嵌预览”按钮	
	elseif event == "UI_COMMAND" and tonumber(arg0) == 09111601 then
		if this:IsVisible() then
			Dress_Enchase_Preview:Disable()
		end

	-- 镶嵌预览界面已打开，禁用“镶嵌预览”按钮	
	elseif event == "DISABLE_DRESS_ENCHASE_PREVIEW" then
		if this:IsVisible() then
			Dress_Enchase_Preview:Disable()
		end
	
	-- 启用“镶嵌预览”按钮	
	elseif event == "ENABLE_DRESS_ENCHASE_PREVIEW" then
		if this:IsVisible() then
			Dress_Enchase_Preview:Enable()
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		Dress_Enchase_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Dress_Enchase_Frame_On_ResetPos()
	
	end
	
	-- 时装预览
	if  ( event == "UI_COMMAND" and tonumber(arg0) == 120203161 ) or (event == "OPEN_DRESSPREVIEW") or ( event == "UI_COMMAND" and tonumber(arg0) == 20120406 ) or ( event == "UI_COMMAND" and tonumber(arg0) == 2024082101 ) then
		if (this:IsVisible()) then
			Dress_Enchase_OnHiden();
		end
	end
	
	
end
		
function Dress_Enchase_OnShown()
	Dress_Enchase_Clear()
	Dress_Enchase_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	Dress_Enchase_CurrentlyJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
end

function Dress_Enchase_Update(ItemIndex, ItemPos)		
	local IIndex = tonumber(ItemIndex)
	local IPos = tonumber(ItemPos)
	local theActionItem = EnumAction(IPos, "packageitem")
	local needMoney = 0
	local Dress_Bore_Count = 0
	local Dress_Gem_Enchased = 0

	if theActionItem:GetID() ~= 0 then
		if IIndex == 1 then---装备类，需要时装
			local equipPoint = LifeAbility:Get_Equip_Point(IPos)
			if equipPoint ~= 16 then
				PushDebugMessage("#{SZPR_091023_45}")
				return
			end

			Dress_Bore_Count = LifeAbility : GetEquip_HoleCount(IPos)		-- 得到时装上的宝石孔数目
			Dress_Gem_Enchased = LifeAbility : GetEquip_GemCount(IPos)	-- 获得镶嵌在时装上的宝石数目
			
			if Dress_Gem_Enchased == 3 then 
				PushDebugMessage("#{SZPR_091023_47}")				-- "该时装不能再镶嵌更多的配饰"
				return
			end

			if Dress_Bore_Count == Dress_Gem_Enchased then
				PushDebugMessage("#{SZPR_091023_87}")				-- "该时装需要在洛阳（246，129）伊天彩处增加孔位后才能继续镶嵌"
				return
			end

			if Dress_GEM_QUALITY[IIndex] ~= -1 then
				LifeAbility : Lock_Packet_Item(Dress_GEM_QUALITY[IIndex],0);
			end
			Dress_Gem_Buttons[IIndex]:SetActionItem(theActionItem:GetID());
			LifeAbility : Lock_Packet_Item(IPos,1);
			Dress_GEM_QUALITY[IIndex] = IPos	
			
			if Dress_GEM_QUALITY[2] ~=-1 and Dress_GEM_QUALITY[2] ~=0 then ---配饰槽上有配饰，需要重新计算消耗钱数
				local dress_gem_count = LifeAbility : GetEquip_GemCount( Dress_GEM_QUALITY[1]);
				local Dress_Gem_Level = LifeAbility : Get_Gem_Level(Dress_GEM_QUALITY[2],1)
				needMoney = Dress_Gem_Cost[Dress_Gem_Level]*(dress_gem_count+1)
				Dress_Enchase_DemandMoney : SetProperty("MoneyNumber",needMoney);
			end
			
			--将时装UI下面的小图标激活
				for i=1,3 do
					local szIconName = LifeAbility : GetEquip_Gem(Dress_GEM_QUALITY[1], i-1);
					if szIconName~=nil and szIconName ~= "" then
						Dress_GEM_EFFECT[i] : SetProperty("ShortImage", szIconName);
						Dress_GEM_EFFECT[i] : Show();
					else
						Dress_GEM_EFFECT[i] : Hide();
					end
				end

		elseif IIndex == 2 then---配饰类
			local Dress_GemType = LifeAbility : Get_Gem_Level(IPos,2);
			if(Dress_GemType ~= 31 and Dress_GemType ~= 32 and Dress_GemType ~= 33) then
				PushDebugMessage("#{SZPR_091023_48}")
				return
			end
			--如果原来有配饰，就将其解锁
			if Dress_GEM_QUALITY[IIndex] ~= -1 then
				LifeAbility : Lock_Packet_Item(Dress_GEM_QUALITY[IIndex],0);
			end
			if Dress_GEM_QUALITY[1]== -1 then
				PushDebugMessage("#{SZPR_091023_89}")
				return
			end
			local dress_gem_count = LifeAbility : GetEquip_GemCount( Dress_GEM_QUALITY[1]);
			local Dress_Gem_Level = LifeAbility : Get_Gem_Level(IPos,1)
			needMoney = Dress_Gem_Cost[Dress_Gem_Level]*(dress_gem_count+1)
			Dress_Enchase_DemandMoney : SetProperty("MoneyNumber",needMoney);
			Dress_Gem_Buttons[IIndex]:SetActionItem(theActionItem:GetID());
			LifeAbility : Lock_Packet_Item(IPos,1);
			Dress_GEM_QUALITY[IIndex] = IPos

		elseif IIndex == 3 then---配饰镶嵌符
			if PlayerPackage : GetItemTableIndex( IPos ) ~= 30503135 then
				PushDebugMessage("#{SZPR_091023_49}")
				return
			end
			if Dress_GEM_QUALITY[IIndex] ~= -1 then
				LifeAbility : Lock_Packet_Item(Dress_GEM_QUALITY[IIndex],0);
			end
			Dress_Gem_Buttons[IIndex]:SetActionItem(theActionItem:GetID());
			LifeAbility : Lock_Packet_Item(IPos,1);
			Dress_GEM_QUALITY[IIndex] = IPos
		end
	end

	-- 时装和配饰都提交后，激活“镶嵌预览”按钮
	if Dress_GEM_QUALITY[1] ~= -1 and Dress_GEM_QUALITY[2] ~= -1 then
		Dress_Enchase_Preview: Enable()
	end
	
	--把确定按钮正常化
	if Dress_GEM_QUALITY[1] ~= -1 and Dress_GEM_QUALITY[2] ~= -1 and Dress_GEM_QUALITY[3] ~= -1  then
		local userMoney = Player:GetData("MONEY_JZ")+Player:GetData("MONEY")
		local Dress_Gem_Level = LifeAbility : Get_Gem_Level(Dress_GEM_QUALITY[2],1)
		local dress_gem_count = LifeAbility : GetEquip_GemCount( Dress_GEM_QUALITY[1]);
		needMoney = Dress_Gem_Cost[Dress_Gem_Level]*(dress_gem_count+1)
		if Dress_Gem_Level < 5 and Dress_Gem_Level > 0 and needMoney~=0 and userMoney>=needMoney then
			Dress_Enchase_OK:Enable()
		end
	end
	
end

------------------------------------------------------
--
--	xml中需要调用的函数,在右键点击UI中的装备时取下装备
--
function Dress_Enchase_Resume_Gem(nIndex)

	if nIndex<25 or nIndex>27 then 
		return
	end
	
	-- 时装或配饰有一项被取下
	if nIndex == 25 or nIndex == 26 then		
		if (IsWindowShow("DressEnchase_Fitting")) then
			DressEnchasing:RestoreDressEnchaseFitting()
			CloseWindow("DressEnchase_Fitting", true)		-- 关闭“镶嵌预览”试衣间
		end		
		Dress_Enchase_Preview: Disable()							-- 禁用“镶嵌预览”按钮
	end

	local nIndex = nIndex - 24
	if( this:IsVisible() ) then
		if Dress_GEM_QUALITY[nIndex]~=nil and Dress_GEM_QUALITY[nIndex] ~= -1 then
			Dress_Gem_Buttons[nIndex]:SetActionItem(-1)			
			LifeAbility : Lock_Packet_Item(Dress_GEM_QUALITY[nIndex],0);
			Dress_GEM_QUALITY[nIndex] = -1
			if nIndex == 1 then
				for i = 1,3 do
					Dress_GEM_EFFECT[i] : Hide()
				end
			end
			if nIndex == 2 or nIndex == 1 then
				Dress_Enchase_DemandMoney : SetProperty("MoneyNumber", 0);
			end
		end
	end
	
	Dress_Enchase_OK:Disable()
end

function Dress_Enchase_Clear()
	for i=1,3 do 
		if Dress_GEM_QUALITY[i] ~= -1 then
			Dress_Gem_Buttons[i]:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(Dress_GEM_QUALITY[i],0);
			Dress_GEM_QUALITY[i] = -1
		end
	end

	for i = 1,3 do
		Dress_GEM_EFFECT[i] : Hide();
	end
	Dress_Enchase_DemandMoney : SetProperty("MoneyNumber", 0);

	Dress_Enchase_OK:Disable()								-- 禁用“确定”按钮
	Dress_Enchase_Preview:Disable()						-- 禁用“镶嵌预览”按钮

	lastDress = -1
	lastDress_Peishi =	-1
	lastDress_Xiangqianfu = -1
end

function Dress_Enchase_OnHiden()
	StopCareObject_Dress_Enchase(g_objCared)
	Dress_Enchase_Clear()
	
	-- 关闭“镶嵌预览”试衣间
	if (IsWindowShow("DressEnchase_Fitting")) then
		DressEnchasing:RestoreDressEnchaseFitting()
		CloseWindow("DressEnchase_Fitting", true)
	end

	this:Hide()
end

------------------------------------------------------
--
--	打开“镶嵌预览”试衣间
--
function DressEnchase_Preview_Clicked()
	
	if (IsWindowShow("DressEnchase_Fitting")) then
		-- 先清空当前试衣间的数据
		DressEnchasing:RestoreDressEnchaseFitting();
	end
	
	-- 打开试衣间，显示试衣效果
	DressEnchasing:OpenDressEnchaseFitting( Dress_GEM_QUALITY[1], Dress_GEM_QUALITY[2], Dress_Gem_Enchased )

end

------------------------------------------------------
--
--	关心NPC
--
function BeginCareObject_Dress_Enchase(objCaredId)
	g_objCared = objCaredId;
	this:CareObject(objCaredId, 1, "Dress_Enchase");
end

function StopCareObject_Dress_Enchase(objCaredId)
	this:CareObject(objCaredId, 0, "Dress_Enchase")
	g_objCared = -1
end

function Dress_Enchase_Buttons_Clicked()
	
	--条件检查已经检查过，按钮可点击
	local Notify = 0	
	if (lastDress ~= Dress_GEM_QUALITY[1]
		or lastDress_Peishi ~=	Dress_GEM_QUALITY[2]
		or lastDress_Xiangqianfu ~= Dress_GEM_QUALITY[3]) then
		lastDress = Dress_GEM_QUALITY[1]
		lastDress_Peishi =	Dress_GEM_QUALITY[2]
		lastDress_Xiangqianfu = Dress_GEM_QUALITY[3]
		Notify = 1;		
	end
	
	if( Notify == 1) then
		--判断绑定
		local Dress_Bind = 0
		local Dress_Gem_Bind = 0
		local Dress_Xiangqianfu_Bind = 0
		if Dress_GEM_QUALITY[1] ~=-1 then
			Dress_Bind = Dress_Enchase_IsBind(Dress_GEM_QUALITY[1])
		end
		if Dress_GEM_QUALITY[2] ~=-1 then
			Dress_Gem_Bind = Dress_Enchase_IsBind(Dress_GEM_QUALITY[2])
		end
		if Dress_GEM_QUALITY[3] ~=-1 then
			Dress_Xiangqianfu_Bind = Dress_Enchase_IsBind(Dress_GEM_QUALITY[3])
		end
		
		local nItemId = PlayerPackage : GetItemTableIndex( Dress_GEM_QUALITY[1] )
		local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nItemId, "Number")
		if(Dress_Bind == 1 or Dress_Gem_Bind == 1 or Dress_Xiangqianfu_Bind == 1) and (PlayerPackage : GetItemTableIndex( Dress_GEM_QUALITY[1] ) ~= 10124391) and (nFashionNumber <= 0) then
			DressEnchasing:Dress_EnchaseShowInfo("SZPR_XML_51")
			return
		-- else
		-- 	DressEnchasing:Dress_EnchaseShowInfo("SZPR_XML_50")
		-- 	return
		end
	end
	
	-- 关闭“镶嵌预览”试衣间
	if (IsWindowShow("DressEnchase_Fitting")) then
		DressEnchasing:RestoreDressEnchaseFitting()
		CloseWindow("DressEnchase_Fitting", true)
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnDress_Enchase");
		Set_XSCRIPT_ScriptID(830013);
		Set_XSCRIPT_Parameter(0,Dress_GEM_QUALITY[1]);
		Set_XSCRIPT_Parameter(1,Dress_GEM_QUALITY[2]);
		Set_XSCRIPT_Parameter(2,Dress_GEM_QUALITY[3]);
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();

	--清空界面和置一些动态值为空
	for i=1,3 do
		if(Dress_Gem_Buttons[i] ~=-1) then
			Dress_Gem_Buttons[i]:SetActionItem(-1)			
			LifeAbility : Lock_Packet_Item(Dress_GEM_QUALITY[i],0);
			Dress_GEM_QUALITY[i] = -1
			Dress_GEM_EFFECT[i] : Hide()
		end
	end
	Dress_Enchase_DemandMoney : SetProperty("MoneyNumber", 0);
	Dress_Enchase_OK:Disable()

end

function Dress_Enchase_IsBind(ItemID)
	if(GetItemBindStatus(ItemID) == 1) then
		return 1;
	else
		return 0;
	end
end

function Dress_Enchase_Cancel_Clicked()
	Dress_Enchase_Close();
	return;
end


function Dress_Enchase_Frame_On_ResetPos()
  Dress_Enchase_Frame:SetProperty("UnifiedPosition", g_Dress_Enchase_Frame_UnifiedPosition);
end
