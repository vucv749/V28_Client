local g_Talent_Preview_Frame_UnifiedPosition = nil 
local g_Talent_Preview_Item = {}
local g_Talent_Preview_UI = {}
local g_Talent_Preview_Line = {}
local g_Talent_Preview_StudyTree = {}	--存当前流派需要有前置天赋的数据

local g_Talent_preview_menpai = -1
local g_Talent_preview_secttype = -1
local g_Talent_preview_targetid = -1
local g_Talent_preview_Schema = nil
local g_Talent_preview_subSchema = nil
local g_Talent_Preview_curFenye = 1
local g_Talent_Preview_Info =
{
	[0] =
	{
		[1] = {instrct = "#{TalentSL_20210804_02}",icon="set:Talent image:Talent_SLLH"},
		[2] = {instrct = "#{TalentSL_20210804_04}",icon="set:Talent image:Talent_SLJG"}
	},
	[1] =
	{
		[1] = {instrct = "#{TalentMJ_20210804_02}",icon="set:Talent image:Talent_MJTL"},
		[2] = {instrct = "#{TalentMJ_20210804_04}",icon="set:Talent image:Talent_MJXL"}
	},	

	[2] =
	{
		[1] = {instrct = "#{TalentGB_20210804_02}",icon="set:Talent image:Talent_GBJK"},
		[2] = {instrct = "#{TalentGB_20210804_04}",icon="set:Talent image:Talent_GBXX"}
	},
	[3] =
	{
		[1] = {instrct = "#{TalentWD_20210804_02}",icon="set:Talent2 image:Talent_WDPX"},
		[2] = {instrct = "#{TalentWD_20210804_04}",icon="set:Talent2 image:Talent_WDZX"}
	},
	[4] =
	{
		[1] = {instrct = "#{TalentEM_20210804_02}",icon="set:Talent image:Talent_EMQF"},
		[2] = {instrct = "#{TalentEM_20210804_04}",icon="set:Talent image:Talent_EMQY"}
	},
	[5] =
	{
		[1] = {instrct = "#{TalentXX_20210804_02}",icon="set:Talent2 image:Talent_XXHM"},
		[2] = {instrct = "#{TalentXX_20210804_04}",icon="set:Talent2 image:Talent_XXJE"}
	},
	[6] =
	{
		[1] = {instrct = "#{TalentTL_20210804_02}",icon="set:Talent image:Talent_TLLW"},
		[2] = {instrct = "#{TalentTL_20210804_04}",icon="set:Talent image:Talent_TLPT"}
	},
	[7] =
	{
		[1] = {instrct = "#{TalentTS_20210804_02}",icon="set:Talent2 image:Talent_TSNS"},
		[2] = {instrct = "#{TalentTS_20210804_04}",icon="set:Talent2 image:Talent_TSXY"}
	},
	[8] =
	{
		[1] = {instrct = "#{TalentXY_20210804_02}",icon="set:Talent2 image:Talent_XYYX"},
		[2] = {instrct = "#{TalentXY_20210804_04}",icon="set:Talent2 image:Talent_XYMG"}
	},
	[10] =
	{
		[1] = {instrct = "#{TalentMT_20220621_04}",icon="set:Talent2 image:Talent_MTWL"},
		[2] = {instrct = "#{TalentMT_20220621_05}",icon="set:Talent2 image:Talent_MTZM"}
	},
	[11] =--MPTODO menpai11
	{
		[1] = {instrct = "#{TalentER_20240802_04}",icon="set:Talent3 image:Talent_ERGSH"},
		[2] = {instrct = "#{TalentER_20240802_05}",icon="set:Talent3 image:Talent_ERGPM"}
	},


}

function Talent_Preview_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("SECT_OPPOSITE",false)
end 

-- Talent_Preview_Close => TLBB_ButtonClose
-- Talent_Preview_Frame_Client => DefaultWindow
-- Talent_Preview_DragTitle => TLBB_DragTitle
-- Talent_Preview_Help => TLBB_ButtonHelp
function Talent_Preview_OnLoad()
	g_Talent_Preview_Frame_UnifiedPosition = Talent_Preview_Frame:GetProperty("UnifiedPosition");

	for i =1, 12 do

		local icon = _G["Talent_Preview_Skill"..i.."Icon"]
		local name = _G["Talent_Preview_Skill"..i.."Name"]

		local all = _G["Talent_Preview_Skill"..i.."Btn"]
		g_Talent_Preview_Item[i] = {icon=icon,name=name,all=all}

	end

	for i=1,9 do
		local light = _G["Talent_Preview_Line"..i.."_2"]
		local dark  = _G["Talent_Preview_Line"..i]

		g_Talent_Preview_Line[i] = { light = light, dark = dark}

	end





	g_Talent_Preview_UI[1] = {icon = Talent_Preview_SkillIcon, name = Talent_Preview_SkillName}
	g_Talent_Preview_UI[2] = {[1] = g_Talent_Preview_Item[1], [2] = g_Talent_Preview_Item[2],[3] = g_Talent_Preview_Item[3]}
	g_Talent_Preview_UI[3] = {[1] = g_Talent_Preview_Item[4], [2] = g_Talent_Preview_Item[5],[3] = g_Talent_Preview_Item[6]}
	g_Talent_Preview_UI[4] = {[1] = g_Talent_Preview_Item[7], [2] = g_Talent_Preview_Item[8],[3] = g_Talent_Preview_Item[9]}
	g_Talent_Preview_UI[5] = {[1] = g_Talent_Preview_Item[10], [2] = g_Talent_Preview_Item[11],[3]=g_Talent_Preview_Item[12]}


end

function Talent_Preview_MakeSubSchema(page)

	local pagelist = 
	{
		[1] = {1,2,3,4,5},
		[2] = {1,6,7,8,9},
		[3] = {1,10,11,12,13},
		[4] = {1,14,15,16,17},
	}
	g_Talent_preview_subSchema = {}

	for i=1,5 do
		table.insert(g_Talent_preview_subSchema,i,g_Talent_preview_Schema.info[pagelist[page][i]])
	end
end


--处理连线
function Talent_Preview_Getline(p1,p2)

	p1 = tonumber(p1)
	p2 = tonumber(p2)
	--lua的二维数组不是很好用
	local list = { 
			[1] = {[4] = 1, [5] = 2},
			[3] = {[5] = 9, [6] = 3},
			[6] = {[9] = 8, [12] = 6},
			[7] = {[10] = 4, [11] = 5},
			[9]= {[12] = 7}}


	if list[p1]~= nil and list[p1][p2] ~= nil then
		return list[p1][p2]
	end
	return -1


end
function Talent_Preview_produceline()
	local coverpos = function(info)
		if info then
			return (info.layer-2)*3+info.col   --(i-2)*3+vi
		end
		return -1
	end
	--local linelist = g_Talent_Studyup_Info[menpai][secttype].line
	for i,v in ipairs(g_Talent_Preview_Line) do

		v.light:Hide()
		v.dark:Hide()
	end

	local linelist = {}

	for i,v in pairs(g_Talent_Preview_StudyTree) do
		local lineid = Talent_Preview_Getline(coverpos(g_Talent_Preview_poslist[v]),coverpos(g_Talent_Preview_poslist[i]))
		if lineid > 0 then
			table.insert(linelist,lineid)
		end
	end
	for j,vj in pairs(linelist) do
		g_Talent_Preview_Line[vj].dark:Show()		
	end	
end
--处理连线end


function Talent_Preview_OnEvent(event)

	if(event == "ADJEST_UI_POS") then
		Talent_Preview_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		Talent_Preview_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		Talent_Preview_On_Hide()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 20210801 then
		local menpai = Get_XParam_INT(0);
		local secttype = Get_XParam_INT(1);
		local targetobjId = Get_XParam_INT(2);
		g_Talent_preview_targetid = targetobjId
		g_Talent_preview_menpai = menpai
		g_Talent_preview_secttype = secttype
		Talent_Preview_InitSchema(menpai,secttype)
		Talent_Preview_MakeSubSchema(1)
		Talent_Preview_SetFenYe(1)
		Talent_Preview_Update()
		Talent_Preview_BeginCareObject(targetobjId)
		PushEvent("SECT_OPPOSITE",2)
		this:Show()
	elseif event == "SECT_OPPOSITE" then
		if tonumber(arg0) ~= 2 then
			this:Hide()
		end
	end
end

function Talent_Preview_Update()
	Talent_Preview_InitSect(g_Talent_preview_menpai,g_Talent_preview_secttype)
	Talent_Preview_produceline()
	Talent_Preview_SkillTreeClicked(1,1)
end

function Talent_Preview_InitSchema(menpai,secttype)
	--调用
	g_Talent_preview_Schema = DataPool:Lua_GetSectSchema(menpai,secttype-1) 

end

function Talent_Preview_SetFenYe(page)
	local fenyetable = {Talent_Preview_Advance,Talent_Preview_Advance2,Talent_Preview_Advance3,Talent_Preview_Advance4}
	for i , v in ipairs(fenyetable) do
		if i == page then
			v:SetCheck(1)
		else
			v:SetCheck(0)
		end
	end
end

function Talent_Preview_ChangeFenye(page)
	Talent_Preview_SetFenYe(page)
	Talent_Preview_MakeSubSchema(page)
	g_Talent_Preview_curFenye = page

	Talent_Preview_Update()
end

function Talent_Preview_InitSect(menpai,secttype)

	Talent_Preview_SkillTree_UpPage:Disable()
	Talent_Preview_SkillTree_DownPage:Disable()
	if secttype == 1 then
		Talent_Preview_SkillTree_LiupaiChange:SetCheck(1)
	elseif secttype == 2 then
		Talent_Preview_SkillTree_LiupaiChange2:SetCheck(1)
	end

	local SetSectcube = function(info,state)
		if state == 0 then
			info.all:Hide()
		else
			info.all:Show()
		end
	end

	local SetButtonStr = function(button,index)
		local sectname = DataPool:Lua_GetSectName(menpai,index)
		local str = ScriptGlobal_Format("#{TalentMP_20210804_68}",sectname)
		button:SetText(str)
	end


	local listTT = g_Talent_Preview_Info[menpai][secttype]

	local sectname = DataPool:Lua_GetSectName(menpai,secttype-1)
	Talent_Preview_SkillTree_LiuPaiName:SetText(sectname)
	Talent_Preview_SkillTree_LiuPaiDetails:SetText(listTT.instrct)
	Talent_Preview_SkillTree_LiuPaiIcon:SetProperty( "Image", listTT.icon )
	SetButtonStr(Talent_Preview_SkillTree_LiupaiChange,0)
	SetButtonStr(Talent_Preview_SkillTree_LiupaiChange2,1)





	g_Talent_Preview_StudyTree = {}
	g_Talent_Preview_poslist = {}
	for i,v in ipairs(g_Talent_preview_subSchema) do
		for vi,vv in ipairs(v) do
			--PushDebugMessage("vv="..vv)

			local infodetail;
			local action = nil

			if vv >= 0 then
				infodetail = DataPool:TBSearch_Index_EQU("DBC_SECT_INFO",vv)	
				action = DataPool:Lua_CreateSectInfoAction(vv,infodetail.maxlevel);

				--把他的前置条件存一下
				if infodetail.limittype > 0 then
					table.insert(g_Talent_Preview_StudyTree,vv,infodetail.limittype)
				end
				table.insert(g_Talent_Preview_poslist,vv,{layer = i,col = vi})

			end
			if i == 1 then
				--第一层数据少
				if action then
					g_Talent_Preview_UI[i].icon:SetActionItem(action:GetID());
					g_Talent_Preview_UI[i].name:SetText(infodetail.szName)
				end

			else
				local uidata = g_Talent_Preview_UI[i][vi];
				if vv < 0 then
					SetSectcube(uidata,0)
				else
					SetSectcube(uidata,1)
					uidata.all:SetCheck(0)
					if(action) then
						uidata.icon:SetActionItem(action:GetID());
					end
					uidata.name:SetText(infodetail.szName);


				end

			end
		end
		
	end

	

end




function Talent_Preview_BeginCareObject(objid)
	local nID = DataPool : GetNPCIDByServerID( objid )
	this:CareObject(nID, 1, "Talent_Preview");
end

function Talent_Preview_On_ResetPos()
	Talent_Preview_Frame:SetProperty("UnifiedPosition", g_Talent_Preview_Frame_UnifiedPosition)
end

function Talent_Preview_On_Hide()
	this:Hide()
end



function Talent_Preview_Help_Click()
end

function Talent_Preview_DetailShow(bshow)
	if bshow == 0 then
		Talent_Preview_Details:Show()
		Talent_Preview_Skillup:Hide()
	else
		Talent_Preview_Details:Hide()
		Talent_Preview_Skillup:Show()
	end
end


function Talent_Preview_SkillTreeClicked(layer,col)
	--他们要是扩了layer记得加上个偏移

	local id = g_Talent_preview_subSchema[layer][col];
	local color = "#cFFF263"
	if layer == 1 then
		local infodesc = DataPool:TBSearch_Index_EQU("DBC_SECT_DESC",id)
		local info = DataPool:TBSearch_Index_EQU("DBC_SECT_INFO",id)
		local action = DataPool:Lua_CreateSectInfoAction(id,1);
		Talent_Preview_DetailShow(0)

		Talent_Preview_DetailsName:SetText(info.szName)
		
		Talent_Preview_Skillup_DetailsText:SetText(color..DataPool:Lua_GetSectDesc(id,0))
		Talent_Preview_SkillBtn:SetCheck(1)



	else
		g_Talent_Preview_UI[layer][col].all:SetCheck(1)
		local infodesc = DataPool:TBSearch_Index_EQU("DBC_SECT_DESC",id)
		local info = DataPool:TBSearch_Index_EQU("DBC_SECT_INFO",id)
		local action = DataPool:Lua_CreateSectInfoAction(id,info.maxlevel);
		Talent_Preview_DetailShow(1)
		Talent_Preview_SkillupName:SetText(info.szName)


		local str = ScriptGlobal_Format("#{TalentMP_20210804_69}",info.maxlevel)
		Talent_Preview_Skilluplevel:SetText(str)
		local strlayer = ScriptGlobal_Format("#{TalentMP_20210804_16}",infodesc.szJingjie)
		Talent_Preview_SkilluplevelRealm:SetText(strlayer)



		local str = ScriptGlobal_Format("#{TalentMP_20210804_15}",info.maxlevel,info.maxlevel)
		Talent_Preview_Skilluplevel:SetText(str)
		local strlayer = ScriptGlobal_Format("#{TalentMP_20210804_16}",infodesc.szJingjie)
		Talent_Preview_SkilluplevelRealm:SetText(strlayer)

		Talent_Preview_Skillup_Explain1:SetText(color..DataPool:Lua_GetSectDesc(id,info.maxlevel-1))


	
	end
end

function Talent_Preview_Close()
	this:Hide()
end


function Talent_Preview_SkillTree_LiupaiChange_Clicked(index)

	if index == g_Talent_preview_secttype then
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ShowPreview" )
		Set_XSCRIPT_ScriptID(292000)
		Set_XSCRIPT_Parameter( 0, g_Talent_preview_targetid )
		Set_XSCRIPT_Parameter( 1, index )
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()		


end