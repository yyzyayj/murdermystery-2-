local cloneref = cloneref or function(x) return x end
local function getService(name) return cloneref(game:GetService(name)) end

local Players          = getService("Players")
local TweenService     = getService("TweenService")
local UserInputService = getService("UserInputService")
local HttpService      = getService("HttpService")
local CoreGui
pcall(function() CoreGui = getService("CoreGui") end)
local LocalPlayer = Players.LocalPlayer

local YzZ = {
	Version     = "1.0.0",
	Flags       = {},
	CacheFolder = "YzZHub/cache",
}

local WindowClass = {}
WindowClass.__index = WindowClass
local TabClass = {}
TabClass.__index = TabClass

local hasFS = (type(writefile) == "function" and type(readfile) == "function"
	and type(isfile) == "function" and type(isfolder) == "function" and type(makefolder) == "function")
local httpRequest = (syn and syn.request) or http_request or request or (http and http.request) or (fluxus and fluxus.request)
local getAsset = getcustomasset or getsynasset

local function ensureFolder(path)
	if not hasFS then return end
	local current = ""
	for part in string.gmatch(path, "[^/]+") do
		current = (current == "") and part or (current .. "/" .. part)
		if not isfolder(current) then pcall(makefolder, current) end
	end
end

local rgb = Color3.fromRGB
YzZ.Themes = {
	Dark = {
		Background = rgb(17, 17, 23), Topbar = rgb(22, 22, 30), Sidebar = rgb(20, 20, 27),
		Element = rgb(29, 29, 39), ElementHover = rgb(37, 37, 50), Stroke = rgb(46, 46, 62),
		Accent = rgb(139, 92, 246), AccentDark = rgb(91, 58, 190),
		Text = rgb(240, 240, 248), SubText = rgb(148, 148, 172),
		ToggleOff = rgb(58, 58, 76), Input = rgb(21, 21, 29),
	},
	Ocean = {
		Background = rgb(12, 18, 28), Topbar = rgb(15, 24, 38), Sidebar = rgb(13, 21, 33),
		Element = rgb(21, 32, 49), ElementHover = rgb(28, 42, 63), Stroke = rgb(37, 55, 82),
		Accent = rgb(56, 189, 248), AccentDark = rgb(14, 116, 180),
		Text = rgb(235, 245, 255), SubText = rgb(135, 160, 190),
		ToggleOff = rgb(45, 62, 88), Input = rgb(14, 22, 35),
	},
	Crimson = {
		Background = rgb(20, 14, 16), Topbar = rgb(27, 18, 21), Sidebar = rgb(24, 16, 19),
		Element = rgb(36, 25, 29), ElementHover = rgb(47, 32, 37), Stroke = rgb(64, 42, 49),
		Accent = rgb(239, 68, 82), AccentDark = rgb(153, 27, 45),
		Text = rgb(250, 240, 242), SubText = rgb(176, 148, 154),
		ToggleOff = rgb(72, 52, 58), Input = rgb(25, 17, 20),
	},
	Emerald = {
		Background = rgb(13, 20, 18), Topbar = rgb(17, 27, 24), Sidebar = rgb(15, 24, 21),
		Element = rgb(24, 37, 33), ElementHover = rgb(31, 48, 43), Stroke = rgb(42, 66, 59),
		Accent = rgb(52, 211, 153), AccentDark = rgb(4, 120, 87),
		Text = rgb(236, 252, 245), SubText = rgb(140, 176, 164),
		ToggleOff = rgb(50, 72, 65), Input = rgb(15, 24, 21),
	},
	Light = {
		Background = rgb(244, 245, 250), Topbar = rgb(255, 255, 255), Sidebar = rgb(237, 239, 246),
		Element = rgb(255, 255, 255), ElementHover = rgb(240, 241, 248), Stroke = rgb(219, 222, 233),
		Accent = rgb(99, 102, 241), AccentDark = rgb(67, 56, 202),
		Text = rgb(24, 24, 34), SubText = rgb(108, 112, 132),
		ToggleOff = rgb(200, 204, 216), Input = rgb(246, 247, 252),
	},
}

local function resolveTheme(t)
	local result = {}
	for k, v in pairs(YzZ.Themes.Dark) do result[k] = v end
	if type(t) == "string" and YzZ.Themes[t] then
		for k, v in pairs(YzZ.Themes[t]) do result[k] = v end
	elseif type(t) == "table" then
		for k, v in pairs(t) do result[k] = v end
	end
	return result
end

YzZ.Icons = {
	["home"] = "rbxassetid://98755624629571", ["house"] = "rbxassetid://98755624629571",
	["settings"] = "rbxassetid://80758916183665", ["cog"] = "rbxassetid://116544501716299",
	["user"] = "rbxassetid://81589895647169", ["users"] = "rbxassetid://115398113982385",
	["sword"] = "rbxassetid://124448418211665", ["swords"] = "rbxassetid://81872698913435",
	["shield"] = "rbxassetid://110987169760162", ["eye"] = "rbxassetid://100033680381365",
	["target"] = "rbxassetid://87563802520297", ["crosshair"] = "rbxassetid://134242818164054",
	["zap"] = "rbxassetid://130551565616516", ["bolt"] = "rbxassetid://102881251417484",
	["save"] = "rbxassetid://126116963775616", ["folder"] = "rbxassetid://80846616596607",
	["folder-open"] = "rbxassetid://76018996254888", ["search"] = "rbxassetid://121018724060431",
	["bell"] = "rbxassetid://97392696311902", ["info"] = "rbxassetid://124560466474914",
	["check"] = "rbxassetid://93898873302694", ["x"] = "rbxassetid://110786993356448",
	["minus"] = "rbxassetid://118026365011536", ["plus"] = "rbxassetid://111774323017047",
	["chevron-down"] = "rbxassetid://134243273101015", ["chevron-up"] = "rbxassetid://122444883127455",
	["chevron-right"] = "rbxassetid://92473583511724", ["star"] = "rbxassetid://136141469398409",
	["heart"] = "rbxassetid://116559368303288", ["lock"] = "rbxassetid://134724289526879",
	["unlock"] = "rbxassetid://93597915325122", ["globe"] = "rbxassetid://114238209622913",
	["map-pin"] = "rbxassetid://84279202219901", ["palette"] = "rbxassetid://86350350950064",
	["sliders"] = "rbxassetid://85538382643347", ["keyboard"] = "rbxassetid://121474456068237",
	["mouse-pointer"] = "rbxassetid://72322454962935", ["mouse-pointer-click"] = "rbxassetid://107150227368485",
	["terminal"] = "rbxassetid://106783148545356", ["code"] = "rbxassetid://107380207681249",
	["bug"] = "rbxassetid://83626408925438", ["wrench"] = "rbxassetid://112148279212860",
	["sparkles"] = "rbxassetid://138635884129147", ["rocket"] = "rbxassetid://87412317685854",
	["flame"] = "rbxassetid://98218034436456", ["gamepad"] = "rbxassetid://92483947987410",
	["layout-dashboard"] = "rbxassetid://139929981863901", ["list"] = "rbxassetid://113179976918783",
	["trash"] = "rbxassetid://106723740584310", ["trash-2"] = "rbxassetid://109843431391323",
	["download"] = "rbxassetid://134814648082393", ["upload"] = "rbxassetid://138212042425501",
	["refresh-cw"] = "rbxassetid://138133190015277", ["power"] = "rbxassetid://96479131758775",
	["copy"] = "rbxassetid://78979572434545", ["image"] = "rbxassetid://112751259236831",
	["type"] = "rbxassetid://133543553793564", ["toggle-right"] = "rbxassetid://90411952142550",
	["menu"] = "rbxassetid://77021539815611", ["sun"] = "rbxassetid://110150589884127",
	["moon"] = "rbxassetid://83380517901735", ["crown"] = "rbxassetid://127843403295538",
	["skull"] = "rbxassetid://137726256442333", ["ghost"] = "rbxassetid://113822048130017",
	["bot"] = "rbxassetid://80451686744860", ["file-text"] = "rbxassetid://90496405707281",
	["paintbrush"] = "rbxassetid://125572663700289", ["circle-check"] = "rbxassetid://85262178816537",
	["circle-alert"] = "rbxassetid://83898160590116", ["triangle-alert"] = "rbxassetid://125920361880643",
}

local function MergeWindUIIcons()
	local windUIURL = "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
	local success, source = pcall(function()
		return game:HttpGet(windUIURL)
	end)

	if not success or type(source) ~= "string" then
		warn("[YzZ] WindUI icon download failed; keeping the existing YzZ icons.")
		return
	end

	local iconBlock = source:match("function a%.b%(%)(.-)end function a%.c%(")
	if not iconBlock then
		warn("[YzZ] WindUI icon table was not found; keeping the existing YzZ icons.")
		return
	end

	local windIcons = {}

	for name, asset in iconBlock:gmatch('%["([^"]+)"%]%s*=%s*"(rbxassetid://%d+)"') do
		windIcons[name] = asset
	end

	for name, asset in iconBlock:gmatch('([%a][%w%-]*)%s*=%s*"(rbxassetid://%d+)"') do
		windIcons[name] = asset
	end

	local mergedIcons = {}

	for name, asset in pairs(windIcons) do
		mergedIcons[name] = asset
	end

	for name, asset in pairs(YzZ.Icons or {}) do
		if mergedIcons[name] == nil then
			mergedIcons[name] = asset
		end
	end

	YzZ.Icons = mergedIcons
end

MergeWindUIIcons()

function YzZ:AddIcons(tbl)
	for name, value in pairs(tbl or {}) do
		YzZ.Icons[string.lower(tostring(name))] = value
	end
end

local transparentClasses = {
	TextLabel = true, TextButton = true, ImageLabel = true, ImageButton = true, ScrollingFrame = true,
}

local function Create(class, props, children)
	local obj = Instance.new(class)
	if obj:IsA("GuiObject") then
		obj.BorderSizePixel = 0
		if transparentClasses[class] then obj.BackgroundTransparency = 1 end
	end
	if obj:IsA("GuiButton") then obj.AutoButtonColor = false end
	local parent
	for k, v in pairs(props or {}) do
		if k == "Parent" then parent = v else obj[k] = v end
	end
	for _, c in ipairs(children or {}) do c.Parent = obj end
	if parent then obj.Parent = parent end
	return obj
end

local function Tween(obj, props, time, style, dir)
	local tw = TweenService:Create(obj, TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end

local function Corner(parent, radius)
	return Create("UICorner", {CornerRadius = radius and UDim.new(0, radius) or UDim.new(1, 0), Parent = parent})
end

local function Pad(parent, l, t, r, b)
	return Create("UIPadding", {
		PaddingLeft = UDim.new(0, l or 0), PaddingTop = UDim.new(0, t or 0),
		PaddingRight = UDim.new(0, r or 0), PaddingBottom = UDim.new(0, b or 0), Parent = parent,
	})
end

local function safe(cb, ...)
	if type(cb) == "function" then task.spawn(cb, ...) end
end

local function hashString(s)
	local h = 5381
	for i = 1, #s do h = (h * 33 + string.byte(s, i)) % 4294967296 end
	return string.format("%08x", h)
end

local function normalizeKey(v)
	if v == nil then return "None" end
	if typeof(v) == "EnumItem" then return v.Name end
	return tostring(v)
end

local function matchesKey(key, input)
	if key == nil or key == "None" then return false end
	if input.UserInputType == Enum.UserInputType.Keyboard then return input.KeyCode.Name == key end
	return input.UserInputType.Name == key
end

local function prettyKey(k)
	if k == nil or k == "None" then return "None" end
	local map = {
		MouseButton1 = "MB1", MouseButton2 = "MB2", MouseButton3 = "MB3",
		LeftShift = "LShift", RightShift = "RShift", LeftControl = "LCtrl", RightControl = "RCtrl",
		LeftAlt = "LAlt", RightAlt = "RAlt", Return = "Enter",
	}
	return map[k] or k
end

local urlCache, urlPending = {}, {}

local function loadUrlImage(url, callback)
	if urlCache[url] then callback(urlCache[url]) return end
	if not (hasFS and httpRequest and getAsset) then return end
	if urlPending[url] then table.insert(urlPending[url], callback) return end
	urlPending[url] = {callback}
	task.spawn(function()
		local lower = string.lower(url)
		local ext = (string.find(lower, "%.jpe?g") and "jpg") or "png"
		ensureFolder(YzZ.CacheFolder)
		local path = YzZ.CacheFolder .. "/" .. hashString(url) .. "." .. ext
		local ok = true
		if not isfile(path) then
			ok = false
			local success, res = pcall(httpRequest, {Url = url, Method = "GET"})
			if success and res and res.Body and #res.Body > 0 and (res.StatusCode == nil or res.StatusCode == 200) then
				ok = pcall(writefile, path, res.Body)
			end
		end
		local asset
		if ok then
			local s, a = pcall(getAsset, path)
			if s then asset = a end
		end
		local callbacks = urlPending[url]
		urlPending[url] = nil
		if asset then
			urlCache[url] = asset
			for _, cb in ipairs(callbacks) do pcall(cb, asset) end
		end
	end)
end

local function resolveIcon(src)
	if type(src) == "table" then return "image", src end
	if type(src) == "number" then return "image", "rbxassetid://" .. src end
	if type(src) ~= "string" or src == "" then return nil end
	if string.match(src, "^rbxassetid://") or string.match(src, "^rbxasset://") or string.match(src, "^rbxthumb://")
		or string.match(src, "^https?://www%.roblox%.com/asset") then
		return "image", src
	end
	if string.match(src, "^%d+$") then return "image", "rbxassetid://" .. src end
	if string.match(src, "^https?://") then return "url", src end
	local key = string.lower(src)
	key = key:gsub("^lucide:", "")
	key = key:gsub("^icon:", "")
	local found = YzZ.Icons[key]
	if found ~= nil then
		if type(found) == "number" then found = "rbxassetid://" .. found end
		return "named", found
	end
	return "text", src
end

function WindowClass:_applyBinds()
	local alive = {}
	for _, b in ipairs(self._binds) do
		if b.inst == nil or b.inst.Parent ~= nil then
			pcall(b.fn)
			table.insert(alive, b)
		end
	end
	self._binds = alive
end

function WindowClass:Bind(inst, map)
	local T = self.T
	local function apply()
		for prop, key in pairs(map) do inst[prop] = T[key] end
	end
	apply()
	table.insert(self._binds, {inst = inst, fn = apply})
end

function WindowClass:BindFn(inst, fn)
	fn()
	table.insert(self._binds, {inst = inst, fn = fn})
end

function WindowClass:SetTheme(t)
	local res = resolveTheme(t)
	for k, v in pairs(res) do self.T[k] = v end
	if type(t) == "string" then self.ThemeName = t end
	if self._binds then self:_applyBinds() end
end

function WindowClass:SetAccent(color)
	self.T.Accent = color
	self.T.AccentDark = color:Lerp(Color3.new(0, 0, 0), 0.38)
	self:_applyBinds()
end

function WindowClass:_connect(signal, fn)
	local c = signal:Connect(fn)
	table.insert(self._conns, c)
	return c
end

function WindowClass:Label(parent, text, size, colorKey, font, props)
	local l = Create("TextLabel", {
		Text = text, TextSize = size, Font = font or Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true, RichText = true, Size = UDim2.new(1, 0, 0, size + 4),
	})
	for k, v in pairs(props or {}) do l[k] = v end
	l.Parent = parent
	self:Bind(l, {TextColor3 = colorKey})
	return l
end

function WindowClass:Stroke(parent, colorKey, thickness)
	local s = Create("UIStroke", {Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = parent})
	self:Bind(s, {Color = colorKey or "Stroke"})
	return s
end

function WindowClass:MakeIcon(parent, src, size, props, lockColor)
	if src == nil or src == "" or src == false then return nil end
	local kind, value = resolveIcon(src)
	if not kind then return nil end
	local sz = (typeof(size) == "UDim2") and size or UDim2.fromOffset(size, size)
	local icon = Create("ImageLabel", {Name = "Icon", Size = sz, ScaleType = Enum.ScaleType.Fit, Image = ""})
	for k, v in pairs(props or {}) do icon[k] = v end

	local ctl = {Icon = icon, Tint = (kind == "named") or (lockColor ~= nil), Locked = (lockColor ~= nil)}
	local label

	if kind == "text" then
		icon.ImageTransparency = 1
		label = Create("TextLabel", {
			Size = UDim2.fromScale(1, 1), Text = value, TextScaled = true,
			Font = Enum.Font.GothamBold, TextColor3 = Color3.new(1, 1, 1), Parent = icon,
		})
	elseif kind == "url" then
		loadUrlImage(value, function(asset) icon.Image = asset end)
	else
		if type(value) == "table" then
			icon.Image = value.Image or value[1] or ""
			if value.ImageRectOffset then icon.ImageRectOffset = value.ImageRectOffset end
			if value.ImageRectSize then icon.ImageRectSize = value.ImageRectSize end
		else
			icon.Image = value
		end
	end

	function ctl.SetColor(c)
		if ctl.Locked then return end
		if label then label.TextColor3 = c
		elseif ctl.Tint then icon.ImageColor3 = c end
	end

	if lockColor then
		if label then label.TextColor3 = lockColor else icon.ImageColor3 = lockColor end
	end

	icon.Parent = parent
	return icon, ctl
end

local function MakeDraggable(Window, handle, target, opts)
	opts = opts or {}
	local dragging, moved, dragStart, startPos = false, false, nil, nil

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging, moved = true, false
			dragStart = input.Position
			if opts.Clamp then
				startPos = UDim2.fromOffset(target.AbsolutePosition.X, target.AbsolutePosition.Y)
			else
				startPos = target.Position
			end
			if opts.OnBegin then opts.OnBegin() end
		end
	end)

	Window:_connect(UserInputService.InputChanged, function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - dragStart
			if delta.Magnitude > 5 then moved = true end
			if not moved and opts.Clamp then return end
			if opts.Clamp then
				local x, y = opts.Clamp(startPos.X.Offset + delta.X, startPos.Y.Offset + delta.Y)
				target.Position = UDim2.fromOffset(x, y)
			else
				target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end
	end)

	Window:_connect(UserInputService.InputEnded, function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
			if opts.OnEnd then opts.OnEnd(moved) end
		end
	end)
end

function WindowClass:_configPath(name)
	name = tostring(name):gsub("[^%w_%- ]", "")
	return self.ConfigFolder .. "/configs/" .. name .. ".json"
end

function WindowClass:_readConfig(name)
	if not hasFS then return nil end
	local path = self:_configPath(name)
	if not isfile(path) then return nil end
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
	if ok and type(data) == "table" then return data end
	return nil
end

function WindowClass:ListConfigs()
	local out = {}
	if hasFS and type(listfiles) == "function" then
		ensureFolder(self.ConfigFolder .. "/configs")
		local ok, files = pcall(listfiles, self.ConfigFolder .. "/configs")
		if ok and type(files) == "table" then
			for _, f in ipairs(files) do
				local n = string.match(f, "([^/\\]+)%.json$")
				if n then table.insert(out, n) end
			end
		end
	end
	table.sort(out)
	return out
end

function WindowClass:SaveConfig(name, silent)
	name = name or self.CurrentConfig
	if not hasFS then
		if not silent then self:Notify({Title = "Config", Content = "Your executor does not support file saving.", Icon = "circle-alert"}) end
		return false
	end
	ensureFolder(self.ConfigFolder .. "/configs")
	local data = {}
	for flag, obj in pairs(self.Flags) do
		local ok, v = pcall(obj.Serialize)
		if ok and v ~= nil then data[flag] = v end
	end
	local okEncode, encoded = pcall(function() return HttpService:JSONEncode(data) end)
	if not okEncode then return false end
	local okWrite = pcall(writefile, self:_configPath(name), encoded)
	if okWrite then
		self.CurrentConfig = name
		if not silent then self:Notify({Title = "Config saved", Content = "Saved as \"" .. tostring(name) .. "\".", Icon = "save"}) end
		for _, cb in ipairs(self._listCallbacks) do pcall(cb) end
	end
	return okWrite
end

function WindowClass:LoadConfig(name, silent)
	name = name or self.CurrentConfig
	local data = self:_readConfig(name)
	if not data then
		if not silent then self:Notify({Title = "Config", Content = "Config \"" .. tostring(name) .. "\" was not found.", Icon = "circle-alert"}) end
		return false
	end
	self._loading = true
	for flag, obj in pairs(self.Flags) do
		local v = data[flag]
		if v ~= nil then pcall(obj.Set, v, false) end
	end
	self._loading = false
	self.CurrentConfig = name
	if not silent then self:Notify({Title = "Config loaded", Content = "Loaded \"" .. tostring(name) .. "\".", Icon = "download"}) end
	return true
end

function WindowClass:DeleteConfig(name)
	if hasFS and type(delfile) == "function" then
		local path = self:_configPath(name)
		if isfile(path) then
			pcall(delfile, path)
			for _, cb in ipairs(self._listCallbacks) do pcall(cb) end
			return true
		end
	end
	return false
end

function WindowClass:_changed()
	if self._loading or not self.AutoSave or self._destroyed then return end
	self._saveToken = (self._saveToken or 0) + 1
	local token = self._saveToken
	task.delay(1, function()
		if token == self._saveToken and not self._destroyed then
			self:SaveConfig(self.CurrentConfig, true)
		end
	end)
end

function WindowClass:_register(tab, opts, title, obj)
	local flag = opts.Flag
	if flag == false then return nil end
	if flag == nil then flag = tab.Title .. "/" .. tostring(title) end
	if self.Flags[flag] then
		local n = 2
		while self.Flags[flag .. "#" .. n] do n = n + 1 end
		flag = flag .. "#" .. n
	end
	self.Flags[flag] = obj
	return flag
end

function WindowClass:SetVisible(v)
	v = v and true or false
	if self._destroyed or self.Visible == v then return end
	self.Visible = v
	local main, scale = self.Main, self._mainScale
	if v then
		main.Visible = true
		scale.Scale = 0.86
		main.GroupTransparency = 1
		Tween(scale, {Scale = 1}, 0.45, Enum.EasingStyle.Back)
		Tween(main, {GroupTransparency = 0}, 0.3)
	else
		Tween(scale, {Scale = 0.9}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		Tween(main, {GroupTransparency = 1}, 0.22)
		task.delay(0.25, function()
			if not self.Visible and main.Parent then main.Visible = false end
		end)
	end
	if self._floatUpdate then self._floatUpdate(v) end
end

function WindowClass:Toggle() self:SetVisible(not self.Visible) end

function WindowClass:SetKeybind(key) self.Keybind = normalizeKey(key) end

function WindowClass:SetFloatingVisible(v)
	if self.FloatingButton then self.FloatingButton.Visible = v and true or false end
end

function WindowClass:SetTitle(title, sub)
	if title then self._titleLabel.Text = title end
	if sub then self._subLabel.Text = sub end
end

function WindowClass:Destroy()
	if self._destroyed then return end
	if self.AutoSave then pcall(function() self:SaveConfig(self.CurrentConfig, true) end) end
	self._destroyed = true
	for _, c in ipairs(self._conns) do pcall(function() c:Disconnect() end) end
	if self.Gui then self.Gui:Destroy() end
	local env = (getgenv and getgenv()) or _G
	if env.__YzZHubWindow == self then env.__YzZHubWindow = nil end
end

function WindowClass:Notify(o)
	if self._destroyed then return end
	if type(o) == "string" then o = {Content = o} end
	o = o or {}
	local T = self.T
	local duration = o.Duration or 4

	local wrap = Create("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = self._notifyHolder})
	wrap.BackgroundTransparency = 1

	local card = Create("CanvasGroup", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.fromOffset(70, 0),
		BackgroundColor3 = T.Element, GroupTransparency = 1, Parent = wrap,
	})
	Corner(card, 10)
	self:Bind(card, {BackgroundColor3 = "Element"})
	self:Stroke(card, "Stroke", 1)
	Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Parent = card})

	local content = Create("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1, Parent = card})
	content.BackgroundTransparency = 1
	Pad(content, 12, 10, 12, 10)
	Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = content})

	local hasIcon = false
	local ic, ctl = self:MakeIcon(content, o.Icon or o.Image or "bell", 22, {LayoutOrder = 1})
	if ic then
		hasIcon = true
		if ctl then self:BindFn(ic, function() ctl.SetColor(T.Accent) end) end
	end

	local textFrame = Create("Frame", {
		Size = UDim2.new(1, hasIcon and -32 or 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2, Parent = content,
	})
	textFrame.BackgroundTransparency = 1
	Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = textFrame})
	self:Label(textFrame, o.Title or "YzZ Hub", 14, "Text", Enum.Font.GothamBold, {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1})
	if o.Content and o.Content ~= "" then
		self:Label(textFrame, o.Content, 12, "SubText", Enum.Font.Gotham, {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2})
	end

	local barTrack = Create("Frame", {Size = UDim2.new(1, 0, 0, 3), LayoutOrder = 2, Parent = card})
	barTrack.BackgroundTransparency = 1
	local bar = Create("Frame", {Size = UDim2.fromScale(1, 1), Parent = barTrack})
	self:Bind(bar, {BackgroundColor3 = "Accent"})

	Tween(card, {GroupTransparency = 0, Position = UDim2.fromOffset(0, 0)}, 0.4, Enum.EasingStyle.Back)
	Tween(bar, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)

	task.delay(duration, function()
		if not card.Parent then return end
		Tween(card, {GroupTransparency = 1, Position = UDim2.fromOffset(70, 0)}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		task.wait(0.32)
		if wrap.Parent then wrap:Destroy() end
	end)
end

function WindowClass:Dialog(o)
	o = o or {}
	local T = self.T
	local overlay = Create("TextButton", {
		Name = "Dialog", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1, Text = "", ZIndex = 60, Parent = self.Main,
	})
	local card = Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(math.min(330, self.Main.AbsoluteSize.X - 40), 0),
		AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = T.Element, Parent = overlay,
	})
	Corner(card, 12)
	self:Bind(card, {BackgroundColor3 = "Element"})
	self:Stroke(card, "Stroke", 1)
	Pad(card, 16, 16, 16, 16)
	local cardScale = Create("UIScale", {Scale = 0.88, Parent = card})
	Create("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = card})

	self:Label(card, o.Title or "Confirm", 16, "Text", Enum.Font.GothamBold, {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1})
	if o.Content then
		self:Label(card, o.Content, 13, "SubText", Enum.Font.Gotham, {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2})
	end

	local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 34), LayoutOrder = 3, Parent = card})
	row.BackgroundTransparency = 1
	Create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right,
		Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = row,
	})

	local function close()
		Tween(overlay, {BackgroundTransparency = 1}, 0.2)
		Tween(cardScale, {Scale = 0.9}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		task.delay(0.22, function() if overlay.Parent then overlay:Destroy() end end)
	end

	for i, b in ipairs(o.Buttons or {{Title = "OK"}}) do
		local primary = b.Primary or (i == #(o.Buttons or {1}))
		local btn = Create("TextButton", {
			Size = UDim2.new(0, 96, 1, 0), Text = b.Title or "OK", Font = Enum.Font.GothamMedium, TextSize = 13,
			LayoutOrder = i, BackgroundTransparency = 0, Parent = row,
		})
		Corner(btn, 8)
		self:Bind(btn, {BackgroundColor3 = primary and "Accent" or "ElementHover", TextColor3 = primary and "Text" or "SubText"})
		if primary then btn.TextColor3 = Color3.new(1, 1, 1) end
		btn.MouseButton1Click:Connect(function()
			close()
			safe(b.Callback)
		end)
	end

	Tween(overlay, {BackgroundTransparency = 0.5}, 0.25)
	Tween(cardScale, {Scale = 1}, 0.35, Enum.EasingStyle.Back)
	return {Close = close}
end

function WindowClass:SelectTab(tab)
	if type(tab) == "number" then tab = self.Tabs[tab] end
	if not tab or self.ActiveTab == tab then return end
	local prev = self.ActiveTab
	self.ActiveTab = tab
	if prev then
		prev.Active = false
		prev.Page.Visible = false
		prev:_visual(false)
	end
	tab.Active = true
	tab.Page.Visible = true
	tab:_visual(true)
	if prev then
		self._cover.BackgroundTransparency = 0
		Tween(self._cover, {BackgroundTransparency = 1}, 0.35)
		tab.Page.Position = UDim2.fromOffset(0, 16)
		Tween(tab.Page, {Position = UDim2.fromOffset(0, 0)}, 0.35, Enum.EasingStyle.Quint)
	end
end

function TabClass:_visual(active, instant)
	local T = self.Window.T
	local d = instant and 0 or 0.2
	Tween(self.Button, {BackgroundTransparency = active and 0.85 or 1}, d)
	Tween(self.Label, {TextColor3 = active and T.Text or T.SubText}, d)
	Tween(self.Indicator, {Size = UDim2.fromOffset(3, active and 16 or 0)}, d)
	if self.IconCtl then self.IconCtl.SetColor(active and T.Accent or T.SubText) end
end

function WindowClass:CreateTab(opts)
	if type(opts) == "string" then opts = {Title = opts} end
	opts = opts or {}
	local T = self.T
	local tab = setmetatable({Window = self, Title = opts.Title or opts.Name or "Tab", Active = false, _order = 0}, TabClass)

	local btn = Create("TextButton", {
		Name = tab.Title, Size = UDim2.new(1, 0, 0, 36), Text = "", BackgroundTransparency = 1,
		LayoutOrder = #self.Tabs + 1, Parent = self._tabList,
	})
	Corner(btn, 8)
	self:Bind(btn, {BackgroundColor3 = "Accent"})

	local indicator = Create("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(3, 0), Parent = btn})
	Corner(indicator)
	self:Bind(indicator, {BackgroundColor3 = "Accent"})

	local labelX = 14
	local icon, ctl = self:MakeIcon(btn, opts.Icon or opts.Image, 18, {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0.5, 0)}, opts.IconColor)
	if icon then labelX = 38 end

	local label = Create("TextLabel", {
		Position = UDim2.fromOffset(labelX, 0), Size = UDim2.new(1, -(labelX + 6), 1, 0), Text = tab.Title,
		Font = Enum.Font.GothamMedium, TextSize = self.Compact and 12 or 13, TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd, Parent = btn,
	})

	tab.Button, tab.Label, tab.Indicator, tab.IconCtl = btn, label, indicator, ctl

	local page = Create("ScrollingFrame", {
		Name = tab.Title, Size = UDim2.fromScale(1, 1), Visible = false, CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = self._content,
	})
	self:Bind(page, {ScrollBarImageColor3 = "Accent"})
	Pad(page, 12, 12, 12, 12)
	Create("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page})
	tab.Page = page

	self:BindFn(btn, function() tab:_visual(tab.Active, true) end)

	btn.MouseEnter:Connect(function()
		if not tab.Active then Tween(label, {TextColor3 = T.Text}, 0.15) end
	end)
	btn.MouseLeave:Connect(function()
		if not tab.Active then Tween(label, {TextColor3 = T.SubText}, 0.15) end
	end)
	btn.MouseButton1Click:Connect(function() self:SelectTab(tab) end)

	table.insert(self.Tabs, tab)
	if #self.Tabs == 1 then self:SelectTab(tab) end
	return tab
end

function TabClass:_base(opts, o)
	o = o or {}
	local W = self.Window
	local T = W.T
	self._order = self._order + 1

	local frame = Create("Frame", {
		Name = tostring(opts.Title or opts.Name or "Element"), Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = self._order, Parent = self.Page,
	})
	Corner(frame, 8)
	W:Bind(frame, {BackgroundColor3 = "Element"})
	local stroke = W:Stroke(frame, "Stroke", 1)
	Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame})

	if opts.Image then
		local holder = Create("Frame", {Name = "Banner", Size = UDim2.new(1, 0, 0, opts.ImageHeight or 90), LayoutOrder = 1, Parent = frame})
		holder.BackgroundTransparency = 1
		Pad(holder, 8, 8, 8, 0)
		local img = W:MakeIcon(holder, opts.Image, UDim2.fromScale(1, 1), {ScaleType = Enum.ScaleType.Crop}, opts.ImageColor)
		if img then Corner(img, 6) end
	end

	local rowProps = {
		Name = "Row", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2, Parent = frame,
	}
	if o.Interactive then rowProps.Text = "" end
	local row = Create(o.Interactive and "TextButton" or "Frame", rowProps)
	row.BackgroundTransparency = 1
	Create("UISizeConstraint", {MinSize = Vector2.new(0, o.MinHeight or 42), Parent = row})
	Pad(row, 12, 8, 12, 8)
	Create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = row,
	})

	local iconBlock = 0
	local icon, ctl = W:MakeIcon(row, opts.Icon, 20, {LayoutOrder = 1}, opts.IconColor)
	if icon then
		iconBlock = 30
		if ctl then W:BindFn(icon, function() ctl.SetColor(T.Accent) end) end
	end

	local rightW = o.RightWidth or 0
	local rightBlock = rightW > 0 and (rightW + 10) or 0

	local textFrame = Create("Frame", {
		Name = "Text", Size = UDim2.new(1, -(iconBlock + rightBlock), 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 2, Parent = row,
	})
	textFrame.BackgroundTransparency = 1
	Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = textFrame})

	local titleText = tostring(opts.Title or opts.Name or "")
	local descText = opts.Description or opts.Desc or opts.Content or ""
	local title = W:Label(textFrame, titleText, 14, "Text", Enum.Font.GothamMedium,
		{Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1})
	local desc = W:Label(textFrame, tostring(descText), 12, "SubText", Enum.Font.Gotham,
		{Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2, Visible = (descText ~= "")})
	if titleText == "" then title.Visible = false end

	local right
	if rightW > 0 then
		right = Create("Frame", {Name = "Right", Size = UDim2.fromOffset(rightW, o.RightHeight or 26), LayoutOrder = 3, Parent = row})
		right.BackgroundTransparency = 1
	end

	local base = {Frame = frame, Row = row, Stroke = stroke, Right = right, TitleLabel = title, DescLabel = desc}
	function base.SetTitle(t) title.Text = tostring(t); title.Visible = (tostring(t) ~= "") end
	function base.SetDesc(t) desc.Text = tostring(t or ""); desc.Visible = (t ~= nil and t ~= "") end
	function base.Flash()
		Tween(stroke, {Color = T.Accent}, 0.1)
		task.delay(0.25, function()
			if stroke.Parent then Tween(stroke, {Color = T.Stroke}, 0.3) end
		end)
	end

	if o.Interactive then
		row.MouseEnter:Connect(function() Tween(frame, {BackgroundColor3 = T.ElementHover}, 0.15) end)
		row.MouseLeave:Connect(function() Tween(frame, {BackgroundColor3 = T.Element}, 0.15) end)
	end
	return base
end

local function decorate(el, base, W, flagGetter)
	el.Frame = base.Frame
	function el:SetTitle(t) base.SetTitle(t) end
	function el:SetDescription(t) base.SetDesc(t) end
	function el:SetVisible(v) base.Frame.Visible = v and true or false end
	function el:Destroy()
		local flag = flagGetter and flagGetter()
		if flag then W.Flags[flag] = nil end
		base.Frame:Destroy()
	end
	return el
end

function TabClass:CreateSection(opts)
	if type(opts) == "string" then opts = {Title = opts} end
	opts = opts or {}
	local W = self.Window
	local T = W.T
	self._order = self._order + 1

	local f = Create("Frame", {Name = "Section", Size = UDim2.new(1, 0, 0, 30), LayoutOrder = self._order, Parent = self.Page})
	f.BackgroundTransparency = 1
	local inner = Create("Frame", {Size = UDim2.fromScale(1, 1), Parent = f})
	inner.BackgroundTransparency = 1
	Pad(inner, 2, 4, 0, 0)
	Create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = inner,
	})
	local icon, ctl = W:MakeIcon(inner, opts.Icon or opts.Image, 16, {LayoutOrder = 1}, opts.IconColor)
	if icon and ctl then W:BindFn(icon, function() ctl.SetColor(T.Accent) end) end
	local lbl = W:Label(inner, tostring(opts.Title or opts.Name or "Section"), 12, "Accent", Enum.Font.GothamBold,
		{Size = UDim2.new(0, 0, 0, 16), AutomaticSize = Enum.AutomaticSize.X, TextWrapped = false, TextYAlignment = Enum.TextYAlignment.Center, LayoutOrder = 2})
	local line = Create("Frame", {AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 1), BackgroundTransparency = 0.4, Parent = f})
	W:Bind(line, {BackgroundColor3 = "Stroke"})

	local el = {Type = "Section", Frame = f}
	function el:SetTitle(t) lbl.Text = tostring(t) end
	function el:SetVisible(v) f.Visible = v and true or false end
	function el:Destroy() f:Destroy() end
	return el
end

function TabClass:CreateParagraph(opts)
	opts = opts or {}
	local W = self.Window
	local base = self:_base(opts, {Interactive = false, MinHeight = 40})
	local el = {Type = "Paragraph"}
	function el:SetContent(t) base.SetDesc(t) end
	return decorate(el, base, W)
end

function TabClass:CreateButton(opts)
	opts = opts or {}
	local W = self.Window
	local T = W.T
	local base = self:_base(opts, {Interactive = true, RightWidth = 20, RightHeight = 20})
	local ic, ctl = W:MakeIcon(base.Right, opts.ButtonIcon or "mouse-pointer-click", UDim2.fromScale(1, 1), {}, opts.ButtonIconColor)
	if ic and ctl then W:BindFn(ic, function() ctl.SetColor(T.SubText) end) end

	base.Row.MouseButton1Click:Connect(function()
		base.Flash()
		if ic then
			Tween(ic, {Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(3, 3)}, 0.08)
			task.delay(0.09, function()
				if ic.Parent then Tween(ic, {Size = UDim2.fromScale(1, 1), Position = UDim2.fromOffset(0, 0)}, 0.25, Enum.EasingStyle.Back) end
			end)
		end
		safe(opts.Callback)
	end)

	local el = {Type = "Button"}
	function el:Fire() safe(opts.Callback) end
	return decorate(el, base, W)
end

function TabClass:CreateToggle(opts)
	opts = opts or {}
	local W = self.Window
	local T = W.T
	local title = opts.Title or opts.Name or "Toggle"
	local callback = opts.Callback
	local base = self:_base(opts, {Interactive = true, RightWidth = 42, RightHeight = 22})

	local track = Create("Frame", {Name = "Track", Size = UDim2.fromScale(1, 1), BackgroundColor3 = T.ToggleOff, Parent = base.Right})
	Corner(track)
	local knob = Create("Frame", {
		Name = "Knob", AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0),
		Size = UDim2.fromOffset(16, 16), BackgroundColor3 = Color3.new(1, 1, 1), Parent = track,
	})
	Corner(knob)

	local state = false
	local function render(instant)
		local goalColor = state and T.Accent or T.ToggleOff
		local goalPos = state and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
		if instant then
			track.BackgroundColor3 = goalColor
			knob.Position = goalPos
		else
			Tween(track, {BackgroundColor3 = goalColor}, 0.2)
			Tween(knob, {Position = goalPos}, 0.3, Enum.EasingStyle.Back)
		end
	end
	local function set(v, silent, instant)
		v = v and true or false
		if v == state then return end
		state = v
		render(instant)
		if not silent then
			W:_changed()
			safe(callback, state)
		end
	end

	state = opts.Default == true
	W:BindFn(track, function() render(true) end)

	local obj = {
		Get = function() return state end,
		Set = function(v, silent) set(v, silent) end,
		Serialize = function() return state end,
	}
	local flag = W:_register(self, opts, title, obj)
	if flag and W._pending and W._pending[flag] ~= nil then
		state = W._pending[flag] == true
		render(true)
	end

	base.Row.MouseButton1Click:Connect(function() set(not state) end)

	if callback then task.defer(function() safe(callback, state) end) end

	local el = {Type = "Toggle", Flag = flag}
	function el:Set(v, silent) set(v, silent) end
	function el:Get() return state end
	return decorate(el, base, W, function() return flag end)
end

function TabClass:CreateSlider(opts)
	opts = opts or {}
	local W = self.Window
	local T = W.T
	local title = opts.Title or opts.Name or "Slider"
	local callback = opts.Callback
	local min, max = opts.Min or 0, opts.Max or 100
	if max <= min then max = min + 1 end
	local inc = opts.Increment or 1
	local suffix = opts.Suffix or ""
	local decimals = 0
	do
		local dec = string.match(tostring(inc), "%.(%d+)")
		if dec then decimals = #dec end
	end
	local function round(v)
		v = math.floor((v - min) / inc + 0.5) * inc + min
		v = tonumber(string.format("%." .. decimals .. "f", v)) or v
		return math.clamp(v, min, max)
	end

	local base = self:_base(opts, {Interactive = false, RightWidth = 70, RightHeight = 20})
	local valueLbl = Create("TextLabel", {
		Size = UDim2.fromScale(1, 1), Text = "", Font = Enum.Font.GothamMedium, TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Right, Parent = base.Right,
	})
	W:Bind(valueLbl, {TextColor3 = "SubText"})

	local barRow = Create("Frame", {Name = "BarRow", Size = UDim2.new(1, 0, 0, 26), LayoutOrder = 3, Parent = base.Frame})
	barRow.BackgroundTransparency = 1
	Pad(barRow, 12, 0, 12, 0)

	local track = Create("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, -3), Size = UDim2.new(1, 0, 0, 6), Parent = barRow})
	Corner(track)
	W:Bind(track, {BackgroundColor3 = "ToggleOff"})
	local fill = Create("Frame", {Size = UDim2.new(0, 0, 1, 0), Parent = track})
	Corner(fill)
	W:Bind(fill, {BackgroundColor3 = "Accent"})
	local knob = Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(12, 12),
		BackgroundColor3 = Color3.new(1, 1, 1), Parent = track,
	})
	Corner(knob)

	local value = min
	local function render(instant)
		local a = (value - min) / (max - min)
		valueLbl.Text = tostring(value) .. suffix
		local d = instant and 0 or 0.08
		Tween(fill, {Size = UDim2.new(a, 0, 1, 0)}, d, Enum.EasingStyle.Quad)
		Tween(knob, {Position = UDim2.new(a, 0, 0.5, 0)}, d, Enum.EasingStyle.Quad)
	end
	local function set(v, silent, instant)
		v = round(tonumber(v) or min)
		if v == value then return end
		value = v
		render(instant)
		if not silent then
			W:_changed()
			safe(callback, value)
		end
	end

	value = round(tonumber(opts.Default) or min)
	render(true)

	local obj = {
		Get = function() return value end,
		Set = function(v, silent) set(v, silent) end,
		Serialize = function() return value end,
	}
	local flag = W:_register(self, opts, title, obj)
	if flag and W._pending and W._pending[flag] ~= nil then
		value = round(tonumber(W._pending[flag]) or value)
		render(true)
	end

	local hit = Create("TextButton", {Size = UDim2.fromScale(1, 1), Text = "", Parent = barRow})
	local dragging = false
	local function fromInput(input)
		local a = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
		set(min + (max - min) * a)
	end
	hit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			self.Page.ScrollingEnabled = false
			Tween(knob, {Size = UDim2.fromOffset(17, 17)}, 0.15, Enum.EasingStyle.Back)
			fromInput(input)
		end
	end)
	W:_connect(UserInputService.InputChanged, function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			fromInput(input)
		end
	end)
	W:_connect(UserInputService.InputEnded, function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
			self.Page.ScrollingEnabled = true
			Tween(knob, {Size = UDim2.fromOffset(12, 12)}, 0.15)
		end
	end)

	if callback then task.defer(function() safe(callback, value) end) end

	local el = {Type = "Slider", Flag = flag}
	function el:Set(v, silent) set(v, silent) end
	function el:Get() return value end
	return decorate(el, base, W, function() return flag end)
end

function TabClass:CreateTextbox(opts)
	opts = opts or {}
	local W = self.Window
	local T = W.T
	local title = opts.Title or opts.Name or "Textbox"
	local callback = opts.Callback
	local base = self:_base(opts, {Interactive = false, RightWidth = W.Compact and 110 or 150, RightHeight = 28})

	local box = Create("TextBox", {
		Size = UDim2.fromScale(1, 1), Text = "", PlaceholderText = opts.Placeholder or "Type here...",
		Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = opts.ClearOnFocus == true,
		TextTruncate = Enum.TextTruncate.AtEnd, BackgroundTransparency = 0, Parent = base.Right,
	})
	Corner(box, 6)
	Pad(box, 8, 0, 8, 0)
	W:Bind(box, {BackgroundColor3 = "Input", TextColor3 = "Text", PlaceholderColor3 = "SubText"})
	local boxStroke = W:Stroke(box, "Stroke", 1)

	local value = ""
	local function set(text, silent)
		value = tostring(text or "")
		box.Text = value
		if not silent then
			W:_changed()
			safe(callback, value)
		end
	end

	value = tostring(opts.Default or "")
	box.Text = value

	local obj = {
		Get = function() return value end,
		Set = function(v, silent) set(v, silent) end,
		Serialize = function() return value end,
	}
	local flag = W:_register(self, opts, title, obj)
	if flag and W._pending and W._pending[flag] ~= nil then
		value = tostring(W._pending[flag])
		box.Text = value
	end

	box.Focused:Connect(function() Tween(boxStroke, {Color = T.Accent}, 0.15) end)
	box.FocusLost:Connect(function(enter)
		Tween(boxStroke, {Color = T.Stroke}, 0.15)
		if opts.RequireEnter and not enter then box.Text = value return end
		local txt = box.Text
		if opts.Numeric then
			local n = tonumber(txt)
			if n == nil then box.Text = value return end
			if opts.Min then n = math.max(n, opts.Min) end
			if opts.Max then n = math.min(n, opts.Max) end
			txt = tostring(n)
		end
		set(txt)
	end)

	if callback and value ~= "" then task.defer(function() safe(callback, value) end) end

	local el = {Type = "Textbox", Flag = flag}
	function el:Set(v, silent) set(v, silent) end
	function el:Get() return value end
	return decorate(el, base, W, function() return flag end)
end

function TabClass:CreateDropdown(opts)
	opts = opts or {}
	local W = self.Window
	local T = W.T
	local multi = (opts.Multi == true) or (opts.Multiple == true) or (opts.MultiSelect == true)
	local title = opts.Title or opts.Name or "Dropdown"
	local callback = opts.Callback
	local base = self:_base(opts, {Interactive = true, RightWidth = W.Compact and 108 or 150, RightHeight = 24})

	local entries, byTitle, selected = {}, {}, {}
	local optionButtons = {}
	local isOpen, searchText = false, ""
	local open, close

	Create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = base.Right,
	})
	local valueLbl = W:Label(base.Right, "", 12, "SubText", Enum.Font.Gotham, {
		Size = UDim2.new(1, -22, 1, 0), TextXAlignment = Enum.TextXAlignment.Right, TextYAlignment = Enum.TextYAlignment.Center,
		TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd, LayoutOrder = 1,
	})
	local chev, chevCtl = W:MakeIcon(base.Right, "chevron-down", 16, {LayoutOrder = 2})
	if chev and chevCtl then W:BindFn(chev, function() chevCtl.SetColor(T.SubText) end) end

	local holder = Create("Frame", {Name = "Options", Size = UDim2.new(1, 0, 0, 0), ClipsDescendants = true, LayoutOrder = 5, Parent = base.Frame})
	holder.BackgroundTransparency = 1
	Pad(holder, 10, 0, 10, 10)
	Create("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = holder})

	local searchBox = Create("TextBox", {
		Size = UDim2.new(1, 0, 0, 28), Text = "", PlaceholderText = "Search...", Font = Enum.Font.Gotham, TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, BackgroundTransparency = 0, LayoutOrder = 1, Visible = false, Parent = holder,
	})
	Corner(searchBox, 6)
	Pad(searchBox, 8, 0, 8, 0)
	W:Bind(searchBox, {BackgroundColor3 = "Input", TextColor3 = "Text", PlaceholderColor3 = "SubText"})
	W:Stroke(searchBox, "Stroke", 1)

	local scroller = Create("ScrollingFrame", {
		Size = UDim2.new(1, 0, 0, 0), LayoutOrder = 2, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 2, Parent = holder,
	})
	W:Bind(scroller, {ScrollBarImageColor3 = "Accent"})
	Create("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = scroller})

	local function visibleEntries()
		local out = {}
		local q = string.lower(searchText)
		for _, e in ipairs(entries) do
			if q == "" or string.find(string.lower(e.Title), q, 1, true) then table.insert(out, e) end
		end
		return out
	end

	local function currentHeight()
		local n = #visibleEntries()
		local listH = math.clamp(n * 33, 0, 165)
		scroller.Size = UDim2.new(1, 0, 0, listH)
		return (searchBox.Visible and 34 or 0) + listH + 10
	end

	local function getValue()
		if multi then
			local out = {}
			for _, e in ipairs(entries) do
				if selected[e.Title] then table.insert(out, e.Title) end
			end
			return out
		end
		for _, e in ipairs(entries) do
			if selected[e.Title] then return e.Title end
		end
		return nil
	end

	local function updateDisplay()
		local v = getValue()
		if multi then
			if #v == 0 then valueLbl.Text = opts.Placeholder or "None"
			elseif #v <= 2 then valueLbl.Text = table.concat(v, ", ")
			else valueLbl.Text = v[1] .. ", " .. v[2] .. " +" .. (#v - 2) end
		else
			valueLbl.Text = v or opts.Placeholder or "Select..."
		end
	end

	local function styleOption(entry, instant)
		local ob = optionButtons[entry.Title]
		if not ob then return end
		local on = selected[entry.Title] == true
		local d = instant and 0 or 0.15
		Tween(ob.Button, {BackgroundTransparency = on and 0.8 or 1}, d)
		Tween(ob.Label, {TextColor3 = on and T.Text or T.SubText}, d)
		if ob.Check then
			ob.Check.ImageColor3 = T.Accent
			Tween(ob.Check, {ImageTransparency = on and 0 or 1}, d)
		end
	end

	local function commit()
		updateDisplay()
		W:_changed()
		safe(callback, getValue())
	end

	local function toggleOption(t)
		if multi then
			selected[t] = (not selected[t]) or nil
			styleOption(byTitle[t])
		else
			selected = {[t] = true}
			for _, e in ipairs(entries) do styleOption(e) end
			close()
		end
		commit()
	end

	local function rebuild()
		for _, ob in pairs(optionButtons) do ob.Button:Destroy() end
		optionButtons = {}
		for i, e in ipairs(visibleEntries()) do
			local b = Create("TextButton", {
				Name = e.Title, Size = UDim2.new(1, 0, 0, 30), Text = "", BackgroundColor3 = T.Accent,
				BackgroundTransparency = 1, LayoutOrder = i, Parent = scroller,
			})
			Corner(b, 6)
			local leftX = 10
			local ic, ctl = W:MakeIcon(b, e.Icon or e.Image, 16, {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0)}, e.IconColor)
			if ic then
				leftX = 32
				if ctl then ctl.SetColor(T.SubText) end
			end
			local lbl = Create("TextLabel", {
				Position = UDim2.fromOffset(leftX, 0), Size = UDim2.new(1, -(leftX + 30), 1, 0), Text = e.Title,
				Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd, TextColor3 = T.SubText, Parent = b,
			})
			local chk = W:MakeIcon(b, "check", 14, {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), ImageTransparency = 1})
			optionButtons[e.Title] = {Button = b, Label = lbl, Check = chk}
			b.MouseEnter:Connect(function()
				if not selected[e.Title] then Tween(b, {BackgroundTransparency = 0.92}, 0.12) end
			end)
			b.MouseLeave:Connect(function()
				if not selected[e.Title] then Tween(b, {BackgroundTransparency = 1}, 0.12) end
			end)
			b.MouseButton1Click:Connect(function() toggleOption(e.Title) end)
			styleOption(e, true)
		end
	end

	close = function()
		if not isOpen then return end
		isOpen = false
		Tween(holder, {Size = UDim2.new(1, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quint)
		if chev then Tween(chev, {Rotation = 0}, 0.25) end
	end
	open = function()
		isOpen = true
		rebuild()
		Tween(holder, {Size = UDim2.new(1, 0, 0, currentHeight())}, 0.3, Enum.EasingStyle.Quint)
		if chev then Tween(chev, {Rotation = 180}, 0.25) end
	end

	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		searchText = searchBox.Text
		if isOpen then
			rebuild()
			Tween(holder, {Size = UDim2.new(1, 0, 0, currentHeight())}, 0.2, Enum.EasingStyle.Quint)
		end
	end)

	local function setOptions(list)
		entries, byTitle = {}, {}
		for _, o in ipairs(list or {}) do
			local e
			if type(o) == "table" then
				e = {Title = tostring(o.Title or o.Name or o[1]), Icon = o.Icon, Image = o.Image, IconColor = o.IconColor}
			else
				e = {Title = tostring(o)}
			end
			table.insert(entries, e)
			byTitle[e.Title] = e
		end
		searchBox.Visible = (#entries > 6) or opts.Search == true
	end

	local function set(v, silent)
		selected = {}
		if type(v) == "table" then
			for _, x in ipairs(v) do
				selected[tostring(x)] = true
				if not multi then break end
			end
		elseif v ~= nil then
			selected[tostring(v)] = true
		end
		updateDisplay()
		for _, e in ipairs(entries) do styleOption(e) end
		if not silent then
			W:_changed()
			safe(callback, getValue())
		end
	end

	setOptions(opts.Options or opts.Values)
	set(opts.Default, true)

	W:BindFn(holder, function()
		for _, e in ipairs(entries) do styleOption(e, true) end
	end)

	local obj = {
		Get = getValue,
		Set = function(v, silent) set(v, silent) end,
		Serialize = getValue,
	}
	local flag = W:_register(self, opts, title, obj)
	if flag and W._pending and W._pending[flag] ~= nil then
		set(W._pending[flag], true)
	end

	base.Row.MouseButton1Click:Connect(function()
		if isOpen then close() else open() end
	end)

	if callback then
		task.defer(function()
			local v = getValue()
			if (multi and #v > 0) or (not multi and v ~= nil) then safe(callback, v) end
		end)
	end

	local el = {Type = "Dropdown", Flag = flag}
	function el:Set(v, silent) set(v, silent) end
	function el:Get() return getValue() end
	function el:Open() open() end
	function el:Close() close() end
	function el:Refresh(list)
		setOptions(list)
		for k in pairs(selected) do
			if not byTitle[k] then selected[k] = nil end
		end
		updateDisplay()
		if isOpen then
			rebuild()
			Tween(holder, {Size = UDim2.new(1, 0, 0, currentHeight())}, 0.2, Enum.EasingStyle.Quint)
		end
	end
	return decorate(el, base, W, function() return flag end)
end

function TabClass:CreateKeybind(opts)
	opts = opts or {}
	local W = self.Window
	local T = W.T
	local title = opts.Title or opts.Name or "Keybind"
	local mode = opts.Mode or "Press"
	local base = self:_base(opts, {Interactive = true, RightWidth = 80, RightHeight = 26})

	local pill = Create("Frame", {Size = UDim2.fromScale(1, 1), Parent = base.Right})
	Corner(pill, 6)
	W:Bind(pill, {BackgroundColor3 = "Input"})
	local pillStroke = W:Stroke(pill, "Stroke", 1)
	local lbl = Create("TextLabel", {Size = UDim2.fromScale(1, 1), Text = "", Font = Enum.Font.GothamMedium, TextSize = 12, Parent = pill})
	W:Bind(lbl, {TextColor3 = "Text"})

	local key = normalizeKey(opts.Default)
	local listening, state = false, false

	local function display() lbl.Text = listening and "..." or prettyKey(key) end
	local function setKey(k, silent)
		key = normalizeKey(k)
		display()
		if not silent then
			W:_changed()
			safe(opts.ChangedCallback, key)
		end
	end
	display()

	local obj = {
		Get = function() return key end,
		Set = function(v, silent) setKey(v, silent) end,
		Serialize = function() return key end,
	}
	local flag = W:_register(self, opts, title, obj)
	if flag and W._pending and W._pending[flag] ~= nil then
		key = normalizeKey(W._pending[flag])
		display()
		if opts.ChangedCallback then
			task.defer(function() safe(opts.ChangedCallback, key) end)
		end
	end

	local function stopListening()
		listening = false
		task.defer(function() W._listening = false end)
		Tween(pillStroke, {Color = T.Stroke}, 0.15)
		display()
	end

	base.Row.MouseButton1Click:Connect(function()
		if listening then stopListening() return end
		listening = true
		W._listening = true
		Tween(pillStroke, {Color = T.Accent}, 0.15)
		display()
	end)

	W:_connect(UserInputService.InputBegan, function(input, gp)
		if listening then
			local k
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.Escape then stopListening() return end
				if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
					k = "None"
				else
					k = input.KeyCode.Name
				end
			elseif input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
				k = input.UserInputType.Name
			end
			if k then
				stopListening()
				setKey(k)
			end
			return
		end
		if gp then return end
		if matchesKey(key, input) then
			if mode == "Hold" then
				state = true
				safe(opts.Callback, true)
			elseif mode == "Toggle" then
				state = not state
				safe(opts.Callback, state)
			else
				safe(opts.Callback, key)
			end
		end
	end)
	W:_connect(UserInputService.InputEnded, function(input)
		if mode == "Hold" and state and matchesKey(key, input) then
			state = false
			safe(opts.Callback, false)
		end
	end)

	local el = {Type = "Keybind", Flag = flag}
	function el:Set(v, silent) setKey(v, silent) end
	function el:Get() return key end
	function el:GetState() return state end
	return decorate(el, base, W, function() return flag end)
end

TabClass.AddSection, TabClass.AddParagraph, TabClass.AddButton = TabClass.CreateSection, TabClass.CreateParagraph, TabClass.CreateButton
TabClass.AddToggle, TabClass.AddSlider, TabClass.AddTextbox = TabClass.CreateToggle, TabClass.CreateSlider, TabClass.CreateTextbox
TabClass.AddDropdown, TabClass.AddKeybind = TabClass.CreateDropdown, TabClass.CreateKeybind
TabClass.CreateInput = TabClass.CreateTextbox

function WindowClass:CreateConfigTab(o)
	o = o or {}
	local tab = self:CreateTab({Title = o.Title or "Config", Icon = o.Icon or "save"})
	local selected = self.CurrentConfig

	tab:CreateSection({Title = "Configuration", Icon = "folder"})

	local nameBox = tab:CreateTextbox({
		Title = "Config name", Description = "Name used when saving a config.", Icon = "file-text",
		Default = selected, Placeholder = "my config", Flag = false,
		Callback = function(t) if t ~= "" then selected = t end end,
	})

	local listDD
	listDD = tab:CreateDropdown({
		Title = "Saved configs", Description = "Pick one to load or delete.", Icon = "folder-open",
		Options = self:ListConfigs(), Flag = false, Placeholder = "No config selected",
		Callback = function(v)
			if v then
				selected = v
				nameBox:Set(v, true)
			end
		end,
	})
	table.insert(self._listCallbacks, function() listDD:Refresh(self:ListConfigs()) end)

	tab:CreateButton({Title = "Save config", Description = "Save every setting under the name above.", Icon = "save",
		Callback = function() self:SaveConfig(selected) end})
	tab:CreateButton({Title = "Load config", Description = "Load the selected config.", Icon = "download",
		Callback = function() self:LoadConfig(selected) end})
	tab:CreateButton({Title = "Delete config", Description = "Delete the selected config file.", Icon = "trash-2",
		Callback = function()
			if self:DeleteConfig(selected) then
				self:Notify({Title = "Config deleted", Content = "Deleted \"" .. tostring(selected) .. "\".", Icon = "trash-2"})
			else
				self:Notify({Title = "Config", Content = "Nothing to delete.", Icon = "circle-alert"})
			end
		end})
	tab:CreateButton({Title = "Refresh list", Icon = "refresh-cw",
		Callback = function() listDD:Refresh(self:ListConfigs()) end})

	tab:CreateToggle({
		Title = "Auto save", Description = "Automatically save the current config when something changes.", Icon = "toggle-right",
		Default = self.AutoSave, Flag = false, Callback = function(v) self.AutoSave = v end,
	})

	tab:CreateSection({Title = "Interface", Icon = "palette"})

	local themeNames = {}
	for name in pairs(YzZ.Themes) do table.insert(themeNames, name) end
	table.sort(themeNames)
	tab:CreateDropdown({
		Title = "Theme", Description = "Change the look of the UI.", Icon = "palette",
		Options = themeNames, Default = self.ThemeName or "Dark", Flag = "__Theme",
		Callback = function(v) if v then self:SetTheme(v) end end,
	})
	tab:CreateKeybind({
		Title = "Menu keybind", Description = "Key that opens / closes the GUI. (Backspace = none)", Icon = "keyboard",
		Default = self.Keybind, Flag = "__MenuKey", ChangedCallback = function(k) self.Keybind = k end,
	})
	if self.FloatingButton then
		tab:CreateToggle({
			Title = "Floating button", Description = "Show the draggable circle button.", Icon = "mouse-pointer-click",
			Default = true, Flag = "__FloatBtn", Callback = function(v) self:SetFloatingVisible(v) end,
		})
	end
	return tab
end

function YzZ:CreateWindow(opts)
	opts = opts or {}
	local env = (getgenv and getgenv()) or _G
	if env.__YzZHubWindow then pcall(function() env.__YzZHubWindow:Destroy() end) end

	local Window = setmetatable({}, WindowClass)
	Window.Title = opts.Title or "YzZ Hub"
	Window.SubTitle = opts.SubTitle or ""
	Window.Flags = {}
	Window.Tabs = {}
	Window.T = {}
	Window.Visible = false
	Window.ConfigFolder = opts.ConfigFolder or "YzZHub"
	Window.CurrentConfig = opts.ConfigName or "default"
	Window.AutoSave = opts.AutoSave ~= false
	Window.Keybind = normalizeKey(opts.Keybind or Enum.KeyCode.RightShift)
	Window._binds, Window._conns, Window._listCallbacks = {}, {}, {}
	Window._loading, Window._listening, Window._destroyed = false, false, false
	YzZ.Flags = Window.Flags
	YzZ.CacheFolder = Window.ConfigFolder .. "/cache"
	env.__YzZHubWindow = Window

	Window:SetTheme(opts.Theme or "Dark")
	local T = Window.T
	if opts.Accent then Window:SetAccent(opts.Accent) end
	if opts.AutoLoad ~= false then Window._pending = Window:_readConfig(Window.CurrentConfig) end

	local gui = Create("ScreenGui", {
		Name = "YzZHub_" .. string.sub(HttpService:GenerateGUID(false), 1, 8), ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999, IgnoreGuiInset = true,
	})
	if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
	local mounted = false
	if gethui then mounted = pcall(function() gui.Parent = gethui() end) and gui.Parent ~= nil end
	if not mounted and CoreGui then mounted = pcall(function() gui.Parent = CoreGui end) and gui.Parent ~= nil end
	if not mounted then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
	Window.Gui = gui

	local camera = workspace.CurrentCamera
	local vp = (gui.AbsoluteSize.X > 0 and gui.AbsoluteSize) or (camera and camera.ViewportSize) or Vector2.new(1280, 720)

	local reqSize = opts.Size or UDim2.fromOffset(620, 420)
	local winW = math.min(reqSize.X.Offset, vp.X - 20)
	local winH = math.min(reqSize.Y.Offset, vp.Y - 20)
	Window.Compact = winW < 500
	local sbW = Window.Compact and 128 or 168

	local Main = Create("CanvasGroup", {
		Name = "Main", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(winW, winH), BackgroundColor3 = T.Background, GroupTransparency = 1,
		Visible = false, Parent = gui,
	})
	Corner(Main, 12)
	Window:Bind(Main, {BackgroundColor3 = "Background"})
	Window:Stroke(Main, "Stroke", 1)
	Window._mainScale = Create("UIScale", {Scale = 1, Parent = Main})
	Window.Main = Main

	local top = Create("Frame", {Name = "Topbar", Size = UDim2.new(1, 0, 0, 46), Parent = Main})
	Window:Bind(top, {BackgroundColor3 = "Topbar"})
	local topLine = Create("Frame", {AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 1), Parent = top})
	Window:Bind(topLine, {BackgroundColor3 = "Stroke"})

	local titleX = 14
	local topIcon, topIconCtl = Window:MakeIcon(top, opts.Icon or opts.Image, 26, {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0)}, opts.IconColor)
	if topIcon then
		titleX = 48
		if topIconCtl then Window:BindFn(topIcon, function() topIconCtl.SetColor(T.Accent) end) end
	end

	local titleHolder = Create("Frame", {Position = UDim2.fromOffset(titleX, 0), Size = UDim2.new(1, -(titleX + 90), 1, 0), Parent = top})
	titleHolder.BackgroundTransparency = 1
	Create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = titleHolder,
	})
	Window._titleLabel = Window:Label(titleHolder, Window.Title, 15, "Text", Enum.Font.GothamBold, {
		Size = UDim2.new(0, 0, 0, 20), AutomaticSize = Enum.AutomaticSize.X, TextWrapped = false,
		TextYAlignment = Enum.TextYAlignment.Center, LayoutOrder = 1,
	})
	Window._subLabel = Window:Label(titleHolder, Window.SubTitle, 12, "SubText", Enum.Font.Gotham, {
		Size = UDim2.new(0, 0, 0, 16), AutomaticSize = Enum.AutomaticSize.X, TextWrapped = false,
		TextYAlignment = Enum.TextYAlignment.Center, LayoutOrder = 2,
	})

	local btnHolder = Create("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(62, 28), Parent = top})
	btnHolder.BackgroundTransparency = 1
	Create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder, Parent = btnHolder,
	})
	local function topButton(iconName, order, cb)
		local b = Create("TextButton", {Size = UDim2.fromOffset(28, 28), Text = "", BackgroundTransparency = 1, LayoutOrder = order, Parent = btnHolder})
		Corner(b, 7)
		Window:Bind(b, {BackgroundColor3 = "ElementHover"})
		local ic, ctl = Window:MakeIcon(b, iconName, 16, {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5)})
		if ic and ctl then Window:BindFn(ic, function() ctl.SetColor(T.SubText) end) end
		b.MouseEnter:Connect(function() Tween(b, {BackgroundTransparency = 0}, 0.15) end)
		b.MouseLeave:Connect(function() Tween(b, {BackgroundTransparency = 1}, 0.15) end)
		b.MouseButton1Click:Connect(cb)
		return b
	end
	topButton("minus", 1, function() Window:SetVisible(false) end)
	topButton("x", 2, function()
		Window:Dialog({
			Title = "Close " .. Window.Title .. "?",
			Content = "This removes the GUI completely. Your config is saved first.",
			Buttons = {
				{Title = "Cancel"},
				{Title = "Close", Primary = true, Callback = function() Window:Destroy() end},
			},
		})
	end)

	MakeDraggable(Window, top, Main)

	local body = Create("Frame", {Name = "Body", Position = UDim2.fromOffset(0, 46), Size = UDim2.new(1, 0, 1, -46), Parent = Main})
	body.BackgroundTransparency = 1

	local sidebar = Create("Frame", {Name = "Sidebar", Size = UDim2.new(0, sbW, 1, 0), Parent = body})
	Window:Bind(sidebar, {BackgroundColor3 = "Sidebar"})
	local sbLine = Create("Frame", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 1, 1, 0), Parent = sidebar})
	Window:Bind(sbLine, {BackgroundColor3 = "Stroke"})

	local showProfile = opts.ShowProfile ~= false
	local profileH = showProfile and 52 or 0

	local tabList = Create("ScrollingFrame", {
		Name = "Tabs", Size = UDim2.new(1, 0, 1, -profileH), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 0, Parent = sidebar,
	})
	Pad(tabList, 8, 10, 9, 8)
	Create("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = tabList})
	Window._tabList = tabList

	if showProfile then
		local prof = opts.Profile or {}
		local pf = Create("Frame", {Name = "Profile", AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, profileH), Parent = sidebar})
		pf.BackgroundTransparency = 1
		local pfLine = Create("Frame", {Size = UDim2.new(1, 0, 0, 1), Parent = pf})
		Window:Bind(pfLine, {BackgroundColor3 = "Stroke"})

		local avatarSrc = prof.Image
		if not avatarSrc and LocalPlayer then
			avatarSrc = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
		end
		local av = Window:MakeIcon(pf, avatarSrc, 32, {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0), ScaleType = Enum.ScaleType.Crop})
		if av then
			Corner(av)
			Window:Bind(av, {BackgroundColor3 = "Element"})
			av.BackgroundTransparency = 0
			Window:Stroke(av, "Stroke", 1)
		end
		local nameText = prof.Title or (LocalPlayer and LocalPlayer.DisplayName) or "Player"
		local subText = prof.Subtitle or (LocalPlayer and ("@" .. LocalPlayer.Name)) or ""
		Window:Label(pf, nameText, 12, "Text", Enum.Font.GothamMedium, {
			Position = UDim2.fromOffset(52, 10), Size = UDim2.new(1, -58, 0, 16), TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd,
		})
		Window:Label(pf, subText, 11, "SubText", Enum.Font.Gotham, {
			Position = UDim2.fromOffset(52, 27), Size = UDim2.new(1, -58, 0, 14), TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd,
		})
	end

	local content = Create("Frame", {Name = "Content", Position = UDim2.fromOffset(sbW, 0), Size = UDim2.new(1, -sbW, 1, 0), ClipsDescendants = true, Parent = body})
	content.BackgroundTransparency = 1
	Window._content = content
	local cover = Create("Frame", {Name = "Cover", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 20, Parent = content})
	Window:Bind(cover, {BackgroundColor3 = "Background"})
	Window._cover = cover

	local notifyHolder = Create("Frame", {
		Name = "Notifications", AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16),
		Size = UDim2.new(0, Window.Compact and 250 or 290, 1, -32), Parent = gui,
	})
	notifyHolder.BackgroundTransparency = 1
	Create("UIListLayout", {
		Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom,
		HorizontalAlignment = Enum.HorizontalAlignment.Right, Parent = notifyHolder,
	})
	Window._notifyHolder = notifyHolder

	Window:_connect(UserInputService.InputBegan, function(input, gp)
		if gp or Window._listening then return end
		if matchesKey(Window.Keybind, input) then Window:Toggle() end
	end)

	if opts.FloatingButton ~= false then
		local fb = type(opts.FloatingButton) == "table" and opts.FloatingButton or {}
		local fsize = fb.Size or 56
		local floatBtn = Create("TextButton", {
			Name = "FloatingButton", Size = UDim2.fromOffset(fsize, fsize),
			Position = fb.Position or UDim2.fromOffset(16, math.floor(vp.Y * 0.42)), Text = "",
			BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0, ZIndex = 50, Parent = gui,
		})
		Corner(floatBtn)
		local grad = Create("UIGradient", {Rotation = 45, Parent = floatBtn})
		Window:BindFn(floatBtn, function() grad.Color = ColorSequence.new(T.Accent, T.AccentDark) end)
		local fstroke = Create("UIStroke", {Thickness = 2, Transparency = 0.25, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = floatBtn})
		local fscale = Create("UIScale", {Scale = 0, Parent = floatBtn})

		local ficon, fctl
		if fb.Text then
			Create("TextLabel", {
				Size = UDim2.fromScale(1, 1), Text = tostring(fb.Text), Font = Enum.Font.GothamBold, TextSize = math.floor(fsize * 0.38),
				TextColor3 = Color3.new(1, 1, 1), Parent = floatBtn,
			})
		else
			ficon, fctl = Window:MakeIcon(floatBtn, fb.Image or fb.Icon or opts.Icon or "sparkles", math.floor(fsize * 0.5),
				{AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5)}, fb.IconColor)
			if fctl and not fctl.Locked then fctl.SetColor(Color3.new(1, 1, 1)) end
		end

		Window.FloatingButton = floatBtn
		Tween(fscale, {Scale = 1}, 0.6, Enum.EasingStyle.Back)

		Window._floatUpdate = function(open)
			Tween(fstroke, {Transparency = open and 0 or 0.25}, 0.25)
			fstroke.Color = open and Color3.new(1, 1, 1) or T.Accent:Lerp(Color3.new(1, 1, 1), 0.35)
			if ficon then Tween(ficon, {Rotation = open and 180 or 0}, 0.45, Enum.EasingStyle.Back) end
		end

		floatBtn.MouseEnter:Connect(function() Tween(fscale, {Scale = 1.08}, 0.2, Enum.EasingStyle.Back) end)
		floatBtn.MouseLeave:Connect(function() Tween(fscale, {Scale = 1}, 0.2) end)

		MakeDraggable(Window, floatBtn, floatBtn, {
			Clamp = function(x, y)
				local s = gui.AbsoluteSize
				return math.clamp(x, 0, math.max(s.X - fsize, 0)), math.clamp(y, 0, math.max(s.Y - fsize, 0))
			end,
			OnBegin = function() Tween(fscale, {Scale = 0.9}, 0.1) end,
			OnEnd = function(moved)
				Tween(fscale, {Scale = 1}, 0.25, Enum.EasingStyle.Back)
				if not moved then Window:Toggle() end
			end,
		})
	end

	if opts.Open ~= false then
		task.defer(function() Window:SetVisible(true) end)
	end

	return Window
end

return YzZ
