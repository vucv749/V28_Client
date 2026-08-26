local EQUIP_BUTTONS;
local EQUIP_QUALITY = -1;
local MATERIAL_BUTTONS;
local MATERIAL_QUALITY = -1;
local Need_Item = 0
local Need_Money =0
local Need_Item_Count = 0
local Bore_Count=0
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local STILE_TYPE = -1 --打孔类型，1点金，2寒玉

local x311200_Stiletto_four_80_ID = {
	--新增包括80~89级的手工装备、套装（师门、秦皇、玄昊）、神器 
	10200018,10201018,10202018,10203018,10204018,10205018,10210018,10210038,10210058,10211018,
	10211038,10211058,10212018,10212038,10212058,10213018,10213038,10213058,10214018,10215018,
	10220019,10221019,10222019,10222033,10222034,10223019,10223033,10223034,10300004,10300006,
	10301000,10301198,10302004,10302006,10302008,10302010,10303000,10304004,10304006,10304008,
	10305004,10305006,10305008,10410025,10410033,10510017,10510047,10510077,10511007,10511037,
	10511067,10512017,10512047,10512077,10514007,10514017,10514037,10514047,10514067,10514077,
	10515027,10515057,10515087,10520027,10520057,10520087,10521007,10521017,10521027,10521037,
	10521047,10521057,10521067,10521077,10521087,10522007,10522037,10522067,10523017,10523047,
	10523077,10552027,10552057,10552087,10553007,10553027,10553037,10553057,10553067,10553087,
	10400075,10402075,10404072,10405071,10412081,10412083,10413084,10413086,10422122,10422124,
	10423047,10423049,10510092,10510093,10510094,10510095,10511094,10511095,10512090,10512091,
	10514101,10514102,10514103,10514104,10522099,10522100,10523099,10523100,
	10306004,10306006,10306008,--新门派曼陀神器
	10206022,10206023,10206024,
}
local x311200_Stiletto_four_ID = {
																	
																	10514091,10514092,10514093,10514094,10514095,10514096,10514097,10514098,10515090,10515091,
																	10515092,10515093,10515094,10515095,10515096,10515097,10515098,10521090,10521091,10521092,
																	10521093,10521094,10521095,10521096,10521097,10521098,10522090,10522091,10522092,10522093,
																	10522094,10522095,10522096,10522097,10522098,10523090,10523091,10523092,10523093,10523094,
																	10523095,10523096,10523097,10523098,10514090,
																	-- 褚少微，2008.6.12。添加102神器极限打孔
																	10300100,10300101,10300102, 10301100,10301101,10301102, 10301200,10301201,10301202, 
																	10302100,10302101,10302102, 10303100,10303101,10303102, 10303200,10303201,10303202,
																	10304100,10304101,10304102, 10305100,10305101,10305102, 10305200,10305201,10305202,
																	10422016,10423024,10422149,	10422150,
																	--胡凯，2008.8.29。旧100套（五件套）及新96套开放极限打孔
																	10510009,10510019,10510029,10510039,10510049,10510059,10510069,10510079,10510089,10511009,
																	10511019,10511029,10511039,10511049,10511059,10511069,10511079,10511089,10512009,10512019,
																	10512029,10512039,10512049,10512059,10512069,10512079,10512089,10513009,10513019,10513029,
																	10513039,10513049,10513059,10513069,10513079,10513089,10511096,10512092,10520092,10522101,
																	10523101,10511097,10512093,10520093,10522102,10523102,10511098,10512094,10520094,10522103,
																	10523103,10511099,10512095,10520095,10522104,10523104,
																	--胡凯，2008.9.18。90级以上（含90）生活技能产出的戒指，护符，肩开放极限打孔
																	10215020,10222020,10223020,10222035,10222036,10223035,10223036,
																	--胡凯，2008.11.11。90级以上（含90）手工装备开放极限打孔（鞋，腰带，护腕，手套，头盔，武器，护甲，项链）
																	10200019,10200020,10201019,10201020,10202019,10202020,10203019,10203020,10204019,10204020,
																	10205019,10205020,10210020,10210040,10210060,10213020,10213040,10213060,10212020,10212040,
																	10212060,10211020,10211040,10211060,10214020,10221020,10220020,
																	--zchw，2008-11-17  TT：41140 90门派套，92级神器开放第四孔
																	10510008,10510038,10510068,
																	10511018,10511028,10511048,10511058,10511078,10511088,10512008,10512038,
																	10512068,10513008,10513018,10513028,10513038,10513048,10513058,10513068,
																	10513078,10513088,10514028,10514058,10514088,10520018,10520028,10520048,
																	10520058,10520078,10520088,10521028,10521058,10521088,10522018,10522048,
																	10522078,10552008,10552038,10552068,10553008,10553018,10553038,10553048,
																	10553068,10553078,
																	--zchw 2008-11-26 TT：41771
																	10410026, 10410027, 10410034, 10410035, 10423025, 10423026,
																	--houzhifang 2008-12-22: dark
																	10150001,10150002,
																	10300005,10302005,10304005,10305005, 
																	--likun 2009-8-18
																	10300103,10300104,10300105,10300106,10300107,10300108,10300109,10300110,10300111,10301103,
																	10301104,10301105,10301106,10301107,10301108,10301109,10301110,10301111,10301203,10301204,
																	10301205,10301206,10301207,10301208,10301209,10301210,10301211,10302103,10302104,10302105,
																	10302106,10302107,10302108,10302109,10302110,10302111,10303103,10303104,10303105,10303106,
																	10303107,10303108,10303109,10303110,10303111,10303203,10303204,10303205,10303206,10303207,
																	10303208,10303209,10303210,10303211,10304103,10304104,10304105,10304106,10304107,10304108,
																	10304109,10304110,10304111,10305103,10305104,10305105,10305106,10305107,10305108,10305109,
																	10305110,10305111,10305203,10305204,10305205,10305206,10305207,10305208,10305209,10305210,
																	10305211,
									--likun 2009-8-26
									10300007,	--赤焰九纹刀	96
									10301001,	--斩忧断愁枪	96
									10301199,	--弈天破邪杖	96
									10302007,	--含光弄影剑	96
									10302009,	--万仞龙渊剑	96
									10303001,	--转魂灭魄钩	96
									10304007,	--雷鸣离火扇	96
									10304009,	--雷鸣离火扇	96
									10305007,	--碎情雾影环	96
									10305009,	--天星耀阳环	96
									--zhanglei 2009-9-4
									10156001, --武魂：琉璃焰
									10156002, --武魂：御瑶盘
									--绑定武魂
									10156003,
									10156004,
									--以下为姑苏新装备
									10510118,	10510119,	10511119,	10512118,	10512119,	10513118,10513119,	
                  10514109, 10515109, 10521109,	10522109,	10523109, 10552118,10553118,
                   --慕容神器
                  10302011,10302200,10302201,10302202,10302203,10302204,10302205,
									10302206,10302207,10302208,10302209,10302210,10302211,
									--新门派曼陀神器
									10306005,10306007,10306009,
									10306100,10306101,10306102,
									10306103,10306104,10306105,10306106,10306107,10306108,10306109,10306110,10306111,
									
									10510120,10512120,10514126,10521121,10523121,10511122,10513120,10520121,
									10522122,10523122,10510121,10511123,10512121,10513121,10514105,10515101,10521103,
									10522105,10523105,	
									}




local g_Object = -1;

function Stiletto_Four_PreLoad()

	this:RegisterEvent("UPDATE_STILETTO_FOUR");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("RESUME_ENCHASE_GEM");
	

end

function Stiletto_Four_OnLoad()
	EQUIP_BUTTONS = Stiletto_Four_Item
	MATERIAL_BUTTONS = Stiletto_Four_Material
end

function Stiletto_Four_OnEvent(event)

	--PushDebugMessage(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 75117) then
	
			local xx = Get_XParam_INT(0);
			local thistype = Get_XParam_INT(1);
			
			if thistype ~= STILE_TYPE then
				Stiletto_Four_Clear()
			end
			STILE_TYPE = thistype
			
			this:Show();

			if STILE_TYPE == 1 then
				Stiletto_Four_Explain1: SetText("#{INTERFACE_XML_JX_07}")
				Stiletto_Four_Explain3: SetText("#{INTERFACE_XML_1162}")
			else
				Stiletto_Four_Explain1: SetText("#{JXDK_080827_1}")
				Stiletto_Four_Explain3: SetText("#{INTERFACE_XML_1163}")
			end
			
			objCared = DataPool : GetNPCIDByServerID(xx);
			AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
			if objCared == -1 then
                    --去掉此行，因为此种信息不适合显示在客户端  
					--PushDebugMessage("server传过来的数据有问题。");
					return;
			end
			BeginCareObject_Stiletto_Four(objCared)
			
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 091016141) then	 --打孔失败后装备仍然保留在界面中  fsy 09/10/16 #57883
			local idBagPos = Get_XParam_INT(0);
			Stiletto_Update(1,idBagPos);
			Resume_Equip_Stiletto_Four(2);
						
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--取消关心
			Stiletto_Four_Cancel_Clicked()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		
		if (EQUIP_QUALITY == tonumber(arg0) ) then
			Stiletto_Four_Clear()
			Stiletto_Four_Update(1,tonumber(arg0))
		end
			
		if (MATERIAL_QUALITY == tonumber(arg0) ) then
			Stiletto_Four_Clear()
			Stiletto_Four_Update(2,tonumber(arg0))
		end
	
		
	elseif ( event == "RESUME_Stiletto_Four_EQUIP" ) then
		Resume_Equip()
	elseif( event == "UPDATE_STILETTO_FOUR") then
		AxTrace(0,1,"arg0="..arg0)
		if arg0 == nil or arg1 == nil then
			return
		end

		Stiletto_Four_Update(tonumber(arg0),tonumber(arg1));		

	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 13) then
			Resume_Equip_Stiletto_Four(1);
		elseif(arg0~=nil and tonumber(arg0) == 53) then
			Resume_Equip_Stiletto_Four(2);
		end
		
	end
end

function Stiletto_Four_OnShown()
	Stiletto_Four_Clear()
end

function Stiletto_Four_Clear()
	if(EQUIP_QUALITY ~= -1) then
		EQUIP_BUTTONS : SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		EQUIP_QUALITY = -1;
	end
	
--	Stiletto_Four_Material_Bak : SetProperty("Image", "set:CommonItem image:ActionBK"); 
--	Stiletto_Four_Material_Bak	: SetToolTip("")
	if(MATERIAL_QUALITY ~= -1) then
		MATERIAL_BUTTONS : SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
		MATERIAL_QUALITY = -1;
	end
	Stiletto_Four_Money : SetProperty("MoneyNumber", "");
	Stiletto_Four_State: SetText("")
	LifeAbility : ClearSlotFour()
end

function Stiletto_Four_Update(pos1,pos0)
	local pos_packet,pos_ui;
	pos_packet = tonumber(pos0);
	pos_ui		 = tonumber(pos1)

	local theAction = EnumAction(pos_packet, "packageitem");
	if pos_ui == 1 then  --放入物品时
		if theAction:GetID() ~= 0 then
			
			local Bore_Count1 = 0;
		  local Need_Item1 = -1;
		  local Need_Money1 = 0;
		  local Need_Item_Count1 =0;
		  
			--Need_Item,Need_Money,Need_Item_Count,Bore_Count=LifeAbility : Stiletto_Preparation(pos_packet);
			Need_Item1,Need_Money1,Need_Item_Count1,Bore_Count1=LifeAbility : Stiletto_Preparation(pos_packet, STILE_TYPE);
					
			if Need_Item1 == 0 then
				return
			end

			local taozhuangid = PlayerPackage : GetItemTableIndex( pos_packet )
			local istaozhuang = 0		  
		
					
		  for i, v in x311200_Stiletto_four_ID do
		    if taozhuangid == v then
			    istaozhuang = 1;
			    break
		    end
	    end
			for i = 1, table.getn(x311200_Stiletto_four_80_ID) do
				if taozhuangid == x311200_Stiletto_four_80_ID[i] then
					istaozhuang = 1
				end
			end
	    
	    if(PlayerPackage:IsBagItemDark(pos_packet) == 1) then
	    	istaozhuang = 1;
	    end
	    
	    if(PlayerPackage:IsIdentityStilettoEquip(taozhuangid) == 1) then
	    	istaozhuang = 1
	    end
	    
	    if istaozhuang == 0 then
	    	PushDebugMessage("#{XQC_20080509_02}")
				return
	    end
	    
			if Bore_Count1 < 3 then --add:lby 20080523
				PushDebugMessage("#{XQC_20080509_03}")
				return
			end
			
			if Bore_Count1 > 3 then --add:lby 20080523
				PushDebugMessage("#{XQC_20080509_04}")
				return
			end
							
							
			if Need_Item1 < -1 then
				PushDebugMessage("#{XQC_20080509_01}")
				return
			end
				
			Need_Item = Need_Item1
			Need_Money = Need_Money1 
			Need_Item_Count = Need_Item_Count1
			Bore_Count = Bore_Count1
				
			--让之前的东西变亮
			if EQUIP_QUALITY ~= -1 then
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
				Stiletto_Four_Money : SetProperty("MoneyNumber", "");
				Stiletto_Four_State: SetText("")
			end

			EQUIP_BUTTONS:SetActionItem(theAction:GetID());
			EQUIP_QUALITY = pos_packet;
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,1);
		else
			EQUIP_BUTTONS:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			EQUIP_QUALITY = -1;
			Stiletto_Four_Money : SetProperty("MoneyNumber", "");
			Stiletto_Four_State: SetText("")
			return;
		end
		Stiletto_Four_Money : SetProperty("MoneyNumber", tostring(Need_Money));
		Stiletto_Four_State : SetText("当前凹槽数:"..Bore_Count..";可以增加凹槽数:"..tostring(4-Bore_Count))
		
	elseif pos_ui == 2 then --点金之煎或寒玉精粹
		
		--local Item_Class = PlayerPackage : GetItemSubTableIndex(pos_packet,0)
	--	local Item_Quality = PlayerPackage : GetItemSubTableIndex(pos_packet,1)
		--local Item_Type = PlayerPackage : GetItemSubTableIndex(pos_packet,2)
		
	

		--if Item_Class ~= 2 or Item_Quality ~= 1 or Item_Type ~= 9 then
		--	return
		--end
		
		if theAction:GetID() ~= 0 then
			
			local itemindex = PlayerPackage : GetItemTableIndex(pos_packet)
						
			if STILE_TYPE == 1 then
				if itemindex ~= 20109101 then  --add:lby 20080523只能放入点金之箭
	 				PushDebugMessage("#{XQC_20080509_05}")
	 				return
	  		end
			elseif STILE_TYPE == 2 then
				if itemindex ~= 20310111 then  --add:hukai 只能放入寒玉精粹
	 				PushDebugMessage("#{JCDK_80905_05}")
	 				return
	  		end
			else
				PushDebugMessage("错误的消耗类型。"..STILE_TYPE)
	 			return
			end
	  
			MATERIAL_BUTTONS:SetActionItem(theAction:GetID());
			if MATERIAL_QUALITY ~= -1 then
				LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
			end
			--让之前的东西变亮
			MATERIAL_QUALITY = pos_packet;
			LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,1);
		else
			MATERIAL_BUTTONS:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
			MATERIAL_QUALITY = -1;
			return;
		end	
	end
	
end

function Stiletto_Four_Buttons_Clicked()
	if MATERIAL_QUALITY == -1 then
		PushDebugMessage("请放入打孔材料")
		return
	end
	if EQUIP_QUALITY ~= -1 then
		if Need_Item == -2 then
			if STILE_TYPE == 1 then
				PushDebugMessage("#{XQC_20080509_07}")
			else
				PushDebugMessage("#{JCDK_80905_07}")
			end
		elseif Need_Item == -3 then
			PushDebugMessage("#{XQC_20080509_04}")

		elseif Player:GetData("MONEY")+Player:GetData("MONEY_JZ") < Need_Money then
			if STILE_TYPE == 1 then
				PushDebugMessage("#{XQC_20080509_08}")
			else
				PushDebugMessage("#{JCDK_80905_08}")
			end
		else
			-- 不能使用绑定材料对重楼戒和重楼玉进行打孔
			local equipTableIndex = PlayerPackage : GetItemTableIndex( EQUIP_QUALITY )
			if(equipTableIndex == 10422016 or equipTableIndex == 10423024) then
				if(GetItemBindStatus(EQUIP_QUALITY) == 0 and GetItemBindStatus(MATERIAL_QUALITY) == 1) then		
					-- 装备不绑定，材料是绑定的
					ShowSystemInfo("CLBD_091211_7");
					return		
				end
			end

			if LifeAbility : Is_SlotFour(EQUIP_QUALITY,MATERIAL_QUALITY,STILE_TYPE) == 1 then
				Clear_XSCRIPT();
					Set_XSCRIPT_Function_Name("OnStiletto_Four");
					Set_XSCRIPT_ScriptID(311200);
					Set_XSCRIPT_Parameter(0,EQUIP_QUALITY);
					Set_XSCRIPT_Parameter(1,MATERIAL_QUALITY);
					Set_XSCRIPT_Parameter(2,STILE_TYPE);
					Set_XSCRIPT_ParamCount(3);
				Send_XSCRIPT();
			end
		end
	else
		PushDebugMessage("#{XQC_20080509_06}")
	end
	
end

function Stiletto_Four_Close()
	--并设置，让背包里的位置变亮
	this:Hide();
	Stiletto_Four_Clear();
	StopCareObject_Stiletto_Four(objCared)
end

function Stiletto_Four_Cancel_Clicked()
	Stiletto_Four_Close();
	return;
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_Stiletto_Four(objCaredId)

	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "Stiletto_Four");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_Stiletto_Four(objCaredId)
	this:CareObject(objCaredId, 0, "Stiletto_Four");
	g_Object = -1;

end

function Resume_Equip_Stiletto_Four(nIndex)

	if( this:IsVisible() ) then
	
		if(nIndex == 1) then
			if(EQUIP_QUALITY ~= -1) then
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
				EQUIP_BUTTONS : SetActionItem(-1);
				EQUIP_QUALITY	= -1;
				Stiletto_Four_Money : SetProperty("MoneyNumber", "");
				Stiletto_Four_State: SetText("")
			end
		else
			if(MATERIAL_QUALITY ~= -1) then
				LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
				MATERIAL_BUTTONS : SetActionItem(-1);
				MATERIAL_QUALITY	= -1;
			end	
		end
		
	end
	
end
