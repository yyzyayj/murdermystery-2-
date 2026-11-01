local cloneref = cloneref or function(x) return x end
local function getService(name) return cloneref(game:GetService(name)) end

local Players = getService("Players")
local TweenService = getService("TweenService")
local UserInputService = getService("UserInputService")
local HttpService = getService("HttpService")
local RunService = getService("RunService")
local GuiService = getService("GuiService")
local Lighting = getService("Lighting")
local CoreGui
pcall(function() CoreGui = getService("CoreGui") end)
local LocalPlayer = Players.LocalPlayer

local ICON_DATA = {}

local YzZ = {
    Version = "2.0.0",
    Flags = {},
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
local WHITE, BLACK = Color3.new(1, 1, 1), Color3.new(0, 0, 0)

local function luminance(c) return c.R * 0.299 + c.G * 0.587 + c.B * 0.114 end

local function buildTheme(o)
    o = o or {}
    local light = o.Light == true
    local bg = o.Background or rgb(14, 14, 20)
    local accent = o.Accent or rgb(139, 92, 246)
    local t = {Light = light, Name = o.Name, Background = bg}
    if light then
        t.Topbar = o.Topbar or bg:Lerp(WHITE, 0.65)
        t.Sidebar = o.Sidebar or bg:Lerp(BLACK, 0.035)
        t.Element = o.Element or bg:Lerp(WHITE, 0.8)
        t.ElementHover = o.ElementHover or bg:Lerp(BLACK, 0.05)
        t.Stroke = o.Stroke or bg:Lerp(BLACK, 0.11)
        t.Text = o.Text or rgb(22, 22, 32)
        t.SubText = o.SubText or bg:Lerp(BLACK, 0.55)
        t.ToggleOff = o.ToggleOff or bg:Lerp(BLACK, 0.17)
        t.Input = o.Input or bg:Lerp(WHITE, 0.55)
    else
        t.Topbar = o.Topbar or bg:Lerp(WHITE, 0.03)
        t.Sidebar = o.Sidebar or bg:Lerp(BLACK, 0.22)
        t.Element = o.Element or bg:Lerp(WHITE, 0.06)
        t.ElementHover = o.ElementHover or bg:Lerp(WHITE, 0.105)
        t.Stroke = o.Stroke or bg:Lerp(WHITE, 0.13)
        t.Text = o.Text or rgb(244, 244, 250)
        t.SubText = o.SubText or bg:Lerp(WHITE, 0.58)
        t.ToggleOff = o.ToggleOff or bg:Lerp(WHITE, 0.2)
        t.Input = o.Input or bg:Lerp(BLACK, 0.25)
    end
    t.Accent = accent
    t.Accent2 = o.Accent2 or accent:Lerp(WHITE, 0.3)
    t.AccentDark = o.AccentDark or accent:Lerp(BLACK, 0.4)
    t.OnAccent = o.OnAccent or ((luminance(accent) > 0.62) and rgb(20, 20, 28) or WHITE)
    t.Success = o.Success or rgb(52, 211, 153)
    t.Warning = o.Warning or rgb(251, 191, 36)
    t.Danger = o.Danger or rgb(248, 81, 97)
    t.FX = o.FX or {}
    return t
end

YzZ.Themes = {}
YzZ.ThemeOrder = {}

function YzZ:AddTheme(name, spec)
    spec = spec or {}
    spec.Name = name
    YzZ.Themes[name] = buildTheme(spec)
    local known = false
    for _, n in ipairs(YzZ.ThemeOrder) do if n == name then known = true break end end
    if not known then table.insert(YzZ.ThemeOrder, name) end
    return YzZ.Themes[name]
end

YzZ:AddTheme("Dark", {
    Background = rgb(15, 15, 22), Accent = rgb(139, 92, 246), Accent2 = rgb(217, 70, 239),
    FX = {Aurora = true, Border = "Flow", Shimmer = true},
})
YzZ:AddTheme("Midnight", {
    Background = rgb(8, 10, 19), Accent = rgb(96, 165, 250), Accent2 = rgb(167, 139, 250),
    FX = {Particles = "Stars", Border = "Flow", Shimmer = true},
})
YzZ:AddTheme("Ocean", {
    Background = rgb(10, 17, 28), Accent = rgb(56, 189, 248), Accent2 = rgb(45, 212, 191),
    FX = {Aurora = true, Particles = "Bubbles"},
})
YzZ:AddTheme("Crimson", {
    Background = rgb(19, 12, 15), Accent = rgb(244, 63, 94), Accent2 = rgb(249, 115, 22),
    FX = {Particles = "Embers", Border = "Flow"},
})
YzZ:AddTheme("Emerald", {
    Background = rgb(10, 18, 16), Accent = rgb(52, 211, 153), Accent2 = rgb(163, 230, 53),
    FX = {Aurora = true, Shimmer = true},
})
YzZ:AddTheme("Sakura", {
    Background = rgb(24, 15, 22), Accent = rgb(244, 114, 182), Accent2 = rgb(253, 164, 175),
    FX = {Aurora = true, Particles = "Petals"},
})
YzZ:AddTheme("Cyberpunk", {
    Background = rgb(10, 8, 17), Accent = rgb(250, 204, 21), Accent2 = rgb(236, 72, 153),
    FX = {Scan = true, Particles = "Rain", Border = "Flow"},
})
YzZ:AddTheme("Synthwave", {
    Background = rgb(20, 10, 36), Accent = rgb(236, 72, 153), Accent2 = rgb(34, 211, 238),
    FX = {Aurora = true, Scan = true, Border = "Rainbow"},
})
YzZ:AddTheme("Galaxy", {
    Background = rgb(6, 6, 18), Accent = rgb(129, 140, 248), Accent2 = rgb(232, 121, 249),
    FX = {Aurora = true, Particles = "Stars", Border = "Flow"},
})
YzZ:AddTheme("Inferno", {
    Background = rgb(20, 10, 8), Accent = rgb(249, 115, 22), Accent2 = rgb(250, 204, 21),
    FX = {Aurora = true, Particles = "Embers"},
})
YzZ:AddTheme("Matrix", {
    Background = rgb(4, 12, 6), Accent = rgb(34, 197, 94), Accent2 = rgb(134, 239, 172),
    FX = {Particles = "Code", Scan = true},
})
YzZ:AddTheme("Glacier", {
    Background = rgb(11, 19, 30), Accent = rgb(125, 211, 252), Accent2 = rgb(196, 181, 253),
    FX = {Particles = "Snow", Shimmer = true},
})
YzZ:AddTheme("Amethyst", {
    Background = rgb(18, 12, 29), Accent = rgb(192, 132, 252), Accent2 = rgb(244, 114, 182),
    FX = {Aurora = true, Particles = "Bubbles", Border = "Flow"},
})
YzZ:AddTheme("Sunset", {
    Background = rgb(24, 14, 22), Accent = rgb(251, 113, 133), Accent2 = rgb(251, 146, 60),
    FX = {Aurora = true, Border = "Flow"},
})
YzZ:AddTheme("Mocha", {
    Background = rgb(30, 30, 46), Accent = rgb(203, 166, 247), Accent2 = rgb(245, 194, 231),
    Text = rgb(205, 214, 244), FX = {Shimmer = true},
})
YzZ:AddTheme("Nord", {
    Background = rgb(46, 52, 64), Accent = rgb(136, 192, 208), Accent2 = rgb(129, 161, 193),
    Text = rgb(236, 239, 244), FX = {Shimmer = true},
})
YzZ:AddTheme("Dracula", {
    Background = rgb(40, 42, 54), Accent = rgb(189, 147, 249), Accent2 = rgb(255, 121, 198),
    Text = rgb(248, 248, 242), FX = {Border = "Flow"},
})
YzZ:AddTheme("Monochrome", {
    Background = rgb(0, 0, 0), Accent = rgb(232, 232, 238), Accent2 = rgb(150, 150, 162),
    Element = rgb(16, 16, 18), ElementHover = rgb(28, 28, 32), Sidebar = rgb(6, 6, 7),
    Topbar = rgb(9, 9, 10), FX = {Border = "Flow"},
})
YzZ:AddTheme("Light", {
    Light = true, Background = rgb(243, 244, 250), Accent = rgb(99, 102, 241), Accent2 = rgb(168, 85, 247),
    FX = {Shimmer = true},
})
YzZ:AddTheme("Lavender", {
    Light = true, Background = rgb(246, 243, 255), Accent = rgb(139, 92, 246), Accent2 = rgb(236, 72, 153),
    FX = {Aurora = true},
})
YzZ:AddTheme("Paper", {
    Light = true, Background = rgb(250, 247, 241), Accent = rgb(217, 119, 6), Accent2 = rgb(244, 63, 94),
    FX = {Shimmer = true},
})

local function resolveTheme(t)
    if type(t) == "string" and YzZ.Themes[t] then return YzZ.Themes[t] end
    if type(t) == "table" then return buildTheme(t) end
    return YzZ.Themes.Dark
end

YzZ.Icons = {}

function YzZ:AddIcons(tbl)
    for name, value in pairs(tbl or {}) do
        YzZ.Icons[string.lower(tostring(name))] = value
    end
end

local ICON_URL = "https://raw.githubusercontent.com/yyzyayj/Steal-an-egg/refs/heads/main/icons.lua"
local PACK_ORDER = {"lucide", "solar", "sfsymbols", "gravity", "craft", "geist"}
local PACK_SET = {lucide = true, solar = true, sfsymbols = true, gravity = true, craft = true, geist = true}
local packCache = {}

local function fetchIconData()
    local source = game:HttpGet(ICON_URL)
    if type(source) ~= "string" or source == "" then
        error("Icon source returned empty content")
    end
    local compiler = loadstring or load
    if type(compiler) ~= "function" then
        error("Dynamic Lua compilation is unavailable")
    end
    local chunk, compileError = compiler(source)
    if type(chunk) ~= "function" then
        error(compileError or "Icon source could not be compiled")
    end
    local data = chunk()
    if type(data) ~= "table" then
        error("Icon source did not return a table")
    end
    return data
end

local iconsLoaded, iconData = pcall(fetchIconData)
if iconsLoaded and type(iconData) == "table" then
    ICON_DATA = iconData
end

local function loadPack(name)
    local cached = packCache[name]
    if cached then return cached end
    local pack = {}
    packCache[name] = pack
    local data = ICON_DATA and ICON_DATA[name]
    if type(data) ~= "table" then return pack end

    local sheets = data.Spritesheets
    local icons = data.Icons
    if type(sheets) == "table" and type(icons) == "table" then
        for key, value in pairs(icons) do
            if type(value) == "table" then
                local sheetKey = tostring(value.Image or 1)
                local image = sheets[sheetKey] or sheets[value.Image] or ""
                pack[key] = {
                    Image = image,
                    ImageRectOffset = value.ImageRectPosition or value.ImageRectOffset,
                    ImageRectSize = value.ImageRectSize,
                    Parts = value.Parts,
                }
            elseif type(value) == "string" or type(value) == "number" then
                pack[key] = value
            end
        end
    else
        for key, value in pairs(data) do
            if type(key) == "string" and (type(value) == "string" or type(value) == "number" or type(value) == "table") then
                pack[key] = value
            end
        end
    end
    return pack
end

local function normalizeIcon(v)
    if type(v) == "number" then return "rbxassetid://" .. v end
    return v
end

local function lookupIcon(key)
    local f = YzZ.Icons[key]
    if f ~= nil then return normalizeIcon(f) end
    local set, name = string.match(key, "^([%w_]+):(.+)$")
    if set and PACK_SET[set] then
        local v = loadPack(set)[name]
        if v ~= nil then return v end
        local b = YzZ.Icons[name]
        if b ~= nil then return normalizeIcon(b) end
        return nil
    end
    if #key <= 2 then return nil end
    for _, s in ipairs(PACK_ORDER) do
        local v = loadPack(s)[key]
        if v ~= nil then return v end
    end
    return nil
end

function YzZ:GetIcon(name)
    if type(name) ~= "string" then return nil end
    local key = string.lower(name)
    key = key:gsub("^icon:", "")
    return lookupIcon(key)
end

function YzZ:SearchIcons(query, limit, set)
    query = string.lower(tostring(query or ""))
    limit = limit or 60
    local out = {}
    local sets = set and {set} or PACK_ORDER
    for _, s in ipairs(sets) do
        if PACK_SET[s] then
            for name in pairs(loadPack(s)) do
                if query == "" or string.find(name, query, 1, true) then
                    table.insert(out, s .. ":" .. name)
                    if #out >= limit then table.sort(out) return out end
                end
            end
        end
    end
    table.sort(out)
    return out
end

function YzZ:ListIconSets()
    return {unpack(PACK_ORDER)}
end

local transparentClasses = {
    TextLabel = true, TextButton = true, ImageLabel = true, ImageButton = true, ScrollingFrame = true,
}
local textClasses = {TextLabel = true, TextButton = true, TextBox = true}

local function Create(class, props, children)
    local obj = Instance.new(class)
    if obj:IsA("GuiObject") then
        obj.BorderSizePixel = 0
        if transparentClasses[class] then obj.BackgroundTransparency = 1 end
    end
    if obj:IsA("GuiButton") then obj.AutoButtonColor = false end
    if textClasses[class] then
        obj.Font = Enum.Font.Gotham
        obj.Text = ""
        obj.TextSize = 13
    end
    local parent
    for k, v in pairs(props or {}) do
        if k == "Parent" then parent = v else obj[k] = v end
    end
    for _, c in ipairs(children or {}) do c.Parent = obj end
    if parent then obj.Parent = parent end
    return obj
end

local EASE_OUT, EASE_IN = Enum.EasingDirection.Out, Enum.EasingDirection.In

local function Tween(obj, props, time, style, dir, delay)
    local tw = TweenService:Create(obj,
        TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quint, dir or EASE_OUT, 0, false, delay or 0), props)
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
    key = key:gsub("^icon:", "")
    local found = lookupIcon(key)
    if found ~= nil then return "named", found end
    return "text", src
end

local function Ripple(host, px, py, color, scale)
    if not host or not host.Parent then return end
    scale = (scale and scale > 0) and scale or 1
    local ap, as = host.AbsolutePosition, host.AbsoluteSize
    local inset = GuiService:GetGuiInset()
    local x, y
    if px and py then
        x, y = px - ap.X, (py + inset.Y) - ap.Y
        if x < -10 or y < -10 or x > as.X + 10 or y > as.Y + 10 then x, y = as.X / 2, as.Y / 2 end
    else
        x, y = as.X / 2, as.Y / 2
    end
    local d = (math.max(as.X, as.Y) * 2.2) / scale
    local c = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(x / scale, y / scale),
        Size = UDim2.fromOffset(0, 0), BackgroundColor3 = color, BackgroundTransparency = 0.8, ZIndex = 5, Parent = host,
    })
    Corner(c)
    Tween(c, {Size = UDim2.fromOffset(d, d), BackgroundTransparency = 1}, 0.6, Enum.EasingStyle.Quad)
    task.delay(0.65, function() if c.Parent then c:Destroy() end end)
end

local function centerOf(inst)
    return inst.AbsolutePosition + inst.AbsoluteSize * inst.AnchorPoint
end

local function MakeDraggable(Window, handle, target, o)
    o = o or {}
    local follow = o.Follow or 26
    local dragging, moved = false, false
    local dragInput, startMouse, startCenter, goal, cur, hb, threshold

    local function finish()
        if not dragging then return end
        dragging = false
        if hb then hb:Disconnect() hb = nil end
        if moved then
            if o.OnEnd then
                o.OnEnd(true, goal)
            else
                Tween(target, {Position = UDim2.fromOffset(goal.X, goal.Y)}, 0.14, Enum.EasingStyle.Quad)
            end
        elseif o.OnEnd then
            o.OnEnd(false, cur)
        end
    end

    handle.InputBegan:Connect(function(input)
        local ut = input.UserInputType
        if ut ~= Enum.UserInputType.MouseButton1 and ut ~= Enum.UserInputType.Touch then return end
        if dragging then return end
        if o.CanDrag and not o.CanDrag() then return end
        dragging, moved = true, false
        dragInput = input
        threshold = (ut == Enum.UserInputType.Touch) and 7 or 4
        startMouse = Vector2.new(input.Position.X, input.Position.Y)
        startCenter = centerOf(target)
        goal, cur = startCenter, startCenter
        if o.OnBegin then o.OnBegin() end
        hb = RunService.Heartbeat:Connect(function(dt)
            local st = dragInput.UserInputState
            if st == Enum.UserInputState.End or st == Enum.UserInputState.Cancel then
                finish()
                return
            end
            if not moved then return end
            cur = cur:Lerp(goal, 1 - math.exp(-dt * follow))
            target.Position = UDim2.fromOffset(cur.X, cur.Y)
        end)
    end)

    Window:_connect(UserInputService.InputChanged, function(input)
        if not dragging then return end
        local isMove
        if dragInput.UserInputType == Enum.UserInputType.Touch then
            isMove = (input == dragInput)
        else
            isMove = (input.UserInputType == Enum.UserInputType.MouseMovement)
        end
        if not isMove then return end
        local delta = Vector2.new(input.Position.X, input.Position.Y) - startMouse
        if not moved and delta.Magnitude >= threshold then moved = true end
        if moved then
            local g = startCenter + delta
            if o.Clamp then
                local cx, cy = o.Clamp(g.X, g.Y)
                g = Vector2.new(cx, cy)
            end
            goal = g
        end
    end)

    Window:_connect(UserInputService.InputEnded, function(input)
        if not dragging then return end
        if input == dragInput
            or (dragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseButton1) then
            finish()
        end
    end)

    return {IsDragging = function() return dragging end}
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
        for prop, key in pairs(map) do
            if self._themeTween and inst.Parent then
                Tween(inst, {[prop] = T[key]}, 0.45, Enum.EasingStyle.Quad)
            else
                inst[prop] = T[key]
            end
        end
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
    if self._binds then
        self._themeTween = self._built == true
        self:_applyBinds()
        self._themeTween = false
        self:_applyFX()
    end
end

function WindowClass:SetAccent(color)
    self.T.Accent = color
    self.T.Accent2 = color:Lerp(WHITE, 0.3)
    self.T.AccentDark = color:Lerp(BLACK, 0.4)
    self.T.OnAccent = (luminance(color) > 0.62) and rgb(20, 20, 28) or WHITE
    self._themeTween = self._built == true
    self:_applyBinds()
    self._themeTween = false
    self:_applyFX()
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

function WindowClass:Stroke(parent, colorKey, thickness, transparency)
    local s = Create("UIStroke", {
        Thickness = thickness or 1, Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = parent,
    })
    self:Bind(s, {Color = colorKey or "Stroke"})
    return s
end

function WindowClass:_scale()
    local us = self._userScale and self._userScale.Scale or 1
    local ms = self._mainScale and self._mainScale.Scale or 1
    return us * ms
end

function WindowClass:Ripple(host, x, y, color)
    Ripple(host, x, y, color or self.T.Accent, self:_scale())
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
    local extras = {}

    if kind == "text" then
        icon.ImageTransparency = 1
        label = Create("TextLabel", {
            Size = UDim2.fromScale(1, 1), Text = value, TextScaled = true,
            Font = Enum.Font.GothamBold, TextColor3 = WHITE, Parent = icon,
        })
    elseif kind == "url" then
        loadUrlImage(value, function(asset) icon.Image = asset end)
    else
        if type(value) == "table" then
            icon.Image = value.Image or value[1] or ""
            local off = value.ImageRectOffset or value.ImageRectPosition
            if off then icon.ImageRectOffset = off end
            if value.ImageRectSize then icon.ImageRectSize = value.ImageRectSize end
            if value.Parts and (value.Image ~= nil) then
                local set = string.match(tostring(src), "^([%w_]+):")
                for _, partName in ipairs(value.Parts) do
                    local part
                    if set and PACK_SET[set] then part = loadPack(set)[partName] end
                    if not part then
                        for _, s in ipairs({"geist", "craft"}) do
                            part = loadPack(s)[partName]
                            if part then break end
                        end
                    end
                    if type(part) == "table" then
                        local extra = Create("ImageLabel", {
                            Name = "Part", Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Fit,
                            Image = part.Image, ImageRectOffset = part.ImageRectOffset, ImageRectSize = part.ImageRectSize,
                            Parent = icon,
                        })
                        table.insert(extras, extra)
                    end
                end
            end
        else
            icon.Image = value
        end
    end

    function ctl.SetColor(c, animate)
        if ctl.Locked then return end
        if label then
            label.TextColor3 = c
        elseif ctl.Tint then
            if animate then Tween(icon, {ImageColor3 = c}, 0.2) else icon.ImageColor3 = c end
            for _, e in ipairs(extras) do e.ImageColor3 = c end
        end
    end

    if lockColor then
        if label then label.TextColor3 = lockColor else
            icon.ImageColor3 = lockColor
            for _, e in ipairs(extras) do e.ImageColor3 = lockColor end
        end
    end

    icon.Parent = parent
    return icon, ctl
end

local function rnd(a, b) return a + (b - a) * math.random() end

local PARTICLE_COUNT = {Stars = 42, Embers = 24, Petals = 16, Snow = 30, Bubbles = 14, Rain = 18, Code = 22}
local CODE_CHARS = "01ABCDEFXYZ$#@+<>/=*"

local ParticleKinds = {}

ParticleKinds.Stars = function(layer, T)
    local size = rnd(1.5, 3.2)
    local obj = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(size, size),
        BackgroundColor3 = (math.random() < 0.3) and T.Accent2 or WHITE, Parent = layer,
    })
    Corner(obj)
    local p = {obj = obj, ph = rnd(0, 6.28), sp = rnd(0.8, 2.6)}
    obj.Position = UDim2.fromScale(math.random(), math.random())
    function p:step(dt, t)
        obj.BackgroundTransparency = 0.25 + 0.7 * (0.5 + 0.5 * math.sin(t * self.sp + self.ph))
    end
    return p
end

ParticleKinds.Embers = function(layer, T)
    local size = rnd(2, 4.5)
    local obj = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(size, size),
        BackgroundColor3 = (math.random() < 0.5) and T.Accent or T.Accent2, Parent = layer,
    })
    Corner(obj)
    local p = {obj = obj, x0 = math.random(), y = math.random(), vy = rnd(0.05, 0.14), ph = rnd(0, 6.28), sw = rnd(0.01, 0.035)}
    function p:step(dt, t)
        self.y = self.y - self.vy * dt
        if self.y < -0.05 then self.y = 1.05 self.x0 = math.random() end
        obj.Position = UDim2.fromScale(self.x0 + math.sin(t * 0.9 + self.ph) * self.sw, self.y)
        obj.BackgroundTransparency = math.clamp(0.15 + (1 - self.y) * 0.85, 0, 1)
    end
    return p
end

ParticleKinds.Petals = function(layer, T)
    local colors = {T.Accent, T.Accent2, WHITE:Lerp(T.Accent, 0.5)}
    local obj = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(rnd(6, 9), rnd(4, 6)),
        BackgroundColor3 = colors[math.random(1, #colors)], BackgroundTransparency = 0.3, Parent = layer,
    })
    Corner(obj, 3)
    local p = {obj = obj, x = math.random(), y = math.random(), vy = rnd(0.05, 0.11), vx = rnd(0.015, 0.04),
        ph = rnd(0, 6.28), rot = rnd(0, 360), rv = rnd(-90, 90)}
    function p:step(dt, t)
        self.y = self.y + self.vy * dt
        self.x = self.x - (self.vx + math.sin(t + self.ph) * 0.01) * dt
        if self.y > 1.05 then self.y = -0.05 self.x = rnd(0.1, 1.2) end
        if self.x < -0.05 then self.x = 1.05 end
        self.rot = self.rot + self.rv * dt
        obj.Rotation = self.rot
        obj.Position = UDim2.fromScale(self.x, self.y)
    end
    return p
end

ParticleKinds.Snow = function(layer, T)
    local size = rnd(2, 4.5)
    local obj = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(size, size),
        BackgroundColor3 = WHITE, BackgroundTransparency = rnd(0.25, 0.55), Parent = layer,
    })
    Corner(obj)
    local p = {obj = obj, x0 = math.random(), y = math.random(), vy = rnd(0.04, 0.1), ph = rnd(0, 6.28), sw = rnd(0.01, 0.03)}
    function p:step(dt, t)
        self.y = self.y + self.vy * dt
        if self.y > 1.05 then self.y = -0.05 self.x0 = math.random() end
        obj.Position = UDim2.fromScale(self.x0 + math.sin(t * 0.7 + self.ph) * self.sw, self.y)
    end
    return p
end

ParticleKinds.Bubbles = function(layer, T)
    local size = rnd(6, 20)
    local obj = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, Parent = layer,
    })
    Corner(obj)
    local stroke = Create("UIStroke", {Thickness = 1, Color = T.Accent2, Transparency = 0.5, Parent = obj})
    local p = {obj = obj, x0 = math.random(), y = math.random(), vy = rnd(0.04, 0.1), ph = rnd(0, 6.28), sw = rnd(0.01, 0.03)}
    function p:step(dt, t)
        self.y = self.y - self.vy * dt
        if self.y < -0.05 then self.y = 1.05 self.x0 = math.random() end
        obj.Position = UDim2.fromScale(self.x0 + math.sin(t * 0.8 + self.ph) * self.sw, self.y)
        stroke.Transparency = math.clamp(0.35 + (1 - self.y) * 0.65, 0, 1)
    end
    return p
end

ParticleKinds.Rain = function(layer, T)
    local obj = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(1, rnd(10, 22)),
        BackgroundColor3 = T.Accent2, BackgroundTransparency = 0.55, Parent = layer,
    })
    local p = {obj = obj, x = math.random(), y = math.random() * 1.2 - 0.1, vy = rnd(0.5, 1.0)}
    function p:step(dt)
        self.y = self.y + self.vy * dt
        if self.y > 1.1 then self.y = -0.1 self.x = math.random() end
        obj.Position = UDim2.fromScale(self.x, self.y)
    end
    return p
end

ParticleKinds.Code = function(layer, T)
    local function char()
        local i = math.random(1, #CODE_CHARS)
        return string.sub(CODE_CHARS, i, i)
    end
    local obj = Create("TextLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(14, 14), Text = char(), TextSize = 13,
        Font = Enum.Font.Code, TextColor3 = T.Accent, Parent = layer,
    })
    local p = {obj = obj, x = math.random(), y = math.random(), vy = rnd(0.12, 0.3), timer = 0}
    function p:step(dt)
        self.y = self.y + self.vy * dt
        if self.y > 1.05 then self.y = -0.05 self.x = math.random() end
        self.timer = self.timer + dt
        if self.timer > 0.18 then self.timer = 0 obj.Text = char() end
        obj.Position = UDim2.fromScale(self.x, self.y)
        obj.TextTransparency = math.clamp(0.1 + (1 - self.y) * 0.55, 0, 1)
    end
    return p
end

local function makeBlob(layer, color, d, layers, alpha)
    local holder = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(d, d), BackgroundTransparency = 1, Parent = layer,
    })
    for i = 1, layers do
        local f = 1 - (i - 1) / layers
        local c = Create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(f, f),
            BackgroundColor3 = color, BackgroundTransparency = 1 - alpha, Parent = holder,
        })
        Corner(c)
    end
    return holder
end

function WindowClass:_clearFX()
    if self._fxLayer then
        for _, c in ipairs(self._fxLayer:GetChildren()) do c:Destroy() end
    end
    self._fx = {blobs = {}, particles = {}, scan = nil}
end

function WindowClass:_applyFX()
    if not self._built or self._destroyed then return end
    self:_clearFX()
    local T = self.T
    local fx = T.FX or {}
    local q = self.EffectQuality
    local on = (q ~= "Off")
    local hi = (q == "High")
    local layer = self._fxLayer
    local intensity = fx.Intensity or 1
    local anyBG = false

    if on and fx.Aurora then
        anyBG = true
        local base = math.max(self._winW or 620, self._winH or 420)
        local specs = {
            {color = T.Accent, size = 0.95, cx = 0.12, cy = 0.15, ax = 0.10, ay = 0.09, sx = 0.31, sy = 0.23, ph = 0.0},
            {color = T.Accent2, size = 0.85, cx = 0.88, cy = 0.85, ax = 0.12, ay = 0.10, sx = 0.26, sy = 0.34, ph = 2.1},
            {color = T.AccentDark:Lerp(T.Accent, 0.4), size = 0.7, cx = 0.55, cy = 0.45, ax = 0.20, ay = 0.15, sx = 0.20, sy = 0.29, ph = 4.2},
        }
        local count = hi and 3 or 2
        local layers = hi and 9 or 5
        local alpha = (hi and 0.04 or 0.065) * intensity
        for i = 1, count do
            local s = specs[i]
            local holder = makeBlob(layer, s.color, base * s.size, layers, alpha)
            s.holder = holder
            table.insert(self._fx.blobs, s)
        end
    end

    if on and fx.Scan then
        anyBG = true
        local band = Create("Frame", {Size = UDim2.new(1, 0, 0, 90), BackgroundColor3 = T.Accent, Parent = layer})
        Create("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.92), NumberSequenceKeypoint.new(1, 1),
            }),
            Parent = band,
        })
        Create("Frame", {
            AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, 1),
            BackgroundColor3 = T.Accent2, BackgroundTransparency = 0.55, Parent = band,
        })
        self._fx.scan = band
    end

    local kind = fx.Particles
    if on and kind and ParticleKinds[kind] then
        anyBG = true
        local n = PARTICLE_COUNT[kind] or 20
        if not hi then n = math.floor(n * 0.45) end
        for _ = 1, n do
            table.insert(self._fx.particles, ParticleKinds[kind](layer, T))
        end
    end

    local bgrad, bstroke = self._borderGrad, self._mainStroke
    if on and fx.Border then
        local seq
        if fx.Border == "Rainbow" then
            seq = ColorSequence.new({
                ColorSequenceKeypoint.new(0, rgb(255, 80, 120)), ColorSequenceKeypoint.new(0.2, rgb(255, 190, 60)),
                ColorSequenceKeypoint.new(0.4, rgb(120, 255, 140)), ColorSequenceKeypoint.new(0.6, rgb(60, 200, 255)),
                ColorSequenceKeypoint.new(0.8, rgb(170, 110, 255)), ColorSequenceKeypoint.new(1, rgb(255, 80, 120)),
            })
        else
            seq = ColorSequence.new({
                ColorSequenceKeypoint.new(0, T.Stroke), ColorSequenceKeypoint.new(0.3, T.Accent),
                ColorSequenceKeypoint.new(0.5, T.Accent2), ColorSequenceKeypoint.new(0.7, T.Accent),
                ColorSequenceKeypoint.new(1, T.Stroke),
            })
        end
        bgrad.Color = seq
        bgrad.Enabled = true
        bstroke.Color = WHITE
        Tween(bstroke, {Thickness = 1.5}, 0.3)
    else
        bgrad.Enabled = false
        bstroke.Color = T.Stroke
        Tween(bstroke, {Thickness = 1}, 0.3)
    end

    local sh = self._shimmer
    sh.Visible = on and fx.Shimmer == true
    sh.BackgroundColor3 = T.Light and T.Accent or WHITE

    local panelA = anyBG and 0.3 or 0
    local cardA = anyBG and 0.12 or 0
    self._cardAlpha = cardA
    Tween(self._top, {BackgroundTransparency = panelA}, 0.4)
    Tween(self._sidebar, {BackgroundTransparency = panelA}, 0.4)
    local alive = {}
    for _, c in ipairs(self._cards) do
        if c.Parent then
            table.insert(alive, c)
            Tween(c, {BackgroundTransparency = cardA}, 0.4)
        end
    end
    self._cards = alive
end

function WindowClass:SetEffects(q)
    if q == true then q = "High" elseif q == false or q == nil then q = "Off" end
    if q ~= "Off" and q ~= "Low" and q ~= "High" then q = "High" end
    self.EffectQuality = q
    self:_applyFX()
end

function WindowClass:_tick(dt)
    if self._destroyed then return end
    local t = os.clock()
    if self._floatTick then self._floatTick(t) end
    if not self.Visible then return end
    local fx = self._fx
    if not fx then return end
    for _, b in ipairs(fx.blobs) do
        b.holder.Position = UDim2.fromScale(
            b.cx + math.sin(t * b.sx + b.ph) * b.ax,
            b.cy + math.cos(t * b.sy + b.ph * 1.7) * b.ay)
    end
    for _, p in ipairs(fx.particles) do p:step(dt, t) end
    if fx.scan then
        fx.scan.Position = UDim2.new(0, 0, ((t % 6) / 6) * 1.3 - 0.15, 0)
    end
    if self._borderGrad.Enabled then self._borderGrad.Rotation = (t * 45) % 360 end
    if self._shimmer.Visible then
        local ph = (t % 7) / 2.4
        self._shimmerGrad.Offset = Vector2.new(ph > 1 and 1 or (-1 + 2 * ph), 0)
    end
end

function WindowClass:SetBlur(on)
    self.BlurEnabled = on and true or false
    self:_updateBlur()
end

function WindowClass:_updateBlur()
    if self._destroyed then return end
    local want = self.BlurEnabled and self.Visible
    if want and not self._blur then
        pcall(function()
            local b = Instance.new("BlurEffect")
            b.Name = "YzZBlur_" .. string.sub(HttpService:GenerateGUID(false), 1, 6)
            b.Size = 0
            b.Parent = Lighting
            self._blur = b
        end)
    end
    if self._blur then Tween(self._blur, {Size = want and 18 or 0}, 0.4) end
end

function WindowClass:SetScale(n)
    n = math.clamp(tonumber(n) or 1, 0.6, 1.5)
    if self._userScale then Tween(self._userScale, {Scale = n}, 0.3) end
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
        if not silent then self:Notify({Title = "Config", Content = "Your executor does not support file saving.", Type = "Warning"}) end
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
        if not silent then self:Notify({Title = "Config saved", Content = "Saved as \"" .. tostring(name) .. "\".", Type = "Success", Icon = "save"}) end
        for _, cb in ipairs(self._listCallbacks) do pcall(cb) end
    end
    return okWrite
end

function WindowClass:LoadConfig(name, silent)
    name = name or self.CurrentConfig
    local data = self:_readConfig(name)
    if not data then
        if not silent then self:Notify({Title = "Config", Content = "Config \"" .. tostring(name) .. "\" was not found.", Type = "Warning"}) end
        return false
    end
    self._loading = true
    for flag, obj in pairs(self.Flags) do
        local v = data[flag]
        if v ~= nil then pcall(obj.Set, v, false) end
    end
    self._loading = false
    self.CurrentConfig = name
    if not silent then self:Notify({Title = "Config loaded", Content = "Loaded \"" .. tostring(name) .. "\".", Type = "Success", Icon = "download"}) end
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
    local root, main, mscale, shadow = self.Root, self.Main, self._mainScale, self._shadow
    self._visToken = (self._visToken or 0) + 1
    local token = self._visToken
    if v then
        root.Visible = true
        mscale.Scale = 0.9
        main.GroupTransparency = 1
        main.Position = UDim2.new(0.5, 0, 0.5, 18)
        Tween(mscale, {Scale = 1}, 0.55, Enum.EasingStyle.Back)
        Tween(main, {GroupTransparency = 0, Position = UDim2.fromScale(0.5, 0.5)}, 0.4, Enum.EasingStyle.Quint)
        Tween(shadow, {GroupTransparency = 0}, 0.5)
    else
        Tween(mscale, {Scale = 0.93}, 0.25, Enum.EasingStyle.Quad, EASE_IN)
        Tween(main, {GroupTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 10)}, 0.22, Enum.EasingStyle.Quad, EASE_IN)
        Tween(shadow, {GroupTransparency = 1}, 0.2)
        task.delay(0.27, function()
            if self._visToken == token and not self.Visible and root.Parent then root.Visible = false end
        end)
    end
    self:_updateBlur()
    if self._floatUpdate then self._floatUpdate(v) end
end

function WindowClass:Toggle() self:SetVisible(not self.Visible) end

function WindowClass:SetKeybind(key) self.Keybind = normalizeKey(key) end

function WindowClass:SetFloatingVisible(v)
    local fb = self.FloatingButton
    if not fb then return end
    v = v and true or false
    self._floatShown = v
    if v then
        fb.Visible = true
        Tween(self._floatScale, {Scale = 1}, 0.45, Enum.EasingStyle.Back)
    else
        Tween(self._floatScale, {Scale = 0}, 0.25, Enum.EasingStyle.Quad, EASE_IN)
        task.delay(0.27, function()
            if not self._floatShown and fb.Parent then fb.Visible = false end
        end)
    end
end

function WindowClass:SetTitle(title, sub)
    if title then self._titleLabel.Text = title end
    if sub then
        self._subLabel.Text = sub
        self._subPill.Visible = (sub ~= "")
    end
end

function WindowClass:Destroy()
    if self._destroyed then return end
    if self.AutoSave then pcall(function() self:SaveConfig(self.CurrentConfig, true) end) end
    self._destroyed = true
    for _, c in ipairs(self._conns) do pcall(function() c:Disconnect() end) end
    if self._blur then pcall(function() self._blur:Destroy() end) end
    if self.Gui then self.Gui:Destroy() end
    local env = (getgenv and getgenv()) or _G
    if env.__YzZHubWindow == self then env.__YzZHubWindow = nil end
end

local NOTIFY_STYLE = {
    Info = {icon = "info", key = "Accent"},
    Success = {icon = "circle-check", key = "Success"},
    Warning = {icon = "triangle-alert", key = "Warning"},
    Error = {icon = "circle-x", key = "Danger"},
}

function WindowClass:Notify(o)
    if self._destroyed then return end
    if type(o) == "string" then o = {Content = o} end
    o = o or {}
    local T = self.T
    local style = NOTIFY_STYLE[o.Type or "Info"] or NOTIFY_STYLE.Info
    local col = T[style.key]
    local duration = o.Duration or 4

    while #self._notifs >= 5 do
        local first = table.remove(self._notifs, 1)
        first()
    end

    local wrap = Create("Frame", {
        Name = "Notif", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Parent = self._notifyHolder,
    })
    Pad(wrap, 0, 0, 0, 8)

    local card = Create("CanvasGroup", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.fromOffset(70, 0),
        BackgroundColor3 = T.Element, GroupTransparency = 1, Parent = wrap,
    })
    Corner(card, 12)
    self:Bind(card, {BackgroundColor3 = "Element"})
    self:Stroke(card, "Stroke", 1, 0.2)
    Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Parent = card})

    local content = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 1, Parent = card,
    })
    Pad(content, 12, 12, 12, 12)
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 11), SortOrder = Enum.SortOrder.LayoutOrder, Parent = content,
    })

    local iconBox = Create("Frame", {
        Size = UDim2.fromOffset(32, 32), BackgroundColor3 = col, BackgroundTransparency = 0.82, LayoutOrder = 1, Parent = content,
    })
    Corner(iconBox, 10)
    local ic = self:MakeIcon(iconBox, o.Icon or o.Image or style.icon, 18,
        {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5)}, col)
    if not ic then iconBox.Visible = false end

    local textFrame = Create("Frame", {
        Size = UDim2.new(1, ic and -43 or 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
        LayoutOrder = 2, Parent = content,
    })
    Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = textFrame})
    self:Label(textFrame, o.Title or "YzZ Hub", 14, "Text", Enum.Font.GothamBold,
        {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1})
    if o.Content and o.Content ~= "" then
        self:Label(textFrame, o.Content, 12, "SubText", Enum.Font.Gotham,
            {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2})
    end

    local barTrack = Create("Frame", {Size = UDim2.new(1, 0, 0, 3), BackgroundTransparency = 1, LayoutOrder = 2, Parent = card})
    local bar = Create("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = col, Parent = barTrack})

    local dead = false
    local function dismiss()
        if dead then return end
        dead = true
        for i, fn in ipairs(self._notifs) do
            if fn == dismiss then table.remove(self._notifs, i) break end
        end
        task.spawn(function()
            if not wrap.Parent then return end
            Tween(card, {GroupTransparency = 1, Position = UDim2.fromOffset(60, 0)}, 0.28, Enum.EasingStyle.Quad, EASE_IN)
            task.wait(0.24)
            if not wrap.Parent then return end
            local h = wrap.AbsoluteSize.Y
            wrap.AutomaticSize = Enum.AutomaticSize.None
            wrap.Size = UDim2.new(1, 0, 0, h)
            wrap.ClipsDescendants = true
            Tween(wrap, {Size = UDim2.new(1, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
            task.wait(0.32)
            if wrap.Parent then wrap:Destroy() end
        end)
    end
    table.insert(self._notifs, dismiss)

    card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dismiss()
        end
    end)

    Tween(card, {GroupTransparency = 0, Position = UDim2.fromOffset(0, 0)}, 0.55, Enum.EasingStyle.Back)
    Tween(bar, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
    task.delay(duration, dismiss)
    return {Dismiss = dismiss}
end

function WindowClass:Dialog(o)
    o = o or {}
    local T = self.T
    local overlay = Create("TextButton", {
        Name = "Dialog", Size = UDim2.fromScale(1, 1), BackgroundColor3 = BLACK,
        BackgroundTransparency = 1, ZIndex = 60, Parent = self.Main,
    })
    local card = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(math.min(340, (self._winW or 620) - 40), 0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = T.Element, Parent = overlay,
    })
    Corner(card, 14)
    self:Bind(card, {BackgroundColor3 = "Element"})
    self:Stroke(card, "Stroke", 1, 0.1)
    Pad(card, 18, 18, 18, 16)
    local cardScale = Create("UIScale", {Scale = 0.88, Parent = card})
    Create("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = card})

    self:Label(card, o.Title or "Confirm", 16, "Text", Enum.Font.GothamBold,
        {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1})
    if o.Content then
        self:Label(card, o.Content, 13, "SubText", Enum.Font.Gotham,
            {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2})
    end

    local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, LayoutOrder = 3, Parent = card})
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = row,
    })

    local closed = false
    local function close()
        if closed then return end
        closed = true
        Tween(overlay, {BackgroundTransparency = 1}, 0.2)
        Tween(cardScale, {Scale = 0.9}, 0.2, Enum.EasingStyle.Quad, EASE_IN)
        task.delay(0.22, function() if overlay.Parent then overlay:Destroy() end end)
    end

    local buttons = o.Buttons or {{Title = "OK"}}
    for i, b in ipairs(buttons) do
        local primary = b.Primary or (i == #buttons)
        local btn = Create("TextButton", {
            Size = UDim2.new(0, 100, 1, 0), Text = b.Title or "OK", Font = Enum.Font.GothamMedium, TextSize = 13,
            LayoutOrder = i, BackgroundTransparency = 0, Parent = row,
        })
        Corner(btn, 9)
        self:Bind(btn, {BackgroundColor3 = primary and "Accent" or "ElementHover", TextColor3 = primary and "OnAccent" or "Text"})
        btn.MouseEnter:Connect(function() Tween(btn, {BackgroundTransparency = 0.12}, 0.15) end)
        btn.MouseLeave:Connect(function() Tween(btn, {BackgroundTransparency = 0}, 0.15) end)
        btn.MouseButton1Down:Connect(function() Tween(btn, {Size = UDim2.new(0, 94, 1, -2)}, 0.08) end)
        btn.MouseButton1Up:Connect(function() Tween(btn, {Size = UDim2.new(0, 100, 1, 0)}, 0.2, Enum.EasingStyle.Back) end)
        btn.MouseButton1Click:Connect(function()
            close()
            safe(b.Callback)
        end)
    end

    Tween(overlay, {BackgroundTransparency = 0.45}, 0.25)
    Tween(cardScale, {Scale = 1}, 0.4, Enum.EasingStyle.Back)
    return {Close = close}
end

local TAB_H, TAB_GAP, TAB_PAD, TAB_PADX, DIV_H = 38, 4, 10, 10, 28

function WindowClass:_moveHighlight(tab, instant)
    local hl = self._highlight
    if not hl or not tab then return end
    local y = TAB_PAD
    for _, item in ipairs(self._tabItems) do
        if item.tab == tab then break end
        y = y + item.h + TAB_GAP
    end
    local pos = UDim2.fromOffset(TAB_PADX, y + 52)
    if instant then
        hl.Position = pos
        hl.Size = UDim2.new(1, -TAB_PADX * 2, 0, TAB_H)
        hl.Visible = true
    else
        Tween(hl, {Position = pos}, 0.42, Enum.EasingStyle.Quint)
    end
end

function WindowClass:SelectTab(tab)
    if type(tab) == "number" then tab = self.Tabs[tab] end
    if not tab or self.ActiveTab == tab then return end
    local prev = self.ActiveTab
    self.ActiveTab = tab
    local dir = 1
    if prev then
        dir = (tab.Index > prev.Index) and 1 or -1
        prev.Active = false
        prev:_visual(false)
        local pg = prev.Group
        Tween(pg, {GroupTransparency = 1}, 0.12)
        task.delay(0.13, function()
            if not prev.Active then pg.Visible = false end
        end)
    end
    tab.Active = true
    tab:_visual(true)
    self:_moveHighlight(tab, prev == nil)

    local g = tab.Group
    g.Visible = true
    if prev then
        g.GroupTransparency = 1
        g.Position = UDim2.fromOffset(0, 16 * dir)
        Tween(g, {GroupTransparency = 0, Position = UDim2.fromOffset(0, 0)}, 0.42, Enum.EasingStyle.Quint)
        tab:_reveal()
    else
        g.GroupTransparency = 0
        g.Position = UDim2.fromOffset(0, 0)
    end
end

function TabClass:_visual(active, instant)
    local T = self.Window.T
    local d = instant and 0 or 0.25
    Tween(self.Label, {TextColor3 = active and T.Text or T.SubText}, d)
    if self.IconCtl then self.IconCtl.SetColor(active and T.Accent or T.SubText, not instant) end
    if active then Tween(self.Button, {BackgroundTransparency = 1}, d) end
end

function TabClass:_reveal()
    local alive, n = {}, 0
    for _, v in ipairs(self._veils) do
        if v.Parent then
            table.insert(alive, v)
            n = n + 1
            if n <= 14 then
                v.BackgroundTransparency = 0
                Tween(v, {BackgroundTransparency = 1}, 0.4, Enum.EasingStyle.Quad, EASE_OUT, (n - 1) * 0.035)
            end
        end
    end
    self._veils = alive
end

function WindowClass:CreateDivider(title)
    local T = self.T
    local order = #self._tabItems + 1
    local f = Create("Frame", {
        Name = "Divider", Size = UDim2.new(1, 0, 0, DIV_H), BackgroundTransparency = 1, LayoutOrder = order, Parent = self._tabInner,
    })
    local lbl = Create("TextLabel", {
        Size = UDim2.new(1, -8, 1, 0), Position = UDim2.fromOffset(8, 4), Text = string.upper(tostring(title or "")),
        Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center, Parent = f,
    })
    self:Bind(lbl, {TextColor3 = "SubText"})
    table.insert(self._tabItems, {h = DIV_H})
    return f
end

function WindowClass:CreateTab(opts)
    if type(opts) == "string" then opts = {Title = opts} end
    opts = opts or {}
    local T = self.T
    local tab = setmetatable({
        Window = self, Title = opts.Title or opts.Name or "Tab", Active = false, _order = 0,
        _veils = {}, Index = #self.Tabs + 1,
    }, TabClass)

    local btn = Create("TextButton", {
        Name = tab.Title, Size = UDim2.new(1, 0, 0, TAB_H), BackgroundTransparency = 1,
        LayoutOrder = #self._tabItems + 1, Parent = self._tabInner,
    })
    Corner(btn, 10)
    self:Bind(btn, {BackgroundColor3 = "ElementHover"})

    local labelX = 14
    local icon, ctl = self:MakeIcon(btn, opts.Icon or opts.Image, 18,
        {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0), ZIndex = 2}, opts.IconColor)
    if icon then labelX = 42 end

    local label = Create("TextLabel", {
        Position = UDim2.fromOffset(labelX, 0), Size = UDim2.new(1, -(labelX + 8), 1, 0), Text = tab.Title,
        Font = Enum.Font.GothamMedium, TextSize = self.Compact and 12 or 13, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 2, Parent = btn,
    })
    tab.Button, tab.Label, tab.IconCtl = btn, label, ctl

    local group = Create("CanvasGroup", {
        Name = tab.Title, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, Parent = self._content,
    })
    local page = Create("ScrollingFrame", {
        Name = "Page", Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 3, ScrollBarImageTransparency = 0.25, ScrollingDirection = Enum.ScrollingDirection.Y,
        ElasticBehavior = Enum.ElasticBehavior.Always, Parent = group,
    })
    self:Bind(page, {ScrollBarImageColor3 = "Accent"})
    Pad(page, 14, 14, 14, 14)
    Create("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page})
    tab.Group, tab.Page = group, page

    self:BindFn(btn, function() tab:_visual(tab.Active, true) end)

    btn.MouseEnter:Connect(function()
        if tab.Active then return end
        Tween(label, {TextColor3 = T.Text}, 0.15)
        Tween(btn, {BackgroundTransparency = 0.55}, 0.15)
        if ctl then ctl.SetColor(T.Text, true) end
    end)
    btn.MouseLeave:Connect(function()
        if tab.Active then return end
        Tween(label, {TextColor3 = T.SubText}, 0.2)
        Tween(btn, {BackgroundTransparency = 1}, 0.2)
        if ctl then ctl.SetColor(T.SubText, true) end
    end)
    btn.MouseButton1Down:Connect(function()
        if icon then Tween(icon, {Size = UDim2.fromOffset(15, 15)}, 0.08) end
    end)
    btn.MouseButton1Up:Connect(function()
        if icon then Tween(icon, {Size = UDim2.fromOffset(18, 18)}, 0.3, Enum.EasingStyle.Back) end
    end)
    btn.MouseButton1Click:Connect(function() self:SelectTab(tab) end)

    table.insert(self._tabItems, {tab = tab, h = TAB_H})
    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then self:SelectTab(tab) end
    return tab
end

function TabClass:_base(opts, o)
    o = o or {}
    local W = self.Window
    local T = W.T
    self._order = self._order + 1

    local card = Create("Frame", {
        Name = tostring(opts.Title or opts.Name or "Element"), Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = self._order, BackgroundTransparency = W._cardAlpha or 0,
        Parent = self.Page,
    })
    Corner(card, 10)
    W:Bind(card, {BackgroundColor3 = "Element"})
    table.insert(W._cards, card)
    local stroke = Create("UIStroke", {
        Thickness = 1, Transparency = 0.35, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = card,
    })
    W:Bind(stroke, {Color = "Stroke"})

    local stack = Create("Frame", {
        Name = "Stack", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = card,
    })
    Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Parent = stack})

    local fx = Create("Frame", {
        Name = "Fx", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 3, Parent = card,
    })
    Corner(fx, 10)
    local veil = Create("Frame", {Name = "Veil", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = fx})
    Corner(veil, 10)
    W:Bind(veil, {BackgroundColor3 = "Background"})
    table.insert(self._veils, veil)

    if opts.Image then
        local holder = Create("Frame", {
            Name = "Banner", Size = UDim2.new(1, 0, 0, opts.ImageHeight or 90), BackgroundTransparency = 1, LayoutOrder = 1, Parent = stack,
        })
        Pad(holder, 8, 8, 8, 0)
        local img = W:MakeIcon(holder, opts.Image, UDim2.fromScale(1, 1), {ScaleType = Enum.ScaleType.Crop}, opts.ImageColor)
        if img then Corner(img, 8) end
    end

    local rowProps = {
        Name = "Row", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2,
        BackgroundTransparency = 1, Parent = stack,
    }
    local row = Create(o.Interactive and "TextButton" or "Frame", rowProps)
    Create("UISizeConstraint", {MinSize = Vector2.new(0, o.MinHeight or 46), Parent = row})
    Pad(row, 14, 9, 14, 9)
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
        BackgroundTransparency = 1, LayoutOrder = 2, Parent = row,
    })
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
        right = Create("Frame", {
            Name = "Right", Size = UDim2.fromOffset(rightW, o.RightHeight or 26), BackgroundTransparency = 1, LayoutOrder = 3, Parent = row,
        })
    end

    local base = {Frame = card, Stack = stack, Row = row, Stroke = stroke, Right = right, Fx = fx, TitleLabel = title, DescLabel = desc}
    function base.SetTitle(t) title.Text = tostring(t) title.Visible = (tostring(t) ~= "") end
    function base.SetDesc(t) desc.Text = tostring(t or "") desc.Visible = (t ~= nil and t ~= "") end
    function base.Flash()
        Tween(stroke, {Color = T.Accent, Transparency = 0}, 0.1)
        task.delay(0.22, function()
            if stroke.Parent then Tween(stroke, {Color = T.Stroke, Transparency = 0.35}, 0.35) end
        end)
    end

    if o.Interactive then
        row.MouseEnter:Connect(function()
            Tween(card, {BackgroundColor3 = T.ElementHover}, 0.18)
            Tween(stroke, {Transparency = 0.1}, 0.18)
        end)
        row.MouseLeave:Connect(function()
            Tween(card, {BackgroundColor3 = T.Element}, 0.25)
            Tween(stroke, {Transparency = 0.35}, 0.25)
        end)
        row.MouseButton1Down:Connect(function(x, y) W:Ripple(fx, x, y) end)
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

    local f = Create("Frame", {
        Name = "Section", Size = UDim2.new(1, 0, 0, 32), LayoutOrder = self._order, BackgroundTransparency = 1, Parent = self.Page,
    })
    local inner = Create("Frame", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = f})
    Pad(inner, 2, 6, 0, 0)
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = inner,
    })
    local icon, ctl = W:MakeIcon(inner, opts.Icon or opts.Image, 16, {LayoutOrder = 1}, opts.IconColor)
    if icon and ctl then W:BindFn(icon, function() ctl.SetColor(T.Accent) end) end
    local lbl = W:Label(inner, tostring(opts.Title or opts.Name or "Section"), 12, "Accent", Enum.Font.GothamBold, {
        Size = UDim2.new(0, 0, 0, 16), AutomaticSize = Enum.AutomaticSize.X, TextWrapped = false,
        TextYAlignment = Enum.TextYAlignment.Center, LayoutOrder = 2,
    })
    local line = Create("Frame", {
        AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 1), Parent = f,
    })
    W:Bind(line, {BackgroundColor3 = "Stroke"})
    Create("UIGradient", {
        Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1)}), Parent = line,
    })

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
    local base = self:_base(opts, {Interactive = true, RightWidth = 22, RightHeight = 22})
    local ic, ctl = W:MakeIcon(base.Right, opts.ButtonIcon or "mouse-pointer-click", UDim2.fromScale(1, 1),
        {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5)}, opts.ButtonIconColor)
    if ic and ctl then W:BindFn(ic, function() ctl.SetColor(T.SubText) end) end

    base.Row.MouseButton1Click:Connect(function()
        base.Flash()
        if ic then
            Tween(ic, {Size = UDim2.fromOffset(13, 13), Rotation = 12}, 0.08)
            task.delay(0.09, function()
                if ic.Parent then Tween(ic, {Size = UDim2.fromScale(1, 1), Rotation = 0}, 0.4, Enum.EasingStyle.Back) end
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
    local base = self:_base(opts, {Interactive = true, RightWidth = 44, RightHeight = 24})

    local track = Create("Frame", {Name = "Track", Size = UDim2.fromScale(1, 1), BackgroundColor3 = T.ToggleOff, Parent = base.Right})
    Corner(track)
    local glow = Create("UIStroke", {Thickness = 1.5, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = track})
    W:BindFn(track, function() glow.Color = T.Accent end)
    local knob = Create("Frame", {
        Name = "Knob", AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0),
        Size = UDim2.fromOffset(18, 18), BackgroundColor3 = WHITE, Parent = track,
    })
    Corner(knob)

    local state, pressed = false, false
    local function knobSize() return pressed and UDim2.fromOffset(25, 16) or UDim2.fromOffset(18, 18) end
    local function render(instant)
        local goalColor = state and T.Accent or T.ToggleOff
        local goalPos = state and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        local goalAnchor = Vector2.new(state and 1 or 0, 0.5)
        local goalGlow = state and 0.55 or 1
        if instant then
            track.BackgroundColor3 = goalColor
            knob.Position, knob.AnchorPoint, knob.Size = goalPos, goalAnchor, knobSize()
            glow.Transparency = goalGlow
        else
            Tween(track, {BackgroundColor3 = goalColor}, 0.25)
            Tween(knob, {Position = goalPos, AnchorPoint = goalAnchor, Size = knobSize()}, 0.38, Enum.EasingStyle.Back)
            Tween(glow, {Transparency = goalGlow}, 0.25)
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

    base.Row.MouseButton1Down:Connect(function()
        pressed = true
        Tween(knob, {Size = knobSize()}, 0.12, Enum.EasingStyle.Quad)
    end)
    local function release()
        if pressed then
            pressed = false
            Tween(knob, {Size = knobSize()}, 0.3, Enum.EasingStyle.Back)
        end
    end
    base.Row.MouseButton1Up:Connect(release)
    base.Row.MouseLeave:Connect(release)
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
        Size = UDim2.fromScale(1, 1), Font = Enum.Font.GothamBold, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right, Parent = base.Right,
    })
    W:Bind(valueLbl, {TextColor3 = "Accent"})

    local barRow = Create("Frame", {
        Name = "BarRow", Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, LayoutOrder = 3, Parent = base.Stack,
    })
    Pad(barRow, 14, 0, 14, 0)

    local track = Create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, -4), Size = UDim2.new(1, 0, 0, 6), Parent = barRow,
    })
    Corner(track)
    W:Bind(track, {BackgroundColor3 = "ToggleOff"})
    local fill = Create("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = WHITE, Parent = track})
    Corner(fill)
    local fillGrad = Create("UIGradient", {Parent = fill})
    W:BindFn(fill, function() fillGrad.Color = ColorSequence.new(T.Accent, T.Accent2) end)

    local knob = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = WHITE, ZIndex = 3, Parent = track,
    })
    Corner(knob)
    local knobStroke = Create("UIStroke", {Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = knob})
    W:Bind(knobStroke, {Color = "Accent"})

    local tip = Create("TextLabel", {
        AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 0, -8), Size = UDim2.fromOffset(0, 20),
        AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, TextTransparency = 1, Text = "",
        Font = Enum.Font.GothamBold, TextSize = 11, ZIndex = 6, Parent = knob,
    })
    Corner(tip, 6)
    Pad(tip, 8, 0, 8, 0)
    W:Bind(tip, {BackgroundColor3 = "Accent", TextColor3 = "OnAccent"})

    local value = min
    local function render(instant)
        local a = (value - min) / (max - min)
        local txt = tostring(value) .. suffix
        valueLbl.Text = txt
        tip.Text = txt
        local d = instant and 0 or 0.14
        Tween(fill, {Size = UDim2.new(a, 0, 1, 0)}, d, Enum.EasingStyle.Quint)
        Tween(knob, {Position = UDim2.new(a, 0, 0.5, 0)}, d, Enum.EasingStyle.Quint)
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

    local hit = Create("TextButton", {Size = UDim2.fromScale(1, 1), Parent = barRow})
    local dragging, dragInput = false, nil
    local function fromInput(input)
        local a = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
        set(min + (max - min) * a)
    end
    local function endDrag()
        if not dragging then return end
        dragging = false
        self.Page.ScrollingEnabled = true
        Tween(knob, {Size = UDim2.fromOffset(14, 14)}, 0.2)
        Tween(tip, {BackgroundTransparency = 1, TextTransparency = 1}, 0.15)
    end
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragInput = true, input
            self.Page.ScrollingEnabled = false
            Tween(knob, {Size = UDim2.fromOffset(19, 19)}, 0.25, Enum.EasingStyle.Back)
            Tween(tip, {BackgroundTransparency = 0, TextTransparency = 0}, 0.15)
            fromInput(input)
        end
    end)
    W:_connect(UserInputService.InputChanged, function(input)
        if not dragging then return end
        local ok
        if dragInput.UserInputType == Enum.UserInputType.Touch then
            ok = (input == dragInput)
        else
            ok = (input.UserInputType == Enum.UserInputType.MouseMovement)
        end
        if ok then fromInput(input) end
    end)
    W:_connect(UserInputService.InputEnded, function(input)
        if dragging and (input == dragInput
            or (dragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseButton1)) then
            endDrag()
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
    local base = self:_base(opts, {Interactive = false, RightWidth = W.Compact and 112 or 156, RightHeight = 30})

    local box = Create("TextBox", {
        Size = UDim2.fromScale(1, 1), Text = "", PlaceholderText = opts.Placeholder or "Type here...",
        Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = opts.ClearOnFocus == true, TextTruncate = Enum.TextTruncate.AtEnd,
        BackgroundTransparency = 0, Parent = base.Right,
    })
    Corner(box, 8)
    Pad(box, 10, 0, 10, 0)
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

    box.Focused:Connect(function()
        Tween(boxStroke, {Color = T.Accent, Thickness = 1.5}, 0.18)
        Tween(base.Stroke, {Color = T.Accent, Transparency = 0.2}, 0.18)
    end)
    box.FocusLost:Connect(function(enter)
        Tween(boxStroke, {Color = T.Stroke, Thickness = 1}, 0.2)
        Tween(base.Stroke, {Color = T.Stroke, Transparency = 0.35}, 0.25)
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
    local base = self:_base(opts, {Interactive = true, RightWidth = W.Compact and 112 or 156, RightHeight = 26})

    local entries, byTitle, selected = {}, {}, {}
    local optionButtons = {}
    local isOpen, searchText = false, ""
    local open, close

    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = base.Right,
    })
    local valueLbl = W:Label(base.Right, "", 12, "SubText", Enum.Font.Gotham, {
        Size = UDim2.new(1, -22, 1, 0), TextXAlignment = Enum.TextXAlignment.Right, TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd, LayoutOrder = 1,
    })
    local chev, chevCtl = W:MakeIcon(base.Right, "chevron-down", 16, {LayoutOrder = 2})
    if chev and chevCtl then W:BindFn(chev, function() chevCtl.SetColor(T.SubText) end) end

    local holder = Create("Frame", {
        Name = "Options", Size = UDim2.new(1, 0, 0, 0), ClipsDescendants = true, BackgroundTransparency = 1,
        LayoutOrder = 5, Parent = base.Stack,
    })
    Pad(holder, 10, 0, 10, 10)
    Create("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = holder})

    local searchBox = Create("TextBox", {
        Size = UDim2.new(1, 0, 0, 30), Text = "", PlaceholderText = "Search...", Font = Enum.Font.Gotham, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, BackgroundTransparency = 0, LayoutOrder = 1,
        Visible = false, Parent = holder,
    })
    Corner(searchBox, 8)
    Pad(searchBox, 10, 0, 10, 0)
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
        return (searchBox.Visible and 36 or 0) + listH + 10
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
        local d = instant and 0 or 0.18
        Tween(ob.Button, {BackgroundTransparency = on and 0.82 or 1}, d)
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
                Name = e.Title, Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = T.Accent,
                BackgroundTransparency = 1, LayoutOrder = i, Parent = scroller,
            })
            Corner(b, 8)
            local leftX = 12
            local ic, ctl = W:MakeIcon(b, e.Icon or e.Image, 16, {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0)}, e.IconColor)
            if ic then
                leftX = 34
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
        Tween(holder, {Size = UDim2.new(1, 0, 0, 0)}, 0.28, Enum.EasingStyle.Quint)
        if chev then Tween(chev, {Rotation = 0}, 0.3, Enum.EasingStyle.Back) end
    end
    open = function()
        isOpen = true
        rebuild()
        Tween(holder, {Size = UDim2.new(1, 0, 0, currentHeight())}, 0.34, Enum.EasingStyle.Quint)
        if chev then Tween(chev, {Rotation = 180}, 0.3, Enum.EasingStyle.Back) end
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
    local base = self:_base(opts, {Interactive = true, RightWidth = 84, RightHeight = 28})

    local pill = Create("Frame", {Size = UDim2.fromScale(1, 1), Parent = base.Right})
    Corner(pill, 8)
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
        Tween(pillStroke, {Color = T.Stroke, Thickness = 1}, 0.15)
        Tween(pill, {Size = UDim2.fromScale(1, 1)}, 0.25, Enum.EasingStyle.Back)
        display()
    end

    base.Row.MouseButton1Click:Connect(function()
        if listening then stopListening() return end
        listening = true
        W._listening = true
        Tween(pillStroke, {Color = T.Accent, Thickness = 1.5}, 0.15)
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

local function getGuiParent()
    local parent
    if type(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok then parent = result end
    end
    if not parent then parent = CoreGui end
    if not parent and LocalPlayer then
        parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
    end
    return parent
end

function YzZ:CreateWindow(opts)
    opts = opts or {}
    local env = (getgenv and getgenv()) or _G
    if env.__YzZHubWindow and type(env.__YzZHubWindow.Destroy) == "function" then
        pcall(function() env.__YzZHubWindow:Destroy() end)
    end

    local config = type(opts.ConfigurationSaving) == "table" and opts.ConfigurationSaving or {}
    local themeName = opts.Theme or "Dark"
    local theme = resolveTheme(themeName)
    local width = math.clamp(tonumber(opts.Width) or 640, 420, 1000)
    local height = math.clamp(tonumber(opts.Height) or 450, 320, 800)
    local floatingEnabled = opts.FloatingButton ~= false
    local gui = Create("ScreenGui", {
        Name = opts.GuiName or "YzZHubUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 10000,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    local parent = getGuiParent()
    if not parent then error("Unable to find a valid GUI parent") end
    gui.Parent = parent

    local root = Create("Frame", {
        Name = "Root",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Parent = gui,
    })
    local main = Create("CanvasGroup", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(width, height),
        BackgroundColor3 = theme.Background,
        ClipsDescendants = true,
        GroupTransparency = 0,
        ZIndex = 2,
        Parent = root,
    })
    Corner(main, 16)
    local mainScale = Create("UIScale", {Scale = 0.92, Parent = main})
    local userScale = Create("UIScale", {Scale = math.clamp(tonumber(opts.Scale) or 1, 0.6, 1.5), Parent = main})

    local shadow = Create("CanvasGroup", {
        Name = "Shadow",
        Position = UDim2.fromOffset(6, 8),
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        GroupTransparency = 0,
        ZIndex = 1,
        Parent = main,
    })
    local shadowFrame = Create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = BLACK,
        BackgroundTransparency = 0.72,
        ZIndex = 1,
        Parent = shadow,
    })
    Corner(shadowFrame, 16)

    local border = Create("UIStroke", {
        Thickness = 1,
        Transparency = 0.08,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = theme.Stroke,
        Parent = main,
    })
    local borderGradient = Create("UIGradient", {Enabled = false, Parent = border})

    local fxLayer = Create("Frame", {
        Name = "Effects",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 2,
        Parent = main,
    })

    local top = Create("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = theme.Topbar,
        ZIndex = 4,
        Parent = main,
    })
    local shimmer = Create("Frame", {
        Name = "Shimmer",
        Size = UDim2.new(0.45, 0, 1, 0),
        BackgroundColor3 = WHITE,
        BackgroundTransparency = 0.88,
        Visible = false,
        ZIndex = 5,
        Parent = top,
    })
    local shimmerGradient = Create("UIGradient", {
        Rotation = 0,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = shimmer,
    })

    local titleIconHolder = Create("Frame", {
        Position = UDim2.fromOffset(14, 10),
        Size = UDim2.fromOffset(32, 32),
        BackgroundTransparency = 1,
        ZIndex = 6,
        Parent = top,
    })
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        Position = UDim2.fromOffset(0, 52),
        Size = UDim2.new(0, 158, 1, -52),
        BackgroundColor3 = theme.Sidebar,
        ZIndex = 3,
        Parent = main,
    })
    local tabInner = Create("ScrollingFrame", {
        Name = "Tabs",
        Position = UDim2.fromOffset(0, 52),
        Size = UDim2.new(1, 0, 1, -52),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 2,
        ScrollBarImageTransparency = 0.55,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ZIndex = 3,
        Parent = sidebar,
    })
    Pad(tabInner, 10, 10, 10, 10)
    Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabInner,
    })
    local highlight = Create("Frame", {
        Name = "TabHighlight",
        Position = UDim2.fromOffset(10, 62),
        Size = UDim2.new(1, -20, 0, TAB_H),
        BackgroundColor3 = theme.ElementHover,
        BackgroundTransparency = 0.15,
        Visible = false,
        ZIndex = 3,
        Parent = sidebar,
    })
    Corner(highlight, 10)

    local content = Create("Frame", {
        Name = "Content",
        Position = UDim2.fromOffset(158, 52),
        Size = UDim2.new(1, -158, 1, -52),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 4,
        Parent = main,
    })

    local titleLabel = Create("TextLabel", {
        Position = UDim2.fromOffset(55, 8),
        Size = UDim2.new(0, 220, 0, 22),
        Text = tostring(opts.Title or "YzZ Hub"),
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        ZIndex = 6,
        Parent = top,
    })
    local subPill = Create("Frame", {
        Position = UDim2.fromOffset(55, 30),
        Size = UDim2.fromOffset(0, 15),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = theme.ElementHover,
        BackgroundTransparency = 0.08,
        Visible = (opts.SubTitle or opts.Subtitle or "") ~= "",
        ZIndex = 6,
        Parent = top,
    })
    Corner(subPill, 5)
    Pad(subPill, 6, 0, 6, 0)
    local subLabel = Create("TextLabel", {
        Size = UDim2.fromOffset(0, 15),
        AutomaticSize = Enum.AutomaticSize.X,
        Text = tostring(opts.SubTitle or opts.Subtitle or ""),
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        BackgroundTransparency = 1,
        ZIndex = 7,
        Parent = subPill,
    })

    local function makeTopButton(name, text, xOffset)
        local button = Create("TextButton", {
            Name = name,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, xOffset, 0.5, 0),
            Size = UDim2.fromOffset(30, 30),
            Text = text,
            Font = Enum.Font.GothamBold,
            TextSize = 15,
            BackgroundTransparency = 1,
            ZIndex = 7,
            Parent = top,
        })
        Corner(button, 8)
        return button
    end
    local hideButton = makeTopButton("Hide", "−", -48)
    local closeButton = makeTopButton("Close", "×", -12)

    local notifyHolder = Create("Frame", {
        Name = "Notifications",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -18, 0, 18),
        Size = UDim2.fromOffset(310, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 100,
        Parent = root,
    })
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 8),
        Parent = notifyHolder,
    })

    local self = setmetatable({
        Gui = gui,
        Root = root,
        Main = main,
        T = theme,
        ThemeName = type(themeName) == "string" and themeName or theme.Name,
        Visible = true,
        Compact = opts.Compact == true,
        AutoSave = opts.AutoSave ~= false and opts.ConfigurationSaving ~= false and config.Enabled ~= false,
        ConfigFolder = tostring(opts.ConfigFolder or config.FolderName or config.Folder or "YzZHub"),
        CurrentConfig = tostring(opts.CurrentConfig or config.FileName or "Default"),
        Keybind = normalizeKey(opts.Keybind or "RightControl"),
        EffectQuality = opts.EffectQuality or "Low",
        BlurEnabled = opts.Blur == true,
        _winW = width,
        _winH = height,
        _mainScale = mainScale,
        _userScale = userScale,
        _shadow = shadow,
        _mainStroke = border,
        _borderGrad = borderGradient,
        _fxLayer = fxLayer,
        _shimmer = shimmer,
        _shimmerGrad = shimmerGradient,
        _top = top,
        _sidebar = sidebar,
        _tabInner = tabInner,
        _content = content,
        _highlight = highlight,
        _titleLabel = titleLabel,
        _subLabel = subLabel,
        _subPill = subPill,
        _notifyHolder = notifyHolder,
        _tabItems = {},
        Tabs = {},
        Flags = {},
        _pending = {},
        _binds = {},
        _conns = {},
        _notifs = {},
        _cards = {},
        _listCallbacks = {},
        _loading = false,
        _listening = false,
        _built = false,
        _destroyed = false,
    }, WindowClass)

    self:Bind(titleLabel, {TextColor3 = "Text"})
    self:Bind(subLabel, {TextColor3 = "SubText"})
    self:Bind(subPill, {BackgroundColor3 = "ElementHover"})
    self:Bind(hideButton, {TextColor3 = "Text", BackgroundColor3 = "ElementHover"})
    self:Bind(closeButton, {TextColor3 = "Danger", BackgroundColor3 = "ElementHover"})
    self:Bind(highlight, {BackgroundColor3 = "ElementHover"})

    local titleIcon = self:MakeIcon(titleIconHolder, opts.Icon or "sparkles", 24, {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        ZIndex = 7,
    }, opts.IconColor or theme.Accent)
    if not titleIcon then titleIconHolder.Visible = false end

    hideButton.MouseButton1Click:Connect(function() self:SetVisible(false) end)
    closeButton.MouseButton1Click:Connect(function() self:SetVisible(false) end)

    MakeDraggable(self, top, main, {
        Follow = 28,
        Clamp = function(x, y)
            local bounds = root.AbsoluteSize
            local halfW, halfH = main.AbsoluteSize.X / 2, main.AbsoluteSize.Y / 2
            return math.clamp(x, halfW + 8, math.max(halfW + 8, bounds.X - halfW - 8)),
                math.clamp(y, halfH + 8, math.max(halfH + 8, bounds.Y - halfH - 8))
        end,
    })

    if floatingEnabled then
        local floating = Create("TextButton", {
            Name = "FloatingButton",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(1, -38, 1, -42),
            Size = UDim2.fromOffset(48, 48),
            Text = "",
            BackgroundColor3 = theme.Element,
            Visible = false,
            ZIndex = 30,
            Parent = root,
        })
        Corner(floating, 16)
        local floatingStroke = self:Stroke(floating, "Accent", 1.5, 0.1)
        local floatingScale = Create("UIScale", {Scale = 0, Parent = floating})
        local floatingIcon = self:MakeIcon(floating, opts.FloatingIcon or opts.Icon or "sparkles", 22, {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            ZIndex = 31,
        }, opts.IconColor or theme.Accent)
        if not floatingIcon then floating.Text = "Y" end
        floating.MouseButton1Click:Connect(function() self:SetVisible(true) end)
        self.FloatingButton = floating
        self._floatScale = floatingScale
        self._floatShown = false
        self._floatUpdate = function(windowVisible)
            self:SetFloatingVisible(not windowVisible)
        end
        MakeDraggable(self, floating, floating, {
            Follow = 30,
            Clamp = function(x, y)
                local bounds = root.AbsoluteSize
                return math.clamp(x, 28, math.max(28, bounds.X - 28)),
                    math.clamp(y, 28, math.max(28, bounds.Y - 28))
            end,
        })
    else
        self._floatUpdate = function() end
    end

    self._built = true
    self:_applyFX()
    self:_updateBlur()
    self:_connect(RunService.RenderStepped, function(dt) self:_tick(dt) end)
    self:_connect(UserInputService.InputBegan, function(input, processed)
        if processed or self._listening or self._destroyed then return end
        if matchesKey(self.Keybind, input) then self:Toggle() end
    end)

    local loaded = self:_readConfig(self.CurrentConfig)
    if loaded then self._pending = loaded end
    env.__YzZHubWindow = self
    if opts.Visible == false then self:SetVisible(false) end
    if opts.Blur == true then self:SetBlur(true) end
    return self
end

function WindowClass:CreateConfigTab()
    if self._configTab and self._configTab.Page and self._configTab.Page.Parent then
        return self._configTab
    end
    local tab = self:CreateTab({Title = "Config", Icon = "settings"})
    tab:CreateSection({Title = "Configuration"})
    local nameBox = tab:CreateTextbox({
        Title = "Config name",
        Default = self.CurrentConfig,
        Placeholder = "Enter a config name",
        Flag = false,
    })
    local selected = self.CurrentConfig
    local list = tab:CreateDropdown({
        Title = "Saved configs",
        Options = self:ListConfigs(),
        Default = self.CurrentConfig,
        Flag = false,
        Search = true,
        Callback = function(value)
            if type(value) == "string" then
                selected = value
                nameBox:Set(value, true)
            end
        end,
    })
    tab:CreateButton({
        Title = "Save config",
        Icon = "save",
        Callback = function() self:SaveConfig(nameBox:Get()) end,
    })
    tab:CreateButton({
        Title = "Load config",
        Icon = "download",
        Callback = function() self:LoadConfig(nameBox:Get() ~= "" and nameBox:Get() or selected) end,
    })
    tab:CreateButton({
        Title = "Delete config",
        Icon = "trash-2",
        Callback = function() self:DeleteConfig(nameBox:Get() ~= "" and nameBox:Get() or selected) end,
    })
    tab:CreateButton({
        Title = "Refresh config list",
        Icon = "refresh-cw",
        Callback = function() list:Refresh(self:ListConfigs()) end,
    })
    tab:CreateSection({Title = "Appearance"})
    tab:CreateDropdown({
        Title = "Theme",
        Options = self.ThemeOrder or YzZ.ThemeOrder,
        Default = self.ThemeName or "Dark",
        Flag = false,
        Callback = function(value) if value then self:SetTheme(value) end end,
    })
    tab:CreateDropdown({
        Title = "Effects quality",
        Options = {"Off", "Low", "High"},
        Default = self.EffectQuality,
        Flag = false,
        Callback = function(value) self:SetEffects(value) end,
    })
    tab:CreateToggle({
        Title = "Background blur",
        Default = self.BlurEnabled,
        Flag = false,
        Callback = function(value) self:SetBlur(value) end,
    })
    self._configTab = tab
    return tab
end

return YzZ
