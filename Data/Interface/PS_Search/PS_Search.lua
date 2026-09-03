--PS_Search.lua

local PAGE_ITEM = 0;
local PAGE_PET  = 1;

local g_CurPage;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

--===============================================
-- PreLoad
--===============================================
function PS_Search_PreLoad()
	this:RegisterEvent("OPEN_FIND_SHOP");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_CLOSE_FIND_SHOP");

end

--===============================================
-- OnLoad
--===============================================
function PS_Search_OnLoad()
	g_CurPage = PAGE_ITEM;
end

--===============================================
-- OnEvent
--===============================================
function PS_Search_OnEvent(event)

	if(event == "OPEN_FIND_SHOP")  then
		PS_Search_Editbox:SetText("")
		PS_Search_Editbox:SetProperty("DefaultEditBox", "True")
		this:Show();
		PS_Search_UpdateFrame(g_CurPage)
		
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_Search");
	
	elseif(event == "OBJECT_CARED_EVENT")   then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "PS_Search");
		end	
	
	elseif ( event == "PS_CLOSE_FIND_SHOP" )    then
		this:Hide();
		PS_Search_Editbox:SetText("")
		
		--È¡Ïû¹ØÐÄ
		this:CareObject(objCared, 0, "PS_Search");

	end
	
end

--===============================================
-- µã»÷Ñ¡ÔñÁÐ±í
--===============================================
function PS_Search_List_Selected()
	
	local nSelect = PS_Search_List:GetFirstSelectItem();
	if( nSelect == -1 )   then
		return;
	end
	
	if(g_CurPage == PAGE_ITEM)    then			--???
		PlayerShop:FindShop("item",nSelect+1);
	elseif(g_CurPage == PAGE_PET) then			--???
		PlayerShop:FindShop("pet",nSelect+1);
		
	end
end

--===============================================
-- µã»÷°´  ÉÌ»áµêÆÌID²é ÒµÄ"²é Ò"°´Å¥
--===============================================
function PS_Search_SearchShopID_Clicked()
	local shopID = PS_Search_Editbox:GetText()
	if shopID and shopID ~= "" and tonumber(shopID) >= 0 then
		PlayerShop:FindShop("shopid", tonumber(shopID))
	end
end

--===============================================
-- UpdateFrame
--===============================================
function PS_Search_UpdateFrame(nPage)
	
	PS_Search_SetTabColor(nPage);
	PS_Search_List:ClearListBox();
	if(nPage == PAGE_ITEM)    then					--???
		PS_Search_List:AddItem("Ti®m V§t Ph¦m",0)
		PS_Search_List:AddItem("Ti®m Bäo ThÕch",1)
		PS_Search_List:AddItem("Ti®m Vû Khí",2)
		PS_Search_List:AddItem("Ti®m Hµ Giáp",3)
		PS_Search_List:AddItem("Ti®m Nguyên Li®u",4)
		
		PS_Search_All:SetText("Toàn bµ v§t ph¦m");

	elseif(nPage == PAGE_PET) then 					--???
		PS_Search_List:AddItem("Ti®m Trân Thú",0)

		PS_Search_All:SetText("Toàn bµ Trân Thú");
		
	end
end

--===============================================
-- ChangeTabIndex
--===============================================
function PS_Search_ChangeTabIndex(nPage)
	g_CurPage = nPage;
	PS_Search_UpdateFrame(nPage)
end

--===============================================
-- Ñ¡Ò»Àà
--===============================================
function PS_Search_All_Clicked()
	
	if(g_CurPage == PAGE_ITEM)    then			--???
		PlayerShop:FindShop("item", -1);
	
	elseif(g_CurPage == PAGE_PET) then			--???
		PlayerShop:FindShop("pet", -1);
		
	end
	
end

--===============================================
-- TabÉÏµÄ×ÖÌåÑ É«
--===============================================
function PS_Search_SetTabColor(nPage)

	local   selColor = "#e010101#Y";
	local noselColor = "#e010101";

	if( nPage == PAGE_ITEM )		then
		PS_Search_Check_Item:SetText(selColor.. "V§t ph¦m");
		PS_Search_Check_Pet:SetText(noselColor.. "Thú");
	elseif( nPage == PAGE_PET )	then
		PS_Search_Check_Item:SetText(noselColor.. "V§t ph¦m");
		PS_Search_Check_Pet:SetText(selColor.. "Thú");
	end

end

--===============================================
-- Close
--===============================================
function PS_Search_Close_Clicked()
	PS_Search_Editbox:SetText("")
	this:Hide();
	--È¡Ïû¹ØÐÄ
	this:CareObject(objCared, 0, "PS_Search");
	
end
