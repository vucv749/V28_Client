--游戏管理员工具物品搜索
--by.Fjqh For Entertainment or Communication Only
local GameTools6_ItemSearch_Item,GameTools6_ItemSearch_Count = {},{};
local g_UIPos;

-- 全局缓存：只读一次文件
local g_ItemSearch_All = nil      -- 普通物品
local g_PetSearch_All  = nil      -- 珍兽

--===============================================
-- OnLoad()
--===============================================
function GameTools6_ItemSearch_PreLoad()
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	this:RegisterEvent("UI_COMMAND");
end

--===============================================
-- OnLoad()
--===============================================
function GameTools6_ItemSearch_OnLoad()
	g_UIPos = GameTools6_ItemSearch_Frame : GetProperty("UnifiedPosition")
end

--===============================================
-- OnEvent()
--===============================================
function GameTools6_ItemSearch_OnEvent(event)
	if ( event == "UI_COMMAND" ) then
		if arg0 == "707022022" then
			local nXp = Get_XParam_INT(0)
			local nYp = Get_XParam_INT(1)
			if nXp ~= nil and nYp ~= nil then
				GameTools6_ItemSearch_Frame:SetProperty("AbsoluteXPosition",tonumber(nXp))
				GameTools6_ItemSearch_Frame:SetProperty("AbsoluteYPosition",tonumber(nYp))
			end
			GameTools6_ItemSearch_Show();
		end
	elseif( event == "PLAYER_LEAVE_WORLD" ) then
		this:Hide();
	elseif (event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" ) then
		GameTools6_ItemSearch_Frame:SetProperty("UnifiedPosition", g_UIPos);
	end
end

--===============================================
--界面初始化
--===============================================
function GameTools6_ItemSearch_Show()
	this:Show()
	GameTools6_ItemSearch_Cancel_Clicked()
	GameTools6_ItemSearch_List:AddItem("#W请先输入#G道具名称#W或#GID#W进行搜索", 0);
	
	--默认选中搜索物品
	GameTools6_ItemSearch_SelectPet:SetCheck(0)
	GameTools6_ItemSearch_electWuPing:SetCheck(1)
end

--===============================================
--取消
--===============================================
function GameTools6_ItemSearch_Cancel_Clicked()
	GameTools6_ItemSearch_Item,GameTools6_ItemSearch_Count = {},{};
	GameTools6_ItemSearch_Act:SetActionItem(-1);
	GameTools6_ItemSearch_List:ClearListBox();
end

--===============================================
--开始搜索
--===============================================
function GameTools6_ItemSearch_OK_Clicked()
	local str1 = GameTools6_ItemSearch_Text2:GetText();
	if str1 == "" then
		PushDebugMessage("搜索内容为空。请输入道具的名称或ID来开始搜索。")
		return
	end
	GameTools6_ItemSearch_Act:SetActionItem(-1);
	
	--第一行放提示
	local str2 = string.format("#W已搜索[#G%s#W]，请选择结果以自动填充：",str1);
	GameTools6_ItemSearch_List:ClearListBox();
	GameTools6_ItemSearch_List:AddItem(str2, 0);
	
	-- 定义最大显示数量
	local maxDisplayCount = 1000

	--J2 道具名称
	--J3 道具ID
	--J4 叠加数量
	local int1 = 0;
	local all
	
	--检查单选框状态 是否选中珍兽搜索
	local WuPingStr = "..\\Bin\\Config\\ItemSearch.txt" 
	local CheckZhuangTai = GameTools6_ItemSearch_SelectPet:GetCheck()
	if CheckZhuangTai == 1 then
        WuPingStr = "..\\Bin\\Config\\PetSearch.txt"
        -- 使用缓存：g_PetSearch_All
        if not g_PetSearch_All then
            local op = io.open(WuPingStr, "r");
            if op then
                g_PetSearch_All = op:read("*a");
                op:close();
            end
			PushDebugMessage("第一次加载珍兽TXT数据成功")
        end
        all = g_PetSearch_All
    else
        -- 使用缓存：g_ItemSearch_All
        if not g_ItemSearch_All then
            local op = io.open(WuPingStr, "r");
            if op then
                g_ItemSearch_All = op:read("*a");
                op:close();
            end
			PushDebugMessage("第一次加载物品TXT数据成功")
        end
        all = g_ItemSearch_All
    end
	
	if all and all ~= "" then
		local F1,F2,F3 = 1,1,1
		local F4,F5
		local J1,J2,J3,J4
		while F1 and int1 < maxDisplayCount do
			F1,F2 = string.find(all,str1,F3,true);
			if F1 and F2 then
				F4 = string.find(all,"\n",F2,true);
				if F4 then
					F3 = F4 + 1;
					while F1 > 1 do
						F1 = F1 - 1;
						F5 = string.byte(all,F1);
						if F5 == 10 then
							J1 = string.sub(all,F1 + 1,F4 - 1);
							F1 = 0;
							break
						end
					end
					if F1 == 1 then
						J1 = string.sub(all,F1,F4 - 1);
					end
					if F1 == 0 or F1 == 1 then
						F4 = string.find(J1,"\t",1,true);
						if F4 then
							J2 = string.sub(J1,1,F4 - 1);
							F5 = F4 + 1;
							F4 = string.find(J1,"\t",F5,true);
							if F4 then
								J3 = string.sub(J1,F5,F4 - 1);
								F5 = F4 + 1;
								J4 = string.sub(J1,F5,-1);
								int1 = int1 + 1;
								GameTools6_ItemSearch_Item[int1] = J3;
								GameTools6_ItemSearch_Count[int1] = J4;
								----------------------自适应空格--------------------------
								-- 目标长度为 20 个字符
								local targetLength = 20
								local space = " "
								-- 计算需要添加的空格数
								local numSpaces = targetLength - string.len(J2)
								if numSpaces < 1 then
									numSpaces = 1  -- 至少添加一个空格以分隔文本
								end
								-- 构建空格字符串
								local spaces = space:rep(numSpaces)
								----------------------自适应空格--------------------------							
								-- str2 = string.format("#R%s    #G叠加数量:%s",J2,J4);
								if CheckZhuangTai == 1 then
									str2 = string.format("#R%s%s#G携带等级:%s", J2, spaces, J4)
								else
									str2 = string.format("#R%s%s#G叠加数量:%s", J2, spaces, J4)
								end
								GameTools6_ItemSearch_List : AddItem(str2, int1);
								
							end
						end
					else
						F1 = nil;
					end
				else
					F1 = nil;
				end
			end
		end
	end
	-- 检查是否超过最大数量限制并提示
    if int1 >= maxDisplayCount then
        local warningMessage = "#R警告: 数据量过大，请写更详细的搜索关键词。"
        GameTools6_ItemSearch_List:AddItem(warningMessage, 0)
    end
end

function GameTools6_ItemSearch_Select_Clicked(Index)
	if Index == 1 then
		GameTools6_ItemSearch_electWuPing:SetCheck(1)
		GameTools6_ItemSearch_SelectPet:SetCheck(0)
		GameTools6_ItemSearch_lvwEquipTitle:RemoveColumnByPos(0)
		GameTools6_ItemSearch_lvwEquipTitle:RemoveColumnByPos(0)
		GameTools6_ItemSearch_lvwEquipTitle:AddColumn( "道具名字", 0, 0.5 );
		GameTools6_ItemSearch_lvwEquipTitle:AddColumn( "叠加数量", 1, 0.5 );
	elseif Index == 2 then
		GameTools6_ItemSearch_electWuPing:SetCheck(0)
		GameTools6_ItemSearch_SelectPet:SetCheck(1)
		GameTools6_ItemSearch_lvwEquipTitle:RemoveColumnByPos(0)
		GameTools6_ItemSearch_lvwEquipTitle:RemoveColumnByPos(0)
		GameTools6_ItemSearch_lvwEquipTitle:AddColumn( "珍兽名字", 0, 0.5 );
		GameTools6_ItemSearch_lvwEquipTitle:AddColumn( "携带等级", 1, 0.5 );
	end
end
--===============================================
--选择列表项目
--===============================================
function GameTools6_ItemSearch_List_Selected()
	local Getid = function (ID)
		local Int1 = -1;
		local Lsid = GemCarve:UpdateProductAction(ID);
		if Lsid and Lsid:GetID() ~= 0 then
			Int1 = Lsid:GetID();
		end
		return Int1;
	end
	local int1 = GameTools6_ItemSearch_List : GetFirstSelectItem();
	if int1 > 0 then
		local Act = Getid(tonumber(GameTools6_ItemSearch_Item[int1]))
		GameTools6_ItemSearch_Act:SetActionItem(Act);
		if GameTools6_ItemSearch_Count[int1] ~= "1" then
			GameTools6_ItemSearch_Act:SetProperty("CornerChar","BotRight "..tostring(GameTools6_ItemSearch_Count[int1]));
		else
			GameTools6_ItemSearch_Act:SetProperty("CornerChar","BotRight ");
		end
		if GameTools6_ItemSearch_SelectPet:GetCheck() == 1 then
			PushEvent("UI_COMMAND",707022021,881122334,tostring(GameTools6_ItemSearch_Item[int1]));
		else
			PushEvent("UI_COMMAND",707022021,707022021,tostring(GameTools6_ItemSearch_Item[int1]),tostring(GameTools6_ItemSearch_Count[int1]));
		end
	end
end
