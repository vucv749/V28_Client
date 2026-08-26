--ÓÎÏ·¹ÜÀíÔ±¹¤¾ßÎïÆ·ËÑË÷
--by.Fjqh For Entertainment or Communication Only
local GameTools6_ItemSearch_Item,GameTools6_ItemSearch_Count = {},{};
local g_UIPos;

-- È«¾Ö»º´æ£ºÖ»¶ÁÒ»´ÎÎÄ¼þ
local g_ItemSearch_All = nil      -- ????
local g_PetSearch_All  = nil      -- ??

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
--½çÃæ³õÊ¼»¯
--===============================================
function GameTools6_ItemSearch_Show()
	this:Show()
	GameTools6_ItemSearch_Cancel_Clicked()
	GameTools6_ItemSearch_List:AddItem("#WTHïnh Tiên ðßa vào#GðÕo cø tên#WHo£c#GID#Wtiªn hành tìm tòi", 0);
	
	--Ä¬ÈÏÑ¡ÖÐËÑË÷ÎïÆ·
	GameTools6_ItemSearch_SelectPet:SetCheck(0)
	GameTools6_ItemSearch_electWuPing:SetCheck(1)
end

--===============================================
--È¡Ïû
--===============================================
function GameTools6_ItemSearch_Cancel_Clicked()
	GameTools6_ItemSearch_Item,GameTools6_ItemSearch_Count = {},{};
	GameTools6_ItemSearch_Act:SetActionItem(-1);
	GameTools6_ItemSearch_List:ClearListBox();
end

--===============================================
--¿ªÊ¼ËÑË÷
--===============================================
function GameTools6_ItemSearch_OK_Clicked()
	local str1 = GameTools6_ItemSearch_Text2:GetText();
	if str1 == "" then
		PushDebugMessage("Tìm tòi nµi dung Vi Không. Thïnh ðßa vào ðÕo cø Ðích tên Ho£c IDm· ra Thï tìm tòi.")
		return
	end
	GameTools6_ItemSearch_Act:SetActionItem(-1);
	
	--µÚÒ»ÐÐ·ÅÌáÊ¾
	local str2 = string.format("#WDÎ tìm tòi[#G%s#W], Thïnh lña ch÷n kªt quä Dî tñ ðµng bö thêm vào:",str1);
	GameTools6_ItemSearch_List:ClearListBox();
	GameTools6_ItemSearch_List:AddItem(str2, 0);
	
	-- ¶¨Òå×î´óÏÔÊ¾ÊýÁ¿
	local maxDisplayCount = 1000

	--J2 µÀ¾ßÃû³Æ
	--J3 µÀ¾ßID
	--J4 µþ¼ÓÊýÁ¿
	local int1 = 0;
	local all
	
	--¼ì²éµ¥Ñ¡¿ò×´Ì¬ ÊÇ·ñÑ¡ÖÐ äÊÞËÑË÷
	local WuPingStr = "..\\Bin\\Config\\ItemSearch.txt" 
	local CheckZhuangTai = GameTools6_ItemSearch_SelectPet:GetCheck()
	if CheckZhuangTai == 1 then
        WuPingStr = "..\\Bin\\Config\\PetSearch.txt"
        -- Ê¹ÓÃ»º´æ£ºg_PetSearch_All
        if not g_PetSearch_All then
            local op = io.open(WuPingStr, "r");
            if op then
                g_PetSearch_All = op:read("*a");
                op:close();
            end
			PushDebugMessage("L¥n ð¥u tiên Gia Täi Trân Thú TXTs¯ li®u thành công")
        end
        all = g_PetSearch_All
    else
        -- Ê¹ÓÃ»º´æ£ºg_ItemSearch_All
        if not g_ItemSearch_All then
            local op = io.open(WuPingStr, "r");
            if op then
                g_ItemSearch_All = op:read("*a");
                op:close();
            end
			PushDebugMessage("L¥n ð¥u tiên Gia Täi v§t ph¦m TXTs¯ li®u thành công")
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
								----------------------×ÔÊÊÓ¦¿ ¸ñ--------------------------
								-- Ä¿±ê³¤¶ÈÎª 20 ¸ö×Ö·û
								local targetLength = 20
								local space = " "
								-- ¼ÆËãÐèÒªÌí¼ÓµÄ¿ ¸ñÊý
								local numSpaces = targetLength - string.len(J2)
								if numSpaces < 1 then
									numSpaces = 1  -- ?????????????
								end
								-- ¹¹½¨¿ ¸ñ×Ö·û´®
								local spaces = space:rep(numSpaces)
								----------------------×ÔÊÊÓ¦¿ ¸ñ--------------------------							
								-- str2 = string.format("#R%s    #Gµþ¼ÓÊýÁ¿:%s",J2,J4);
								if CheckZhuangTai == 1 then
									str2 = string.format("#R%S%s#Gmang theo c¤p b§c: %s", J2, spaces, J4)
								else
									str2 = string.format("#R%S%s#Gch°ng s¯ lßþng: %s", J2, spaces, J4)
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
	-- ¼ì²éÊÇ·ñ³¬¹ý×î´óÊýÁ¿ÏÞÖÆ²¢ÌáÊ¾
    if int1 >= maxDisplayCount then
        local warningMessage = "#RcÄnh cáo: S¯ li®u Lßþng quá l¾n, Thïnh Tä Canh k¬ lÕi Ðích tìm tòi m¤u ch¯t T×."
        GameTools6_ItemSearch_List:AddItem(warningMessage, 0)
    end
end

function GameTools6_ItemSearch_Select_Clicked(Index)
	if Index == 1 then
		GameTools6_ItemSearch_electWuPing:SetCheck(1)
		GameTools6_ItemSearch_SelectPet:SetCheck(0)
		GameTools6_ItemSearch_lvwEquipTitle:RemoveColumnByPos(0)
		GameTools6_ItemSearch_lvwEquipTitle:RemoveColumnByPos(0)
		GameTools6_ItemSearch_lvwEquipTitle:AddColumn( "ÐÕo cø tên", 0, 0.5 );
		GameTools6_ItemSearch_lvwEquipTitle:AddColumn( "Ch°ng s¯ lßþng", 1, 0.5 );
	elseif Index == 2 then
		GameTools6_ItemSearch_electWuPing:SetCheck(0)
		GameTools6_ItemSearch_SelectPet:SetCheck(1)
		GameTools6_ItemSearch_lvwEquipTitle:RemoveColumnByPos(0)
		GameTools6_ItemSearch_lvwEquipTitle:RemoveColumnByPos(0)
		GameTools6_ItemSearch_lvwEquipTitle:AddColumn( "Trân Thú tên", 0, 0.5 );
		GameTools6_ItemSearch_lvwEquipTitle:AddColumn( "Mang theo c¤p b§c", 1, 0.5 );
	end
end
--===============================================
--Ñ¡ÔñÁÐ±íÏîÄ¿
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
