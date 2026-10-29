AzerothCursor = { version = "1.0.0" }
local A = AzerothCursor
A.colors = {
 {"Cyan", 0, 1, 1}, {"Magenta", 1, .12, .85}, {"Lime", .45, 1, .05},
 {"Gold", 1, .8, .05}, {"White", 1, 1, 1}, {"Orange", 1, .35, .02},
 {"Red", 1, .08, .08}, {"Blue", .25, .5, 1}
}
A.defaults = { enabled=false, size=64, thickness=2, opacity=100, halo=45,
 crosshair=24, dot=5, pulse=false, color=1, language="fr" }
local limits = {size={24,160}, thickness={1,3}, opacity={20,100}, halo={0,100},
 crosshair={0,100}, dot={0,24}, color={1,8}}
function A.Number(v, fallback)
 if type(v)~="number" and type(v)~="string" then return fallback end
 local n=tonumber(v)
 if not n or n~=n or n>1e100 or n< -1e100 then return fallback end
 return n
end
function A.InitDB()
 local old=type(AzerothCursorDB)=="table" and AzerothCursorDB or {}
 local db={}
 for k,v in pairs(A.defaults) do
  local n=old[k]
  if limits[k] then
   local range=limits[k]
   db[k]=math.floor(math.max(range[1],math.min(range[2],A.Number(n,v)))+.5)
  elseif type(v)=="boolean" then
   if type(n)=="boolean" then db[k]=n else db[k]=v end
  elseif k=="language" then db[k]=n=="en" and "en" or "fr" end
 end
 if type(old.rgb)=="table" then
  local r,g,b=A.Number(old.rgb[1]),A.Number(old.rgb[2]),A.Number(old.rgb[3])
  if r and g and b then db.rgb={math.max(0,math.min(1,r)),math.max(0,math.min(1,g)),math.max(0,math.min(1,b))} end
 end
 -- The first beta enabled its overlay automatically. Upgrade once to native-only,
 -- keeping the user's appearance settings for when they explicitly enable it.
 if old.schema~=2 then db.enabled=false end
 db.schema=2
 db.minimapAngle=math.mod(A.Number(old.minimapAngle,245),360)
 AzerothCursorDB=db;A.db=db
end
function A.Color()
 if A.db.rgb then return unpack(A.db.rgb) end
 local c=A.colors[A.db.color];return c[2],c[3],c[4]
end
local function Texture(parent,asset,layer)
 local t=parent:CreateTexture(nil,layer or "OVERLAY")
 t:SetTexture("Interface\\AddOns\\AzerothCursor\\Media\\"..asset..".tga")
 t:SetPoint("CENTER",parent,"CENTER",0,0)
 return t
end
function A.CreateVisual(name,parent)
 local f=CreateFrame("Frame",name,parent or UIParent)
 f:SetWidth(1);f:SetHeight(1);f:EnableMouse(false)
 f.halo=Texture(f,"Halo","BACKGROUND")
 f.outline=Texture(f,"Outline2","BORDER")
 f.ring=Texture(f,"Ring2","ARTWORK")
 f.crossOutline=Texture(f,"CrossOutline","ARTWORK")
 f.cross=Texture(f,"Cross","OVERLAY")
 f.dotOutline=Texture(f,"DotOutline","OVERLAY")
 f.dot=Texture(f,"Dot","OVERLAY")
 f.beacon=Texture(f,"Ring3","OVERLAY");f.beacon:Hide()
 return f
end
local function Size(t,n) t:SetWidth(n);t:SetHeight(n) end
function A.Style(f)
 local db=A.db;local r,g,b=A.Color()
 Size(f.ring,db.size);Size(f.outline,db.size);Size(f.halo,db.size*1.8)
 f.ring:SetTexture("Interface\\AddOns\\AzerothCursor\\Media\\Ring"..db.thickness..".tga")
 f.outline:SetTexture("Interface\\AddOns\\AzerothCursor\\Media\\Outline"..db.thickness..".tga")
 f.ring:SetVertexColor(r,g,b,db.opacity/100)
 f.outline:SetVertexColor(0,0,0,db.opacity/100)
 f.halo:SetVertexColor(r,g,b,db.halo/100)
 -- A transparent central gap keeps the exact click point and native pointer readable.
 Size(f.cross,db.crosshair*2+16);Size(f.crossOutline,db.crosshair*2+16)
 f.cross:SetVertexColor(r,g,b,db.opacity/100);f.crossOutline:SetVertexColor(0,0,0,db.opacity/100)
 if db.crosshair>0 then f.cross:Show();f.crossOutline:Show() else f.cross:Hide();f.crossOutline:Hide() end
 Size(f.dot,math.max(1,db.dot*2));Size(f.dotOutline,math.max(1,db.dot*2))
 f.dot:SetVertexColor(r,g,b,db.opacity/100);f.dotOutline:SetVertexColor(0,0,0,db.opacity/100)
 if db.dot>0 then f.dot:Show();f.dotOutline:Show() else f.dot:Hide();f.dotOutline:Hide() end
end
function A.Apply()
 if not A.visual then return end
 A.Style(A.visual)
 if A.preview then A.Style(A.preview) end
 if not A.db.enabled then A.visual:Hide();A.findRemaining=0 end
 if A.RefreshOptions then A.RefreshOptions() end
end
function A.Preset(name)
 if name=="native" then A.db.enabled=false;A.Apply();return end
 local presets={
  balanced={64,2,100,45,24,5,false,1},
  raid={96,3,100,65,40,6,false,2},
  minimal={40,1,100,0,0,3,false,3}
 }
 local p=presets[name];if not p then return end
 local keys={"size","thickness","opacity","halo","crosshair","dot","pulse","color"}
 for i=1,table.getn(keys) do A.db[keys[i]]=p[i] end
 A.db.rgb=nil;A.db.enabled=true;A.Apply()
end
function A.Find()
 A.db.enabled=true;A.findRemaining=1.2;A.Apply()
end
function A.Update(dt)
 dt=math.max(0,A.Number(dt,0));A.time=(A.time or 0)+dt
 A.findRemaining=math.max(0,(A.findRemaining or 0)-dt)
 local f=A.visual
 if not A.db.enabled or not GetCursorPosition or (IsMouselooking and IsMouselooking()) then f:Hide();return end
 local x,y=GetCursorPosition()
 if type(x)~="number" or type(y)~="number" then f:Hide();return end
 local scale=UIParent:GetEffectiveScale() or 1
 if scale<=0 then f:Hide();return end
 x=x/scale;y=y/scale
 if x<0 or y<0 or x>UIParent:GetWidth() or y>UIParent:GetHeight() then f:Hide();return end
 if x~=A.lastX or y~=A.lastY or scale~=A.lastScale then
  f:ClearAllPoints();f:SetPoint("CENTER",UIParent,"BOTTOMLEFT",x,y)
  A.lastX=x;A.lastY=y;A.lastScale=scale
 end
 f:Show()
 if A.db.pulse then f.halo:SetAlpha(.72+.28*math.sin(A.time*4)) else f.halo:SetAlpha(1) end
 if A.findRemaining>0 then
  local progress=1-A.findRemaining/1.2
  Size(f.beacon,A.db.size+180*(1-progress))
  f.beacon:SetVertexColor(1,1,1,1-progress*.7);f.beacon:Show()
 else f.beacon:Hide() end
end
function A.Say(text)
 if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage("|cff00ffffAzeroth Cursor|r: "..text) end
end
function A.Command(message)
 local msg=string.lower(message or "")
 if msg=="on" then A.db.enabled=true;A.Apply()
 elseif msg=="off" then A.db.enabled=false;A.Apply()
 elseif msg=="find" then A.Find()
 elseif msg=="native" or msg=="balanced" or msg=="raid" or msg=="minimal" then A.Preset(msg)
 elseif msg=="reset" then AzerothCursorDB={language=A.db.language};A.InitDB();A.Apply()
 elseif msg=="fr" or msg=="en" then A.db.language=msg;A.Apply()
 else
  local _,_,hex=string.find(msg,"^color%s+#?(%x%x%x%x%x%x)$")
  if hex then
   A.db.rgb={tonumber(string.sub(hex,1,2),16)/255,tonumber(string.sub(hex,3,4),16)/255,tonumber(string.sub(hex,5,6),16)/255};A.db.enabled=true;A.Apply()
  else A.ToggleOptions() end
 end
end
function A.Initialize()
 if A.db then A.CreateMinimap();return end
 A.InitDB()
 A.visual=A.CreateVisual("AzerothCursorVisual");A.visual:SetFrameStrata("TOOLTIP");A.visual:SetFrameLevel(100)
 A.visual:Hide();A.Apply()
 A.CreateMinimap()
 SLASH_AZEROTHCURSOR1="/azcursor";SLASH_AZEROTHCURSOR2="/azcur";SlashCmdList.AZEROTHCURSOR=A.Command
 A.driver:SetScript("OnUpdate",function() A.Update(arg1) end)
 local state=A.db.enabled and (A.db.language=="fr" and "Actif." or "Enabled.") or (A.db.language=="fr" and "Désactivé." or "Disabled.")
 A.Say(state.." Options : /azcursor")
end
A.driver=CreateFrame("Frame","AzerothCursorDriver",UIParent)
A.driver:RegisterEvent("ADDON_LOADED");A.driver:RegisterEvent("PLAYER_LOGIN")
A.driver:SetScript("OnEvent",function()
 if (event=="ADDON_LOADED" and arg1=="AzerothCursor") or event=="PLAYER_LOGIN" then A.Initialize() end
end)
