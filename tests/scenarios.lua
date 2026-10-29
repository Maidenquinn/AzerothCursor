-- Standalone legacy FrameXML geometry mock.
dofile("tests/mock.lua")
local proto=getmetatable(UIParent).__index
function proto:CreateTexture(name,layer)
 local t=CreateFrame("Texture",name,self);t.layer=layer;return t
end
function proto:SetTexture(path) self.texture=path end
function proto:SetVertexColor(r,g,b,a) self.rgba={r,g,b,a} end
function proto:SetAlpha(a) self.alpha=a end
function proto:EnableMouse(v) self.mouseEnabled=v end
function proto:SetFrameStrata(v) self.strata=v end
function proto:SetFrameLevel(v) self.level=v end
function proto:GetFrameLevel() return self.level or 1 end
function proto:SetOrientation(v) self.orientation=v end
function proto:SetMinMaxValues(a,b) self.low=a;self.high=b end
function proto:SetValueStep(v) self.step=v end
function proto:SetThumbTexture(v) self.thumb=self:CreateTexture();self.thumb:SetTexture(v) end
function proto:GetThumbTexture() return self.thumb end
function proto:GetValue() return self.value or self.low or 0 end
function proto:SetValue(v)
 v=math.max(self.low,math.min(self.high,v));local changed=self.value~=v;self.value=v
 if changed and self.scripts.OnValueChanged then
  local prev=this;this=self;self.scripts.OnValueChanged();this=prev
 end
end
function proto:SetColorRGB(r,g,b)
 self.rgb={r,g,b}
 if self.scripts.OnColorSelect then local prev=this;this=self;self.scripts.OnColorSelect();this=prev end
end
function proto:GetColorRGB() return unpack(self.rgb) end
for _,slot in ipairs({"ColorWheel","ColorValue","ColorWheelThumb","ColorValueThumb"}) do
 local key=slot
 proto["Set"..key.."Texture"]=function(self,texture)
  assert(type(texture)=="table" and texture.kind=="Texture",key..": expected a Texture region")
  assert(texture.parent==self,key..": expected an owned region")
  self[key]=texture
 end
 proto["Get"..key.."Texture"]=function(self) return self[key] end
end
Minimap=CreateFrame("Frame","Minimap",UIParent);Minimap:SetWidth(140);Minimap:SetHeight(140)
local cursorX,cursorY,looking=350,440,false
function GetCursorPosition() return cursorX,cursorY end
function IsMouselooking() return looking end
-- Remove modern convenience functions to catch accidental Lua 5.1+ usage.
string.match=nil;string.gmatch=nil
dofile("Core.lua");dofile("Options.lua")
local A=AzerothCursor
event="ADDON_LOADED";arg1="OtherAddon";A.driver.scripts.OnEvent();assert(not A.db)
arg1="AzerothCursor";A.driver.scripts.OnEvent()
assert(not A.db.enabled and A.db.size==64 and A.db.language=="fr")
assert(AzerothCursorDB==A.db and SlashCmdList.AZEROTHCURSOR)
local count=table.getn(objects);event="PLAYER_LOGIN";A.driver.scripts.OnEvent();assert(count==table.getn(objects))
A.Update(.016);assert(not A.visual:IsShown());A.Command("on");A.Update(.016);assert(A.visual:IsShown());near(A.visual:GetCenter(),cursorX)
local x,y=A.visual:GetCenter();near(x,350);near(y,440)
assert(A.visual.mouseEnabled==false and A.visual.strata=="TOOLTIP")
UIParent:SetScale(.75);cursorX=600;cursorY=300;A.Update(.016)
x,y=A.visual:GetCenter();near(x,800);near(y,400)
-- Scale changes are handled even if physical mouse position is unchanged.
UIParent:SetScale(1.25);A.Update(.016);x,y=A.visual:GetCenter();near(x,480);near(y,240)
looking=true;A.Update(.016);assert(not A.visual:IsShown())
looking=false;A.Update(.016);assert(A.visual:IsShown())
cursorX=-1;A.Update(.016);assert(not A.visual:IsShown())
cursorX=300;A.Command("off");A.Update(.016);assert(not A.visual:IsShown())
A.Command("find");A.Update(.1);assert(A.visual:IsShown() and A.visual.beacon:IsShown())
A.Update(1.3);assert(not A.visual.beacon:IsShown())
A.Command("raid");assert(A.db.size==96 and A.db.thickness==3 and A.db.color==2)
A.Command("color #1234FF");local r,g,b=A.Color();near(r,18/255);near(g,52/255);near(b,1)
A.Command("minimal");assert(not A.db.rgb and A.db.crosshair==0)
assert(not A.visual.cross:IsShown() and not A.visual.crossOutline:IsShown())
A.Command("reset");assert(A.db.size==64 and not A.db.enabled)
A.Command("");assert(A.panel:IsShown() and A.preview.mouseEnabled==false)
assert(not A.preview:IsShown() and A.panel.nativeCursor:IsShown())
A.RefreshOptions();assert(not A.db.enabled) -- Programmatic slider updates do not enable it.
for _,row in ipairs(A.panel.rows) do assert(row.value:GetText()~="") end
local function press(button)
 this=button;button.scripts.OnClick()
end
press(A.panel.enabled);assert(A.db.enabled)
assert(A.preview:IsShown() and not A.panel.nativeCursor:IsShown())
press(A.panel.pulse);assert(A.db.pulse)
press(A.panel.language);assert(A.db.language=="en")
assert(A.panel.enabled.text:GetText()=="Cursor marker : On")
A.Command("off");press(A.panel.color);assert(A.picker:IsShown() and not A.db.enabled)
local original={A.Color()}
A.picker.select:SetColorRGB(.2,.4,.6);near(A.db.rgb[2],.4);assert(A.db.enabled)
A.picker.channels[1].slider:SetValue(123);near(A.db.rgb[1],123/255)
press(A.picker.cancel);assert(not A.picker:IsShown() and not A.db.enabled);local cr,cg,cb=A.Color();near(cr,original[1]);near(cg,original[2]);near(cb,original[3])
press(A.panel.color);A.picker.channels[3].slider:SetValue(77);assert(A.db.enabled);press(A.picker.accept);near(A.db.rgb[3],77/255);assert(A.db.enabled)
press(A.panel.color);A.picker.select:SetColorRGB(1,0,0);A.picker:Hide();near(A.db.rgb[3],77/255)
for _,row in ipairs(A.panel.rows) do
 row.slider:SetValue(row.slider.low);A.Command("off");row.slider:SetValue(row.slider.high);assert(A.db[row.key]==row.slider.high and A.db.enabled)
 row.slider:SetValue(row.slider.low);assert(A.db[row.key]==row.slider.low)
end
-- Actual +/- controls honor bounds, not just programmatic command paths.
local minus,plus=A.panel.rows[1].minus,A.panel.rows[1].plus
assert(minus and plus)
for i=1,200 do press(plus) end;assert(A.db.size==160)
for i=1,200 do press(minus) end;assert(A.db.size==24)
-- Closing options does not disable the cursor. Disable works while panel is hidden.
A.Command("on");A.ToggleOptions();assert(not A.panel:IsShown());A.Update(.016);assert(A.visual:IsShown())
local before=table.getn(objects)
for i=1,300 do A.Update(.016) end
assert(table.getn(objects)==before)
-- Persisted tables are sanitized, including non-numbers, infinities and missing fields.
AzerothCursorDB={size=0/0,thickness=999,opacity=-99,halo="85",color={},dot=1/0,enabled=false,pulse="yes",language="xx",rgb={1,-2,4}}
A.InitDB();assert(A.db.size==64 and A.db.thickness==3 and A.db.opacity==20 and A.db.halo==85)
assert(A.db.color==1 and A.db.dot==5 and not A.db.enabled and not A.db.pulse and A.db.language=="fr")
r,g,b=A.Color();assert(r==1 and g==0 and b==1)
AzerothCursorDB={enabled=true,size=89};A.InitDB();assert(not A.db.enabled and A.db.size==89 and A.db.schema==2)
A.db.enabled=true;A.InitDB();assert(A.db.enabled)
AzerothCursorDB={schema=2,enabled=false,rgb={1,0,1},minimapAngle=123};A.InitDB()
local saved=A.db;A.db=nil;A.InitDB();assert(A.db.size==saved.size and A.db.rgb[3]==1 and not A.db.enabled)
assert(A.db.minimapAngle==123)
A.minimap.Place();local point=A.minimap.points[1];near(point[4],78*math.cos(math.rad(123)))
A.minimap.scripts.OnDragStart();A.minimap.scripts.OnUpdate();A.minimap.scripts.OnDragStop();assert(not A.minimap.dragging)
press(A.minimap);assert(A.panel:IsShown());press(A.minimap);assert(not A.panel:IsShown())
A.Preset("native");A.Update(.016);assert(not A.visual:IsShown())
-- Every overlay frame stays mouse transparent; no combat action or CVar is called.
for _,f in ipairs(objects) do
 if f==A.visual or f==A.preview then assert(f.mouseEnabled==false) end
end
print("Azeroth Cursor: native Lua 5.0 loading, geometry, settings, UI and persistence OK")
