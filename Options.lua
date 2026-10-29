local A=AzerothCursor
local strings={
 fr={title="Azeroth Cursor",subtitle="Retrouvez votre souris au milieu des effets.",enabled="Repère actif",pulse="Halo animé",yes="Oui",no="Non",
 size="Diamètre du repère",thickness="Épaisseur de l'anneau",opacity="Opacité du repère",halo="Intensité du halo",crosshair="Taille du réticule",dot="Taille du point central",
 balanced="Équilibré",raid="Combat intense",minimal="Discret",preview="APERÇU",color="Choisir la couleur",native="Origine",cancel="Annuler",accept="Valider",red="Rouge",green="Vert",blue="Bleu",miniTip="Clic : options. Glisser : déplacer.",custom="Personnalisée",find="Retrouver le curseur",close="Fermer",
 hint="Le centre indique le point de clic. Le repère laisse passer tous les clics.",footer="/azcursor find : signal lumineux  •  /azcursor off : désactiver",
 detail="Origine : curseur natif seul.\nActivez le repère ou choisissez un préréglage pour ajouter les effets.",
 Cyan="Cyan",Magenta="Magenta",Lime="Vert citron",Gold="Or",White="Blanc",Orange="Orange",Red="Rouge",Blue="Bleu"},
 en={title="Azeroth Cursor",subtitle="Find your mouse in the middle of spell effects.",enabled="Cursor marker",pulse="Animated halo",yes="On",no="Off",
 size="Marker diameter",thickness="Ring thickness",opacity="Marker opacity",halo="Halo intensity",crosshair="Crosshair size",dot="Center dot size",
 balanced="Balanced",raid="Intense combat",minimal="Minimal",preview="PREVIEW",color="Choose color",native="Original",cancel="Cancel",accept="Apply",red="Red",green="Green",blue="Blue",miniTip="Click: settings. Drag: move.",custom="Custom",find="Locate cursor",close="Close",
 hint="The center marks the click point. All clicks pass through the marker.",footer="/azcursor find: light beacon  •  /azcursor off: disable",
 detail="Original: native cursor only.\nEnable the marker or choose a preset to add effects.",
 Cyan="Cyan",Magenta="Magenta",Lime="Lime",Gold="Gold",White="White",Orange="Orange",Red="Red",Blue="Blue"}
}
function A.L(key) return strings[A.db.language][key] or key end
local function Back(f,r,g,b)
 f:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="Interface\\Buttons\\WHITE8X8",edgeSize=1})
 f:SetBackdropColor(r,g,b,.98);f:SetBackdropBorderColor(.22,.38,.44,1)
end
local function Text(p,x,y,w,h,size)
 local t=p:CreateFontString(nil,"OVERLAY")
 t:SetPoint("TOPLEFT",p,"TOPLEFT",x,y);t:SetWidth(w);t:SetHeight(h)
 t:SetFont("Fonts\\FRIZQT__.TTF",size or 13);t:SetJustifyH("LEFT");t:SetJustifyV("TOP")
 return t
end
local function Button(p,x,y,w,h,fn)
 local b=CreateFrame("Button",nil,p);b:SetPoint("TOPLEFT",p,"TOPLEFT",x,y);b:SetWidth(w);b:SetHeight(h)
 Back(b,.08,.15,.18);b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
 b.text=Text(b,5,-7,w-10,h-7,12);b.text:SetJustifyH("CENTER");b:SetScript("OnClick",fn)
 return b
end
function A.Slider(parent,x,y,width,low,high,changed)
 local s=CreateFrame("Slider",nil,parent)
 s:SetPoint("TOPLEFT",parent,"TOPLEFT",x,y);s:SetWidth(width);s:SetHeight(16)
 s:SetOrientation("HORIZONTAL");s:SetMinMaxValues(low,high);s:SetValueStep(1);s:EnableMouse(true)
 Back(s,.04,.08,.10)
 s:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
 local thumb=s:GetThumbTexture();thumb:SetWidth(24);thumb:SetHeight(24)
 s:SetScript("OnValueChanged",function()
  changed(math.max(low,math.min(high,math.floor(this:GetValue()+.5))))
 end)
 return s
end
function A.OpenColorPicker()
 if A.picker and A.picker:IsShown() then return end
 if not A.picker then
  local p=CreateFrame("Frame","AzerothCursorColorPicker",A.panel);A.picker=p
  p:SetWidth(380);p:SetHeight(490);p:SetPoint("CENTER",A.panel,"CENTER",0,0)
  p:SetFrameStrata("FULLSCREEN_DIALOG");p:SetFrameLevel(110);p:EnableMouse(true)
  Back(p,.025,.045,.06)
  p.title=Text(p,22,-18,336,30,18)
  local cs=CreateFrame("ColorSelect",nil,p);p.select=cs
  cs:SetPoint("TOPLEFT",p,"TOPLEFT",38,-62);cs:SetWidth(304);cs:SetHeight(210);cs:EnableMouse(true)
  local wheel=cs:CreateTexture(nil,"ARTWORK");cs:SetColorWheelTexture(wheel)
  wheel:SetPoint("TOPLEFT",cs,"TOPLEFT",0,0);wheel:SetWidth(210);wheel:SetHeight(210)
  local strip=cs:CreateTexture(nil,"ARTWORK");cs:SetColorValueTexture(strip)
  strip:SetPoint("TOPLEFT",cs,"TOPLEFT",242,0);strip:SetWidth(24);strip:SetHeight(210)
  local thumb=cs:CreateTexture(nil,"OVERLAY")
  thumb:SetTexture("Interface\\AddOns\\AzerothCursor\\Media\\Ring3.tga")
  cs:SetColorWheelThumbTexture(thumb);thumb:SetWidth(14);thumb:SetHeight(14)
  thumb=cs:CreateTexture(nil,"OVERLAY");thumb:SetTexture("Interface\\Buttons\\WHITE8X8")
  cs:SetColorValueThumbTexture(thumb);thumb:SetWidth(30);thumb:SetHeight(4)
  p.channels={}
  local keys={"red","green","blue"}
  for i,key in ipairs(keys) do
   local index=i;local y=-294-(i-1)*42
   local row={label=Text(p,22,y,88,22,12),value=Text(p,306,y,52,22,12),key=key}
   row.slider=A.Slider(p,102,y-1,190,0,255,function(v)
    if p.syncing then return end
    local rgb={A.Color()};rgb[index]=v/255;A.db.rgb=rgb;A.db.enabled=true;A.Apply();p.Refresh()
   end)
   table.insert(p.channels,row)
  end
  p.hex=Text(p,22,-424,336,22,13);p.hex:SetJustifyH("CENTER")
  p.accept=Button(p,22,-454,160,30,function() p.committed=true;p:Hide() end)
  p.cancel=Button(p,198,-454,160,30,function() p:Hide() end)
  function p.Refresh()
   p.syncing=true
   local rgb={A.Color()};cs:SetColorRGB(unpack(rgb))
   for i,row in ipairs(p.channels) do
    local n=math.floor(rgb[i]*255+.5);row.slider:SetValue(n);row.value:SetText(n);row.label:SetText(A.L(row.key))
   end
   p.hex:SetText(string.format("#%02X%02X%02X",math.floor(rgb[1]*255+.5),math.floor(rgb[2]*255+.5),math.floor(rgb[3]*255+.5)))
   p.syncing=false
  end
  cs:SetScript("OnColorSelect",function()
   if p.syncing then return end
   A.db.rgb={cs:GetColorRGB()};A.db.enabled=true;A.Apply();p.Refresh()
  end)
  p:SetScript("OnHide",function()
   if not p.committed then
    A.db.rgb=p.originalRGB;A.db.color=p.originalColor;A.db.enabled=p.originalEnabled;A.Apply()
   end
  end)
  table.insert(UISpecialFrames,"AzerothCursorColorPicker")
  p.committed=true;p:Hide()
 end
 local p=A.picker
 p.originalRGB=A.db.rgb and {unpack(A.db.rgb)} or nil;p.originalColor=A.db.color;p.originalEnabled=A.db.enabled;p.committed=false
 p.title:SetText(A.L("color"));p.accept.text:SetText(A.L("accept"));p.cancel.text:SetText(A.L("cancel"))
 p.Refresh();p:Show()
end
function A.CreateMinimap()
 if A.minimap or not Minimap then return end
 local b=CreateFrame("Button","AzerothCursorMinimapButton",Minimap);A.minimap=b
 b:SetWidth(31);b:SetHeight(31);b:SetFrameStrata("MEDIUM");b:SetFrameLevel(Minimap:GetFrameLevel()+9)
 local ring=b:CreateTexture(nil,"BACKGROUND");ring:SetTexture("Interface\\AddOns\\AzerothCursor\\Media\\Ring3.tga")
 ring:SetWidth(30);ring:SetHeight(30);ring:SetPoint("CENTER",b,"CENTER",0,0);ring:SetVertexColor(0,1,1,1)
 local icon=b:CreateTexture(nil,"ARTWORK");icon:SetTexture("Interface\\Cursor\\Point")
 icon:SetWidth(22);icon:SetHeight(22);icon:SetPoint("CENTER",b,"CENTER",0,0)
 b:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
 function b.Place()
  local a=math.rad(A.db.minimapAngle)
  local radius=math.max(Minimap:GetWidth(),Minimap:GetHeight())/2+8
  b:ClearAllPoints();b:SetPoint("CENTER",Minimap,"CENTER",radius*math.cos(a),radius*math.sin(a))
 end
 b:RegisterForClicks("LeftButtonUp");b:RegisterForDrag("LeftButton")
 b:SetScript("OnClick",function() if GameTooltip then GameTooltip:Hide() end;A.ToggleOptions() end)
 b:SetScript("OnDragStart",function() b.dragging=true end)
 b:SetScript("OnDragStop",function() b.dragging=false end)
 b:SetScript("OnUpdate",function()
  if not b.dragging then return end
  local x,y=GetCursorPosition();local mx,my=Minimap:GetCenter();local scale=Minimap:GetEffectiveScale()
  if not mx or not my or not x or not y or not scale or scale<=0 then return end
  A.db.minimapAngle=math.deg(math.atan2(y/scale-my,x/scale-mx));b.Place()
 end)
 b:SetScript("OnEnter",function()
  if not GameTooltip then return end
  GameTooltip:SetOwner(b,"ANCHOR_LEFT");GameTooltip:SetText("Azeroth Cursor",0,1,1)
  GameTooltip:AddLine(A.L("miniTip"),1,1,1);GameTooltip:Show()
 end)
 b:SetScript("OnLeave",function() if GameTooltip then GameTooltip:Hide() end end)
 b.Place()
end
function A.RefreshOptions()
 if not A.panel then return end
 local p=A.panel
 for _,entry in ipairs(p.labels) do entry[1]:SetText(A.L(entry[2])) end
 for _,row in ipairs(p.rows) do
  row.label:SetText(A.L(row.key));row.value:SetText(tostring(A.db[row.key])..row.suffix)
  p.refreshing=true;row.slider:SetValue(A.db[row.key]);p.refreshing=false
 end
 p.enabled.text:SetText(A.L("enabled").." : "..A.L(A.db.enabled and "yes" or "no"))
 p.pulse.text:SetText(A.L("pulse").." : "..A.L(A.db.pulse and "yes" or "no"))
 local color=A.db.rgb and A.L("custom") or A.L(A.colors[A.db.color][1])
 p.colorName:SetText(color);p.color.text:SetText(A.L("color"))
 p.swatch:SetVertexColor(A.Color())
 p.language.text:SetText(A.db.language=="fr" and "English" or "Français")
 A.Style(A.preview)
 A.preview:SetScale(math.min(1,180/math.max(A.db.size*1.8,A.db.crosshair*2+16)))
 if A.db.enabled then A.preview:Show();p.nativeCursor:Hide() else A.preview:Hide();p.nativeCursor:Show() end
end
function A.BuildOptions()
 if A.panel then return end
 local p=CreateFrame("Frame","AzerothCursorOptions",UIParent);A.panel=p
 p:SetWidth(680);p:SetHeight(600);p:SetPoint("CENTER",UIParent,"CENTER",0,0)
 p:SetFrameStrata("DIALOG");p:EnableMouse(true);p:SetMovable(true);p:SetClampedToScreen(true)
 Back(p,.025,.045,.06);p.labels={};p.rows={}
 local function Label(key,x,y,w,h,size)
  local t=Text(p,x,y,w,h,size);table.insert(p.labels,{t,key});return t
 end
 local header=CreateFrame("Frame",nil,p);header:SetPoint("TOPLEFT",p,"TOPLEFT",0,0);header:SetWidth(680);header:SetHeight(72)
 header:EnableMouse(true);header:RegisterForDrag("LeftButton")
 header:SetScript("OnDragStart",function() p:StartMoving() end)
 header:SetScript("OnDragStop",function() p:StopMovingOrSizing() end)
 p:SetScript("OnHide",function() p:StopMovingOrSizing() end)
 Label("title",22,-18,420,28,23);Label("subtitle",22,-49,630,22,13)
 local function LocalButton(key,x,y,w,fn)
  local b=Button(p,x,y,w,32,fn);table.insert(p.labels,{b.text,key});return b
 end
 LocalButton("native",22,-86,88,function() A.Preset("native") end)
 LocalButton("balanced",118,-86,96,function() A.Preset("balanced") end)
 LocalButton("raid",222,-86,112,function() A.Preset("raid") end)
 LocalButton("minimal",342,-86,80,function() A.Preset("minimal") end)
 p.language=Button(p,528,-86,130,32,function() A.db.language=A.db.language=="fr" and "en" or "fr";A.Apply() end)
 p.enabled=Button(p,22,-132,195,32,function() A.db.enabled=not A.db.enabled;A.Apply() end)
 p.pulse=Button(p,227,-132,195,32,function() A.db.pulse=not A.db.pulse;A.Apply() end)
 local specs={{"size",24,160,4,""},{"thickness",1,3,1,""},{"opacity",20,100,5," %"},
  {"halo",0,100,5," %"},{"crosshair",0,100,4,""},{"dot",0,24,1,""}}
 for i,spec in ipairs(specs) do
  local key,low,high,step,suffix=unpack(spec);local y=-179-(i-1)*46
  local row={key=key,suffix=suffix,label=Label(key,22,y,290,23),value=Text(p,330,y,68,23,13)}
  row.value:SetJustifyH("RIGHT")
  row.minus=Button(p,22,y-21,26,24,function() A.db[key]=math.max(low,A.db[key]-1);A.db.enabled=true;A.Apply() end);row.minus.text:SetText("-")
  row.plus=Button(p,372,y-21,26,24,function() A.db[key]=math.min(high,A.db[key]+1);A.db.enabled=true;A.Apply() end);row.plus.text:SetText("+")
  row.slider=A.Slider(p,60,y-25,294,low,high,function(v)
   if not p.refreshing then A.db[key]=v;A.db.enabled=true;A.Apply() end
  end)
  table.insert(p.rows,row)
 end
 local stage=CreateFrame("Frame",nil,p);stage:SetPoint("TOPLEFT",p,"TOPLEFT",438,-132);stage:SetWidth(220);stage:SetHeight(220)
 Back(stage,.06,.09,.12)
 local caption=Text(stage,12,-10,196,22,12);caption:SetText(" ");table.insert(p.labels,{caption,"preview"})
 A.preview=A.CreateVisual(nil,stage);A.preview:SetPoint("CENTER",stage,"CENTER",0,-8)
 p.nativeCursor=stage:CreateTexture(nil,"OVERLAY");p.nativeCursor:SetTexture("Interface\\Cursor\\Point")
 p.nativeCursor:SetWidth(32);p.nativeCursor:SetHeight(32);p.nativeCursor:SetPoint("CENTER",stage,"CENTER",12,-20)
 p.colorName=Text(p,438,-365,220,24,14);p.colorName:SetJustifyH("CENTER")
 p.color=Button(p,438,-395,220,32,A.OpenColorPicker)
 p.swatch=p.color:CreateTexture(nil,"OVERLAY");p.swatch:SetTexture("Interface\\Buttons\\WHITE8X8")
 p.swatch:SetWidth(16);p.swatch:SetHeight(16);p.swatch:SetPoint("LEFT",p.color,"LEFT",8,0)
 p.color.text:SetWidth(182);p.color.text:ClearAllPoints();p.color.text:SetPoint("TOPLEFT",p.color,"TOPLEFT",30,-7)
 Label("detail",438,-444,220,122,12)
 Label("hint",22,-461,390,42,12)
 LocalButton("find",22,-514,236,A.Find)
 LocalButton("close",268,-514,154,function() p:Hide() end)
 Label("footer",22,-568,630,22,12)
 table.insert(UISpecialFrames,"AzerothCursorOptions")
 p:Hide();A.RefreshOptions()
end
function A.ToggleOptions()
 A.BuildOptions()
 if A.panel:IsShown() then A.panel:Hide() else
  local w,h=UIParent:GetWidth(),UIParent:GetHeight()
  A.panel:SetScale(math.min(1,(w-24)/680,(h-24)/600))
  A.RefreshOptions();A.panel:Show()
 end
end
