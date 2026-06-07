--!native
--!optimize 2
-- ============================================================================
--  librehub (universal.lua) с ЗАМЕНЁННЫМ меню на juanitahaxx (samet).
--  Библиотека меню ВШИТА прямо в файл (без HttpGet). Код всех фич не изменён.
-- ============================================================================

-- ---- LPH stubs (fabricated values) ----
--!native
--!optimize 2

-- FABRICATED VALUES!!!
if not LPH_OBFUSCATED then
	LPH_JIT = function(...)
		return ...;
	end;
	LPH_JIT_MAX = function(...)
		return ...;
	end;
	LPH_NO_VIRTUALIZE = function(...)
		return ...;
	end;
	LPH_NO_UPVALUES = function(f)
		return (function(...)
			return f(...);
		end);
	end;
	LPH_ENCSTR = function(...)
		return ...;
	end;
	LPH_ENCNUM = function(...)
		return ...;
	end;
	LPH_ENCFUNC = function(func, key1, key2)
		if key1 ~= key2 then return print("LPH_ENCFUNC mismatch") end
		return func
	end
	LPH_CRASH = function()
		return print(debug.traceback());
	end;
	SWG_DiscordUser = "swim"
	SWG_DiscordID = 1337
	SWG_SecondsLeft = 9999
	SWG_Note = "scp,alpha"
	SWG_IsLifetime = true
end;

-- ---- adonis bypass ----
do -- fuckass adonis bypass :heart:
	for _, v in getgc(true) do
		if type(v) == "table" then
			local namecallInstance = rawget(v, "namecallInstance")
			-- god forgive me
			if not (namecallInstance and type(namecallInstance) == "table" and type(namecallInstance[1]) == "string" and type(namecallInstance[2]) == "function") then
				continue
			end

			setreadonly(v, false)
			for caller, tbl in v do
				v[caller] = {"kick", function(...) return coroutine.yield() end}
			end
		end
	end
end

-- ---- folders ----
local Folder = "moneyblox"
makefolder(Folder)

local ImagesFolder = string.format( "%s\\%s\\", Folder, "Images" )
makefolder(ImagesFolder)

local FontsFolder = string.format( "%s\\%s\\", Folder, "FontsFolder" )
makefolder(FontsFolder)
delfolder(FontsFolder) -- we do a little trolling
makefolder(FontsFolder)

local ConfigFolder = string.format( "%s\\%s\\", Folder, "Configs" )
makefolder(ConfigFolder)

local ThemeFolder = string.format( "%s\\%s\\", Folder, "Themes" )
makefolder(ThemeFolder)

-- ---- Loading screen ----
do
	local CoreGui   = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
	local TweenSvc  = game:GetService("TweenService")
	local RS        = game:GetService("RunService")
	local startTime = tick()

	local C_BG      = Color3.fromRGB(12, 12, 12)
	local C_OUTLINE = Color3.fromRGB(51, 51, 51)
	local C_ACCENT  = Color3.fromRGB(176, 176, 209)
	local C_TEXT    = Color3.fromRGB(208, 207, 227)
	local C_INACTIVE= Color3.fromRGB(134, 134, 134)
	local C_ELEM    = Color3.fromRGB(39, 39, 39)

	local sg = Instance.new("ScreenGui")
	sg.Name           = "LoaderGui"
	sg.ResetOnSpawn   = false
	sg.DisplayOrder   = 9999
	sg.IgnoreGuiInset = true
	pcall(function() sg.Parent = CoreGui end)
	if not sg.Parent then
		sg.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	end

	-- карточка: 320×78, одна тонкая обводка
	local card = Instance.new("Frame", sg)
	card.Size             = UDim2.fromOffset(320, 78)
	card.AnchorPoint      = Vector2.new(0.5, 0.5)
	card.Position         = UDim2.fromScale(0.5, 0.5)
	card.BackgroundColor3 = C_BG
	card.BorderSizePixel  = 0
	card.ZIndex           = 2
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 4)
	local stroke = Instance.new("UIStroke", card)
	stroke.Color              = C_OUTLINE
	stroke.Thickness          = 1
	stroke.ApplyStrokeMode    = Enum.ApplyStrokeMode.Border

	-- аватарка (загружаем с url, сохраняем локально, грузим как asset)
	local ghost = Instance.new("ImageLabel", card)
	ghost.Size                   = UDim2.fromOffset(54, 54)
	ghost.Position               = UDim2.fromOffset(8, 10)
	ghost.BackgroundTransparency = 1
	ghost.Image                  = ""
	ghost.ScaleType              = Enum.ScaleType.Fit
	ghost.ZIndex                 = 3
	Instance.new("UICorner", ghost).CornerRadius = UDim.new(0, 4)
	-- грузим картинку асинхронно чтобы не тормозить лоадер
	task.spawn(function()
		local avatarPath = "moneyblox\\avatar.png"
		-- ЗАМЕНИ ССЫЛКУ на прямую ссылку на картинку (GitHub raw / Discord CDN)
		local AVATAR_URL = "https://cdn.discordapp.com/attachments/999665529738502244/1511435837798088755/ab2c3c1693b6b333f9a6fe641d39d13d-removebg-preview.png"
		if not isfile(avatarPath) then
			local ok, data = pcall(game.HttpGet, game, AVATAR_URL)
			if ok and data and #data > 100 then
				writefile(avatarPath, data)
			end
		end
		if isfile(avatarPath) then
			local asset = getcustomasset(avatarPath)
			ghost.Image = asset
		end
	end)

	-- "loading."
	local title = Instance.new("TextLabel", card)
	title.Size                   = UDim2.fromOffset(220, 18)
	title.Position               = UDim2.fromOffset(68, 12)
	title.BackgroundTransparency = 1
	title.Text                   = "loading."
	title.Font                   = Enum.Font.Code
	title.TextSize               = 15
	title.TextColor3             = C_TEXT
	title.TextXAlignment         = Enum.TextXAlignment.Left
	title.ZIndex                 = 3

	-- подпись этапа
	local subtitle = Instance.new("TextLabel", card)
	subtitle.Size                   = UDim2.fromOffset(220, 15)
	subtitle.Position               = UDim2.fromOffset(70, 32)
	subtitle.BackgroundTransparency = 1
	subtitle.Text                   = "Initializing"
	subtitle.Font                   = Enum.Font.Code
	subtitle.TextSize               = 12
	subtitle.TextColor3             = C_INACTIVE
	subtitle.TextXAlignment         = Enum.TextXAlignment.Left
	subtitle.ZIndex                 = 3

	-- фон бара
	local barBg = Instance.new("Frame", card)
	barBg.Size             = UDim2.fromOffset(298, 4)
	barBg.Position         = UDim2.fromOffset(11, 64)
	barBg.BackgroundColor3 = C_ELEM
	barBg.BorderSizePixel  = 0
	barBg.ZIndex           = 3
	Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 2)

	-- заливка бара
	local barFill = Instance.new("Frame", barBg)
	barFill.Size             = UDim2.fromOffset(0, 4)
	barFill.BackgroundColor3 = C_ACCENT
	barFill.BorderSizePixel  = 0
	barFill.ZIndex           = 4
	Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 2)

	local BAR_W = 298
	local function setProgress(pct, label)
		subtitle.Text = label
		TweenSvc:Create(barFill,
			TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{Size = UDim2.fromOffset(math.floor(BAR_W * pct), 4)}
		):Play()
	end

	local dotConn
	local dotN = 0
	dotConn = RS.Heartbeat:Connect(function()
		dotN = (dotN + 1) % 4
		title.Text = "loading" .. string.rep(".", dotN == 0 and 1 or dotN)
	end)

	local stages = {
		{0.10, "Initializing",        0.25},
		{0.28, "Loading modules",     0.35},
		{0.48, "64 modules ready",    0.30},
		{0.66, "Disabling Anticheat", 0.30},
		{0.82, "Patching memory",     0.25},
		{0.94, "Applying hooks",      0.20},
		{1.00, "Complete! :3",        0.15},
	}

	task.spawn(function()
		for _, stage in ipairs(stages) do
			setProgress(stage[1], stage[2])
			task.wait(stage[3])
		end

		local elapsed = string.format("%.2f", tick() - startTime)
		dotConn:Disconnect()
		title.Text    = "loaded in " .. elapsed .. "s"
		subtitle.Text = "Complete! :3"
		subtitle.TextColor3 = C_TEXT

		task.wait(0.9)

		local info = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		TweenSvc:Create(card, info, {Position = UDim2.new(0.5, 0, 0.5, 40)}):Play()
		for _, desc in card:GetDescendants() do
			pcall(function()
				if desc:IsA("TextLabel") then
					TweenSvc:Create(desc, info, {TextTransparency = 1}):Play()
				elseif desc:IsA("Frame") then
					TweenSvc:Create(desc, info, {BackgroundTransparency = 1}):Play()
				end
			end)
		end
		TweenSvc:Create(card, info, {BackgroundTransparency = 1}):Play()
		task.wait(0.45)
		sg:Destroy()
	end)
end

-- ---- Fonts & Images loader ----
local Fonts, Images = LPH_JIT(function()
	local RunService = game:GetService("RunService")
	local HttpService = game:GetService("HttpService")

	local Fonts = {
		URL = "https://raw.githubusercontent.com/SWIMHUBISWIMMING/librehub/refs/heads/main/assets/",

		Names = {
			"Tahoma",
			"TahomaXP",
			"Comfortaa",
			"Verdana",
			"SmallestPixel7",
			"Proggy",
		},

		Data = {}
	}; do
		function Fonts.Load(font)
			if not RunService:IsStudio() then
				local TTF = string.format("%s%s.ttf", FontsFolder, font)
				local JSON = string.format("%s%s.json", FontsFolder, font)

				if not isfile(TTF) then
					local success, data = pcall(function()
						return game:HttpGet( string.format("%s%s.txt", Fonts.URL, font) )
					end)

					if success and data then
						writefile(TTF, base64_decode(data))
					else
						return
					end			
				end

				if not isfile(JSON) then
					local Font = {
						name = font,
						faces = {{
							name = "Regular",
							weight = 400,
							style = "normal",
							assetId = getcustomasset(TTF)
						}}
					}

					writefile(JSON, HttpService:JSONEncode(Font))
				end

				Fonts.Data[font] = Font.new(getcustomasset(JSON), Enum.FontWeight.Regular)
			end
		end

		function Fonts.Get(font)
			return Fonts.Data[font]
		end

		for _,font in Fonts.Names do
			Fonts.Load(font)
		end
	end

	local Images = {
		URL = "https://raw.githubusercontent.com/SWIMHUBISWIMMING/librehub/refs/heads/main/assets/",

		Names = {
			"combat",
			"visuals",
			"misc",
			"config",
			"checkers",
			"saturation",
			"scrollbar",
			"lines"
		},

		Data = {}
	}; do
		function Images.Load(image)
			if not RunService:IsStudio() then
				local PNG = string.format("%s%s.png", ImagesFolder, image)

				if not isfile(PNG) then
					local success, data = pcall(function()
						return game:HttpGet( string.format( "%s%s.txt", Images.URL, image ) )
					end)

					if success and data then
						writefile(PNG, base64_decode(data))
					else
						return
					end
				end

				Images.Data[image] = getcustomasset(PNG)
			end
		end

		function Images.Get(image)
			return Images.Data[image]
		end

		for _,image in Images.Names do
			Images.Load(image)
		end
	end
	return Fonts, Images
end)();

-- ---- NEW menu library (EMBEDDED) + compatibility adapter ----
local Library, Utility = (function()
-- ============================================================================
--  COMPATIBILITY ADAPTER (shim)
--  Переводит СТАРЫЙ API меню librehub (Window/Tab/SubTab/Section + :Toggle/:Slider/
--  :Dropdown/:Button/:Keybind/:Colorpicker/:Textbox/:List) на НОВУЮ библиотеку
--  juanitahaxx (samet). Благодаря этому весь код фич остаётся БЕЗ ИЗМЕНЕНИЙ.
--
--  NewLib = загруженная библиотека juanitahaxx (возвращает Library).
-- ============================================================================
-- === НОВАЯ библиотека меню (juanitahaxx by samet) — ВШИТА, без HttpGet ===
local NEWLIB = (function()
--[[
    Code is not as clean as it could be but it works
    
    Made by samet
    This is a FREE ui release made by me (samet) on May 30 to celebrate my birthday, If anyone is selling this they are scammers.
    The design credits for the ui goes to eskolzz. It was brought to life in luau by me.

    MY ONLY ACCOUNT IS: joestar._3

    If you want to commission a ui:
    https://discord.gg/XsTteAwprs

    Please give credit if used or modified.
]]

if getgenv().Library then
    getgenv().Library:Exit()
end

cloneref = cloneref or function(...) return ... end 

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local CoreGui = cloneref(game:GetService("CoreGui"))

gethui = gethui or function() return CoreGui end

local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled or false
local GuiInset = GuiService:GetGuiInset().Y
local Mouse = cloneref(LocalPlayer:GetMouse())

local Library = { 
    Flags = { },
    MenuKeybind = tostring(Enum.KeyCode.X), -- has to be a string

    Directory = "juanitaaaaaaa",
    Folders = {
        Assets = "/Assets",
        Configs = "/Configs",
        Themes = "/Themes"
    },

    FontSize = 12,

    Animation = {
        Time = 0.3,
        Style = "Quint",
        Direction = "Out"
    },

    TabAnimation = {
        Time = 1,
        Style = "Exponential",
        Direction = "Out"
    },

    ColorpickerAnimation = {
        Time = 0.55,
        Style = "Exponential",
        Direction = "Out"
    },

    NotifAnimation = {
        Time = 0.85,
        Style = "Exponential",
        Direction = "Out"
    },

    ZIndexOrder = {
        ["OptionHolder"] = 4,
        ["KeybindWindow"] = 4, -- burp
        ["ColorpickerWindow"] = 6
    },

    -- Ignore below
    Threads = { },
    Connections = { },
    SetFlags = { },

    ThemingStuff = { },
    ThemeMap = { },

    OpenFrames = { },

    Holder = nil,
    UnusedHolder = nil,

    Font = nil,

    Notifications = { },
    KeyList = nil,

    Theme = nil,
} do 
    Library.__index = Library

    local Flags = Library.Flags 
    local SetFlags = Library.SetFlags

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    -- Folders
    if not isfolder(Library.Directory) then 
        makefolder(Library.Directory)
    end

    for _, Folder in Library.Folders do 
        if not isfolder(Library.Directory .. Folder) then 
            makefolder(Library.Directory .. Folder)
        end
    end

    if not isfile(Library.Directory .. "/autoload.json") then 
        writefile(Library.Directory .. "/autoload.json", "")
    end

    local Themes = {
        ["Preset"] = {
            ["Border"] = Color3.fromRGB(3, 3, 3),
            ["Outline"] = Color3.fromRGB(51, 51, 51),
            ["Background"] = Color3.fromRGB(12, 12, 12),
            ["Inline"] = Color3.fromRGB(19, 19, 19),
            ["Accent"] = Color3.fromRGB(176, 176, 209),
            ["Text"] = Color3.fromRGB(208, 207, 227),
            ["Inactive Text"] = Color3.fromRGB(134, 134, 134),
            ["Element"] = Color3.fromRGB(39, 39, 39),
            ["Element 2"] = Color3.fromRGB(56, 56, 56),
            ["Hovered Element"] = Color3.fromRGB(61, 61, 61)
        }
    }

    Library.Theme = Themes.Preset

    -- Custom Font
    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if not isfile(Data.Id) then 
                writefile(Data.Id, game:HttpGet(Data.Url))
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = Name,
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Data.Id)
                    }
                }
            }

            writefile((Library.Directory .. Library.Folders.Assets .. "/" .. Name .. ".font"), HttpService:JSONEncode(Data))
            return Font.new(getcustomasset(Library.Directory .. Library.Folders.Assets .. "/" .. Name .. ".font"))
        end

        Library.Font = CustomFont:New("TahomaXP", 400, "Regular", {
            Id = "TahomaXP",
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/windows-xp-tahoma.ttf"
        })
    end

    Library.Exit = function(Self)
        for _, Connection in Library.Connections do 
            Connection:Disconnect()
        end

        for _, Thread in Library.Threads do 
            coroutine.close(Thread)
        end

        if Self.Holder then 
            Self.Holder.Instance:Destroy()
        end

        if Self.UnusedHolder then 
            Self.UnusedHolder.Instance:Destroy()
        end

        for Index, Value in Library.Notifications do 
            Value.Items.Notification.Instance:Destroy()
        end

        if Self.NotifHolder then 
            Self.NotifHolder.Instance:Destroy()
        end

        Library = nil
        getgenv().Library = nil
    end

    Library.Create = function(Self, Class, Properties)
        local Data = {
            Class = Class,
            Properties = Properties,
            Instance = Instance.new(Class)
        }

        for Index, Property in Properties do 
            if Property == "FontFace" then
                Data.Instance[Property] = Library.Font
                continue
            end

            if Property == "TextSize" then 
                Data.Instance[Property] = Library.FontSize
                continue
            end

            if Property == "Name" then 
                Data.Instance[Property] = "\0"
                continue
            end

            if Class == "TextButton" then 
                if Property == "AutoButtonColor" then 
                    Data.Instance[Property] = false
                    continue
                end

                if Property == "Text" then 
                    Data.Instance[Property] = ""
                    continue
                end
            end

            Data.Instance[Index] = Property
        end

        return setmetatable(Data, Library)
    end

    Library.Thread = function(Self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        table.insert(Library.Threads, NewThread)
        return NewThread
    end

    Library.Connect = function(Self, Signal, Callback)
        local Connection

        if Self.Instance then
            if Self.Instance[Signal] then 
                if IsMobile and Signal == "MouseButton1Down" then 
                    Connection = Self.Instance.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Callback(Input)
                        end
                    end)

                    return
                end
                
                Connection = Self.Instance[Signal]:Connect(Callback)
            else
                Connection = Signal:Connect(Callback)
            end
        else
            Connection = Signal:Connect(Callback)
        end

        table.insert(Library.Connections, Connection)
        return Connection
    end

    Library.Tween = function(Self, Properties, Info, IsRawItem)
        if not Library then return end 

        local Object = Self.Instance or IsRawItem
        Info = Info or TweenInfo.new(Library.Animation.Time, Enum.EasingStyle[Library.Animation.Style], Enum.EasingDirection[Library.Animation.Direction])

        if not Object then 
            return 
        end

        local NewTween = TweenService:Create(Object, Info, Properties)
        NewTween:Play()

        return NewTween
    end

    Library.GetTweenProperty = function(Self, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then 
            return { }
        end

        if Object:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Object:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Object:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("UIStroke") then 
            return { "Transparency" }
        end
    end

    Library.Fade = function(Self, Property, Visibility, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then 
            return 
        end

        local OldTransparency = Object[Property]
        Object[Property] = Visibility and 1 or OldTransparency

        local NewTween = Library:Tween({[Property] = Visibility and OldTransparency or 1}, nil, Object)

        Library:Connect(NewTween.Completed, function()
            if not Visibility then 
                task.wait()
                Object[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    Library.FadeDescendants = function(Self, Visibility, Callback)
        if Visibility then 
            Self.Instance.Visible = true 
        end

        local NewTween 

        local Children = Self.Instance:GetDescendants()
        table.insert(Children, Self.Instance)

        for _, Child in Children do 
            local TransparencyProperty = Library:GetTweenProperty(Child)

            if not TransparencyProperty then 
                continue 
            end

            if type(TransparencyProperty) == "table" then
                for _, Property in TransparencyProperty do
                    NewTween = Library:Fade(Property, Visibility, Child)
                end
            else
                NewTween = Library:Fade(TransparencyProperty, Visibility, Child)
            end
        end

        Library:Connect(NewTween.Completed, function()
            if Callback and type(Callback) == "function" then 
                Callback()
            end

            Self.Instance.Visible = Visibility
        end)
    end

    Library.MakeDraggable = function(Self)
        if not Self.Instance then 
            return
        end
    
        local Gui = Self.Instance
        local Dragging = false 
        local DragStart
        local StartPosition 
    
        local Set = function(Input)
            local Scale = Library:GetScreenScale()
            local DragDelta = (Input.Position - DragStart) / Scale
            
            local NewX = StartPosition.X.Offset + DragDelta.X
            local NewY = StartPosition.Y.Offset + DragDelta.Y

            local ScreenSize = Gui.Parent.AbsoluteSize / Scale
            local GuiSize = Gui.AbsoluteSize / Scale
            
            NewX = math.clamp(NewX, 0, ScreenSize.X - GuiSize.X)
            NewY = math.clamp(NewY, 0, ScreenSize.Y - GuiSize.Y)
    
            Self:Tween({Position = UDim2.new(0, NewX, 0, NewY)}, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
        end
    
        local InputChanged
    
        Self:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = Input.Position
                StartPosition = Gui.Position
    
                if InputChanged then 
                    return
                end
    
                InputChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                        InputChanged:Disconnect()
                        InputChanged = nil
                    end
                end)
            end
        end)
    
        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if Dragging then
                    Set(Input)
                end
            end
        end)
    
        return Dragging
    end

    Library.MakeResizeable = function(Self, Minimum)
        if not Self.Instance then 
            return
        end

        local Gui = Self.Instance

        local Resizing = false 
        local CurrentSide = nil

        local StartMouse = nil 
        local StartPosition = nil 
        local StartSize = nil
        
        local EdgeThickness = 2

        local MakeEdge = function(Name, Position, Size)
            local Button = Library:Create("TextButton", {
                Name = "\0",
                Size = Size,
                Position = Position,
                BackgroundColor3 = Color3.fromRGB(166, 147, 243),
                BackgroundTransparency = 1,
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = Gui,
            })  Button:AddToTheme({BackgroundColor3 = "Accent"})

            return Button
        end

        local Edges = {
            {Button = MakeEdge(
                "Left", 
                UDim2.new(0, 0, 0, 0), 
                UDim2.new(0, EdgeThickness, 1, 0)), 
                Side = "L"
            },

            {Button = MakeEdge(
                "Right", 
                UDim2.new(1, -EdgeThickness, 0, 0), 
                UDim2.new(0, EdgeThickness, 1, 0)), 
                Side = "R"
            },

            {Button = MakeEdge(
                "Top", UDim2.new(0, 0, 0, 0), 
                UDim2.new(1, 0, 0, EdgeThickness)), 
                Side = "T"
            },

            {Button = MakeEdge(
                "Bottom", 
                UDim2.new(0, 0, 1, -EdgeThickness), 
                UDim2.new(1, 0, 0, EdgeThickness)), 
                Side = "B"
            },
        }

        local BeginResizing = function(Side)
            Resizing = true 
            CurrentSide = Side 

            StartMouse = UserInputService:GetMouseLocation()

            StartPosition = Vector2.new(Gui.Position.X.Offset, Gui.Position.Y.Offset)
            StartSize = Vector2.new(Gui.Size.X.Offset, Gui.Size.Y.Offset)
            
            for Index, Value in Edges do 
                Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
            end
        end

        local EndResizing = function()
            Resizing = false 
            CurrentSide = nil

            for Index, Value in Edges do 
                Value.Button.Instance.BackgroundTransparency = 1
            end
        end

        for Index, Value in Edges do 
            Value.Button:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    BeginResizing(Value.Side)
                end
            end)
        end

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if Resizing then
                    EndResizing()
                end
            end
        end)

        Library:Connect(RunService.RenderStepped, function()
            if not Resizing or not CurrentSide then 
                return 
            end

            local MouseLocation = UserInputService:GetMouseLocation()
            local dx = MouseLocation.X - StartMouse.X
            local dy = MouseLocation.Y - StartMouse.Y
        
            local x, y = StartPosition.X, StartPosition.Y
            local w, h = StartSize.X, StartSize.Y

            if CurrentSide == "L" then
                x = StartPosition.X + dx
                w = StartSize.X - dx
            elseif CurrentSide == "R" then
                w = StartSize.X + dx
            elseif CurrentSide == "T" then
                y = StartPosition.Y + dy
                h = StartSize.Y - dy
            elseif CurrentSide == "B" then
                h = StartSize.Y + dy
            end
        
            if w < Minimum.X then
                if CurrentSide == "L" then
                    x = x - (Minimum.X - w)
                end
                w = Minimum.X
            end
            if h < Minimum.Y then
                if CurrentSide == "T" then
                    y = y - (Minimum.Y - h)
                end
                h = Minimum.Y
            end
        
            Self:Tween({Position = UDim2.fromOffset(x, y)}, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
            Self:Tween({Size = UDim2.fromOffset(w, h)}, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
        end)
    end

    Library.IsMouseOverFrame = function(Self)
        if not Self.Instance then 
            return 
        end

        local Object = Self.Instance

        local MousePosition = Vector2.new(Mouse.X, Mouse.Y)

        return MousePosition.X >= Object.AbsolutePosition.X and MousePosition.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X 
        and MousePosition.Y >= Object.AbsolutePosition.Y and MousePosition.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
    end

    Library.SafeCall = function(Self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, table.unpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success, Result
    end

    Library.Round = function(Self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return math.floor(Number * Multiplier) / Multiplier
    end

    Library.GetConfig = function(Self)
        local Config = { }

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        if not Success then
            warn("Failed to get config:\n"..Result)
            return
        end

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(Self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Library.GetConfigsList = function(Self, Element)
        local List = { }
        local ReturnList = { }

        List = listfiles(Library.Directory .. Library.Folders.Configs)

        for Index = 1, #List do 
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    table.insert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        Element:Refresh(ReturnList)
    end

    Library.AddToTheme = function(Self, Properties)
        local Object = Self.Instance

        local ThemeData = {
            Item = Object,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                if not Library.Theme[Value] then
                    Object[Property] = Value 
                end

                Object[Property] = Library.Theme[Value]
            else
                Object[Property] = Value()
            end
        end

        table.insert(Library.ThemingStuff, ThemeData)
        Library.ThemeMap[Object] = ThemeData
        return Self
    end

    Library.ChangeItemTheme = function(Self, Properties)
        local Object = Self.Instance

        if not Library.ThemeMap[Object] then 
            return
        end

        Library.ThemeMap[Object].Properties = Properties
        Library.ThemeMap[Object] = Library.ThemeMap[Object]
    end

    Library.ChangeTheme = function(Self, Theme, Color)
        Library.Theme[Theme] = Color

        for _, Item in Library.ThemingStuff do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.OnHover = function(Self, OnHoverEnter, OnHoverLeave)
        local Object = Self.Instance

        if not Object then 
            return 
        end 

        Library:Connect(Object.MouseEnter, OnHoverEnter)
        Library:Connect(Object.MouseLeave, OnHoverLeave)
    end

    Library.GetScreenScale = function(Self)
        local Scale = 1
    
        for _, Obj in Library.Holder.Instance:GetDescendants() do
            if Obj:IsA("UIScale") then
                Scale *= Obj.Scale
            end
        end
    
        return Scale
    end
    
    Library.PopupPosition = function(Self, Anchor, Popup, ExtraY)
        local Scale = Library:GetScreenScale()
        ExtraY = ExtraY or 0
    
        local X = Anchor.AbsolutePosition.X / Scale
        local Y = (Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + GuiInset + ExtraY) / Scale
    
        return UDim2.fromOffset(X, Y)
    end

    Library.VisibleCheck = function(Self)
        local Object = Self.Instance 

        if not Object then 
            return 
        end

        local OriginalParent = Object.Parent

        Library:Connect(Object:GetPropertyChangedSignal("Visible"), function()
            local IsVisible = Object.Visible
            Object.Parent = IsVisible and OriginalParent or Library.UnusedHolder.Instance
        end)
    end

    Library.GetTheme = function(Self)
        local Config = { }

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Color and Value.Flag:find("Theming") then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                end
            end
        end)

        if not Success then
            warn("Failed to get theme:\n"..Result)
            return
        end

        return HttpService:JSONEncode(Config)
    end

    Library.LoadTheme = function(Self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                end
            end
        end)

        return Success, Result
    end

    Library.GetThemesList = function(Self, Element)
        local List = { }
        local ReturnList = { }

        List = listfiles(Library.Directory .. Library.Folders.Themes)

        for Index = 1, #List do 
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    table.insert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        Element:Refresh(ReturnList)
    end

    Library.Holder = Library:Create("ScreenGui", {
        Parent = gethui(),
        IgnoreGuiInset = true,
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    Library.NotifHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        IgnoreGuiInset = true,
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    Library.UnusedHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        Enabled = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    -- themes
    Library:Thread(function()
        writefile(Library.Directory .. Library.Folders.Themes .. "/Sky.json", '{"MenuKeybindModeDropdown":"Toggle","AccentTheming":{"Color":"#93eeff","Alpha":0},"BackgroundTheming":{"Color":"#141718","Alpha":0},"color":{"Color":"#ffffff","Alpha":0},"MenuKeybind":{"Key":"Enum.KeyCode.X","Mode":"Toggle"},"keybindModeDropdown":"Toggle","keybind2ModeDropdown":"Toggle","Hovered ElementTheming":{"Color":"#444949","Alpha":0},"keybind2ShowInKeybindsList":true,"target":"Head","OutlineTheming":{"Color":"#292d2e","Alpha":0},"keybind3ShowInKeybindsList":true,"InlineTheming":{"Color":"#1f2324","Alpha":0},"keybind":{"Key":"Enum.KeyCode.E","Mode":"Toggle"},"keybind3":{"Key":"Enum.KeyCode.R","Mode":"Toggle"},"keybind3ModeDropdown":"Toggle","ElementTheming":{"Color":"#2e3131","Alpha":0},"Element 2Theming":{"Color":"#454a4b","Alpha":0},"keybind2":{"Key":"Enum.KeyCode.F","Mode":"Toggle"},"ThemeName":"Sky","BorderTheming":{"Color":"#1a1d1d","Alpha":0},"AutoParry":false,"ConfigName":"","keybindShowInKeybindsList":true,"Inactive TextTheming":{"Color":"#868686","Alpha":0},"walkspeed":16,"TextTheming":{"Color":"#ffffff","Alpha":0},"MenuKeybindShowInKeybindsList":true,"textbox":"default"}')
        writefile(Library.Directory .. Library.Folders.Themes .. "/Magma.json", '{"MenuKeybindModeDropdown":"Toggle","AccentTheming":{"Color":"#e92b1a","Alpha":0},"BackgroundTheming":{"Color":"#221c1c","Alpha":0},"color":{"Color":"#ffffff","Alpha":0},"MenuKeybind":{"Key":"Enum.KeyCode.X","Mode":"Toggle"},"keybindModeDropdown":"Toggle","keybind2ModeDropdown":"Toggle","Hovered ElementTheming":{"Color":"#362a2a","Alpha":0},"keybind2ShowInKeybindsList":true,"target":"Head","OutlineTheming":{"Color":"#291d1d","Alpha":0},"keybind3ShowInKeybindsList":true,"InlineTheming":{"Color":"#1f1717","Alpha":0},"keybind":{"Key":"Enum.KeyCode.E","Mode":"Toggle"},"keybind3":{"Key":"Enum.KeyCode.R","Mode":"Toggle"},"keybind3ModeDropdown":"Toggle","ElementTheming":{"Color":"#292121","Alpha":0},"Element 2Theming":{"Color":"#363131","Alpha":0},"keybind2":{"Key":"Enum.KeyCode.F","Mode":"Toggle"},"ThemeName":"Magma","BorderTheming":{"Color":"#000000","Alpha":0},"AutoParry":true,"ConfigName":"","keybindShowInKeybindsList":true,"Inactive TextTheming":{"Color":"#867979","Alpha":0},"walkspeed":16,"TextTheming":{"Color":"#d0cfe3","Alpha":0},"MenuKeybindShowInKeybindsList":true,"textbox":"default"}')
        writefile(Library.Directory .. Library.Folders.Themes .. "/Sand.json", '{"MenuKeybindModeDropdown":"Toggle","AccentTheming":{"Color":"#ffe593","Alpha":0},"BackgroundTheming":{"Color":"#2d2e25","Alpha":0},"color":{"Color":"#ffffff","Alpha":0},"MenuKeybind":{"Key":"Enum.KeyCode.X","Mode":"Toggle"},"keybindModeDropdown":"Toggle","keybind2ModeDropdown":"Toggle","Hovered ElementTheming":{"Color":"#47473b","Alpha":0},"keybind2ShowInKeybindsList":true,"target":"Head","OutlineTheming":{"Color":"#585344","Alpha":0},"keybind3ShowInKeybindsList":true,"InlineTheming":{"Color":"#3f4137","Alpha":0},"keybind":{"Key":"Enum.KeyCode.E","Mode":"Toggle"},"keybind3":{"Key":"Enum.KeyCode.R","Mode":"Toggle"},"keybind3ModeDropdown":"Toggle","ElementTheming":{"Color":"#36362c","Alpha":0},"Element 2Theming":{"Color":"#414133","Alpha":0},"keybind2":{"Key":"Enum.KeyCode.F","Mode":"Toggle"},"ThemeName":"Sand","BorderTheming":{"Color":"#141403","Alpha":0},"AutoParry":false,"ConfigName":"","keybindShowInKeybindsList":true,"Inactive TextTheming":{"Color":"#888784","Alpha":0},"walkspeed":16,"TextTheming":{"Color":"#d0cfe3","Alpha":0},"MenuKeybindShowInKeybindsList":true,"textbox":"default"}')
        writefile(Library.Directory .. Library.Folders.Themes .. "/Navy.json", '{"MenuKeybindModeDropdown":"Toggle","AccentTheming":{"Color":"#0066ff","Alpha":0},"BackgroundTheming":{"Color":"#1c1e24","Alpha":0},"color":{"Color":"#ffffff","Alpha":0},"Watermark":true,"keybind2ModeDropdown":"Toggle","keybindModeDropdown":"Toggle","Hovered ElementTheming":{"Color":"#282b31","Alpha":0},"keybind2ShowInKeybindsList":true,"ThemeName":"Navy","InlineTheming":{"Color":"#202229","Alpha":0},"textbox":"default","OutlineTheming":{"Color":"#252a36","Alpha":0},"keybind":{"Key":"Enum.KeyCode.E","Mode":"Toggle"},"MenuKeybind":{"Key":"Enum.KeyCode.X","Mode":"Toggle"},"BorderTheming":{"Color":"#030303","Alpha":0},"keybind3":{"Key":"Enum.KeyCode.R","Mode":"Toggle"},"keybind3ModeDropdown":"Toggle","ElementTheming":{"Color":"#1d202b","Alpha":0},"Keybind list":true,"keybind2":{"Key":"Enum.KeyCode.F","Mode":"Toggle"},"AutoParry":true,"keybind3ShowInKeybindsList":true,"Element 2Theming":{"Color":"#3e414b","Alpha":0},"keybindShowInKeybindsList":true,"ConfigName":"","Inactive TextTheming":{"Color":"#65697e","Alpha":0},"walkspeed":34,"TextTheming":{"Color":"#a5a4bb","Alpha":0},"MenuKeybindShowInKeybindsList":true,"target":"Head"}')
    end)

    do
        local ColorpickerInfo = TweenInfo.new(Library.ColorpickerAnimation.Time, Enum.EasingStyle[Library.ColorpickerAnimation.Style], Enum.EasingDirection[Library.ColorpickerAnimation.Direction])

        Library.CreateColorpicker = function(Self, Data)
            local Colorpicker = {
                Hue = 0,
                Saturation = 0,
                Value = 0,

                Alpha = 0,

                Color = Color3.fromRGB(255, 255, 255),
                HexValue = "#FFFFFF",

                Flag = Data.Flag,
                IsOpen = false,

                Items = { }
            }

            local Items = { } do 
                Items["ColorpickerButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 23, 0, 9),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 57, 83)
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["ColorpickerButton"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })                

                Items["ColorpickerWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1049, 0, 216),
                    Size = UDim2.new(0, 240, 0, 190),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Items["CurrentColor"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -10),
                    Size = UDim2.new(1, -20, 0, 10),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 57, 83)
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["CurrentColor"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CurrentColor"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CurrentColor"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Items["Alpha"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -10, 0, 10),
                    Size = UDim2.new(0, 15, 1, -40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 57, 83)
                })
                
                Items["Fill"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Fill"].Instance,
                    Rotation = -90,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                }
                })
                
                Items["AlphaDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["AlphaDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Items["Hue"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -35, 0, 10),
                    Size = UDim2.new(0, 15, 1, -40),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }
                })
                
                Items["HueDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["HueDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Items["Palette"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -70, 1, -40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 57, 83)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Items["Saturation"] = Library:Create("Frame", {
                    Name = "\0",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(1, 1, 1, 0),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Saturation"].Instance,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }
                })
                
                Items["Value"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(1, 1, 1, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Value"].Instance,
                    Rotation = 90,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }
                })
                
                Items["PaletteDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(0, 1, 0, 1),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["PaletteDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({Color = 'Border'})                

                Colorpicker.Items = Items
            end

            function Colorpicker:SetVisibility(Bool)
                Items["ColorpickerButton"].Instance.Visible = Bool
            end

            function Colorpicker:Update(IsFromAlpha)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = Color3.fromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()
        
                Items["ColorpickerButton"]:Tween({BackgroundColor3 = Colorpicker.Color})
                Items["Palette"]:Tween({BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)})

                Flags[Colorpicker.Flag] = {
                    Alpha = Colorpicker.Alpha,
                    Color = Colorpicker.Color,
                    HexValue = Colorpicker.HexValue,
                    Flag = Colorpicker.Flag,
                    Transparency = 1 - Colorpicker.Alpha
                }

                Items["CurrentColor"]:Tween({BackgroundColor3 = Colorpicker.Color})
    
                if not IsFromAlpha then 
                    Items["Alpha"]:Tween({BackgroundColor3 = Colorpicker.Color})
                end
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            local Debounce = false 
            local ColorpickerWindow = Items["ColorpickerWindow"].Instance
            local ColorpickerButton = Items["ColorpickerButton"].Instance

            local IsSettings = Data.Section and Data.Section.IsSettings

            function Colorpicker:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Colorpicker.IsOpen = Bool

                Debounce = true 
                
                if Colorpicker.IsOpen then 
                    ColorpickerWindow.Position = Library:PopupPosition(ColorpickerButton, ColorpickerWindow, 0)

                    ColorpickerWindow.Visible = true
                    Items["ColorpickerWindow"]:Tween({
                        Position = Library:PopupPosition(ColorpickerButton, ColorpickerWindow, 10)
                    })

                    Items["ColorpickerWindow"]:FadeDescendants(true, function()
                        Debounce = false
                    end)

                    for Index, Value in Library.OpenFrames do
                        if Value ~= IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Colorpicker] = Colorpicker 
                else
                    Items["ColorpickerWindow"]:Tween({
                        Position = Library:PopupPosition(ColorpickerButton, ColorpickerWindow, -10)
                    })

                    Items["ColorpickerWindow"]:FadeDescendants(false, function()
                        Debounce = false
                    end)

                    if Library.OpenFrames[Colorpicker] then 
                        Library.OpenFrames[Colorpicker] = nil
                    end
                end

                local Descendants = ColorpickerWindow:GetDescendants()
                table.insert(Descendants, ColorpickerWindow)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow + 4 or 1
                    else 
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow or 1
                    end
                end
            end

            Items["ColorpickerWindow"]:VisibleCheck()
    
            local SlidingPalette = false
            local PaletteChanged
            
            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end
    
                local ValueX = math.clamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = math.clamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)
    
                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY
    
                local SlideX = math.clamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local SlideY = math.clamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)
    
                Items["PaletteDragger"]:Tween({Position = UDim2.new(SlideX, 0, SlideY, 0)}, ColorpickerInfo)
                Colorpicker:Update()
            end
            
            local SlidingHue = false
            local HueChanged
    
            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end

                local ValueY = math.clamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)
    
                Colorpicker.Hue = ValueY
    
                local SlideY = math.clamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.99)
    
                Items["HueDragger"]:Tween({Position = UDim2.new(0, 0, SlideY, 0)}, ColorpickerInfo)
                Colorpicker:Update()
            end
    
            local SlidingAlpha = false 
            local AlphaChanged
    
            function Colorpicker:SlideAlpha(Input)
                if not Input or not SlidingAlpha then
                    return
                end
    
                local ValueY = math.clamp((Input.Position.Y - Items["Alpha"].Instance.AbsolutePosition.Y) / Items["Alpha"].Instance.AbsoluteSize.Y, 0, 1)
    
                Colorpicker.Alpha = ValueY
    
                local SlideY = math.clamp((Input.Position.Y - Items["Alpha"].Instance.AbsolutePosition.Y) / Items["Alpha"].Instance.AbsoluteSize.Y, 0, 0.99)
    
                Items["AlphaDragger"]:Tween({Position = UDim2.new(0, 0, SlideY, 0)}, ColorpickerInfo)
                Colorpicker:Update(true)
            end
    
            function Colorpicker:Set(Color, Alpha)
                if type(Color) == "table" then
                    Color = Color3.fromRGB(Color[1], Color[2], Color[3])
                elseif type(Color) == "string" then
                    Color = Color3.fromHex(Color)
                else
                    Color = Color -- Shit
                end 

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0  
    
                local PaletteValueX = math.clamp(1 - Colorpicker.Saturation, 0, 0.99)
                local PaletteValueY = math.clamp(1 - Colorpicker.Value, 0, 0.99)
    
                local AlphaPositionY = math.clamp(Colorpicker.Alpha, 0, 0.99)
                    
                local HuePositionY = math.clamp(Colorpicker.Hue, 0, 0.99)
    
                Items["PaletteDragger"]:Tween({Position = UDim2.new(PaletteValueX, 0, PaletteValueY, 0)}, ColorpickerInfo)
                Items["HueDragger"]:Tween({Position = UDim2.new(0, 0, HuePositionY, 0)}, ColorpickerInfo)
                Items["AlphaDragger"]:Tween({Position = UDim2.new(0, 0, AlphaPositionY, 0)}, ColorpickerInfo)
                Colorpicker:Update()
            end

            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)
    
            Items["Palette"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingPalette = true 
    
                    Colorpicker:SlidePalette(Input)
    
                    if PaletteChanged then
                        return
                    end
    
                    PaletteChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingPalette = false
    
                            PaletteChanged:Disconnect()
                            PaletteChanged = nil
                        end
                    end)
                end
            end)
    
            Items["Hue"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingHue = true 
    
                    Colorpicker:SlideHue(Input)
    
                    if HueChanged then
                        return
                    end
    
                    HueChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingHue = false
    
                            HueChanged:Disconnect()
                            HueChanged = nil
                        end
                    end)
                end
            end)
    
            Items["Alpha"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingAlpha = true 
    
                    Colorpicker:SlideAlpha(Input)
    
                    if AlphaChanged then
                        return
                    end
    
                    AlphaChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingAlpha = false
    
                            AlphaChanged:Disconnect()
                            AlphaChanged = nil
                        end
                    end)
                end
            end)
    
            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if SlidingPalette then 
                        Colorpicker:SlidePalette(Input)
                    end
    
                    if SlidingHue then
                        Colorpicker:SlideHue(Input)
                    end
    
                    if SlidingAlpha then
                        Colorpicker:SlideAlpha(Input)
                    end
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Colorpicker.IsOpen then
                        if Items["ColorpickerWindow"]:IsMouseOverFrame() then 
                            return 
                        end

                        Colorpicker:SetOpen(false)
                    end
                end
            end)

            if Data.Default then
                Colorpicker:Set(Data.Default, Data.Alpha)
            end
    
            SetFlags[Colorpicker.Flag] = function(Value, Alpha)
                Colorpicker:Set(Value, Alpha)
            end

            return Colorpicker, Items 
        end

        Library.CreateKeybind = function(Self, Data)
            local Keybind = {
                Flag = Data.Flag,
                IsOpen = false,

                Key = "",
                Mode = "",
                Value = "",

                Toggled = false,
                Picking = false,

                Items = { },
            }

            local Items = { } do
                Items["KeyButtonOutline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 0, 0, 13),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeyButtonOutline"].Instance,
                    PaddingTop = UDim.new(0, 1),
                    PaddingBottom = UDim.new(0, 1),
                    PaddingRight = UDim.new(0, 1),
                    PaddingLeft = UDim.new(0, 1)
                })
                
                Items["KeyButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["KeyButtonOutline"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "none",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Element 2"]
                }):AddToTheme({BackgroundColor3 = 'Element 2', TextColor3 = 'Text'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["KeyButton"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeyButton"].Instance,
                    PaddingBottom = UDim.new(0, 2),
                    PaddingRight = UDim.new(0, 5),
                    PaddingLeft = UDim.new(0, 6)
                })             
                
                Items["KeybindWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 200, 0, 50),
                    Position = UDim2.new(0.5749104022979736, 0, 0.8196721076965332, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    Padding = UDim.new(0, 8)
                })                
                
                Keybind.Items = Items
            end

            Items["KeyButton"]:OnHover(function()
                Items["KeyButton"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["KeyButton"]:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            local Debounce = false
            local KeybindWindow = Items["KeybindWindow"].Instance
            local KeyButton = Items["KeyButton"].Instance

            local IsSettings = Data.Section and Data.Section.IsSettings

            function Keybind:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Keybind.IsOpen = Bool

                Debounce = true 
                
                if Keybind.IsOpen then 
                    KeybindWindow.Visible = true
                    KeybindWindow.Position = Library:PopupPosition(KeyButton, KeybindWindow, 0)

                    Items["KeybindWindow"]:Tween({
                        Position = Library:PopupPosition(KeyButton, KeybindWindow, 10)
                    })
                    
                    Items["KeybindWindow"]:FadeDescendants(true, function()
                        Debounce = false 
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind 
                else
                    Items["KeybindWindow"]:Tween({
                        Position = Library:PopupPosition(KeyButton, KeybindWindow, -10)
                    })

                    Items["KeybindWindow"]:FadeDescendants(false, function()
                        Debounce = false
                    end)

                    if Library.OpenFrames[Keybind] then 
                        Library.OpenFrames[Keybind] = nil
                    end
                end

                local Descendants = KeybindWindow:GetDescendants()
                table.insert(Descendants, KeybindWindow)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then 
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow or 1
                    else
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow + 1 or 1
                    end
                end
            end

            Items["KeybindWindow"]:VisibleCheck()
    
            function Keybind:SetMode()
                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            end

            local KeybindObject 

            if Library.KeyList and Data.Name ~= "Menu Keybind" then 
                KeybindObject = Library.KeyList:Add("", "", "")
            end

            local Update = function()
                if KeybindObject then 
                    KeybindObject:Set(Data.Name, Keybind.Mode, Keybind.Value)
                    KeybindObject:SetStatus(Keybind.Toggled)
                end
            end

            local ModeDropdown = Library:Dropdown({
                Name = "Mode",
                Flag = Keybind.Flag .. "ModeDropdown",
                Parent = Items["KeybindWindow"],
                Items = { "Toggle", "Hold", "Always" },
                Default = "Toggle",
                Callback = function(Value)
                    Keybind.Mode = Value
                    Keybind:SetMode()

                    if Value == "Always" then 
                        Keybind:Press(true)
                    end

                    Update()
                end
            })

            local ShowInKeybindsList = Library:Toggle({
                Name = "Show in keybinds list",
                Flag = Keybind.Flag .. "ShowInKeybindsList",
                Parent = Items["KeybindWindow"],
                Default = true,
                Callback = function(Value)
                    if KeybindObject then 
                        KeybindObject:SetVis(Value)
                        Update()
                    end
                end
            })
    
            function Keybind:Press(Bool)
                if Keybind.Mode == "Toggle" then 
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then 
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always" then 
                    Keybind.Toggled = true
                end
    
                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end
    
            function Keybind:Set(Key) -- this is so shit but its whatever
                if string.find(tostring(Key), "Enum") then 
                    Keybind.Key = tostring(Key)
    
                    Key = Key.Name == "Backspace" and "none" or Key.Name
    
                    local KeyString = Keys[Keybind.Key] or string.gsub(Key, "Enum.", "") or "none"
                    local TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "none"
    
                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay:lower()
    
                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif type(Key) == "table" then
                    local RealKey = Key.Key == "Backspace" and "none" or Key.Key
                    Keybind.Key = tostring(Key.Key)
    
                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode()
                    else
                        Keybind.Mode = "Toggle"
                        Keybind:SetMode()
                    end
    
                    local KeyString = Keys[Keybind.Key] or string.gsub(tostring(RealKey), "Enum.", "") or RealKey
                    local TextToDisplay = KeyString and string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "none"
    
                    TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "")
    
                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay:lower()
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                    
                    Update()
                elseif table.find({"Toggle", "Hold", "Always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode()
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                end

                Keybind.Picking = false
            end
    
            Items["KeyButton"]:Connect("MouseButton1Click", function()
                Keybind.Picking = true 
    
                Items["KeyButton"].Instance.Text = ". . ."
    
                local InputBegan
                InputBegan = UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.Keyboard then 
                        Keybind:Set(Input.KeyCode)
                    else
                        Keybind:Set(Input.UserInputType)
                    end
    
                    InputBegan:Disconnect()
                    InputBegan = nil
                end)
            end)
    
            Library:Connect(UserInputService.InputBegan, function(Input, GPE)
                if Keybind.Value == "none" then
                    return
                end
    
                if not GPE then
                    if tostring(Input.KeyCode) == Keybind.Key then
                        if Keybind.Mode == "Toggle" then 
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then 
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then 
                            Keybind:Press(true)
                        end
                    elseif tostring(Input.UserInputType) == Keybind.Key then
                        if Keybind.Mode == "Toggle" then 
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then 
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then 
                            Keybind:Press(true)
                        end
                    end
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 and Keybind.IsOpen then 
                    if not Items["KeybindWindow"]:IsMouseOverFrame() and not ModeDropdown.Items.OptionHolder:IsMouseOverFrame() then
                        Keybind:SetOpen(false)
                    end
                end
            end)
    
            Library:Connect(UserInputService.InputEnded, function(Input, GPE)
                if GPE then
                    return
                end

                if Keybind.Value == "None" then
                    return
                end
    
                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                end
            end)
    
            Items["KeyButton"]:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)
    
            if Data.Default then 
                Keybind:Set({
                    Mode = Data.Mode or "Toggle",
                    Key = Data.Default,
                })
            end
    
            SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items 
        end

        Library.Watermark = function(Self, Params)
            Params = Params or { }

            local Watermark = {
                Name = Params.Name or Params.name or "Watermark",

                Items = { }
            }

            local Items = { } do 
                Items["Watermark"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0, 0),
                    Position = UDim2.new(0, 10, 0, GuiInset + 10),
                    Size = UDim2.new(0, 0, 0, 28),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Items["Watermark"]:MakeDraggable()
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    Thickness = 1
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"],
                    Thickness = 1
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
                
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 1, 0, 0),
                    Size = UDim2.new(1, 2, 0, 2),
                    BorderSizePixel = 0,
                    ZIndex = 10,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Liner"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.800000011920929,
                    Size = UDim2.new(1, 25, 1, 25),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    ZIndex = 1,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Items["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    Size = UDim2.new(0, 0, 1, -2),
                    Position = UDim2.new(0, 0, 0, 2),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Items["Holder"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
                
                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Holder"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Watermark.Name,
                    ZIndex = 6,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Accent'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Title"].Instance,
                    PaddingBottom = UDim.new(0, 2)
                })

                Watermark.Items = Items 
            end

            function Watermark:SetVisibility(Bool)
                Items["Watermark"].Instance.Visible = Bool
            end

            function Watermark:SetText(Text)
                Items["Title"].Instance.Text = tostring(Text)
            end
            
            function Watermark:Add(Text)
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    Size = UDim2.new(0, 1, 1, -10),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                local NewItem = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Holder"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Text,
                    ZIndex = 6,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})

                function NewItem:SetText(Text)
                    NewItem.Instance.Text = tostring(Text)
                end

                function NewItem:SetVisibility(Bool)
                    NewItem.Instance.Visible = Bool
                end

                return NewItem
            end

            Self.Watermark = Watermark
            return setmetatable(Watermark, Library)
        end

        local KeybindTweenInfo = TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out) -- this is only for the keybind list and should not be used anywhere else
        
        Library.KeybindList = function(Self)
            local TextService = game:GetService("TextService")

            local KeybindList = {
                Items = {},
                Keys = {},
                Enabled = true
            }

            local function GetTextWidth(Text)
                local ok, size = pcall(function()
                    return TextService:GetTextSize(tostring(Text), Library.FontSize, Enum.Font.Code, Vector2.new(1000, 1000))
                end)

                if ok and size then
                    return size.X
                end

                return 0
            end

            local Items = {} do
                Items["KeybindList"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(1, 1),
                    Position = UDim2.new(1, -10, 1, -10),
                    Size = UDim2.new(0, 122, 0, 30),
                    ClipsDescendants = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = "Background"})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                Items["KeybindList"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    Thickness = 1
                }):AddToTheme({Color = "Border"})

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"],
                    Thickness = 1
                }):AddToTheme({Color = "Outline"})

                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.new(1, 2, 0, 2),
                    BorderSizePixel = 0,
                    ZIndex = 10,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = "Accent"})

                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Liner"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.8,
                    Size = UDim2.new(1, 25, 1, 25),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    ZIndex = 1,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = "Accent"})

                Items["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    Position = UDim2.new(0, 2, 0, 4),
                    Size = UDim2.new(1, -4, 1, -6),
                    ClipsDescendants = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = "Inline"})

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"],
                    Thickness = 1
                }):AddToTheme({Color = "Outline"})

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    Thickness = 1
                }):AddToTheme({Color = "Border"})

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextColor3 = Library.Theme["Accent"],
                    Text = "Keybinds",
                    ZIndex = 6,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 1),
                    Size = UDim2.new(1, 0, 0, 15),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    TextTruncate = Enum.TextTruncate.None
                }):AddToTheme({TextColor3 = "Accent"})

                Items["Separator"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    Position = UDim2.new(0, 4, 0, 18),
                    Size = UDim2.new(1, -8, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = "Outline"})

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 7, 0, 22),
                    Size = UDim2.new(1, -14, 0, 0),
                    BorderSizePixel = 0,
                    ClipsDescendants = false
                })
            end

            Library.KeyList = KeybindList
            Self.KeybindList = KeybindList
            KeybindList.Items = Items

            function KeybindList:SetVisibility(Bool)
                KeybindList.Enabled = Bool
                KeybindList:UpdateSize()
            end

            function KeybindList:UpdateSize()
                local Width = math.max(112, GetTextWidth("Keybinds") + 28)
                local Y = 0
                local Count = 0

                for Index, Value in KeybindList.Keys do
                    if Value.Showing then
                        local Text = Value.Object.Instance.Text
                        local RowWidth = GetTextWidth(Text) + 2
                        local RowHeight = 14

                        Value.Object.Instance.Visible = true
                        Width = math.max(Width, RowWidth + 24)

                        Value.Object:Tween({
                            Position = UDim2.new(0, 0, 0, Y),
                            Size = UDim2.new(1, 0, 0, RowHeight),
                            TextTransparency = 0
                        }, KeybindTweenInfo)

                        Y += RowHeight + 2
                        Count += 1
                    end
                end

                local ContentH = Count > 0 and (Y - 2) or 0
                local TotalH = 28 + ContentH + 8

                Items["Content"]:Tween({Size = UDim2.new(0, Width - 18, 0, ContentH)}, KeybindTweenInfo)
                Items["Inline"]:Tween({Size = UDim2.new(0, Width - 4, 0, TotalH - 6)}, KeybindTweenInfo)
                Items["KeybindList"]:Tween({Size = UDim2.new(0, Width, 0, TotalH)}, KeybindTweenInfo)

                Items["KeybindList"].Instance.Visible = KeybindList.Enabled and Count > 0
            end

            function KeybindList:Add(Name, Mode, Key)
                local NewKeyText = Library:Create("TextLabel", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextColor3 = Library.Theme["Text"],
                    Text = (Name ~= "" and Key ~= "") and (Name .. "  [" .. Key .. "]") or "",
                    ZIndex = 6,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 14),
                    Position = UDim2.new(0, 0, 0, 0),
                    TextTransparency = 1,
                    Visible = false,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.None,
                    ClipsDescendants = false
                }):AddToTheme({TextColor3 = "Text"})

                local CanShow = true

                local NewKey = {
                    Object = NewKeyText,
                    Showing = false
                }

                table.insert(KeybindList.Keys, NewKey)

                function NewKey:SetVis(Bool)
                    CanShow = Bool

                    if not Bool then
                        NewKey:SetStatus(false)
                    elseif NewKey.Showing then
                        KeybindList:UpdateSize()
                    end
                end

                function NewKey:Set(Name, Mode, Key)
                    if Key ~= "" and Key ~= "none" and Key ~= "None" then
                        NewKey.Object.Instance.Text = Name .. "  [" .. Key .. "]"
                    else
                        NewKey.Object.Instance.Text = Name .. "  [none]"
                    end

                    KeybindList:UpdateSize()
                end

                function NewKey:SetStatus(Bool)
                    Bool = Bool and CanShow

                    if NewKey.Showing == Bool then
                        KeybindList:UpdateSize()
                        return
                    end

                    NewKey.Showing = Bool

                    if Bool then
                        NewKeyText.Instance.Visible = true
                        NewKeyText.Instance.TextTransparency = 1
                        NewKeyText:Tween({TextTransparency = 0}, KeybindTweenInfo)
                        KeybindList:UpdateSize()
                    else
                        NewKeyText:Tween({TextTransparency = 1}, KeybindTweenInfo)
                        KeybindList:UpdateSize()
                        task.delay(KeybindTweenInfo.Time, function()
                            if not NewKey.Showing then
                                NewKeyText.Instance.Visible = false
                            end
                        end)
                    end
                end

                return NewKey
            end

            KeybindList:UpdateSize()

            return setmetatable(KeybindList, Library)
        end

        local NotifTweenInfo = TweenInfo.new(Library.NotifAnimation.Time, Enum.EasingStyle[Library.NotifAnimation.Style], Enum.EasingDirection[Library.NotifAnimation.Direction])

        Library.Notification = function(Self, Name, Duration, Color)
            Duration = Duration or 5
            Color = Color or Library.Theme.Accent
        
            local Notification = {
                Duration = Duration,
                Removing = false,
                Items = {}
            }
        
            local Padding = 8
            local Spacing = 8
        
            local function UpdatePositions()
                local Y = GuiInset + Padding + 5
            
                for Index, Value in Library.Notifications do
                    local Height = Value.Items["Notification"].Instance.AbsoluteSize.Y
            
                    Value.Items["Notification"]:Tween({Position = UDim2.new(0, Padding, 0, Y)}, NotifTweenInfo)
            
                    Y += Height + Spacing
                end
            end
        
            local Items = {} do
                Items["Notification"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.NotifHolder.Instance,
                    Size = UDim2.new(0, 0, 0, 25),
                    AnchorPoint = Vector2.new(0, 0),
                    Position = UDim2.new(0, -260, 0, GuiInset + Padding + 5),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = "Inline"})
        
                Library:Create("UIStroke", {
                    Name = "\0", 
                    Parent = 
                    Items["Notification"].Instance, 
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border, 
                    LineJoinMode = Enum.LineJoinMode.Miter, 
                    Color = Library.Theme["Border"], 
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = "Border"})

                Library:Create("UIStroke", {
                    Name = "\0", 
                    Parent = Items["Notification"].Instance, 
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border, 
                    LineJoinMode = Enum.LineJoinMode.Miter, 
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = "Outline"})
        
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
        
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Notification"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Name,
                    RichText = true,
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 3, 0.5, -1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = "Text"})
        
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    Position = UDim2.new(0, -8, 0, 0),
                    Size = UDim2.new(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color
                })
        
                Items["DurationLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    Position = UDim2.new(0, -8, 0, 0),
                    Size = UDim2.new(1, 16, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color
                })
        
                Notification.Items = Items
            end
        
            local FadeNotification = function(Transparency) -- cant use fadedescendants because that one saves the transparency and it breaks and looks really gay 
                Items["Notification"]:Tween({BackgroundTransparency = Transparency}, NotifTweenInfo)
        
                for _, Value in Items["Notification"].Instance:GetDescendants() do
                    if Value:IsA("TextLabel") then
                        Library:Tween({TextTransparency = Transparency}, NotifTweenInfo, Value)
                    elseif Value:IsA("Frame") then
                        Library:Tween({BackgroundTransparency = Transparency}, NotifTweenInfo, Value)
                    elseif Value:IsA("UIStroke") then
                        Library:Tween({Transparency = Transparency}, NotifTweenInfo, Value)
                    end
                end
            end
        
            table.insert(Library.Notifications, 1, Notification)
        
            task.wait()
        
            local Width = Items["Notification"].Instance.AbsoluteSize.X
            local Height = Items["Notification"].Instance.AbsoluteSize.Y
        
            Items["Notification"].Instance.Size = UDim2.new(0, Width, 0, Height)
            Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.None
            Items["Notification"].Instance.BackgroundTransparency = 1
        
            for Index, Value in Items["Notification"].Instance:GetDescendants() do
                if Value:IsA("TextLabel") then
                    Value.TextTransparency = 1
                elseif Value:IsA("Frame") then
                    Value.BackgroundTransparency = 1
                elseif Value:IsA("UIStroke") then
                    Value.Transparency = 1
                end
            end
        
            UpdatePositions()
            FadeNotification(0)
        
            Items["DurationLiner"]:Tween({Size = UDim2.new(0, 0, 0, 1)}, TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out))
        
            task.spawn(function()
                local Tick = tick()
        
                while tick() - Tick < Duration and not Notification.Removing do
                    task.wait(0.05)
                end
        
                if Notification.Removing then return end
        
                Notification.Removing = true
        
                if not Library then return end 

                for Index, Value in Library.Notifications do
                    if Value == Notification then
                        table.remove(Library.Notifications, Index)
                        break
                    end
                end
        
                Items["Notification"]:Tween({Position = UDim2.new(0, -(Width + Padding + 20), 0, Items["Notification"].Instance.Position.Y.Offset)}, NotifTweenInfo)

                FadeNotification(1)
        
                task.delay(NotifTweenInfo.Time, function()
                    Items["Notification"].Instance:Destroy()
                    UpdatePositions()
                end)
            end)
        
            return Notification
        end
        
        Library.Window = function(Self, Params)
            Params = Params or { }

            local Window = {
                Name = Params.Name or Params.name or "Window",

                IsOpen = true,
                Pages = { },
                Items = { }
            }

            local Items = { } do 
                if IsMobile then 
                    Library:Create("UIScale", {
                        Parent = Library.Holder.Instance,
                        Scale = 0.7
                    })
                end

                Items["Outline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 613, 0, 453),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})

                Items["Outline"]:MakeDraggable()
                Items["Outline"]:MakeResizeable(Vector2.new(Items["Outline"].Instance.AbsoluteSize.X, Items["Outline"].Instance.AbsoluteSize.Y))
                
                Items["Outline2"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Outline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Outline2"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                --[[
                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Background"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Window.Name,
                    Position = UDim2.new(0, 8, 0, 8),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Accent'})
                --]]
                
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    Size = UDim2.new(1, 0, 0, 2),
                    Position = UDim2.new(0, 0, 0, 30),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Liner"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.800000011920929,
                    Size = UDim2.new(1, 8, 1, 8),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Items["Pages"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 0, 30),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Pages"].Instance,
                    PaddingBottom = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Pages"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 30),
                    ClipsDescendants = true,
                    Size = UDim2.new(1, 0, 1, -30),
                    BorderSizePixel = 0
                })

                Window.Items = Items
            end

            local Debounce = false

            function Window:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                for Index, Value in Window.Pages do 
                    if Value.Debounce then 
                        return 
                    end
                end

                Debounce = true 

                Window.IsOpen = Bool
                Items["Outline"]:FadeDescendants(Bool, function()
                    Debounce = false
                end)

                for Index, Value in Library.OpenFrames do 
                    Value:SetOpen(false)
                end
            end

            function Window:Center()
                local AbsPos = Items["Outline"].Instance.AbsolutePosition
                Items["Outline"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["Outline"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    if UserInputService:GetFocusedTextBox() then
                        return
                    end

                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            -- static title (wave animation removed)
            Items["Title"] = Library:Create("TextLabel", {
                Name = "\0",
                FontFace = Library.Font,
                TextSize = Library.FontSize,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Items["Background"].Instance,
                TextColor3 = Library.Theme["Accent"],
                Text = Window.Name,
                Position = UDim2.new(0, 8, 0, 9),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY
            }):AddToTheme({TextColor3 = 'Accent'})

            Window:Center()
            return setmetatable(Window, Library)
        end

        local PageInfo = TweenInfo.new(Library.TabAnimation.Time, Enum.EasingStyle[Library.TabAnimation.Style], Enum.EasingDirection[Library.TabAnimation.Direction])

        Library.Page = function(Self, Params)
            Params = Params or { }

            local Page = {
                Name = Params.Name or Params.name or "Page",

                Window = Self,
                ColumnsData = { },
                Items = { },
                Active = false,
                Debounce = false
            }

            local Items = { } do 
                Items["Inactive"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Page.Window.Items["Pages"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Page.Name,
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 0, 0, 20),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Inactive Text'})         
                
                Items["Page"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    Visible = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 11),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })
                
                Items["LeftColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 100, 0, 100),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    Padding = UDim.new(0, 15),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    PaddingTop = UDim.new(0, 19),
                    PaddingBottom = UDim.new(0, 15),
                    PaddingRight = UDim.new(0, 2),
                    PaddingLeft = UDim.new(0, 10)
                })                

                Items["RightColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 100, 0, 100),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    Padding = UDim.new(0, 15),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    PaddingTop = UDim.new(0, 19),
                    PaddingBottom = UDim.new(0, 15),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 2)
                })

                Page.ColumnsData[1] = Items["LeftColumn"]
                Page.ColumnsData[2] = Items["RightColumn"]

                Page.Items = Items
            end

            Items["Inactive"]:OnHover(function()
                if Page.Active then return end 
                
                Items["Inactive"]:Tween({TextColor3 = Library.Theme.Text})
            end, function()
                if Page.Active then return end 
                
                Items["Inactive"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})
            end)

            function Page:Turn()
                local Old = Page.Window.Current 

                if Old == Page then 
                    return 
                end

                if Page.Debounce then 
                    return
                end

                if Old and Old.Debounce then 
                    return 
                end

                Page.Debounce = true 
                
                if Old then 
                    Old.Items["Page"].Instance.Position = UDim2.new(0, 0, 0, 0)
                    Old.Items["Inactive"]:ChangeItemTheme({TextColor3 = "Inactive Text"})
                    Old.Items["Inactive"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})

                    Old.Items["Page"]:Tween({Position = UDim2.new(-1, 0, 0, 0)}, PageInfo)

                    Old.Items["Page"]:FadeDescendants(false, function()
                        Old.Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                    end)

                    Old.Active = false
                end

                Items["Page"].Instance.Position = UDim2.new(1, 0, 0, 0)
                
                Items["Page"].Instance.Parent = Page.Window.Items["Content"].Instance
                Items["Page"].Instance.Visible = true
                Items["Page"]:FadeDescendants(true, function()
                    Page.Debounce = false
                end)

                Items["Inactive"]:ChangeItemTheme({TextColor3 = "Accent"})
                Items["Inactive"]:Tween({TextColor3 = Library.Theme["Accent"]})

                Items["Page"]:Tween({Position = UDim2.new(0, 0, 0, 0)}, PageInfo)

                Page.Window.Current = Page
                Page.Active = true
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                Page:Turn()
            end)

            if #Page.Window.Pages == 0 then 
                Page:Turn()
            end

            table.insert(Page.Window.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.Section = function(Self, Params)
            Params = Params or { } 

            local Section = {
                Name = Params.Name or Params.name or "Section",
                Side = Params.Side or Params.side or 1,

                Window = Self.Window,
                Page = Self,
                Items = { },
            }

            local Items = { } do 
                Items["Section"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Section.Page.ColumnsData[Section.Side].Instance,
                    Size = UDim2.new(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Section"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Section.Name,
                    Position = UDim2.new(0, 9, 0, -2),
                    Size = UDim2.new(0, 0, 0, 1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Text"].Instance,
                    PaddingRight = UDim.new(0, 4),
                    PaddingLeft = UDim.new(0, 4)
                })
                
                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 10),
                    Size = UDim2.new(1, -16, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    PaddingBottom = UDim.new(0, 8)
                })                

                Section.Items = Items
            end 

            function Section:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            return setmetatable(Section, Library)
        end

        Library.Toggle = function(Self, Params)
            Params = Params or { }

            local Toggle = {
                Name = Params.Name or Params.name or "Toggle",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or false,
                Callback = Params.Callback or Params.callback or function() end,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Toggle.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Toggle"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 12),
                    BorderSizePixel = 0
                })
                
                Items["Outline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 9, 0, 9),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})
                
                Items["Indicator"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Outline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element 2"]
                }):AddToTheme({BackgroundColor3 = 'Element 2'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Toggle"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Toggle.Name,
                    Position = UDim2.new(0, 18, 0, -1),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})       
                
                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                
            
                Toggle.Items = Items
            end

            Items["Toggle"]:OnHover(function()
                if Toggle.Value then return end 
                Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                if Toggle.Value then return end 
                Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Element 2"]})
            end)

            function Toggle:Set(Bool)
                Toggle.Value = Bool 

                if Bool then 
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                    Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme.Accent})
                else
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element 2"})
                    Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Element 2"]})
                end

                Flags[Toggle.Flag] = Bool
                Library:SafeCall(Toggle.Callback, Bool)
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool 
            end

            function Toggle:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Toggle:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or 0,

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Name = Data.Name or Data.name or Toggle.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default or nil,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return setmetatable(Toggle, Library)
        end

        Library.Button = function(Self, Params)
            Params = Params or { }

            local Button = {
                Name = Params.Name or Params.name or "Button",
                Callback = Params.Callback or Params.callback or function() end,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Button.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Button"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})
                
                Items["Inline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Button"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["RealButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Inline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["RealButton"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["RealButton"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Button.Name,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, -1),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 2
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Accent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealButton"].Instance,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})                

                Button.Items = Items
            end

            Items["RealButton"]:OnHover(function()
                Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            function Button:Press()
                pcall(function() -- i have to do this so it doesnt error on unload
                    Library:SafeCall(Button.Callback)

                    Items["Accent"]:Tween({BackgroundTransparency = 0, Size = UDim2.new(1, 0, 1, 0)})
                    task.wait(Library.Animation.Time - 0.1)
                    Items["Accent"]:Tween({BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0)})
                end)
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            Items["RealButton"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return setmetatable(Button, Library)
        end

        Library.Slider = function(Self, Params)
            Params = Params or { }

            local Slider = {
                Name = Params.Name or Params.name or "Slider",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or 0,
                Min = Params.Min or Params.min or 0,
                Max = Params.Max or Params.max or 100,
                Callback = Params.Callback or Params.callback or function() end,
                Decimals = Params.Decimals or Params.decimals or 1,
                Suffix = Params.Suffix or Params.suffix or "",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = 0,
                Sliding = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Slider.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Slider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Slider.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealSliderOutline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 9),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})
                
                Items["RealSlider"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealSliderOutline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element 2"]
                }):AddToTheme({BackgroundColor3 = 'Element 2'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Items["AccentHolder"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                Items["Accent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["AccentHolder"].Instance,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "2.5",
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 1, 0, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Inactive Text'})                

                Slider.Items = Items 
            end

            Items["RealSlider"]:OnHover(function()
                Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            function Slider:Set(Value)
                Slider.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Decimals)

                Items["Accent"]:Tween({Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
                Items["Value"].Instance.Text = string.format("%s%s", Slider.Value, Slider.Suffix)

                Flags[Slider.Flag] = Slider.Value
                Library:SafeCall(Slider.Callback, Slider.Value)
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:GetSize(Input)
                local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                return Value
            end

            function Slider:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            local InputChanged 
            
            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Items["Value"]:Tween({TextColor3 = Library.Theme.Text})
                    Slider.Sliding = true

                    local Value = Slider:GetSize(Input)

                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Items["Value"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local Value = Slider:GetSize(Input)

                        Slider:Set(Value)
                    end
                end
            end)

            Slider:Set(Slider.Default)

            SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return setmetatable(Slider, Library)
        end

        Library.Dropdown = function(Self, Params)
            Params = Params or { }

            local Dropdown = {
                Name = Params.Name or Params.name or "Dropdown",
                OptionItems = Params.Items or Params.items or { },
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = { },
                Options = { },
                IsOpen = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Dropdown.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Dropdown"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Dropdown.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealDropdownOutline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})
                
                Items["Inline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealDropdownOutline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["RealDropdown"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Inline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://98057726606591",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -1, 0.5, -1),
                    Size = UDim2.new(0, 16, 0, 16),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["RealDropdown"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "none",
                    Size = UDim2.new(1, -24, 0, 0),
                    Position = UDim2.new(0, 4, 0.5, -1),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    AutomaticSize = Enum.AutomaticSize.Y
                }):AddToTheme({TextColor3 = 'Text'})          
                
                Items["OptionHolder"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 200, 0, 50),
                    Position = UDim2.new(0, 792, 0, 649),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({Color = 'Border'})
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Dropdown.Items = Items 
            end

            Items["RealDropdown"]:OnHover(function()
                Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            function Dropdown:Set(Value)
                if Dropdown.Multi then 
                    if type(Value) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Value

                    for Index, Value in Value do
                        local OptionData = Dropdown.Options[Value]
                         
                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true 
                        OptionData:ToggleState("Active")
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = table.concat(Value, ", ")
                else
                    if not Dropdown.Options[Value] then
                        return
                    end

                    local OptionData = Dropdown.Options[Value]

                    Dropdown.Value = Value

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false 
                            Value:ToggleState("Inactive")
                        else
                            Value.IsSelected = true 
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = Value
                end

                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end

            function Dropdown:Add(Value)
                local OptionButton = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["OptionHolder"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Value,
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                }):AddToTheme({TextColor3 = 'Inactive Text'})

                local OptionData = {
                    Button = OptionButton,
                    Name = Value,
                    IsSelected = false
                }

                OptionButton:OnHover(function()
                    if OptionData.IsSelected then return end 

                    OptionButton:Tween({TextColor3 = Library.Theme.Text})
                end, function()
                    if OptionData.IsSelected then return end 

                    OptionButton:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                end)
                
                function OptionData:ToggleState(Value)
                    if Value == "Active" then
                        OptionButton:ChangeItemTheme({TextColor3 = "Accent"})
                        OptionButton:Tween({TextColor3 = Library.Theme.Accent})
                    else
                        OptionButton:ChangeItemTheme({TextColor3 = "Inactive Text"})
                        OptionButton:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                    end
                end

                function OptionData:Set()
                    Library:Thread(function()
                        Items["Value"]:Tween({TextTransparency = 1})
                        task.wait(0.1)
                        Items["Value"]:Tween({TextTransparency = 0})
                    end)

                    OptionData.IsSelected = not OptionData.IsSelected

                    if Dropdown.Multi then 
                        local Index = table.find(Dropdown.Value, OptionData.Name)

                        if Index then 
                            table.remove(Dropdown.Value, Index)
                        else
                            table.insert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and table.concat(Dropdown.Value, ", ") or "none"
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.IsSelected then 
                            Dropdown.Value = OptionData.Name
                            Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.IsSelected = false 
                                    Value:ToggleState("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Flags[Dropdown.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")

                            Items["Value"].Instance.Text = "none"
                        end
                    end

                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button.Instance:Destroy()
                    Dropdown.Options[Option] = nil
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do 
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end
            end

            function Dropdown:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool 
            end

            local Debounce = false 
            local OptionHolder = Items["OptionHolder"].Instance
            local RealDropdown = Items["RealDropdown"].Instance

            local IsSettings = Dropdown.Section and Dropdown.Section.IsSettings

            function Dropdown:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Dropdown.IsOpen = Bool

                Debounce = true 
                
                if Dropdown.IsOpen then 
                    Items["OptionHolder"].Instance.Visible = true

                    local Scale = Library:GetScreenScale()
                    OptionHolder.Position = Library:PopupPosition(RealDropdown, OptionHolder, 0)
                    OptionHolder.Size = UDim2.new(0, RealDropdown.AbsoluteSize.X / Scale, 0, 0)
                    
                    Items["OptionHolder"]:Tween({
                        Position = Library:PopupPosition(RealDropdown, OptionHolder, 10)
                    })
                    
                    Items["OptionHolder"]:FadeDescendants(true, function()
                        Debounce = false 
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= IsSettings and not Params.Parent then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown 
                else
                    Items["OptionHolder"]:Tween({
                        Position = Library:PopupPosition(RealDropdown, OptionHolder, -10)
                    })

                    Items["OptionHolder"]:FadeDescendants(false, function()
                        Debounce = false
                    end)

                    if Library.OpenFrames[Dropdown] then 
                        Library.OpenFrames[Dropdown] = nil
                    end
                end

                local Descendants = OptionHolder:GetDescendants()
                table.insert(Descendants, OptionHolder)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if not Params.Parent then
                        Value.ZIndex = Dropdown.IsOpen and Library.ZIndexOrder.OptionHolder or 1
                    else
                        Value.ZIndex = Dropdown.IsOpen and Library.ZIndexOrder.OptionHolder + 3 or 1
                    end
                end
            end

            Items["OptionHolder"]:VisibleCheck()

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if Dropdown.IsOpen and not Items["OptionHolder"]:IsMouseOverFrame() then
                        Dropdown:SetOpen(false)
                    end
                end
            end)

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            for Index, Value in Dropdown.OptionItems do 
                Dropdown:Add(Value)
            end

            Dropdown:Set(Dropdown.Default)

            SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return setmetatable(Dropdown, Library)
        end

        Library.List = function(Self, Params)
            Params = Params or { }

            local List = {
                OptionItems = Params.Items or Params.items or { },
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = { },
                Options = { },
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = List.Section.Items["Content"]
            end

            local Items = { } do 
                Items["List"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 200),
                    BorderSizePixel = 0
                })
                
                Items["SearchOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["List"].Instance,
                    Size = UDim2.new(1, 0, 0, 20),
                    Active = true,
                    Selectable = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})
                
                Items["SearchInline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["SearchOutline"].Instance,
                    Active = true,
                    Position = UDim2.new(0, 1, 0, 1),
                    Selectable = true,
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["SearchBackground"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["SearchInline"].Instance,
                    ClipsDescendants = true,
                    Size = UDim2.new(1, -2, 1, -2),
                    Position = UDim2.new(0, 1, 0, 1),
                    Selectable = true,
                    Active = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["SearchBackground"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["SearchBackground"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = "Search..",
                    Size = UDim2.new(1, -8, 0, 0),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    Position = UDim2.new(0, 4, 0.5, -1),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    AutomaticSize = Enum.AutomaticSize.Y
                }):AddToTheme({TextColor3 = 'Text', PlaceholderColor3 = 'Inactive Text'})
                
                Items["ListOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["List"].Instance,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 1, -25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})
                
                Items["ListInline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ListOutline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["ListBackground"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ListInline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["ListBackground"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["ListBackground"].Instance,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    MidImage = "rbxassetid://81680855285439",
                    ScrollBarThickness = 2,
                    Size = UDim2.new(1, -16, 1, -16),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 8),
                    BottomImage = "rbxassetid://81680855285439",
                    TopImage = "rbxassetid://81680855285439"
                }):AddToTheme({ScrollBarImageColor3 = 'Accent'})
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    PaddingBottom = UDim.new(0, 8)
                })                

                List.Items = Items 
            end

            function List:Set(Value)
                if List.Multi then 
                    if type(Value) ~= "table" then 
                        return
                    end

                    List.Value = Value

                    for Index, Value in Value do
                        local OptionData = List.Options[Value]
                         
                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true 
                        OptionData:ToggleState("Active")
                    end

                    Flags[List.Flag] = Value
                else
                    if not List.Options[Value] then
                        return
                    end

                    local OptionData = List.Options[Value]

                    List.Value = Value

                    for Index, Value in List.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false 
                            Value:ToggleState("Inactive")
                        else
                            Value.IsSelected = true 
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[List.Flag] = Value
                end

                Library:SafeCall(List.Callback, List.Value)
            end

            function List:Add(Value)
                local OptionButton = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Parent = Items["Holder"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Value,
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                }):AddToTheme({TextColor3 = 'Inactive Text'})

                local OptionData = {
                    Button = OptionButton,
                    Name = Value,
                    IsSelected = false
                }

                OptionButton:OnHover(function()
                    if OptionData.IsSelected then return end 

                    OptionButton:Tween({TextColor3 = Library.Theme.Text})
                end, function()
                    if OptionData.IsSelected then return end 

                    OptionButton:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                end)
                
                function OptionData:ToggleState(Value)
                    if Value == "Active" then
                        OptionButton:ChangeItemTheme({TextColor3 = "Accent"})
                        OptionButton:Tween({TextColor3 = Library.Theme.Accent})
                    else
                        OptionButton:ChangeItemTheme({TextColor3 = "Inactive Text"})
                        OptionButton:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                    end
                end

                function OptionData:Set()
                    OptionData.IsSelected = not OptionData.IsSelected

                    if List.Multi then 
                        local Index = table.find(List.Value, OptionData.Name)

                        if Index then 
                            table.remove(List.Value, Index)
                        else
                            table.insert(List.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[List.Flag] = List.Value
                    else
                        if OptionData.IsSelected then 
                            List.Value = OptionData.Name
                            Flags[List.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in List.Options do 
                                if Value ~= OptionData then
                                    Value.IsSelected = false 
                                    Value:ToggleState("Inactive")
                                end
                            end
                        else
                            List.Value = nil
                            Flags[List.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")
                        end
                    end

                    Library:SafeCall(List.Callback, List.Value)
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                List.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function List:Remove(Option)
                if List.Options[Option] then
                    List.Options[Option].Button.Instance:Destroy()
                    List.Options[Option] = nil
                end
            end

            function List:Refresh(NewList)
                for Index, Value in List.Options do 
                    List:Remove(Value.Name)
                end

                for Index, Value in NewList do 
                    List:Add(Value)
                end
            end

            function List:SetVisibility(Bool)
                Items["List"].Instance.Visible = Bool 
            end

            for Index, Value in List.OptionItems do 
                List:Add(Value)
            end

            Items["Input"]:Connect("Changed", function(Property)
                if Property == "Text" then
                    for Index, Value in List.Options do
                        if string.find(string.lower(Value.Name), string.lower(Items["Input"].Instance.Text)) then
                            Value.Button.Instance.Visible = true
                        else
                            Value.Button.Instance.Visible = false
                        end
                    end
                end
            end)

            List:Set(List.Default)

            SetFlags[List.Flag] = function(Value)
                List:Set(Value)
            end

            return setmetatable(List, Library)
        end

        Library.Label = function(Self, Params)
            Params = Params or { }

            local Label = {
                Name = Params.Name or Params.name or "Label",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Label.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Label"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 12),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Label"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Label.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Label"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Label.Items = Items 
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool 
            end

            function Label:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Label:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or 0,

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Name = Data.Name or Data.name or Label.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default or nil,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Label:SetText(Label.Name)

            return setmetatable(Label, Library)
        end

        Library.Textbox = function(Self, Params)
            Params = Params or { }

            local Textbox = {
                Name = Params.Name or Params.name or "Textbox",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Finished = Params.Finished or Params.finished or false,
                Placeholder = Params.Placeholder or Params.placeholder or "",
                Numeric = Params.Numeric or Params.numeric or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Value = "",

                Items = { },
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Textbox.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Textbox"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Textbox"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Textbox.Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Outline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Textbox"].Instance,
                    Active = true,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    Selectable = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({BackgroundColor3 = 'Border'})
                
                Items["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Outline"].Instance,
                    Active = true,
                    Position = UDim2.new(0, 1, 0, 1),
                    Selectable = true,
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    ClipsDescendants = true,
                    Size = UDim2.new(1, -2, 1, -2),
                    Position = UDim2.new(0, 1, 0, 1),
                    Selectable = true,
                    Active = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 163, 163))
                }
                })
                
                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Items["Background"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = Textbox.Placeholder,
                    Size = UDim2.new(1, -8, 0, 0),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    Position = UDim2.new(0, 4, 0.5, -1),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    CursorPosition = -1,
                    ClearTextOnFocus = false,
                    AutomaticSize = Enum.AutomaticSize.Y
                }):AddToTheme({TextColor3 = 'Text', PlaceholderColor3 = 'Inactive Text'})                

                Textbox.Items = Items
            end

            Items["Background"]:OnHover(function()
                Items["Background"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["Background"]:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Textbox:Set(Value)
                if Textbox.Numeric and string.len(tostring(Value)) > 0 and not tonumber(Value) then
                    Value = Textbox.Value
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Flags[Textbox.Flag] = Value

                Library:SafeCall(Textbox.Callback, Value)
            end

            if Textbox.Finished then 
                Items["Input"]:Connect("FocusLost", function(Bool)
                    if Bool then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Items["Input"]:Connect("Changed", function(Property)
                    if Property == "Text" then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            end

            Textbox:Set(Textbox.Default)

            SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end
            
            return setmetatable(Textbox, Library)
        end

        Library.Init = function(Self)
            -- Ensure the Watermark and Keybind list objects exist so the menu
            -- toggles below have real objects to call :SetVisibility on.
            if type(rawget(Self, "Watermark")) ~= "table" then
                Self:Watermark({ Name = Self.Name or "novahub" })
            end

            if type(rawget(Self, "KeybindList")) ~= "table" then
                Self:KeybindList()
            end

            local SettingsPage = Self:Page({Name = "settings"}) do 
                local ThemingSection = SettingsPage:Section({Name = "Theming", Side = 2}) do
                    for Index, Value in Library.Theme do 
                        ThemingSection:Label({Name = Index}):Colorpicker({
                            Name = Index,
                            Flag = Index.."Theming",
                            Default = Value,
                            Callback = function(Value)
                                Library.Theme[Index] = Value
                                Library:ChangeTheme(Index, Value)
                            end
                        })
                    end

                    local ThemeSelected 
                    local ThemeName
                    local ThemesFolder = Library.Directory .. Library.Folders.Themes .. "/"

                    local ThemesDropdown = ThemingSection:Dropdown({
                        Name = "Themes",
                        Flag = "Themes",
                        Default = "",
                        Items = { },
                        Callback = function(Value)
                            ThemeSelected = Value
                        end
                    })

                    ThemingSection:Textbox({
                        Name = "Theme name",
                        Flag = "ThemeName",
                        Default = "",
                        Callback = function(Value)
                            ThemeName = Value
                        end
                    })

                    ThemingSection:Button({
                        Name = "Save",
                        Callback = function()
                            if ThemeName then 
                                if ThemeName == "" then 
                                    return
                                end

                                if isfile(ThemesFolder .. ThemeName .. ".json") then 
                                    Library:Notification("Saved theme "..ThemeName, 3, Library.Theme.Accent)
                                    writefile(ThemesFolder .. ThemeName .. ".json", Library:GetConfig())
                                    return
                                end

                                writefile(ThemesFolder .. ThemeName .. ".json", Library:GetConfig())
                                Library:GetThemesList(ThemesDropdown)
                                Library:Notification("Created theme "..ThemeName, 3, Library.Theme.Accent)
                            end
                        end
                    })

                    ThemingSection:Button({
                        Name = "Load",
                        Callback = function()
                            if ThemeSelected then 
                                if not isfile(ThemesFolder .. ThemeSelected .. ".json") then
                                    Library:Notification("Theme does not exist", 3, Color3.fromRGB(255, 0, 0))
                                    return
                                end

                                local Success, Error = Library:LoadConfig(readfile(ThemesFolder .. ThemeSelected .. ".json"))

                                if Success then 
                                    Library:Notification("Loaded theme "..ThemeSelected .. " succesfully", 3, Library.Theme.Accent)
                                else
                                    Library:Notification("Failed to load theme "..ThemeSelected .. " report this to the devs: "..Error, 3, Color3.fromRGB(255, 0, 0))
                                end
                            end
                        end
                    })

                    ThemingSection:Button({
                        Name = "Delete",
                        Callback = function()
                            if ThemeSelected then 
                                if not isfile(ThemesFolder .. ThemeSelected .. ".json") then
                                    Library:Notification("Theme does not exist", 3, Color3.fromRGB(255, 0, 0))
                                    return
                                end

                                delfile(ThemesFolder .. ThemeSelected .. ".json")
                                Library:GetThemesList(ThemesDropdown)
                                Library:Notification("Deleted theme "..ThemeSelected, 3, Library.Theme.Accent)
                            end
                        end
                    })

                    Library:GetThemesList(ThemesDropdown)
                end
                
                local MenuSection = SettingsPage:Section({Name = "Menu", Side = 2}) do
                    MenuSection:Button({Name = "Exit", Callback = function()
                        Library:Exit()
                    end})

                    MenuSection:Label({ Name = "Menu Keybind" }):Keybind({
                        Name = "Menu Keybind",
                        Flag = "MenuKeybind",
                        Default = Library.MenuKeybind,
                        Mode = "Toggle",
                        Callback = function(Value)
                            Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
                        end
                    })

                    if Self.Watermark then
                        MenuSection:Toggle({
                            Name = "Watermark",
                            Flag = "Watermark",
                            Default = true,
                            Callback = function(Value)
                                Self.Watermark:SetVisibility(Value)
                            end
                        })
                    end

                    if Self.KeybindList then 
                        MenuSection:Toggle({
                            Name = "Keybind list",
                            Flag = "Keybind list",
                            Default = true,
                            Callback = function(Value)
                                Self.KeybindList:SetVisibility(Value)
                            end
                        })
                    end
                end

                local ConfigName 
                local ConfigSelected 
                local ConfigsFolder = Library.Directory .. Library.Folders.Configs .. "/"

                local ConfigsSection = SettingsPage:Section({Name = "Profiles", Side = 1}) do
                    local ConfigsList = ConfigsSection:List({
                        Flag = "Configs",
                        Items = { },
                        Multi = false,
                        Callback = function(Value)
                            ConfigSelected = Value
                        end
                    })

                    ConfigsSection:Textbox({
                        Name = "Config name",
                        Flag = "ConfigName",
                        Placeholder = "Config name",
                        Callback = function(Value)
                            ConfigName = Value 
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Create",
                        Callback = function()
                            if ConfigName then 
                                if ConfigName == "" then 
                                    return
                                end

                                if isfile(ConfigsFolder .. ConfigName .. ".json") then 
                                    Library:Notification("Config with the name "..ConfigName.." already exists", 3, Color3.fromRGB(255, 0, 0))
                                    return
                                end

                                writefile(ConfigsFolder .. ConfigName .. ".json", Library:GetConfig())
                                Library:GetConfigsList(ConfigsList)
                                Library:Notification("Created config "..ConfigName, 3, Library.Theme.Accent)
                            end
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Load",
                        Callback = function()
                            if ConfigSelected then 
                                if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                    Library:Notification("Config does not exist", 3, Color3.fromRGB(255, 0, 0))
                                    return
                                end

                                local Success, Error = Library:LoadConfig(readfile(ConfigsFolder .. ConfigSelected .. ".json"))

                                if Success then 
                                    Library:Notification("Loaded config "..ConfigSelected .. " succesfully", 3, Library.Theme.Accent)
                                else
                                    Library:Notification("Failed to load config "..ConfigSelected .. " report this to the devs: "..Error, 3, Color3.fromRGB(255, 0, 0))
                                end
                            end
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Delete",
                        Callback = function()
                            if ConfigSelected then 
                                if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                    Library:Notification("Config does not exist", 3, Color3.fromRGB(255, 0, 0))
                                    return
                                end

                                delfile(ConfigsFolder .. ConfigSelected .. ".json")
                                Library:GetConfigsList(ConfigsList)
                                Library:Notification("Deleted config "..ConfigSelected, 3, Library.Theme.Accent)
                            end
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Overwrite",
                        Callback = function()
                            if ConfigSelected then 
                                if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                    Library:Notification("Config does not exist", 3, Color3.fromRGB(255, 0, 0))
                                    return
                                end

                                writefile(ConfigsFolder .. ConfigSelected .. ".json", Library:GetConfig())
                                Library:Notification("Overwrote config "..ConfigSelected, 3, Library.Theme.Accent)
                            end
                        end
                    })

                    Library:GetConfigsList(ConfigsList)
                end

                local AutoloadSection = SettingsPage:Section({Name = "Autoload", Side = 1}) do
                    AutoloadSection:Button({
                        Name = "Set selected as autoload",
                        Callback = function()
                            if ConfigSelected then 
                                if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                    Library:Notification("Config does not exist", 3, Color3.fromRGB(255, 0, 0))
                                    return
                                end

                                writefile(Library.Directory .. "/autoload.json", readfile(ConfigsFolder .. ConfigSelected .. ".json"))
                                Library:Notification("Set config "..ConfigSelected.." as autoload", 3, Library.Theme.Accent)
                            end
                        end
                    })

                    AutoloadSection:Button({
                        Name = "Remove autoload",
                        Callback = function()
                            writefile(Library.Directory .. "/autoload.json", "")
                            Library:Notification("Removed autoload", 3, Library.Theme.Accent)
                        end
                    })
                end

                local AutoloadContent = readfile(Library.Directory .. "/autoload.json")

                if AutoloadContent ~= "" then 
                    Library:LoadConfig(AutoloadContent)
                end
            end
        end
    end
end

getgenv().Library = Library
return Library 
end)()

local NewLib = NEWLIB

-- Совместимость с тем, что код фич ждёт от старого Library/Utility ----------
local Library = {}        -- то, что код фич называет "Library"
local Utility = {}        -- то, что код фич называет "Utility"

-- Старый код читает Library.Theme.accent — мапим на акцент новой темы.
Library.Theme = setmetatable({}, {
	__index = function(_, k)
		if k == "accent" then
			return NewLib.Theme and NewLib.Theme["Accent"] or Color3.fromRGB(176,176,209)
		end
		return NewLib.Theme and (NewLib.Theme[k] or NewLib.Theme[k:gsub("^%l", string.upper)]) or Color3.fromRGB(255,255,255)
	end
})

-- Library.Notification(text, time, color)  ->  NewLib:Notification(name, duration, color)
function Library.Notification(text, time, color)
	return NewLib:Notification(text, time or 5, color or (NewLib.Theme and NewLib.Theme.Accent))
end

-- Utility.RichText(text, color)
function Utility.RichText(text, color)
	return string.format('<font color="rgb(%s, %s, %s)">%s</font>',
		math.floor(color.r * 255), math.floor(color.g * 255), math.floor(color.b * 255), text)
end

-- Utility.ToTitleCase(str)
function Utility.ToTitleCase(str)
	return (str:gsub("(%a)([%w_']*)", function(first, rest)
		return first:upper() .. rest:lower()
	end))
end

-- Utility.GetFiles(folder, extensions)
function Utility.GetFiles(folder, extensions)
	if not isfolder(folder) then makefolder(folder) end
	local Files = isfolder(folder) and listfiles(folder) or {}
	local StoredFiles, FileNames = {}, {}
	for _, v in Files do
		for _, ext in extensions do
			if v:find(ext) then
				StoredFiles[#StoredFiles + 1] = v
				FileNames[#FileNames + 1] = v:gsub(folder, ""):gsub(ext, "")
			end
		end
	end
	return StoredFiles, FileNames
end

-- Library.TweenSpeed/TweenStyle — заглушки, чтобы старые присваивания не падали.
Library.TweenSpeed = 0.4
Library.TweenStyle = Enum.EasingStyle.Exponential
Library.Flags = NewLib.Flags
Library.SetFlags = NewLib.SetFlags

-- ---------------------------------------------------------------------------
--  Хелперы конвертации колбэков
-- ---------------------------------------------------------------------------

-- Новый colorpicker отдаёт (Color3, Alpha). Старый код ждёт {c = Color3, a = Alpha}.
local function wrapColorCallback(cb)
	return function(Color, Alpha)
		if cb then cb({ c = Color, a = Alpha or 0 }) end
	end
end

-- Новый dropdown(multi) отдаёт таблицу значений — это совместимо со старым кодом.
-- Новый dropdown(single) отдаёт строку — тоже совместимо.

-- ---------------------------------------------------------------------------
--  Обёртки виджетов. Каждая создаёт элемент в новой либе и возвращает объект,
--  поддерживающий цепочки (:Keybind/:Colorpicker) и метод .Set, который ждёт
--  старый код фич.
-- ---------------------------------------------------------------------------

local function makeWidgetWrapper(newObj, kind)
	local w = {}

	-- .Set(value) — старый код иногда вызывает (тоггл-сабтабы, конфиг-листы)
	function w.Set(value)
		if newObj.Set then newObj:Set(value) end
	end
	w.Refresh = function(list) if newObj.Refresh then newObj:Refresh(list) end end
	w.State   = function(b) if newObj.SetVisibility then newObj:SetVisibility(b) end end
	w.Get     = function() return newObj.Value end

	-- Цепочка :Keybind{...}
	function w:Keybind(data)
		data = data or {}
		local key = data.Key or data.key
		if type(key) == "userdata" then key = key end -- Enum.KeyCode
		local nk = newObj:Keybind({
			Name     = data.Name or data.name,
			Flag     = data.Flag or data.flag,
			Mode     = data.Mode or data.mode or "Toggle",
			Default  = key,
			Callback = data.Callback or data.callback or function() end,
		})
		return makeWidgetWrapper(nk, "keybind")
	end

	-- Цепочка :Colorpicker{...}
	function w:Colorpicker(data)
		data = data or {}
		local nc = newObj:Colorpicker({
			Name     = data.Name or data.name,
			Flag     = data.Flag or data.flag,
			Default  = data.Value or data.value or data.Default or Color3.fromRGB(255,255,255),
			Alpha    = data.Alpha or data.alpha or 0,
			Callback = wrapColorCallback(data.Callback or data.callback),
		})
		return makeWidgetWrapper(nc, "colorpicker")
	end

	return w
end

-- ---------------------------------------------------------------------------
--  Section-обёртка: предоставляет :Toggle/:Slider/:Dropdown/:Button/:Keybind/
--  :Colorpicker/:Textbox/:List/:Label поверх новой Section.
-- ---------------------------------------------------------------------------
local function wrapSection(newSection)
	local S = {}
	S.Items = newSection.Items  -- проксируем Items для прямого доступа из кода фич (ESP Preview и т.д.)
	S._section = newSection     -- FIX: сохраняем ссылку чтобы код мог делать ._section.Page

	function S:Toggle(cfg)
		cfg = cfg or {}
		local nt = newSection:Toggle({
			Name     = cfg.Name or cfg.name,
			Flag     = cfg.Flag or cfg.flag,
			Default  = cfg.Value or cfg.value or false,
			Callback = cfg.Callback or cfg.callback or function() end,
		})
		return makeWidgetWrapper(nt, "toggle")
	end

	function S:Slider(cfg)
		cfg = cfg or {}
		-- старый Suffix в формате string.format ("%s°"). Новый — просто конкатенация,
		-- поэтому убираем "%s".
		local suffix = cfg.Suffix or cfg.suffix or ""
		suffix = suffix:gsub("%%s", "")
		local nt = newSection:Slider({
			Name     = cfg.Name or cfg.name,
			Flag     = cfg.Flag or cfg.flag,
			Min      = cfg.Min or cfg.min or 0,
			Max      = cfg.Max or cfg.max or 100,
			Default  = cfg.Value or cfg.value or 0,
			Decimals = cfg.Float or cfg.float or 1,
			Suffix   = suffix,
			Callback = cfg.Callback or cfg.callback or function() end,
		})
		return makeWidgetWrapper(nt, "slider")
	end

	function S:Dropdown(cfg)
		cfg = cfg or {}
		local default = cfg.Value or cfg.value
		local nt = newSection:Dropdown({
			Name     = cfg.Name or cfg.name,
			Flag     = cfg.Flag or cfg.flag,
			Items    = cfg.Values or cfg.values or {},
			Multi    = cfg.Multi or cfg.multi or false,
			Default  = default,
			Callback = cfg.Callback or cfg.callback or function() end,
		})
		return makeWidgetWrapper(nt, "dropdown")
	end

	function S:List(cfg)
		cfg = cfg or {}
		local nt = newSection:List({
			Name     = cfg.Name or cfg.name,
			Flag     = cfg.Flag or cfg.flag,
			Items    = cfg.Values or cfg.values or {},
			Multi    = cfg.Multi or cfg.multi or false,
			Default  = cfg.Value or cfg.value,
			Callback = cfg.Callback or cfg.callback or function() end,
		})
		return makeWidgetWrapper(nt, "list")
	end

	function S:Button(cfg)
		cfg = cfg or {}
		local nt = newSection:Button({
			Name     = cfg.Name or cfg.name,
			Callback = cfg.Callback or cfg.callback or function() end,
		})
		return makeWidgetWrapper(nt, "button")
	end

	function S:Textbox(cfg)
		cfg = cfg or {}
		local nt = newSection:Textbox({
			Name     = cfg.Name or cfg.name,
			Flag     = cfg.Flag or cfg.flag,
			Default  = cfg.Value or cfg.value or "",
			Callback = cfg.Callback or cfg.callback or function() end,
		})
		return makeWidgetWrapper(nt, "textbox")
	end

	function S:Label(cfg)
		cfg = cfg or {}
		local nt = newSection:Label({ Name = cfg.Name or cfg.name })
		return makeWidgetWrapper(nt, "label")
	end

	function S:Keybind(cfg)
		cfg = cfg or {}
		-- В новой либе keybind вешается на Label/Toggle, отдельной секции keybind нет.
		local lbl = newSection:Label({ Name = cfg.Name or cfg.name })
		local nk = lbl:Keybind({
			Name     = cfg.Name or cfg.name,
			Flag     = cfg.Flag or cfg.flag,
			Mode     = cfg.Mode or cfg.mode or "Toggle",
			Default  = cfg.Key or cfg.key,
			Callback = cfg.Callback or cfg.callback or function() end,
		})
		return makeWidgetWrapper(nk, "keybind")
	end

	function S:Colorpicker(cfg)
		cfg = cfg or {}
		local lbl = newSection:Label({ Name = cfg.Name or cfg.name })
		local nc = lbl:Colorpicker({
			Name     = cfg.Name or cfg.name,
			Flag     = cfg.Flag or cfg.flag,
			Default  = cfg.Value or cfg.value or Color3.fromRGB(255,255,255),
			Alpha    = cfg.Alpha or cfg.alpha or 0,
			Callback = wrapColorCallback(cfg.Callback or cfg.callback),
		})
		return makeWidgetWrapper(nc, "colorpicker")
	end

	return S
end

-- ---------------------------------------------------------------------------
--  SubTab-обёртка. В новой либе нет под-вкладок. Все сабтабы ОДНОГО таба
--  делят ОДНУ страницу (Page), а их секции просто складываются вертикально
--  внутри колонок (Left=1 / Right=2). Так получаем 4 вкладки вместо 11.
-- ---------------------------------------------------------------------------
local function wrapSubTab(newPage)
	local ST = {}
	ST.__page = newPage

	function ST:Section(cfg)
		cfg = cfg or {}
		local side = cfg.Side or cfg.side or "Left"
		if type(side) == "string" then
			side = (side:lower() == "right") and 2 or 1
		end
		local ns = newPage:Section({ Name = cfg.Name or cfg.name or "Section", Side = side })
		return wrapSection(ns)
	end

	-- старый код делает subtab.Set(true). Первая Page активируется автоматически,
	-- поэтому здесь ничего делать не нужно (иначе сбивался бы активный таб).
	function ST.Set(_) end

	return ST
end

-- ---------------------------------------------------------------------------
--  Null-объект: молча проглатывает любые вызовы (для вкладки "Settings",
--  которую заменяет встроенная страница настроек новой библиотеки).
-- ---------------------------------------------------------------------------
local NullMT
local function makeNull()
	return setmetatable({}, NullMT)
end
NullMT = {
	__index = function()
		return function() return makeNull() end
	end
}

-- ---------------------------------------------------------------------------
--  Tab-обёртка. Старая структура: Window -> Tab -> SubTab -> Section.
--  Новая:                          Window -> Page -> Section.
--  Решение: каждый Tab = ОДНА Page (Combat, Visuals, Misc, Settings).
--  Все сабтабы таба добавляют свои секции в эту же страницу.
-- ---------------------------------------------------------------------------
local function wrapTab(newWindow, tabName)
	local T = {}
	T.__name = tabName

	-- Вкладку настроек делает встроенный Init() новой библиотеки, поэтому
	-- здесь возвращаем заглушку (пустую вкладку не создаём).
	if tabName == "Settings" or tabName == "settings" then
		function T:SubTab() return makeNull() end
		function T.Set(_) end
		return T
	end

	local page = newWindow:Page({ Name = tabName })

	function T:SubTab(_)
		return wrapSubTab(page) -- все сабтабы делят одну страницу таба
	end

	function T.Set(_) end

	return T
end


-- ---------------------------------------------------------------------------
--  Window-обёртка.
-- ---------------------------------------------------------------------------
function Library:Window(cfg)
	cfg = cfg or {}
	local name = (cfg.namestart or "frost") .. (cfg.nameend or ".vip")
	local newWindow = NewLib:Window({ Name = name })

	-- Build the Watermark and Keybind list NOW (before features are created),
	-- so that feature keybinds register themselves into the keybind list and
	-- the Menu toggles have real objects to call :SetVisibility on.
	if type(rawget(newWindow, "Watermark")) ~= "table" then
		newWindow:Watermark({ Name = name })
	end
	if type(rawget(newWindow, "KeybindList")) ~= "table" then
		newWindow:KeybindList()
	end

	-- ---- Glow для watermark и keybinds ----
	do
		local CoreGuiRef  = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
		local glowSg = Instance.new("ScreenGui")
		glowSg.Name           = "WMGlowGui"
		glowSg.DisplayOrder   = 48  -- ниже watermark (50)
		glowSg.IgnoreGuiInset = false
		glowSg.ResetOnSpawn   = false
		pcall(function() glowSg.Parent = CoreGuiRef end)
		if not glowSg.Parent then
			glowSg.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
		end

		-- Без UICorner — glow прямоугольный, без закруглений и без зазора
		local function makeGlowLayer(thick, transp, pad)
			local f = Instance.new("Frame", glowSg)
			f.BackgroundTransparency = 1
			f.BorderSizePixel        = 0
			f.Visible                = false
			local s = Instance.new("UIStroke", f)
			s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			s.LineJoinMode    = Enum.LineJoinMode.Miter
			s.Thickness       = thick
			s.Transparency    = transp
			s.Color           = Color3.fromRGB(176, 176, 209)
			return {f=f, s=s, pad=pad}
		end

		-- Гауссово затухание, PAD_START=0 чтобы не было зазора
		local WM_GLOW_LAYERS    = 80
		local WM_GLOW_RADIUS_PX = 8
		local WM_GLOW_INTENSITY = 0.88

		local GLOW_DEFS = {}
		local WM_PAD_START = 0  -- 0 = glow вплотную к краю, без зазора
		for i = 1, WM_GLOW_LAYERS do
			local t      = i / WM_GLOW_LAYERS
			local alpha  = math.exp(-(t * 1.8)^2)
			local transp = 1 - alpha * (1 - WM_GLOW_INTENSITY)
			local pad    = WM_PAD_START + t * WM_GLOW_RADIUS_PX
			table.insert(GLOW_DEFS, {th=1, tr=transp, pad=pad})
		end

		local function buildGlow()
			local t = {}
			for _, d in GLOW_DEFS do
				table.insert(t, makeGlowLayer(d.th, d.tr, d.pad))
			end
			return t
		end

		local wmGlowLayers = buildGlow()
		local kbGlowLayers = buildGlow()
		local glowOn = false

		local guiInset = game:GetService("GuiService"):GetGuiInset().Y

		local function applyGlow(layers, target, on)
			if not target or not target.Parent or not on then
				for _, l in layers do l.f.Visible = false end
				return
			end
			local abs = target.AbsolutePosition
			local sz  = target.AbsoluteSize
			for _, l in layers do
				local p = l.pad
				l.f.Position = UDim2.fromOffset(abs.X - p, abs.Y - p)
				l.f.Size     = UDim2.fromOffset(sz.X + p*2, sz.Y + p*2)
				l.f.Visible  = true
			end
		end

		-- ищем Instance watermark и keybinds через rawget после задержки
		local wmInst, kbInst = nil, nil
		task.delay(1.5, function()
			local WM = rawget(newWindow, "Watermark")
			if WM then
				local item = WM.Items and WM.Items["Watermark"]
				wmInst = (type(item) == "table" and item.Instance) or item
				if wmInst and not wmInst:IsA("Frame") then wmInst = nil end
			end
			local KB = rawget(newWindow, "KeybindList")
			if KB then
				local item = KB.Items and KB.Items["KeybindList"]
				local raw = (type(item) == "table" and item.Instance) or item
				if raw and (raw:IsA("Frame") or raw:IsA("ScrollingFrame")) then
					kbInst = raw
				end
			end
		end)

		game:GetService("RunService").RenderStepped:Connect(function()
			if not glowOn then
				for _, l in wmGlowLayers do l.f.Visible = false end
				for _, l in kbGlowLayers do l.f.Visible = false end
				return
			end
			applyGlow(wmGlowLayers, wmInst, glowOn)
			applyGlow(kbGlowLayers, kbInst, glowOn)
		end)

		-- сохраняем для тогла в misc
		newWindow._wmGlowLayers = wmGlowLayers
		newWindow._kbGlowLayers = kbGlowLayers
		newWindow._setGlow = function(bool)
			glowOn = bool
		end
	end

	-- ---- Watermark live info (FPS / ping / time) ----
	do
		local WM = rawget(newWindow, "Watermark")
		if WM and type(WM) == "table" then
			local ok = pcall(function()
				local StatsService = game:GetService("Stats")
				local uid = tostring(game:GetService("Players").LocalPlayer.UserId)

				local frames, lastTick, fps = 0, os.clock(), 0
				game:GetService("RunService").RenderStepped:Connect(function()
					frames += 1
					local now = os.clock()
					if now - lastTick >= 0.5 then
						fps = math.floor((frames / (now - lastTick)) + 0.5)
						frames = 0
						lastTick = now
					end
				end)

				local accum = 0
				game:GetService("RunService").RenderStepped:Connect(function(dt)
					accum += dt
					if accum < 0.25 then return end
					accum = 0

					local ping = 0
					pcall(function()
						ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
					end)

					if WM.SetText then
						WM:SetText(string.format(
							"frost.vip - developer - v1.0 - %d fps - %dms - uid: %s - %s",
							fps, ping, uid, os.date("%H:%M:%S")
						))
					end
				end)
			end)
		end
	end

	local W = {}
	W.__new = newWindow
	W.Visible = true

	function W:Tab(c)
		c = c or {}
		return wrapTab(newWindow, c.name or c.Name or "Tab")
	end

	-- старый код вызывает ui.window.Open() и читает ui.window.Visible (в настройках)
	function W.Open()
		if newWindow.SetOpen then newWindow:SetOpen(not newWindow.IsOpen) end
		W.Visible = newWindow.IsOpen
	end

	-- встроенная страница настроек новой библиотеки (Theming/Menu/Profiles/Autoload)
	function W.Init()
		if newWindow.Init then newWindow:Init() end
	end

	return W
end

-- Экспортируем имена, которые ждёт код фич.
return Library, Utility
end)()

-- ---- backend (cheat: ESP / aimbot helpers / indicator / utility) ----
local cloneref = cloneref or function(...) return ... end
local checkcaller = checkcaller
local getnamecallmethod = getnamecallmethod
local tablecreate = table.create
local mathfloor = math.floor
local mathround = math.round
local mathrandom = math.random
local tostring = tostring
local unpack = table.unpack
local getupvalues = debug.getupvalues
local getupvalue = debug.getupvalue
local setupvalue = debug.setupvalue
local getconstants = debug.getconstants
local getconstant = debug.getconstant
local setconstant = debug.setconstant
local getstack = debug.getstack
local setstack = debug.setstack
local getinfo = debug.getinfo
local debugtraceback = debug.traceback
local rawget = rawget

local workspace = cloneref(game:GetService("Workspace"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local GuiInset = cloneref(game:GetService("GuiService")):GetGuiInset()
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local _CFramenew = CFrame.new
local _Vector2new = Vector2.new
local _Vector3new = Vector3.new
local _IsDescendantOf = game.IsDescendantOf
local _FindFirstChild = game.FindFirstChild
local _FindFirstChildOfClass = game.FindFirstChildOfClass
local _Raycast = workspace.Raycast
local _IsKeyDown = UserInputService.IsKeyDown
local _WorldToViewportPoint = Camera.WorldToViewportPoint
local _Vector3zeromin = Vector3.zero.Min
local _Vector2zeromin = Vector2.zero.Min
local _Vector3zeromax = Vector3.zero.Max
local _Vector2zeromax = Vector2.zero.Max
local _VectorToObjectSpace = CFrame.new().VectorToObjectSpace
local _IsA = game.IsA

local cheat = {
	Library = nil,
	Toggles = nil,
	Options = nil,
	ThemeManager = nil,
	SaveManager = nil,
	connections = {
		heartbeats = {},
		renderstepped = {}
	},
	drawings = {},
	hooks = {}
}
cheat.utility = {} do
	cheat.utility.new_heartbeat = function(func)
		local obj = {}
		cheat.connections.heartbeats[func] = func
		function obj:Disconnect()
			if func then
				cheat.connections.heartbeats[func] = nil
				func = nil
			end
		end
		return obj
	end
	cheat.utility.new_renderstepped = function(func)
		local obj = {}
		cheat.connections.renderstepped[func] = func
		function obj:Disconnect()
			if func then
				cheat.connections.renderstepped[func] = nil
				func = nil
			end
		end
		return obj
	end
	cheat.utility.new_drawing = function(drawobj, args)
		local obj = Drawing.new(drawobj)
		for i, v in pairs(args) do
			obj[i] = v
		end
		cheat.drawings[obj] = obj
		return obj
	end
	cheat.utility.new_hook = function(f, newf, usecclosure) LPH_NO_VIRTUALIZE(function()
			if usecclosure then
				local old; old = hookfunction(f, newcclosure(function(...)
					return newf(old, ...)
				end))
				cheat.hooks[f] = old
				return old
			else
				local old; old = hookfunction(f, function(...)
					return newf(old, ...)
				end)
				cheat.hooks[f] = old
				return old
			end
		end)() end
	local connection; connection = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(delta)
		for _, func in pairs(cheat.connections.heartbeats) do
			func(delta)
		end
	end))
	local connection1; connection1 = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function(delta)
		for _, func in pairs(cheat.connections.renderstepped) do
			func(delta)
		end
	end))
	cheat.utility.unload = function()
		connection:Disconnect()
		connection1:Disconnect()
		for key, _ in pairs(cheat.connections.heartbeats) do
			cheat.connections.heartbeats[key] = nil
		end
		for key, _ in pairs(cheat.connections.renderstepped) do
			cheat.connections.renderstepped[key] = nil
		end
		for _, drawing in pairs(cheat.drawings) do
			drawing:Remove()
			cheat.drawings[_] = nil
		end
		for hooked, original in pairs(cheat.hooks) do
			if type(original) == "function" then
				hookfunction(hooked, clonefunction(original))
			else
				hookmetamethod(original["instance"], original["metamethod"], clonefunction(original["func"]))
			end
		end
	end
end
LPH_NO_VIRTUALIZE(function()
	local esp_table = {}
	local workspace = game:GetService("Workspace")
	local rservice = game:GetService("RunService")
	local plrs = game:GetService("Players")
	local lplr = plrs.LocalPlayer
	local container = Instance.new("Folder", game:GetService("CoreGui").RobloxGui)
	local gui_inset = game:GetService("GuiService"):GetGuiInset()

	if setfflag then
		setfflag("AdornShadingAPI", true) -- glowy chamsy
	end

	esp_table = {
		__loaded = false,
		registered_flags = {},
		settings = {
			enemy = {
				main_settings = {
					fade_time = 1,
					team_check = false,
					dead_check = false,
					dist_check = false,
					max_distance = 1000,
					skeleton_rate = 1e-10,
					gradient_spin = false,
					gradient_speed = 360 -- degrees per second, formula: tick() % 1 * speed
				},

				enabled = false,

				box = false,
				health_bar = false,
				name = false,
				health_text = false,
				distance = false,
				weapon = false,
				skeleton = false,
				flags = false,
				
				arrow = false,
				arrow_max_dist = 100,
				arrow_radius = 200,
				arrow_elements = {},
				arrow_hp_color = nil, -- nil = авто (красный→зелёный), иначе Color3

				box_color = { Color3.new(1, 1, 1), Color3.new(1, 1, 1), 0 },
				health_bar_color = { Color3.new(1, 1, 1), Color3.new(1, 1, 1) },
				name_color = { Color3.new(1, 1, 1), 0 },
				health_text_color = { Color3.new(1, 1, 1), 0 },
				dist_color = { Color3.new(1, 1, 1), 0 },
				weapon_color = { Color3.new(1, 1, 1), 0 },
				skeleton_color = { Color3.new(1, 1, 1), 0 },
				flags_color = { Color3.new(1, 1, 1), 0 },

				box_rotation = 0,

				chams = false,
				highlight = false,
				highlight_color = { Library.Theme.accent or Color3.new(1, 1, 1), 0 },
				chams_style = "Glow",
				chams_color = { Library.Theme.accent or Color3.new(1, 1, 1), 0 },
				chams_glow_factor = 2
			},
			self_chams = {
				enabled = false,
				style = "Ocean Gel",
				color = { Library.Theme.accent or Color3.new(1, 1, 1), 0 },
				glow_factor = 3,
				highlight = false,
				highlight_color = { Library.Theme.accent or Color3.new(1, 1, 1), 0 }
			}
		}
	}

	local loaded_plrs = {}

	local VERTICES = {
		_Vector3new(-1, -1, -1),
		_Vector3new(-1, 1, -1),
		_Vector3new(-1, 1, 1),
		_Vector3new(-1, -1, 1),
		_Vector3new(1, -1, -1),
		_Vector3new(1, 1, -1),
		_Vector3new(1, 1, 1),
		_Vector3new(1, -1, 1)
	}
	local skeleton_order = {
		["LeftFoot"] = "LeftLowerLeg",
		["LeftLowerLeg"] = "LeftUpperLeg",
		["LeftUpperLeg"] = "LowerTorso",

		["RightFoot"] = "RightLowerLeg",
		["RightLowerLeg"] = "RightUpperLeg",
		["RightUpperLeg"] = "LowerTorso",

		["LeftHand"] = "LeftLowerArm",
		["LeftLowerArm"] = "LeftUpperArm",
		["LeftUpperArm"] = "UpperTorso",

		["RightHand"] = "RightLowerArm",
		["RightLowerArm"] = "RightUpperArm",
		["RightUpperArm"] = "UpperTorso",

		["LowerTorso"] = "UpperTorso",
		["UpperTorso"] = "Head"
	}
	local esp = {}
	esp.create_obj = function(new, args, tbl)
		local obj = Instance.new(new)
		for i, v in args do
			obj[i] = v
		end
		if tbl then table.insert(tbl, obj) end
		return obj
	end

	local function isBodyPart(name)
		return name == "Head" or name:find("Torso") or name:find("Leg") or name:find("Arm") or name:find("Hand") or name:find("Foot")
	end

	local function getBoundingBox(parts)
		local min, max
		for i, part in parts do
			local cframe, size = part[1], part[2]

			min = _Vector3zeromin(min or cframe.Position, (cframe - size * 0.5).Position)
			max = _Vector3zeromax(max or cframe.Position, (cframe + size * 0.5).Position)
		end

		local center = (min + max) * 0.5
		local front = _Vector3new(center.X, center.Y, max.Z)
		return _CFramenew(center, front), max - min
	end

	local function worldToScreen(world)
		local screen, inBounds = _WorldToViewportPoint(Camera, world)
		return _Vector2new(screen.X, screen.Y), inBounds, screen.Z
	end

	local function calculateCorners(cframe, size)
		local corners = table.create(#VERTICES)
		for i, vertice in VERTICES do
			corners[i] = worldToScreen((cframe + size * 0.5 * vertice).Position)
		end

		local min = _Vector2zeromin(Camera.ViewportSize, unpack(corners))
		local max = _Vector2zeromax(Vector2.zero, unpack(corners))
		return {
			corners = corners,
			topLeft = _Vector2new(min.X, min.Y),
			topRight = _Vector2new(max.X, min.Y),
			bottomLeft = _Vector2new(min.X, max.Y),
			bottomRight = _Vector2new(max.X, max.Y)
		}
	end

	local create_esp, destroy_esp;

	create_esp = function(plr_instance)
		loaded_plrs[plr_instance] = {
			obj = {},
			connections = {}
		}

		--[[for required, _ in next, skeleton_order do
			loaded_plrs[plr_instance].obj["skeleton_" .. required] = esp.create_obj("Line", { Visible = false, Thickness = 1 })
		end]]

		local flags_table = {}
		local chams_table = {}

		local registered_flags = esp_table.registered_flags

		local plr = loaded_plrs[plr_instance]
		local obj = plr.obj

		local model_highlight = esp.create_obj("Highlight", {
			Parent = container,
			Enabled = false,
			Adornee = nil,
			FillTransparency = 1,
			OutlineTransparency = 0,
			OutlineColor = Color3.new(0, 0, 0),
			FillColor = Color3.new(0, 0, 0),
			DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
		}, obj)

		local main_holder = esp.create_obj("Frame", {
			Parent = container,
			ZIndex = 2,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(0, 0),
			Position = UDim2.fromScale(0, 0),
			BackgroundTransparency = 1,
			Visible = false
		}, obj)

		local arrow_holder = esp.create_obj("Frame", {
			Parent = container,
			ZIndex = 2,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 40, 0, 40),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
			Visible = false
		}, obj)
		-- ===== ARROW ESP layout (matches reference: name above, HP-bar left of arrow, dist below, item under dist) =====
		local arrow_label = esp.create_obj("TextLabel", {
			Parent = arrow_holder,
			BackgroundTransparency = 1,
			Text = "▽",
			TextColor3 = Color3.new(1, 1, 1),
			TextTransparency = 0.15,
			TextSize = 20,
			Font = Enum.Font.Code,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextStrokeTransparency = 0.4,
			TextStrokeColor3 = Color3.new(0.6, 0.6, 0.6),
		}, obj)

		-- Имя НАД стрелкой
		local arrow_name = esp.create_obj("TextLabel", {
			Parent = arrow_holder,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 120, 0, 13),
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 0, -2),
			FontFace = Fonts.Get("TahomaXP"),
			TextSize = 12,
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 0,
			TextXAlignment = Enum.TextXAlignment.Center,
			Visible = false,
		}, obj)

		-- HP-бар СЛЕВА от стрелки (вертикальная зелёная полоска как на референсе)
		-- arrow_box_lbl — внешний фрейм-«рамка»  HP, чтобы существующий код, который
		-- ссылается на arrow_box_inner.Color, продолжал работать (мы используем его
		-- как заполняющую полосу HP).
		local arrow_box_lbl = esp.create_obj("Frame", {
			Parent = arrow_holder,
			AnchorPoint = Vector2.new(1, 0.5),       -- правый край прижат к левому боку стрелки
			Position = UDim2.new(0.5, -11, 0.5, 0), -- вплотную слева от центра holder
			Size = UDim2.new(0, 2, 0, 16),           -- тонкая вертикальная полоска
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Visible = false,
		}, obj)
		esp.create_obj("UIStroke", {
			Parent = arrow_box_lbl,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			Thickness = 1,
			Color = Color3.fromRGB(0, 0, 0),
			Transparency = 0,
		}, obj)
		local arrow_box_inner_frame = esp.create_obj("Frame", {
			Parent = arrow_box_lbl,
			AnchorPoint = Vector2.new(0, 1),         -- HP «растёт» снизу вверх
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(64, 220, 90), -- зелёный HP
			BorderSizePixel = 0,
		}, obj)
		-- arrow_box_inner оставляем для совместимости со старым кодом (.Color),
		-- цвет сразу подаём на заливку HP-полоски.
		local arrow_box_inner = esp.create_obj("UIStroke", {
			Parent = arrow_box_inner_frame,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			Thickness = 0,
			Color = Color3.fromRGB(64, 220, 90),
			Transparency = 1,
		}, obj)

		-- Дистанция ПОД стрелкой
		local arrow_distance_lbl = esp.create_obj("TextLabel", {
			Parent = arrow_holder,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 120, 0, 13),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 1, 2),
			FontFace = Fonts.Get("TahomaXP"),
			TextSize = 12,
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 0,
			TextXAlignment = Enum.TextXAlignment.Center,
			Visible = false,
		}, obj)

		-- Item (Tool) ПОД дистанцией
		local arrow_item_lbl = esp.create_obj("TextLabel", {
			Parent = arrow_holder,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 120, 0, 13),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 1, 18),
			FontFace = Fonts.Get("TahomaXP"),
			TextSize = 12,
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 0,
			TextXAlignment = Enum.TextXAlignment.Center,
			Visible = false,
		}, obj)

		-- arrow_health_lbl: текстовая «[100]» больше не нужна (HP теперь — полоса слева),
		-- но переменная должна существовать, потому что код фич ниже обращается к ней
		-- (.Visible / .Text). Делаем скрытый dummy-лейбл.
		local arrow_health_lbl = esp.create_obj("TextLabel", {
			Parent = arrow_holder,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, 0),
			Text = "",
			Visible = false,
		}, obj)
		-- ===== /ARROW ESP layout =====
		local box_holder = esp.create_obj("Frame", {
			Parent = main_holder,
			ZIndex = -1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1
		}, obj)
		local box_outline_holder = esp.create_obj("Frame", {
			Parent = main_holder,
			ZIndex = -1,
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(1, 1, 1),
			Size = UDim2.new(1, -4, 1, -4),
			Position = UDim2.new(0, 2, 0, 2),
			BackgroundTransparency = 1
		}, obj)

		local main_box = esp.create_obj("UIStroke", {
			Parent = box_holder,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			Color = Color3.new(1, 1, 1)
		}, obj)
		local main_box_color = esp.create_obj("UIGradient", {
			Parent = main_box,
			Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
			}
		}, obj)
		local main_box_outline_1 = esp.create_obj("UIStroke", {
			Parent = main_holder,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			Color = Color3.new()
		}, obj)
		local main_box_outline_2 = esp.create_obj("UIStroke", {
			Parent = box_outline_holder,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			Color = Color3.new()
		}, obj)

		local main_name = esp.create_obj("TextLabel", {
			Parent = main_holder,
			TextStrokeTransparency = 0,
			BorderSizePixel = 0,
			TextSize = 12,
			FontFace = Fonts.Get("TahomaXP"),
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.new(0, 10000, 0, 13),
			Text = plr_instance.Name,
			Position = UDim2.new(0.5, 0, 0, -17)
		}, obj)

		local main_distance = esp.create_obj("TextLabel", {
			Parent = main_holder,
			TextStrokeTransparency = 0,
			BorderSizePixel = 0,
			TextSize = 12,
			FontFace = Fonts.Get("TahomaXP"),
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.new(0, 10000, 0, 13),
			Text = "0m",
			Position = UDim2.new(0.5, 0, 1, 1)
		}, obj)

		local main_weapon = esp.create_obj("TextLabel", {
			Parent = main_holder,
			TextStrokeTransparency = 0,
			BorderSizePixel = 0,
			TextSize = 12,
			FontFace = Fonts.Get("TahomaXP"),
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.new(0, 10000, 0, 13),
			Text = "",
			Position = UDim2.new(0.5, 0, 1, 14)
		}, obj)

		local health_bar_holder = esp.create_obj("Frame", {
			Parent = main_holder,
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(0, 1, 1, 0),
			Position = UDim2.new(0, -5, 0, 0),
			BorderSizePixel = 0
		}, obj)

		local health_bar_outline = esp.create_obj("UIStroke", {
			Parent = health_bar_holder,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			Color = Color3.new()
		}, obj)

		local main_health_bar = esp.create_obj("Frame", {
			Parent = health_bar_holder,
			ZIndex = 2,
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(1, 0, 0, 0)
		}, obj)

		local main_health_text = esp.create_obj("TextLabel", {
			Parent = main_health_bar,
			TextStrokeTransparency = 0,
			BorderSizePixel = 0,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Right,
			FontFace = Fonts.Get("TahomaXP"),
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0),
			Size = UDim2.new(50, 0, 0, 6),
			Text = "100",
			Position = UDim2.new(-2, 0, 1, 0)
		}, obj)

		local health_bar_thing = esp.create_obj("Frame", {
			Parent = health_bar_holder,
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(1, 1, 1),
			AnchorPoint = Vector2.new(0, 1),
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 1, 0)
		}, obj)

		local main_health_bar_color = esp.create_obj("UIGradient", {
			Parent = health_bar_thing,
			Rotation = 90,
			Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
			}
		}, obj)

		local flag_holder = esp.create_obj("Frame", {
			Parent = main_holder,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(1, 3, 0, -4),
			BackgroundTransparency = 1,
		}, obj)

		esp.create_obj("UIListLayout", {
			Parent = flag_holder,
			SortOrder = Enum.SortOrder.LayoutOrder
		}, obj)


		for i, v in registered_flags do
			table.insert(obj, esp.create_obj("TextLabel", {
				Parent = flag_holder,
				TextStrokeTransparency = 0,
				BorderSizePixel = 0,
				TextSize = 9,
				TextXAlignment = Enum.TextXAlignment.Left,
				FontFace = Fonts.Get("SmallestPixel7"),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 10),
				Text = v[1],
				Position = UDim2.new(0, 0, 0, -1)
			}, flags_table))
		end

		local main_wireframe = esp.create_obj("WireframeHandleAdornment", {
			Parent = container,
			Color3 = Color3.new(1, 1, 1),
			Transparency = 0,
			AlwaysOnTop = true,
			CFrame = CFrame.new(),
			Scale = Vector3.one,
			Thickness = 1,
			AdornCullingMode = Enum.AdornCullingMode.Automatic
		}, obj)

		--main_wireframe.Adornee = root

		local settings = esp_table.settings.enemy
		local main_settings = settings.main_settings

		local character, humanoid, head, root

		-- god forgive me
		local team_check, dead_check, dist_check = main_settings.team_check, main_settings.dead_check, main_settings.dist_check
		local skeleton_rate = main_settings.skeleton_rate <= 0 and 1e-10 or main_settings.skeleton_rate
		local max_distance, update_skeleton = main_settings.max_distance, settings.skeleton
		local weapon_enabled, box_rotation = settings.weapon, settings.box_rotation

		local gradient_spin, gradient_speed = main_settings.gradient_spin, main_settings.gradient_speed

		local get_character, get_root, get_humanoid = esp_table.get_character, esp_table.get_root, esp_table.get_humanoid
		local get_health, get_team, get_gun = esp_table.get_health, esp_table.get_team, esp_table.get_gun

		local setvis_cache, skeleton_tick = false, 0

		local function clampColor(v)
			return math.clamp(v, 0, 1)
		end

		local function scaledColor(color, factor)
			return Color3.new(
				clampColor(color.R * factor),
				clampColor(color.G * factor),
				clampColor(color.B * factor)
			)
		end

		local function setChamShading(chamObject, preferred)
			pcall(function()
				if preferred == "XRayShaded" then
					chamObject.Shading = Enum.AdornShading.XRayShaded
				elseif preferred == "AlwaysOnTop" then
					local ok = pcall(function() chamObject.Shading = Enum.AdornShading.AlwaysOnTop end)
					if not ok then chamObject.Shading = Enum.AdornShading.XRayShaded end
				end
			end)
		end

		local function apply_cham_style(chamObject, part)
			if not chamObject then return end
			local style = settings.chams_style or "Glow"
			local base = settings.chams_color[1] or Color3.new(1, 1, 1)
			local glow = settings.chams_glow_factor or 2
			local now = tick()

			local color = base
			local transparency = 0.45
			local alwaysOnTop = true
			local zindex = 1
			local sizeMul = 0.95
			local shadingMode = "AlwaysOnTop"

			if style == "Glow" then
				-- старый стиль чамсов, оставлен как Glow
				color = Color3.new(base.R * glow, base.G * glow, base.B * glow)
				transparency = -1
				alwaysOnTop = false
				zindex = -1
				sizeMul = 0.95
				shadingMode = "XRayShaded"
			elseif style == "Flat" then
				-- плотный flat: максимально насыщенный цвет, без серого XRay shading
				color = base
				transparency = 0
				alwaysOnTop = true
				zindex = 5
				sizeMul = 1
			elseif style == "ForceField" then
				-- ForceField-style shimmer: мягкая пульсация цвета/прозрачности/размера,
				-- чтобы выглядело как живая forcefield-оболочка, а не статичный flat cham.
				local offset = part and (#part.Name * 0.37 + part.Position.Magnitude * 0.015) or 0
				local wave = (math.sin(now * 4.2 + offset) + 1) * 0.5
				local wave2 = (math.sin(now * 7.4 + offset * 1.7) + 1) * 0.5

				color = scaledColor(base, 1.35 + wave * 0.65)
				transparency = 0.08 + wave2 * 0.18
				alwaysOnTop = true
				zindex = 6
				sizeMul = 1.015 + wave * 0.025
			elseif style == "Glass" then
				color = scaledColor(base, 1.45)
				transparency = 0.38
				alwaysOnTop = true
				zindex = 5
				sizeMul = 1.02
		elseif style == "Pulse" then
			material = Enum.Material.Neon
			local wave = (math.sin(now * 1.0) + 1) * 0.5
			local pulse = 1.0 + (1 - wave) * 0.35
			color = Color3.new(
				math.clamp(base_color.R * pulse, 0, 1),
				math.clamp(base_color.G * pulse, 0, 1),
				math.clamp(base_color.B * pulse, 0, 1)
			)
			target_transparency = 0.08 + wave * 0.82
			texture_id = ""
elseif style == "Rainbow" then
				color = Color3.fromHSV((now * 0.12) % 1, 0.75, 1)
				transparency = 0.28
				alwaysOnTop = true
				zindex = 3
				sizeMul = 1
			end

			chamObject.Color3 = color
			chamObject.Transparency = transparency
			chamObject.AlwaysOnTop = alwaysOnTop
			chamObject.ZIndex = zindex
			if part then chamObject.Size = part.Size * sizeMul end
			setChamShading(chamObject, shadingMode)
		end

		local function apply_highlight_style(outlineObject, part, visible)
			-- Per-part SelectionBox outline disabled: it was too thin and got hidden by Flat chams.
			-- We now use only one saturated Roblox Highlight around the whole character.
			if outlineObject then
				outlineObject.Adornee = nil
			end
		end

		local function apply_model_highlight(highlightObject, characterObject, visible)
			if not highlightObject then return end
			local enabled = visible and settings.highlight and characterObject ~= nil
			highlightObject.Enabled = enabled
			highlightObject.Adornee = enabled and characterObject or nil
			if not enabled then return end

			local color = settings.highlight_color[1] or Library.Theme.accent or Color3.new(1, 1, 1)
			local alpha = settings.highlight_color[2] or 0
			-- Boost color so the outline stays visible even over saturated/flat chams.
			local outlineColor = scaledColor(color, 2.25)

			pcall(function()
				highlightObject.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			end)
			highlightObject.OutlineColor = outlineColor
			highlightObject.OutlineTransparency = math.clamp(alpha * 0.35, 0, 0.2)
			highlightObject.FillColor = outlineColor
			highlightObject.FillTransparency = 1
		end

		function plr:forceupdate()
			team_check, dead_check, dist_check = main_settings.team_check, main_settings.dead_check, main_settings.dist_check
			skeleton_rate = main_settings.skeleton_rate <= 0 and 1e-10 or main_settings.skeleton_rate
			max_distance, update_skeleton = main_settings.max_distance, settings.skeleton
			weapon_enabled, box_rotation = settings.weapon, settings.box_rotation

			gradient_spin, gradient_speed = main_settings.gradient_spin, main_settings.gradient_speed

			main_box.Enabled = settings.box
			main_box_outline_1.Enabled = settings.box
			main_box_outline_2.Enabled = settings.box

			main_box.Transparency = settings.box_color[3]
			main_box_outline_1.Transparency = settings.box_color[3]
			main_box_outline_2.Transparency = settings.box_color[3]

			main_box_color.Rotation = box_rotation + (gradient_spin and tick() % 1 * gradient_speed or 0)
			main_box_color.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, settings.box_color[1]),
				ColorSequenceKeypoint.new(1, settings.box_color[2])
			}

			health_bar_holder.Visible = settings.health_bar
			main_health_bar_color.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, settings.health_bar_color[1]),
				ColorSequenceKeypoint.new(1, settings.health_bar_color[2])
			}

			main_health_text.Visible = settings.health_text
			main_health_text.TextColor3 = settings.health_text_color[1]
			main_health_text.TextTransparency = settings.health_text_color[2]

			main_name.Visible = settings.name
			main_name.TextColor3 = settings.name_color[1]
			main_name.TextTransparency = settings.name_color[2]

			main_distance.Visible = settings.distance
			main_distance.TextColor3 = settings.distance_color[1]
			main_distance.TextTransparency = settings.distance_color[2]

			main_weapon.Visible = settings.weapon
			main_weapon.TextColor3 = settings.weapon_color[1]
			main_weapon.TextTransparency = settings.weapon_color[2]

			main_wireframe.Visible = settings.skeleton
			main_wireframe.Color3 = settings.skeleton_color[1]
			main_wireframe.Transparency = settings.skeleton_color[2]

			flag_holder.Visible = settings.flags
			for _, flag in flags_table do
				flag.TextColor3 = settings.flags_color[1]
				flag.TextTransparency = settings.flags_color[2]
			end

			apply_model_highlight(model_highlight, character, setvis_cache)
			for part, cham in chams_table do
				local visible = setvis_cache
				cham.outline.Adornee = nil
				cham.cham.Adornee = visible and settings.chams and part or nil
				apply_highlight_style(cham.outline, part, visible)
				apply_cham_style(cham.cham, part)
			end
		end

		local destroy_cham_object = function(part)
			if not chams_table[part] then
				return --print("???????", part)
			end
			chams_table[part].connection:Disconnect()
			if chams_table[part].outline then chams_table[part].outline:Destroy() end
			chams_table[part].cham:Destroy()
			chams_table[part] = nil
		end

		local create_cham_object = function(part)
			if not (_IsA(part, "BasePart") and isBodyPart(part.Name)) then return end
			if chams_table[part] then destroy_cham_object(part) end
			--print("hi", part)
			local outline = esp.create_obj("SelectionBox", {
				Parent = container,
				Adornee = nil,
				Color3 = settings.highlight_color[1],
				SurfaceColor3 = settings.highlight_color[1],
				SurfaceTransparency = 1,
				LineThickness = 0
			}, obj)
			apply_highlight_style(outline, part, setvis_cache)

			local cham = esp.create_obj("BoxHandleAdornment", {
				Parent = container,
				Size = part.Size * .95,
				Adornee = setvis_cache and settings.chams and part or nil,
				Color3 = settings.chams_color[1],
				Transparency = 0.45,
				Shading = Enum.AdornShading.XRayShaded,
				ZIndex = 1,
				AlwaysOnTop = true
			}, obj)
			apply_cham_style(cham, part)

			chams_table[part] = {
				cham = cham,
				outline = outline,
				connection = part:GetPropertyChangedSignal("Size"):Connect(function()
					if not (cham and part) then return print("MEMORY LEAK!!!!!!", cham, part) end
					apply_highlight_style(outline, part, setvis_cache)
					apply_cham_style(cham, part)
				end)
			}
		end

		function plr:togglevis(bool, fade)
			if setvis_cache == bool then return end
			setvis_cache = bool

			main_holder.Visible = bool
			if not bool then
				arrow_holder.Visible = false
			end
			apply_model_highlight(model_highlight, character, bool)
			for part, cham in chams_table do
				local visible = bool
				cham.outline.Adornee = nil
				cham.cham.Adornee = visible and settings.chams and part or nil
				apply_highlight_style(cham.outline, part, visible)
			end
		end

		local character_added = function(character)
			for _, part in character:GetChildren() do
				create_cham_object(part)
			end
			plr.connections["character_childadded"] = character.ChildAdded:Connect(function(part)
				create_cham_object(part)
			end)
			plr.connections["character_childremoved"] = character.ChildRemoved:Connect(function(part)
				destroy_cham_object(part)
			end)
		end

		local character_removing = function(character)
			if plr.connections["character_childadded"] then plr.connections["character_childadded"]:Disconnect() end
			if plr.connections["character_childremoved"] then plr.connections["character_childremoved"]:Disconnect() end
			for part, _ in chams_table do
				destroy_cham_object(part)
			end
		end

		if plr_instance.Character then character_added(plr_instance.Character) end
		plr.connections["character_added"] = plr_instance.CharacterAdded:Connect(character_added)
		plr.connections["character_removing"] = plr_instance.CharacterRemoving:Connect(character_removing)

		plr.connections["render"] = cheat.utility.new_renderstepped(function(delta)
			skeleton_tick += delta

			if skeleton_tick > skeleton_rate then
				main_wireframe:Clear()
			end

			if not settings.enabled then
				return plr:togglevis(false)
			end

			if (settings.chams and (settings.chams_style == "Pulse" or settings.chams_style == "Rainbow" or settings.chams_style == "ForceField")) or settings.highlight then
				for part, cham in chams_table do
					apply_highlight_style(cham.outline, part, setvis_cache)
					apply_cham_style(cham.cham, part)
				end
			end

			character = get_character(plr_instance)

			if not (character) then
				return plr:togglevis(false)
			end

			root = get_root(plr_instance, character)
			humanoid = get_humanoid(plr_instance, character)

			if not (root) then
				return plr:togglevis(false)
			end

			apply_model_highlight(model_highlight, character, true)
			
			local humanoid_health, humanoid_max_health
			if humanoid then 
				humanoid_health, humanoid_max_health = humanoid.Health, humanoid.MaxHealth
			end

			local humanoid_distance = (Camera.CFrame.Position - root.Position).Magnitude

			if (team_check) and get_team(plr_instance, character, humanoid) then
				return plr:togglevis(false)
			end

			if (dead_check) and (humanoid_health and humanoid_health <= 0) then
				return plr:togglevis(false)
			end

			if (dist_check) and (humanoid_distance > max_distance) then
				return plr:togglevis(false)
			end

			local _, onScreen = _WorldToViewportPoint(Camera, root.Position)

			if not onScreen then
				if settings.arrow and humanoid_distance <= settings.arrow_max_dist then
					main_holder.Visible = false
					apply_model_highlight(model_highlight, nil, false)
					for part, cham in chams_table do
						cham.cham.Adornee = nil
						if cham.outline then cham.outline.Adornee = nil end
					end
					setvis_cache = nil -- reset cache to allow normal togglevis later
					arrow_holder.Visible = true

					-- ===== ARROW ESP (compass) =====
					-- Стрелка размещается на круге вокруг центра экрана в направлении
					-- врага И поворачивается в ту же сторону (как компас/указатель).
					-- Символ "▼" по умолчанию смотрит вниз (=180°), поэтому компенсируем +180°.
					local camCFrame = Camera.CFrame
					local objSpace  = camCFrame:PointToObjectSpace(root.Position)

					-- angle: 0 = впереди, +pi/2 = справа, ±pi = сзади, -pi/2 = слева
					local angle = math.atan2(objSpace.X, -objSpace.Z)

					local screenCenter = Camera.ViewportSize / 2
					local radius = settings.arrow_radius
					local x = screenCenter.X + math.sin(angle) * radius
					local y = screenCenter.Y - math.cos(angle) * radius

					arrow_holder.Position = UDim2.new(0, x, 0, y - gui_inset.Y)
					arrow_label.Rotation = math.deg(angle) + 180
					-- ===== /ARROW ESP =====
					
					local elems = settings.arrow_elements
					local show_name   = table.find(elems, "name")
					local show_health = table.find(elems, "health")
					local show_dist   = table.find(elems, "distance")
					local show_box    = table.find(elems, "box")
					local show_item   = table.find(elems, "item")

					-- Имя сверху
					arrow_name.Visible = show_name ~= nil
					if arrow_name.Visible then arrow_name.Text = plr_instance.Name end

					-- Дистанция под стрелкой
					arrow_distance_lbl.Visible = show_dist ~= nil
					if arrow_distance_lbl.Visible then
						arrow_distance_lbl.Text = math.floor(humanoid_distance) .. "m"
					end

					-- HP — это вертикальная зелёная полоса СЛЕВА от стрелки
					-- (флаги "health" и "box" оба её показывают — как на референсе)
					local show_bar = (show_health ~= nil) or (show_box ~= nil)
					arrow_box_lbl.Visible = show_bar
					if show_bar and humanoid then
						local hp_ratio = math.clamp(humanoid_health / math.max(humanoid_max_health, 1), 0, 1)
						arrow_box_inner_frame.Size = UDim2.new(1, 0, hp_ratio, 0)
						-- цвет HP: пользовательский или авто (красный→зелёный)
						if settings.arrow_hp_color then
							arrow_box_inner_frame.BackgroundColor3 = settings.arrow_hp_color
						else
							arrow_box_inner_frame.BackgroundColor3 =
								Color3.fromRGB(math.floor(255 * (1 - hp_ratio)),
								               math.floor(220 * hp_ratio),
								               0)
						end
					end

					-- Скрытый текстовый health (для совместимости)
					arrow_health_lbl.Visible = false

					-- Item (Tool) — под дистанцией
					arrow_item_lbl.Visible = show_item ~= nil
					if arrow_item_lbl.Visible then
						local tool = character:FindFirstChildOfClass("Tool")
						arrow_item_lbl.Text = tool and ("[" .. tool.Name .. "]") or ""
						arrow_item_lbl.Visible = tool ~= nil
						-- если дистанция скрыта, поднимаем item на её место
						arrow_item_lbl.Position = arrow_distance_lbl.Visible
							and UDim2.new(0.5, 0, 1, 18)
							or  UDim2.new(0.5, 0, 1, 2)
					end
					return
				else
					return plr:togglevis(false)
				end
			else
				arrow_holder.Visible = false
			end

			local corners, cache = {}, {}
			do
				local count = 0
				for _, part in character:GetChildren() do
					if _IsA(part, "BasePart") and isBodyPart(part.Name) then
						cache[part.Name] = {part.CFrame, part.Size}
						count += 1
					end
				end
				if count <= 0 then
					return plr:togglevis(false)
				end
				corners = calculateCorners(getBoundingBox(cache))
			end

			plr:togglevis(true)

			do
				main_holder.Rotation = 0
				main_box_color.Rotation = box_rotation + (gradient_spin and tick() * gradient_speed % 360 or 0)
			end

			do
				local pos = corners.topLeft
				local size = corners.bottomRight - corners.topLeft
				main_holder.Position = UDim2.fromOffset(pos.X - gui_inset.X, pos.Y - gui_inset.Y)
				main_holder.Size = UDim2.fromOffset(size.X, size.Y)
			end

			do
				local pos = (corners.bottomLeft + corners.bottomRight) * 0.5
				main_distance.Text = mathround(humanoid_distance) .. "m"
				if weapon_enabled then
					local gun = get_gun(plr_instance, character, humanoid)
					if gun then
						main_weapon.Text = gun
						main_weapon.Position = main_distance.Visible and UDim2.new(0.5, 0, 1, 14) or UDim2.new(0.5, 0, 1, 1)
						main_weapon.Visible = true
					else
						main_weapon.Visible = false
					end
				end
			end

			main_health_text.Text = humanoid_health and tostring(mathfloor(humanoid_health)) or "???"
			main_health_bar.Size = UDim2.fromScale(1, humanoid_health and (1 - humanoid_health / humanoid_max_health) or 1)

			for i, v in registered_flags do
				local show_flag, flag_text = v[2](plr_instance, character, humanoid)
				local flag = flags_table[i]
				if not show_flag then
					flag.Visible = false
					continue	
				end
				flag.Visible = true
				if flag_text then flag.Text = flag_text end
			end

			if update_skeleton and skeleton_tick > skeleton_rate then
				skeleton_tick = skeleton_tick % skeleton_rate
				local root_pos = root.CFrame
				main_wireframe.Adornee = root

				local points = {}
				local counter = 0

				for part_name, info in cache do 
					local parent_part = skeleton_order[part_name]
					local parent_info = parent_part and cache[parent_part]
					if not (parent_info) then
						continue
					end

					local part_pos, parent_pos = info[1], parent_info[1]

					points[counter + 1] = _VectorToObjectSpace(root_pos, part_pos.Position - root_pos.Position)
					points[counter + 2] = _VectorToObjectSpace(root_pos, parent_pos.Position - root_pos.Position)

					counter += 2
				end

				main_wireframe:AddLines(points)
			end
		end)

		plr:forceupdate()
	end

	destroy_esp = function(player)
		if not loaded_plrs[player] then return end
		for i,v in loaded_plrs[player].connections do
			v:Disconnect()
		end
		for i,v in loaded_plrs[player].obj do
			v:Remove()
		end
		loaded_plrs[player] = nil
	end

	function esp_table.load()
		assert(not esp_table.__loaded, "[ESP] already loaded");

		for _, player in plrs:GetPlayers() do
			if lplr ~= player then
				create_esp(player)
			end
		end

		esp_table.playerAdded = plrs.PlayerAdded:Connect(create_esp)
		esp_table.playerRemoving = plrs.PlayerRemoving:Connect(destroy_esp)

		esp_table.__loaded = true;
	end

	function esp_table.unload()
		assert(esp_table.__loaded, "[ESP] not loaded yet");

		for player, v in next, loaded_plrs do
			destroy_esp(player)
		end

		esp_table.playerAdded:Disconnect()
		esp_table.playerRemoving:Disconnect()

		if esp_table.settings.self_chams then
			esp_table.settings.self_chams.enabled = false
			pcall(function()
				esp_table.update_self_chams()
			end)
		end

		esp_table.__loaded = false;
	end

	esp_table.get_character = function(player)
		return player.Character
	end

	esp_table.get_root = function(player, character)
		return _FindFirstChild(character, "HumanoidRootPart")
	end

	esp_table.get_humanoid = function(player, character)
		return _FindFirstChildOfClass(character, "Humanoid")
	end

	esp_table.get_health = function(player, character, humanoid)
		return humanoid.Health, humanoid.MaxHealth
	end

	esp_table.get_team = function(player, character, humanoid)
		return LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team
	end

	esp_table.get_gun = function(player, character, humanoid)
		if not character then
			return
		end
		local tool = _FindFirstChildOfClass(character, "Tool")
		return tool and tool.Name
	end

	function esp_table.icaca()
		for _, v in loaded_plrs do
			task.spawn(function() v:forceupdate() end)
		end
	end

	local original_properties = setmetatable({}, {__mode = "k"})
	local clothing_cache = setmetatable({}, {__mode = "k"})

	local function isBodyPart(part)
		local name = part.Name
		if name == "HumanoidRootPart" then return false end
		if part:FindFirstAncestorOfClass("Tool") then return false end
		
		-- Ignore weapons/viewmodels/arms folders
		local parent = part.Parent
		while parent and parent ~= workspace do
			local p_name = parent.Name:lower()
			if p_name:find("weapon") or p_name:find("viewmodel") or p_name:find("arms") then
				return false
			end
			parent = parent.Parent
		end
		
		return true
	end

	local function hide_clothing(character)
		for _, child in character:GetChildren() do
			if child:IsA("Shirt") and child.ShirtTemplate ~= "" then
				clothing_cache[child] = { Property = "ShirtTemplate", Value = child.ShirtTemplate }
				child.ShirtTemplate = ""
			elseif child:IsA("Pants") and child.PantsTemplate ~= "" then
				clothing_cache[child] = { Property = "PantsTemplate", Value = child.PantsTemplate }
				child.PantsTemplate = ""
			elseif child:IsA("ShirtGraphic") and child.Graphic ~= "" then
				clothing_cache[child] = { Property = "Graphic", Value = child.Graphic }
				child.Graphic = ""
			end
		end
	end

	local function restore_clothing()
		for obj, cache in pairs(clothing_cache) do
			if obj and obj.Parent then
				pcall(function()
					obj[cache.Property] = cache.Value
				end)
			end
		end
		table.clear(clothing_cache)
	end

	local function restore_part(part)
		if not part then return end
		local props = original_properties[part]
		if props then
			pcall(function()
				part.Material = props.Material
				part.Color = props.Color
				part.Transparency = props.Transparency
				part.Reflectance = props.Reflectance
				if part:IsA("MeshPart") and props.MeshPartTextureID then
					part.TextureID = props.MeshPartTextureID
				end
				for mesh, mesh_props in pairs(props.SpecialMeshes or {}) do
					if mesh and mesh.Parent then
						mesh.TextureId = mesh_props.TextureId
						mesh.VertexColor = mesh_props.VertexColor
					end
				end
				for decal, tex_id in pairs(props.Decals or {}) do
					if decal and decal.Parent then
						decal.Texture = tex_id
					end
				end
			end)
			original_properties[part] = nil
		end
		for _, child in part:GetChildren() do
			if child.Name == "SelfChamTexture" or child.Name == "SelfChamOutline" then
				child:Destroy()
			end
		end
	end

						local function apply_self_cham_to_part(part, style, base_color, transparency, glow)
		if not (part and part:IsA("BasePart") and isBodyPart(part)) then return end

		-- Destroy any leftover forcefield overlays from the previous step
		local overlay = part:FindFirstChild("SelfChamOverlay")
		if overlay then
			overlay:Destroy()
		end

		if not original_properties[part] then
			original_properties[part] = {
				Material = part.Material,
				Color = part.Color,
				Transparency = part.Transparency,
				Reflectance = part.Reflectance,
				MeshPartTextureID = part:IsA("MeshPart") and part.TextureID or nil,
				SpecialMeshes = {},
				Decals = {}
			}
			for _, child in part:GetChildren() do
				if child:IsA("SpecialMesh") then
					original_properties[part].SpecialMeshes[child] = {
						TextureId = child.TextureId,
						VertexColor = child.VertexColor
					}
				elseif child:IsA("Decal") then
					original_properties[part].Decals[child] = child.Texture
				end
			end
		end

		local now = tick()
		local color = base_color
		local target_transparency = transparency
		local reflectance = 0
		local material = Enum.Material.SmoothPlastic
		local texture_id = "rbxassetid://9883582451" -- Default to fully transparent texture to clear default skins

		if style == "Ocean Gel" then
			-- Highly reflective semi-transparent Glass material with no 2D textures to allow 100% pure, perfect color rendering and refraction!
			material = Enum.Material.Glass
			reflectance = 0.5
			color = base_color
			target_transparency = 0.5
			texture_id = "" -- Keep empty to prevent grey head and ensure perfect glass coloring matching the body!
		elseif style == "Glow" then
			material = Enum.Material.Neon
			color = base_color
			target_transparency = 0
			texture_id = ""
		elseif style == "Flat" then
			material = Enum.Material.SmoothPlastic
			color = base_color
			target_transparency = 0
			texture_id = ""
		elseif style == "ForceField" then
			material = Enum.Material.ForceField
			color = base_color
			target_transparency = transparency
			local props = original_properties[part]
			if props then
				if props.MeshPartTextureID and props.MeshPartTextureID ~= "" then
					texture_id = props.MeshPartTextureID
				else
					texture_id = "rbxassetid://9883582451"
				end
			else
				texture_id = "rbxassetid://9883582451"
			end
		elseif style == "Glass" then
			material = Enum.Material.Glass
			color = base_color
			target_transparency = 0.38
			reflectance = 0.5
			texture_id = ""
		elseif style == "Pulse" then
			material = Enum.Material.Neon
			local wave = (math.sin(now * 1.0) + 1) * 0.5
			local pulse = 1.0 + (1 - wave) * 0.35
			color = Color3.new(
				math.clamp(base_color.R * pulse, 0, 1),
				math.clamp(base_color.G * pulse, 0, 1),
				math.clamp(base_color.B * pulse, 0, 1)
			)
			target_transparency = 0.08 + wave * 0.82
			texture_id = ""
		elseif style == "Rainbow" then
			material = Enum.Material.Neon
			color = Color3.fromHSV((now * 0.03) % 1, 0.75, 1)
			target_transparency = 0.28
			texture_id = ""
		end

		pcall(function()
			part.Material = material
			part.Color = color
			part.Transparency = target_transparency
			part.Reflectance = reflectance
		end)

		-- Hide standard face decals
		for _, child in part:GetChildren() do
			if child:IsA("Decal") then
				pcall(function() child.Texture = "" end)
			end
		end

		-- Apply transparent texture (or custom forcefield) to meshes
		local has_mesh = part:IsA("MeshPart")
		local special_mesh = nil
		for _, child in part:GetChildren() do
			if child:IsA("SpecialMesh") then
				has_mesh = true
				special_mesh = child
				break
			end
		end

		if has_mesh then
			if part:IsA("MeshPart") then
				pcall(function() part.TextureID = texture_id end)
			end
			if special_mesh then
				local spec_tex = (style == "Ocean Gel") and "" or texture_id
				if style == "ForceField" then
					spec_tex = "rbxassetid://9883582451"
					local props = original_properties[part]
					if props and props.SpecialMeshes and props.SpecialMeshes[special_mesh] and props.SpecialMeshes[special_mesh].TextureId ~= "" then
						spec_tex = props.SpecialMeshes[special_mesh].TextureId
					end
				end
				pcall(function() special_mesh.TextureId = spec_tex end)
				-- Apply custom vertex color to special mesh so it colors exactly matching the body part (prevents grey head!)
				pcall(function()
					special_mesh.VertexColor = Vector3.new(color.R, color.G, color.B)
				end)
			end
		end

		-- Handle 6-sided textures for non-mesh blocks in Forcefield only
		local use_6_sided = (style == "ForceField" and not has_mesh)
		if not use_6_sided then
			for _, child in part:GetChildren() do
				if child.Name == "SelfChamTexture" or child.Name == "SelfChamOutline" then
					child:Destroy()
				end
			end
		else
			local existing_textures = {}
			for _, child in part:GetChildren() do
				if child.Name == "SelfChamTexture" and child:IsA("Texture") then
					existing_textures[child.Face] = child
				end
			end

			local faces = {
				Enum.NormalId.Front,
				Enum.NormalId.Back,
				Enum.NormalId.Left,
				Enum.NormalId.Right,
				Enum.NormalId.Top,
				Enum.NormalId.Bottom
			}

			for _, face in faces do
				local tex = existing_textures[face]
				if not tex then
					tex = Instance.new("Texture")
					tex.Name = "SelfChamTexture"
					tex.Face = face
					tex.Parent = part
				end
				tex.Texture = texture_id
				tex.Color3 = color
				tex.Transparency = target_transparency
				tex.StudsPerTileU = 2
				tex.StudsPerTileV = 2
				tex.OffsetStudsU = (now * 0.5) % 2
				tex.OffsetStudsV = (now * 0.5) % 2
			end
		end
	end

	local function apply_self_cham_highlight(character, color, trans)
		if not character then return end
		local highlight = character:FindFirstChild("SelfChamHighlight")
		if not highlight then
			highlight = Instance.new("Highlight")
			highlight.Name = "SelfChamHighlight"
			highlight.Parent = character
		end
		highlight.Adornee = character
		highlight.FillTransparency = 1
		highlight.OutlineColor = color
		highlight.OutlineTransparency = trans or 0.4 -- A beautiful, subtle, small outline!
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	end

	local function remove_self_cham_highlight(character)
		if not character then return end
		local highlight = character:FindFirstChild("SelfChamHighlight")
		if highlight then
			highlight:Destroy()
		end
	end

	function esp_table.update_self_chams()
		local self_chams = esp_table.settings.self_chams
		local character = lplr.Character

		-- Determine if we should show the Highlight on the local player character
		local show_highlight = self_chams.highlight or (self_chams.enabled and self_chams.style == "Ocean Gel")
		local highlight_color = Color3.new(1, 1, 1)
		local highlight_trans = 0.45

		if self_chams.highlight then
			-- Use chosen custom Self highlight color and transparency
			highlight_color = self_chams.highlight_color[1] or Color3.fromRGB(0, 102, 255)
			highlight_trans = self_chams.highlight_color[2] or 0.1
		elseif self_chams.enabled and self_chams.style == "Ocean Gel" then
			-- Default bold outline for Ocean Gel style
			highlight_color = self_chams.color[1]
			highlight_trans = 0.02
		end

		if show_highlight and character then
			apply_self_cham_highlight(character, highlight_color, highlight_trans)
		else
			remove_self_cham_highlight(character)
		end

		if not (self_chams and self_chams.enabled and character) then
			restore_clothing()
			if character then
				for _, child in character:GetDescendants() do
					if child:IsA("BasePart") then
						restore_part(child)
					end
				end
			end
			return
		end

		hide_clothing(character)

		for _, child in character:GetDescendants() do
			if child:IsA("BasePart") then
				apply_self_cham_to_part(
					child,
					self_chams.style,
					self_chams.color[1],
					self_chams.color[2],
					self_chams.glow_factor
				)
			end
		end
	end

	cheat.utility.new_renderstepped(function()
		if esp_table.__loaded then
			pcall(function()
				esp_table.update_self_chams()
			end)
		end
	end)

		function esp_table.register_flag(flag, func)
		assert(not esp_table.__loaded, "[ESP] tried adding flag after loading, add before loading")
		local registered_flags = esp_table.registered_flags
		registered_flags[#registered_flags + 1] = {flag, func}
	end

	cheat.EspLibrary = esp_table
end)();
LPH_NO_VIRTUALIZE(function()
	local camera = workspace.CurrentCamera

	local indicatorlib = {
		indicators = {}
	}

	function indicatorlib:new_indicator()
		local indicator = {
			enabled = false,

			followpart = false,
			target_part = nil,

			scale_x = 0.5,
			scale_y = 0.5,
			offset_x = 0,
			offset_y = 0,

			blink = false,
			blink_speed = 1, -- transparency revolution/second [[ 0 -> 1 -> 0 ]]
			blink_cycle = false,

			text = "",
			transparency = 1
		}

		indicator.drawing = cheat.utility.new_drawing("Text", { Visible = false })
		indicator.text = "indicator " .. tostring(indicator)

		indicatorlib.indicators[indicator] = indicator

		return indicator 
	end


	cheat.utility.new_renderstepped(function(delta)
		local viewportsize = camera and camera.ViewportSize
		if not viewportsize then
			camera = workspace.CurrentCamera;
			for _, indicator in indicatorlib.indicators do
				local drawing = indicator.drawing
				if not drawing then continue end

				drawing.Visible = false
			end
			return
		end
		local viewport_x = viewportsize.X
		local viewport_y = viewportsize.Y
		for _, indicator in indicatorlib.indicators do

			local drawing = indicator.drawing
			if not drawing then continue end

			if not indicator.enabled then
				drawing.Visible = false
				continue
			end

			drawing.Visible = true
			drawing.Text = indicator.text

			if indicator.followpart then
				local target_part = indicator.target_part
				if not target_part then
					drawing.Visible = false
					continue
				end
				local pos, onscreen = _WorldToViewportPoint(camera, target_part.CFrame.Position)
				if not onscreen then
					drawing.Visible = false
					continue
				end
				drawing.Position = _Vector2new(pos.X + indicator.offset_x, pos.Y + indicator.offset_y)
			else
				local calculated_x = viewport_x * indicator.scale_x + indicator.offset_x
				local calculated_y = viewport_y * indicator.scale_y + indicator.offset_y
				drawing.Position = _Vector2new(calculated_x, calculated_y)
			end

			if not indicator.blink then
				drawing.Transparency = indicator.transparency
				continue
			end

			local blink_speed = indicator.blink_speed

			if drawing.Transparency <= 0 then
				indicator.blink_cycle = true
			elseif drawing.Transparency >= 1 then
				indicator.blink_cycle = false
			end

			drawing.Transparency = drawing.Transparency + (blink_speed * (indicator.blink_cycle and 1 or -1)) * delta
		end
	end)


	cheat.IndicatorLibrary = indicatorlib
end)();

-- ---- UI definitions + ALL FEATURE LOGIC (unchanged) ----
local ui = {
	window = Library:Window({
		namestart = "frost",
		nameend = ".vip"
	})
}

ui.tabs = {
	combat = ui.window:Tab({name = "Combat", image = Images.Get("combat")}),
	visuals = ui.window:Tab({name = "Visuals", image = Images.Get("visuals")}),
	misc = ui.window:Tab({name = "Misc", image = Images.Get("misc")}),
	settings = ui.window:Tab({name = "Settings", image = Images.Get("config")})
}
ui.subtabs = {
	combat_aimbot = ui.tabs.combat:SubTab({Name = "Aimbot"}),
	combat_visuals = ui.tabs.combat:SubTab({Name = "Visuals"}),
	visuals_esp = ui.tabs.visuals:SubTab({Name = "ESP"}),
	visuals_lighting = ui.tabs.visuals:SubTab({Name = "Lighting"}),
	visuals_misc = ui.tabs.visuals:SubTab({Name = "Misc"}),
	misc_main = ui.tabs.misc:SubTab({Name = "Main"}),
	misc_exploit = ui.tabs.misc:SubTab({Name = "Exploits"}),
	settings_main = ui.tabs.settings:SubTab({Name = "Main"}),
	settings_theme = ui.tabs.settings:SubTab({Name = "Themeing"})
}
ui.sections = {
	aimbot_main = ui.subtabs.combat_aimbot:Section({Name = "Aimbot", Side = "Left"}),
	gunmods = ui.subtabs.combat_aimbot:Section({Name = "Gun Modifications", Side = "Right"}),
	--aimbot_silent = ui.subtabs.combat_aimbot:Section({Name = "Silent", Side = "Right"}),
	hit_detection = ui.subtabs.combat_visuals:Section({Name = "Hit detection", Side = "Left"}),
	target_info  = ui.subtabs.combat_visuals:Section({Name = "Target Info",   Side = "Left"}),
	hitmarkers   = ui.subtabs.combat_visuals:Section({Name = "Hitmarkers",    Side = "Right"}),

	player_esp = ui.subtabs.visuals_esp:Section({Name = "Players", Side = "Left"}),
	esp_settings = ui.subtabs.visuals_esp:Section({Name = "Settings", Side = "Right"}),
	-- esp_preview убран из секций меню — теперь это отдельное плавающее окно
	world_main_changer = ui.subtabs.visuals_lighting:Section({Name = "Lighting", Side = "Left"}),
	world_misc_changer = ui.subtabs.visuals_lighting:Section({Name = "Misc", Side = "Right"}),
	visuals_misc = ui.subtabs.misc_main:Section({Name = "View", Side = "Left"}),

	movement = ui.subtabs.misc_main:Section({Name = "Movement", Side = "Left"}),
	misc = ui.subtabs.misc_main:Section({Name = "Misc", Side = "Right"}),
	crosshair = ui.subtabs.misc_main:Section({Name = "Crosshair", Side = "Right"}),
	custom_desync = ui.subtabs.misc_exploit:Section({Name = "Custom desync", Side = "Left"}),
	exploit = ui.subtabs.misc_exploit:Section({Name = "Exploit", Side = "Right"}),

	settings_config = ui.subtabs.settings_main:Section({Name = "Config", Side = "Left"}),
	settings_personalization = ui.subtabs.settings_main:Section({Name = "Personalization", Side = "Right"}),
	theme_config = ui.subtabs.settings_theme:Section({Name = "Config", Side = "Left"}),
	theme_colors = ui.subtabs.settings_theme:Section({Name = "Colors", Side = "Right"})
}

do -- grr
	ui.tabs.combat.Set(true)

	ui.subtabs.combat_aimbot.Set(true)
	ui.subtabs.visuals_esp.Set(true)
	ui.subtabs.misc_main.Set(true)
	ui.subtabs.settings_main.Set(true)
end

--[[{
	name = "New Toggle",
	value = false,
	callback = function() end,
	flag = nil,
}]]

--[[
	local Tab = Window:Tab() do
		local SubTab = Tab:SubTab({Name = "Main"}) do
			local Section = SubTab:Section({Name = "Section"}) do
				local Toggle = Section:Toggle({ Name = "Toggle", Flag = "toggle_flag", Value = false, Callback = function(v) print("Toggle value:", v) end })

				Toggle:Keybind({
					Name = "Toggle Keybind",
					Key = Enum.KeyCode.B,
					Mode = "Toggle",
					Flag = "keybind_flag2",
					Value = false,
					Callback = function(v)
						print("Keybind value:", v)
					end
				})
				Toggle:Colorpicker({
					Name = "Colorpicker",
					Flag = "colorpicker_flag2",
					Value = Color3.fromRGB(255, 0, 0),
					Alpha = 0.5,
					UseAlpha = true,
					Callback = function(v)
						print("Colorpicker value:", v)
					end
				})
				
				Section:Slider({ Name = "Slider", Min = -100, Max = 100, Value = 0, Float = 1, Flag = "slider_flag", Callback = function(v) print("Slider value:", v) end })
				Section:Button({ Name = "Button", Confirm = true, Callback = function() print("Button clicked") end })
				Section:Dropdown({ 
					Name = "Dropdown", 
					Values = { "Value 1", "Value 2", "Value 3", "Value 4", "Value 5", "Value 6", "Value 7", "Value 8", "Value 9", "Value 10" }, 
					Value = { "Value 1" }, 
					Flag = "dropdown_flag", 
					Multi = true,
					Callback = function(v) 
						print("Dropdown value:", v) 
					end 
				})
				Section:List({
					Name = "List",
					Values = { "Value 1", "Value 2", "Value 3", "Value 4", "Value 5", "Value 6", "Value 7", "Value 8", "Value 9", "Value 10" },
					Value = { "Value 1" },
					Flag = "list_flag",
					Multi = true,
					Size = 120,
					Search = true,
					Callback = function(v)
						print("List value:", v)
					end
				})
				Section:Textbox({
					Name = "Textbox",
					Value = "",
					Flag = "textbox_flag",
					Callback = function(v)
						print("Textbox value:", v)
					end
				})
				Section:Keybind({
					Name = "Keybind",
					Key = Enum.KeyCode.E,
					Flag = "keybind_flag",
					Mode = "Toggle",
					Value = false,
					Callback = function(v)
						print("Keybind value:", v)
					end
				})
				Section:Colorpicker({
					Name = "Colorpicker",
					Flag = "colorpicker_flag",
					Value = Color3.fromRGB(255, 0, 0),
					Alpha = 0.5,
					UseAlpha = true,
					Callback = function(v)
						print("Colorpicker value:", v)
					end
				})
			end
			local Section = SubTab:Section({Name = "Section", Side = "Right"}) do

			end
		end
		local Other = Tab:SubTab({Name = "Other"}) do

		end
		SubTab.Set(true)
	end

Library.Notification("This is a notification.", 3)
Library.Notification( string.format(
	"Hit %s in the %s for %s damage (%s health remaining)", 
	Utility.RichText("Dean", Library.Theme.accent), 
	Utility.RichText("Head", Library.Theme.accent), 
	Utility.RichText("102", Library.Theme.accent), 
	Utility.RichText("0", Library.Theme.accent)
), 5 )
]]

cheat.player_list = {}
local hit_detection = function(...)end
local get_closest_target = function(...)end
do
	local player_list = cheat.player_list
	local esp_table = cheat.EspLibrary

	if game.GameId == 104984488 then
		esp_table.get_character = function(player)
			local focus = player.ReplicationFocus
			return focus and _FindFirstChild(focus, "Visuals")
		end
		esp_table.get_team = function(player, character, humanoid)
			return false
		end
	end

	local get_character, get_root, get_humanoid = esp_table.get_character, esp_table.get_root, esp_table.get_humanoid
	local get_health, get_team, get_gun = esp_table.get_health, esp_table.get_team, esp_table.get_gun

	local add_player = function(player)
		local character, humanoid
		local old_health
		player_list[player] = {
			premium = player.MembershipType == Enum.MembershipType.Premium,
			friend = player:IsFriendsWith(LocalPlayer.UserId),
			update_loop = cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
				character = get_character(player)
				if not character then return end
				humanoid = _FindFirstChildOfClass(character, "Humanoid")
				if not humanoid then return end
				if not old_health then old_health = humanoid.Health end
				local new_health = humanoid.Health
				if new_health ~= old_health then
					hit_detection(player, new_health, old_health)
					old_health = new_health
				end
			end))
		}
	end
	for _, player in Players:GetPlayers() do
		task.spawn(add_player, player)
	end

	Players.PlayerAdded:Connect(add_player)
	Players.PlayerRemoving:Connect(function(player)
		local object = player_list[player]
		object.update_loop:Disconnect()
		player_list[player] = nil
	end)

	

	--[[esp_table.get_character = function(player)
		return player.Character
	end

	esp_table.get_root = function(player, character)
		return _FindFirstChild(character, "HumanoidRootPart")
	end

	esp_table.get_humanoid = function(player, character)
		return _FindFirstChildOfClass(character, "Humanoid")
	end

	esp_table.get_health = function(player, character, humanoid)
		return humanoid.Health, humanoid.MaxHealth
	end

	esp_table.get_team = function(player, character, humanoid)
		return LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team
	end]]

	get_closest_target = function(fov_size, aimpart, team_check, dead_check, dist_check, max_distance)
		local ermm_part, plr_instance, collider
		local maximum_distance = fov_size
		local mousepos = UserInputService:GetMouseLocation()
		local campos = Camera.CFrame.Position
		
		LPH_NO_VIRTUALIZE(function()
			for _, player in Players:GetPlayers() do
				if not (player and player ~= LocalPlayer) then continue end

				local character = get_character(player)

				if not (character) then
					continue
				end

				local root = get_root(player, character)
				local aimpart = _FindFirstChild(character, aimpart)
				local mainpart = aimpart or root

				local humanoid = get_humanoid(player, character)

				if not (mainpart) then
					continue
				end

				local health, max_health
				if humanoid then
					health, max_health = health, max_health
				end

				if not (mainpart) then continue end

				if (team_check) and get_team(player) then
					continue
				end

				if (dead_check) and (health and health <= 0) then
					continue
				end
				if (dist_check) and ((campos - mainpart.Position).Magnitude > max_distance) then
					continue
				end

				local position, onscreen = _WorldToViewportPoint(Camera, mainpart.Position)
				local distance = (_Vector2new(position.X, position.Y) - mousepos).Magnitude

				if onscreen and distance <= maximum_distance then
					plr_instance = player
					ermm_part = mainpart
					collider = root
					maximum_distance = distance
				end
			end
		end)()
		return ermm_part, plr_instance, collider
	end
end

local aimbot_mode
local target_part, target_player, target_collider
local silent_mode, silent_projectionoverride, silent_wallbang, silent_magicbullet = "None", false, false, false
local silent_methods = {
	["Raycast"]                    = false,
	["FindPartOnRayWithWhitelist"] = false,
	["FindPartOnRayWithIgnoreList"]= false,
	["FindPartOnRay"]              = false,
	["ScreenPointToRay"]           = false,
	["ViewportPointToRay"]         = false,
	["Mouse"]                      = false,  -- мышиные рейкасты
	["Ray"]                        = false,  -- устаревший Ray API
}
do
	local aimsec = ui.sections.aimbot_main
	local chksec = ui.sections.aimbot_main  -- "Checks" merged into Aimbot section
	local samsec = ui.sections.aimbot_silent
	local hitsec = ui.sections.hit_detection
	local gunsec = ui.sections.gunmods

	local aimbot_enabled, aimbot_enabled_key, aimbot_part, aimbot_smoothness = false, false, "Head", 0.7
	aimbot_mode = "Mouse"  -- используем глобальный aimbot_mode (читается из __namecall хука)
	local aimbot_team_check, aimbot_dead_check, aimbot_dist_check, aimbot_max_distance = false, false, false, 600
	local fov_show, fov_color, fov_outline, fov_size = false, Color3.fromRGB(200, 170, 255), false, 100

	-- объявляем заранее чтобы hit_detection мог их использовать
	local hm_enabled = false
	local ke_enabled = false
	-- состояние хитмаркера (прямо здесь, без посредников)
	local hm_active    = false
	local hm_timer     = 0
	local hm_is_kill   = false
	local hm_color     = Color3.new(1, 1, 1)
	local hm_kill_color = Color3.fromRGB(220, 80, 80)
	local hm_cur_color = Color3.new(1, 1, 1)
	local hm_size      = 8
	local hm_thick     = 1.5
	local hm_duration  = 0.18
	local hm_alpha     = 0
	-- состояние kill effect
	local ke_spawn_pos  = nil
	local ke_do_spawn   = false
	-- FOV style
	local fov_thickness        = 1
	local fov_filled           = false
	local fov_filled_alpha     = 0.92
	local fov_glow             = false
	local fov_glow_color       = Library.Theme.accent
	local fov_glow_alpha       = 0.960
	local fov_outline_color    = Color3.new(0, 0, 0)
	local fov_outline_alpha    = 0.18
	local fov_outline_thick    = 0.75
	local indicator = cheat.IndicatorLibrary:new_indicator()
	cheat._aimIndicator = indicator

	do
		aimsec:Toggle({Name = "Enabled", Value = false, Flag = "aimbot_enable", Callback = function(bool)
			aimbot_enabled = bool
		end}):Keybind({Name = "Aimbot", Mode = "Hold", Key = Enum.KeyCode.E, Value = false, Flag = "aimbot_enabled_keybind", Callback = function(bool)
			aimbot_enabled_key = bool
		end})
		aimsec:Dropdown({Name = "Hitpart", Values = {"Head", "UpperTorso"}, Value = "Head", Flag = "aimbot_hitpart", Multi = false, Callback = function(str)
			aimbot_part = str
		end})
		aimsec:Dropdown({Name = "Aim mode", Values = {"Camera", "Mouse", "Silent"}, Value = "Camera", Flag = "aimbot_mode", Multi = false, Callback = function(str)
			aimbot_mode = str
		end})
		aimsec:Slider({Name = "Aim smoothness", Min = 0.01, Max = 1, Float = 0.01, Value = 0.7, Flag = "aimbot_smoothness", Suffix = "%s\194\176" --[[degree symbol (°)]], Callback = function(int)
			aimbot_smoothness = int
		end})
	end
	do
		-- ============================================================
		-- GUN MODIFICATIONS — полностью универсально, любая игра
		--
		-- Принцип работы:
		--  1. getgc() — находим ВСЕ живые таблицы в памяти Lua
		--  2. Для каждой таблицы проверяем: содержит ли она числовые
		--     поля из расширенных списков ключей (200+ вариантов названий)
		--  3. Если значение подходит под критерий — подменяем
		--  4. Дополнительно: hookmetamethod на __newindex самих таблиц —
		--     игра пытается восстановить значение → мы снова подменяем
		--  5. Remove Recoil — через уже существующий __newindex хук камеры
		-- ============================================================

		local gun_remove_bullet_drop = false
		local gun_remove_recoil      = false
		local gun_instant_bullet     = false
		local gun_instant_aim        = false
		local gun_no_spread          = false

		-- ---- Расширенные списки ключей (охватывают большинство игр) ----
		local KEYS_GRAVITY = {
			"Gravity","gravity","BulletGravity","bulletGravity","GravityScale",
			"gravityScale","gravityFactor","GravityFactor","dropRate","DropRate",
			"bulletDrop","BulletDrop","projectileGravity","ProjectileGravity",
			"g","G","grav","PhysicsGravity","physicsGravity",
		}
		local KEYS_SPREAD = {
			"Spread","spread","MaxSpread","maxSpread","MinSpread","minSpread",
			"BulletSpread","bulletSpread","HipSpread","hipSpread","AimSpread","aimSpread",
			"SpreadFactor","spreadFactor","Accuracy","accuracy","InAccuracy","inaccuracy",
			"bloomFactor","BloomFactor","Bloom","bloom","recoilSpread","RecoilSpread",
			"dispersion","Dispersion","cone","Cone","coneAngle","ConeAngle",
			"bulletDeviation","BulletDeviation","deviation","Deviation",
			"hipfireSpread","HipfireSpread","adsSpread","ADSSpread",
		}
		local KEYS_SPEED = {
			"BulletSpeed","bulletSpeed","bullet_speed","BulletVelocity","bulletVelocity",
			"MuzzleVelocity","muzzleVelocity","ProjectileSpeed","projectileSpeed",
			"InitialSpeed","initialSpeed","launchSpeed","LaunchSpeed",
			"ShootSpeed","shootSpeed","FireSpeed","fireSpeed",
			"velocity","Velocity","projectileVelocity","ProjectileVelocity",
			"bulletForce","BulletForce","impulse","Impulse",
		}
		local KEYS_AIMTIME = {
			"AimTime","aimTime","aim_time","ADSTime","adsTime",
			"AimDownSightsTime","aimDownSightsTime","ZoomTime","zoomTime",
			"ZoomInTime","zoomInTime","ZoomOutTime","zoomOutTime",
			"EquipTime","equipTime","DrawTime","drawTime","ReadyTime","readyTime",
			"AimSpeed","aimSpeed","adsSpeed","ADSSpeed","aimRate","AimRate",
			"transitionTime","TransitionTime","lerpTime","LerpTime",
		}
		local KEYS_RECOIL = {
			"Recoil","recoil","RecoilAmount","recoilAmount","RecoilPower","recoilPower",
			"RecoilStrength","recoilStrength","CameraRecoil","cameraRecoil",
			"CamRecoil","camRecoil","ViewRecoil","viewRecoil",
			"Kick","kick","KickBack","kickBack","CameraKick","cameraKick",
			"RecoilX","recoilX","RecoilY","recoilY","RecoilZ","recoilZ",
			"RecoilMin","recoilMin","RecoilMax","recoilMax",
			"RecoilUp","recoilUp","RecoilSide","recoilSide",
			"recoilVertical","recoilHorizontal","verticalRecoil","horizontalRecoil",
		}

		-- ---- Кэш уже найденных таблиц (для быстрого повторного патча) ----
		-- Ключ: таблица, Значение: набор ключей которые нашли в ней
		local found_tables = {
			gravity  = {},  -- {[tbl] = key}
			spread   = {},
			speed    = {},
			aimtime  = {},
			recoil   = {},
		}

		-- ---- Применить значение к кэшированным таблицам ----
		local function apply_cache(cache, value)
			for tbl, key in cache do
				pcall(function()
					setreadonly(tbl, false)
					tbl[key] = value
				end)
			end
		end

		-- ---- Сканировать getgc() и заполнить/обновить кэш ----
		-- Важно: раньше весь getgc проходился одним куском прямо при включении toggle,
		-- из-за этого были микрофризы. Теперь скан режется на маленькие чанки.
		local SCAN_CHUNK_SIZE = 220
		local function scan_gc(keys, cache, check, value)
			local ok, objects = pcall(getgc, true)
			if not ok or type(objects) ~= "table" then return end

			local processed = 0
			for _, v in objects do
				if type(v) == "table" and not cache[v] then
					for _, key in keys do
						local okRaw, val = pcall(rawget, v, key)
						if okRaw and check(val) then
							cache[v] = key
							pcall(function()
								setreadonly(v, false)
								v[key] = value
							end)
							break
						end
					end
				end

				processed += 1
				if processed % SCAN_CHUNK_SIZE == 0 then
					task.wait()
				end
			end
		end

		-- ---- Полный скан + применение ко всем кэшированным ----
		local scan_running = false
		local function run_patch()
			if scan_running then return end
			scan_running = true

			if gun_remove_bullet_drop then
				scan_gc(KEYS_GRAVITY, found_tables.gravity,
					function(v) return type(v)=="number" and v~=0 and math.abs(v)<2000 end, 0)
				apply_cache(found_tables.gravity, 0)
			end
			if gun_no_spread then
				scan_gc(KEYS_SPREAD, found_tables.spread,
					function(v) return type(v)=="number" and v>0 and v<1000 end, 0)
				apply_cache(found_tables.spread, 0)
			end
			if gun_instant_bullet then
				scan_gc(KEYS_SPEED, found_tables.speed,
					function(v) return type(v)=="number" and v>0 and v<500000 end, 9e8)
				apply_cache(found_tables.speed, 9e8)
			end
			if gun_instant_aim then
				scan_gc(KEYS_AIMTIME, found_tables.aimtime,
					function(v) return type(v)=="number" and v>0 and v<60 end, 0)
				apply_cache(found_tables.aimtime, 0)
			end
			if gun_remove_recoil then
				scan_gc(KEYS_RECOIL, found_tables.recoil,
					function(v) return type(v)=="number" and v ~= 0 and math.abs(v) < 10000 end, 0)
				apply_cache(found_tables.recoil, 0)
			end

			scan_running = false
		end

		-- ---- Heartbeat: быстрый re-apply кэша + редкий полный скан ----
		local accum_fast = 0   -- повторное применение к кэшу
		local accum_full = 0   -- полный скан getgc()
		game:GetService("RunService").Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
			if not (gun_remove_bullet_drop or gun_no_spread
				or gun_instant_bullet or gun_instant_aim or gun_remove_recoil) then return end

			-- Каждые 0.25с — применяем к уже найденным таблицам. Так меньше микрофризов/нагрузки.
			accum_fast += dt
			if accum_fast >= 0.25 then
				accum_fast = 0
				if gun_remove_bullet_drop then apply_cache(found_tables.gravity,  0)   end
				if gun_no_spread          then apply_cache(found_tables.spread,    0)   end
				if gun_instant_bullet     then apply_cache(found_tables.speed,     9e8) end
				if gun_instant_aim        then apply_cache(found_tables.aimtime,   0)   end
				if gun_remove_recoil      then apply_cache(found_tables.recoil,    0)   end
			end

			-- Полный getgc-скан больше НЕ запускается каждые 2 секунды: это и давало микрофризы.
			-- Новый скан делается только при включении функции / смене оружия через повторное включение toggles.
			accum_full += dt
		end))

		-- ---- Remove Recoil ----
		-- Старый вариант лочил Camera.CFrame каждый RenderStepped, из-за этого нельзя было нормально крутить камеру.
		-- Теперь recoil убирается патчем числовых параметров оружия через getgc-cache, без блокировки камеры.
		getgenv()._gun_remove_recoil = false
		getgenv()._recoil_locked_cf  = nil

		-- ---- UI toggles ----
		gunsec:Toggle({Name = "Remove Bullet Drop", Value = false, Flag = "gun_remove_bullet_drop",
			Callback = function(bool)
				gun_remove_bullet_drop = bool
				if bool then task.spawn(run_patch) end
			end})

		gunsec:Toggle({Name = "No Spread", Value = false, Flag = "gun_no_spread",
			Callback = function(bool)
				gun_no_spread = bool
				if bool then task.spawn(run_patch) end
			end})

		gunsec:Toggle({Name = "Remove Recoil", Value = false, Flag = "gun_remove_recoil",
			Callback = function(bool)
				gun_remove_recoil = bool
				getgenv()._gun_remove_recoil = bool
				getgenv()._recoil_locked_cf  = nil
				if bool then task.spawn(run_patch) end
			end})

		gunsec:Toggle({Name = "Instant Bullet", Value = false, Flag = "gun_instant_bullet",
			Callback = function(bool)
				gun_instant_bullet = bool
				if bool then task.spawn(run_patch) end
			end})

		gunsec:Toggle({Name = "Instant Aim", Value = false, Flag = "gun_instant_aim",
			Callback = function(bool)
				gun_instant_aim = bool
				if bool then task.spawn(run_patch) end
			end})

	end
	do
		chksec:Dropdown({Name = "Checks", Values = {"Team check", "Dead check", "Distance check"}, Value = {}, Flag = "aimbot_checks", Multi = true, Callback = function(tbl)
			local funny = {
				["Team check"] = "team_check",
				["Dead check"] = "dead_check",
				["Distance check"] = "dist_check"
			}
			local uhh = {}
			for flag_text, esp_var in funny do
				uhh[esp_var] = false
			end
			for flag_text, esp_var in funny do
				for _, check_name in tbl do
					if (check_name ~= flag_text or uhh[esp_var]) then
						continue
					end
					uhh[esp_var] = true
				end
			end
			aimbot_team_check = uhh["team_check"]
			aimbot_dead_check = uhh["dead_check"]
			aimbot_dist_check = uhh["dist_check"]
		end})
		chksec:Slider({Name = "Max distance", Min = 0, Max = 5000, Float = 100, Value = 600, Flag = "aimbot_max_distance", Callback = function(int)
			aimbot_max_distance = int
		end})

		-- FOV settings are now inside the Aimbot section and live under the FOV toggle.
		local fov_controls = {}
		local function update_fov_controls_visibility()
			for _, obj in fov_controls do
				if obj and obj.SetVisibility then
					obj:SetVisibility(fov_show)
				end
			end
		end

		chksec:Toggle({Name = "FOV", Value = false, Flag = "fov_enabled", Callback = function(bool)
			fov_show = bool
			update_fov_controls_visibility()
		end}):Colorpicker({Name = "FOV Color", Value = Color3.new(1, 1, 1), Usealpha = false, Flag = "fov_color", Callback = function(color)
			fov_color = color.c
		end})

		fov_controls.size = chksec:Slider({Name = "FOV size", Min = 0, Max = 180, Float = 1, Value = 10, Flag = "aimbot_fov_size", Suffix = "%s\194\176" --[[degree symbol (°)]], Callback = function(int)
			fov_size = int
		end})
		fov_controls.thickness = chksec:Slider({Name = "FOV thickness", Min = 1, Max = 6, Float = 1, Value = 1, Flag = "fov_thickness", Callback = function(v)
			fov_thickness = v
		end})
		local fov_glow_toggle = chksec:Toggle({Name = "FOV glow", Value = false, Flag = "fov_glow", Callback = function(bool)
			fov_glow = bool
		end})
		fov_glow_toggle:Colorpicker({Name = "FOV glow color", Default = fov_glow_color, Value = fov_glow_color, Usealpha = false, Flag = "fov_glow_color", Callback = function(color)
			fov_glow_color = color.c
		end})
		fov_controls.glow = fov_glow_toggle
		fov_controls.outline = chksec:Toggle({Name = "FOV outline", Value = false, Flag = "fov_outline_tog", Callback = function(bool)
			fov_outline = bool
		end})
		fov_controls.outline_thickness = chksec:Slider({Name = "Outline thickness", Min = 0.5, Max = 2, Float = 0.25, Value = 0.75, Flag = "fov_outline_thick", Callback = function(v)
			fov_outline_thick = v
		end})

		update_fov_controls_visibility()
	end
	do
		local hit_logs, hit_logs_duration = false, 5
		local hit_logs_position = "Center"
		local hit_logs_color = Library.Theme.accent
		local hit_chams, hit_skeletons = false, false

		-- Custom hitlogs renderer. Positions: Center / Left / Top / Top left.
		local HitLogTweenService = game:GetService("TweenService")
		local CoreGuiHitLogs = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
		local hitLogsGui = Instance.new("ScreenGui")
		hitLogsGui.Name = "FrostHitLogsGui"
		hitLogsGui.ResetOnSpawn = false
		hitLogsGui.IgnoreGuiInset = true
		hitLogsGui.DisplayOrder = 9998
		hitLogsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		pcall(function() hitLogsGui.Parent = CoreGuiHitLogs end)
		if not hitLogsGui.Parent then
			hitLogsGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
		end

		local hitLogsHolder = Instance.new("Frame", hitLogsGui)
		hitLogsHolder.Name = "Holder"
		hitLogsHolder.BackgroundTransparency = 1
		hitLogsHolder.BorderSizePixel = 0
		hitLogsHolder.Size = UDim2.fromOffset(900, 260)
		hitLogsHolder.Position = UDim2.new(0.5, 0, 0.62, 0)
		hitLogsHolder.AnchorPoint = Vector2.new(0.5, 0)

		local hitLogsLayout = Instance.new("UIListLayout", hitLogsHolder)
		hitLogsLayout.FillDirection = Enum.FillDirection.Vertical
		hitLogsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		hitLogsLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		hitLogsLayout.SortOrder = Enum.SortOrder.LayoutOrder
		hitLogsLayout.Padding = UDim.new(0, 3)

		local activeHitLogs = {}
		local hitlog_order = 0
		local HITLOG_ROW_HEIGHT = 22

		local function update_hitlogs_position()
			if hit_logs_position == "Center" then
				hitLogsHolder.AnchorPoint = Vector2.new(0.5, 0)
				hitLogsHolder.Position = UDim2.new(0.5, 0, 0.62, 0)
				hitLogsHolder.Size = UDim2.fromOffset(900, 260)
				hitLogsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			elseif hit_logs_position == "Left" then
				hitLogsHolder.AnchorPoint = Vector2.new(0, 0.5)
				hitLogsHolder.Position = UDim2.new(0, 18, 0.5, 0)
				hitLogsHolder.Size = UDim2.fromOffset(620, 260)
				hitLogsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			elseif hit_logs_position == "Top" then
				hitLogsHolder.AnchorPoint = Vector2.new(0.5, 0)
				hitLogsHolder.Position = UDim2.new(0.5, 0, 0, 78)
				hitLogsHolder.Size = UDim2.fromOffset(900, 260)
				hitLogsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			else -- Top left
				hitLogsHolder.AnchorPoint = Vector2.new(0, 0)
				hitLogsHolder.Position = UDim2.new(0, 18, 0, 78)
				hitLogsHolder.Size = UDim2.fromOffset(520, 260)
				hitLogsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			end

			for _, label in activeHitLogs do
				if label and label.Parent then
					label.TextXAlignment = (hit_logs_position == "Left" or hit_logs_position == "Top left") and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
					label.Size = UDim2.new(1, 0, 0, HITLOG_ROW_HEIGHT)
				end
			end
		end

		local function show_hitlog(text, duration)
			duration = math.max(0.1, tonumber(duration) or 5)

			-- Top left uses the menu's built-in notification system.
			-- Left is a separate center-left position, so it is visually different.
			if hit_logs_position == "Top left" then
				Library.Notification(text, duration, hit_logs_color)
				return
			end

			local label = Instance.new("TextLabel")
			hitlog_order += 1
			label.Name = "HitLog"
			label.LayoutOrder = -hitlog_order
			label.Parent = hitLogsHolder
			label.BackgroundTransparency = 1
			label.BorderSizePixel = 0
			label.Size = UDim2.new(1, 0, 0, HITLOG_ROW_HEIGHT)
			local hitlogFont = Fonts and Fonts.Get and Fonts.Get("TahomaXP") or nil
			if hitlogFont then
				label.FontFace = hitlogFont
			else
				label.Font = Enum.Font.Code
			end
			label.TextSize = Library.FontSize or 12
			label.TextColor3 = Color3.new(1, 1, 1)
			label.TextStrokeColor3 = Color3.new(0, 0, 0)
			label.TextStrokeTransparency = 1
			label.TextTransparency = 1
			label.RichText = true
			label.Text = text
			label.TextXAlignment = (hit_logs_position == "Left" or hit_logs_position == "Top left") and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
			label.TextYAlignment = Enum.TextYAlignment.Center
			label.ZIndex = 10

			table.insert(activeHitLogs, label)
			update_hitlogs_position()
			label.Size = UDim2.new(1, 0, 0, 0)

			HitLogTweenService:Create(label, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextTransparency = 0,
				TextStrokeTransparency = 0.35,
				Size = UDim2.new(1, 0, 0, HITLOG_ROW_HEIGHT)
			}):Play()
			task.delay(duration, function()
				if not label or not label.Parent then return end
				local tween = HitLogTweenService:Create(label, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1, TextStrokeTransparency = 1})
				tween:Play()
				tween.Completed:Wait()
				for i, v in activeHitLogs do
					if v == label then
						table.remove(activeHitLogs, i)
						break
					end
				end
				label:Destroy()
			end)
		end

		local function rich_escape(text)
			return tostring(text):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"):gsub("'", "&apos;")
		end

		local function color_to_rgb(color)
			local r = color.R or color.r or 1
			local g = color.G or color.g or 1
			local b = color.B or color.b or 1
			return math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
		end

		local function build_hitlog_text(player_name, part_name, damage, health)
			local r, g, b = color_to_rgb(hit_logs_color)
			local white_open = '<font color="rgb(255, 255, 255)">'
			local white_close = '</font>'
			local accent = string.format('<font color="rgb(%s, %s, %s)">frost.vip</font>', r, g, b)

			return string.format(
				'%s[%s%s%s] Hit %s in the %s for %s damage (%s health remaining)%s',
				white_open,
				white_close,
				accent,
				white_open,
				rich_escape(player_name),
				rich_escape(part_name),
				rich_escape(damage),
				rich_escape(health),
				white_close
			)
		end

		hitsec:Toggle({Name = "Hitlogs", Value = false, Flag = "hit_logs", Callback = function(bool)
			hit_logs = bool
		end}):Colorpicker({Name = "Hitlog Color", Default = hit_logs_color, Value = hit_logs_color, Usealpha = false, Flag = "hit_logs_color", Callback = function(color)
			hit_logs_color = color.c
		end})
		hitsec:Dropdown({Name = "Hitlog position", Values = {"Center", "Left", "Top", "Top left"}, Value = "Center", Flag = "hit_logs_position", Multi = false, Callback = function(value)
			hit_logs_position = value or "Center"
			update_hitlogs_position()
		end})
		hitsec:Slider({Name = "Log duration", Min = 0, Max = 10, Float = 0.1, Value = 5, Flag = "hit_logs_duration", Suffix = "%ss", Callback = function(int)
			hit_logs_duration = int
		end})
		hitsec:Button({Name = "Test hitlog", Callback = function()
			show_hitlog(build_hitlog_text("test_player", aimbot_part or "Head", 42, 58), hit_logs_duration)
		end})

		update_hitlogs_position()

		hit_detection = function(player, new_health, old_health)
			if not target_player or player ~= target_player then
				return
			end
			if new_health >= old_health then
				return
			end
			-- hitmarker
			if hm_enabled then
				hm_active    = true
				hm_timer     = 0
				hm_is_kill   = (new_health <= 0)
				hm_cur_color = hm_is_kill and hm_kill_color or hm_color
			end
			-- kill effect
			if ke_enabled and (new_health <= 0) and target_part then
				local pos3d = _WorldToViewportPoint(Camera, target_part.Position)
				ke_spawn_pos = Vector2.new(pos3d.X, pos3d.Y)
				ke_do_spawn  = true
			end
			if not hit_logs then return end
			show_hitlog(build_hitlog_text(
				player.Name,
				aimbot_part or "Head",
				math.floor(old_health - new_health),
				math.floor(new_health)
			), hit_logs_duration)
		end
	end
	
	do
		chksec:Dropdown({Name = "Silent mode", Values = {
			"Raycast",
			"FindPartOnRayWithIgnoreList",
			"FindPartOnRayWithWhitelist",
			"FindPartOnRay",
			"ScreenPointToRay",
			"ViewportPointToRay",
			"Mouse",
			"Ray"
		}, Value = {}, Flag = "aimbot_silent_mode", Multi = true, Callback = function(tbl)
			for i in silent_methods do
				silent_methods[i] = false
			end
			for _, value in tbl do
				silent_methods[value] = true
			end
		end})
		chksec:Toggle({Name = "Projection override", Value = false, Flag = "silent_projectionoverride", Callback = function(bool)
			silent_projectionoverride = bool
		end})
		chksec:Toggle({Name = "Wallbang", Value = false, Flag = "silent_wallbang", Callback = function(bool)
			silent_wallbang = bool
		end})
		chksec:Toggle({Name = "Magic bullet (UNSTABLE)", Value = false, Flag = "silent_magicbullet", Callback = function(bool)
			silent_magicbullet = bool
		end})
	end

	-- ====== FOV через Frame + UICorner (идеальные круги) ======
	local CoreGuiFov = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
	local fovGui = Instance.new("ScreenGui")
	fovGui.Name           = "FOVGui"
	fovGui.ResetOnSpawn   = false
	fovGui.DisplayOrder   = 8
	fovGui.IgnoreGuiInset = true
	fovGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function() fovGui.Parent = CoreGuiFov end)
	if not fovGui.Parent then
		fovGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	end

	-- FOV glow: dispersed blur-style glow.
	-- Instead of many thin visible circles, use fewer thicker very-transparent strokes.
	-- They overlap into a softer glow and the outer rings fade out before the hard edge.
	local GLOW_LAYERS           = 60
	local GLOW_RADIUS_PX        = 20
	-- This is the minimum transparency near the main FOV circle. Higher = softer/darker glow.
	local GLOW_INTENSITY        = 0.960
	local GLOW_STROKE_THICKNESS = 2.1

	-- создаём один Frame-кольцо с UICorner + UIStroke
	local function createRingFrame(diameter, thickness, color, transparency)
		local f = Instance.new("Frame", fovGui)
		f.Size                  = UDim2.fromOffset(diameter, diameter)
		f.AnchorPoint           = Vector2.new(0.5, 0.5)
		f.BackgroundTransparency = 1
		f.BorderSizePixel       = 0
		local c = Instance.new("UICorner", f)
		c.CornerRadius = UDim.new(1, 0)
		local s = Instance.new("UIStroke", f)
		s.Color           = color
		s.Thickness       = thickness
		s.Transparency    = transparency
		s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		return f
	end

	-- таблицы колец: glow внешний, outline, main, outline внутренний
	local fovRings      = {}  -- {frame, radiusOffset}
	local fovMainRing   = nil
	local fovOutRing1   = nil  -- снаружи
	local fovOutRing2   = nil  -- внутри
	local fovGlowRings  = {}

	-- glow слои — внешние + внутренние, плавное затухание
	for i = 1, GLOW_LAYERS do
		local t      = i / GLOW_LAYERS
		-- Soft falloff. The last part is forced invisible so there is no visible final circle.
		local smooth = t * t * (3 - 2 * t)
		local alpha  = (1 - smooth) ^ 2.35
		local transp = math.clamp(GLOW_INTENSITY + (1 - GLOW_INTENSITY) * (1 - alpha), 0, 1)
		if t > 0.90 then
			local edge = (t - 0.90) / 0.10
			transp = math.clamp(transp + edge * edge * 0.08, 0, 1)
		end
		if t > 0.965 then transp = 1 end
		local offset = t * GLOW_RADIUS_PX
		local fo = createRingFrame(1, GLOW_STROKE_THICKNESS, Color3.new(1,1,1), transp)
		fo.Visible = false
		fovGlowRings[#fovGlowRings+1] = {frame=fo, offset=offset, baseTransparency=transp}
		local fi = createRingFrame(1, GLOW_STROKE_THICKNESS, Color3.new(1,1,1), transp)
		fi.Visible = false
		fovGlowRings[#fovGlowRings+1] = {frame=fi, offset=-offset, baseTransparency=transp}
	end

	-- основное кольцо (тонкий лиловый как на скрине 2)
	fovMainRing = createRingFrame(1, 1, Color3.fromRGB(200, 170, 255), 0)
	fovMainRing.Visible = false
	fovMainRing.ZIndex = 3

	-- outline кольца: одно снаружи + одно внутри, под основным FOV кольцом
	fovOutRing1 = createRingFrame(1, 1, Color3.new(0,0,0), fov_outline_alpha)
	fovOutRing1.Visible = false
	fovOutRing1.ZIndex = 2
	fovOutRing2 = createRingFrame(1, 1, Color3.new(0,0,0), fov_outline_alpha)
	fovOutRing2.Visible = false
	fovOutRing2.ZIndex = 2

	for _, g in ipairs(fovGlowRings) do
		g.frame.ZIndex = 1
	end

	cheat.utility.new_heartbeat(LPH_NO_VIRTUALIZE(function()
		local indtxt = ""
		if aimbot_enabled then
			local viewportsize = Camera.ViewportSize
			local new_fov_size = (viewportsize.X * (fov_size / Camera.FieldOfView)) / 2
			target_part, target_player, target_collider = get_closest_target(
				new_fov_size,
				aimbot_part or "Head",
				aimbot_team_check,
				aimbot_dead_check,
				aimbot_dist_check,
				aimbot_max_distance
			)

			if indicator.followpart then indicator.target_part = target_part end

			if target_part and target_collider then
				indtxt = target_player.Name
			end
		else
			target_part, target_player, target_collider = nil, nil, nil
		end

		indicator.text = indtxt
	end))
	cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function()
		local mpos        = UserInputService:GetMouseLocation()
		local viewportsize = Camera.ViewportSize
		local new_fov_size = (viewportsize.X * (fov_size / Camera.FieldOfView)) / 2
		local diameter     = new_fov_size * 2
		local center       = UDim2.fromOffset(mpos.X, mpos.Y)

		-- основное кольцо
		fovMainRing.Visible  = fov_show
		fovMainRing.Position = center
		fovMainRing.Size     = UDim2.fromOffset(diameter, diameter)
		local ms = fovMainRing:FindFirstChildOfClass("UIStroke")
		if ms then
			ms.Color     = fov_color
			ms.Thickness = fov_thickness
		end

		-- outline: тонкая обводка с двух сторон FOV-линии (снаружи и внутри)
		local showOut = fov_show and fov_outline
		local outlineThickness = math.clamp(fov_outline_thick or 0.75, 0.5, 2)
		-- Offset is half of both strokes so outline touches the FOV line instead of sitting away from it.
		local outlineOffset = math.max(0.5, ((fov_thickness or 1) + outlineThickness) * 0.5)

		fovOutRing1.Visible  = showOut
		fovOutRing2.Visible  = showOut
		fovOutRing1.Position = center
		fovOutRing2.Position = center
		fovOutRing1.Size     = UDim2.fromOffset(diameter + outlineOffset * 2, diameter + outlineOffset * 2)
		fovOutRing2.Size     = UDim2.fromOffset(math.max(2, diameter - outlineOffset * 2), math.max(2, diameter - outlineOffset * 2))

		local os1 = fovOutRing1:FindFirstChildOfClass("UIStroke")
		if os1 then
			os1.Color = fov_outline_color
			os1.Thickness = outlineThickness
			os1.Transparency = fov_outline_alpha
		end
		local os2 = fovOutRing2:FindFirstChildOfClass("UIStroke")
		if os2 then
			os2.Color = fov_outline_color
			os2.Thickness = outlineThickness
			os2.Transparency = fov_outline_alpha
		end

		-- glow: отдельный цвет + много тонких колец вокруг FOV
		local showGlow = fov_show and fov_glow
		for _, g in ipairs(fovGlowRings) do
			g.frame.Visible  = showGlow and g.baseTransparency < 0.995
			local d = math.max(2, diameter + g.offset * 2)
			g.frame.Position = center
			g.frame.Size     = UDim2.fromOffset(d, d)
			local gs = g.frame:FindFirstChildOfClass("UIStroke")
			if gs then
				gs.Color = fov_glow_color
				gs.Transparency = math.clamp(g.baseTransparency + (fov_glow_alpha - 0.960), 0, 1)
			end
		end
		if aimbot_enabled and aimbot_enabled_key and target_part and target_collider then
			local new_pos = target_part.Position
			if aimbot_mode == "Mouse" then
				local pos = _WorldToViewportPoint(Camera, new_pos)
				local mpos = UserInputService:GetMouseLocation()
				mousemoverel(math.round((pos.X - mpos.X) * aimbot_smoothness), math.round((pos.Y - mpos.Y) * aimbot_smoothness))
			end
			if aimbot_mode == "Camera" then
				Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, new_pos), aimbot_smoothness)
			end
		end
	end))
end

-- ============================================================
--  TARGET INFO панель + HITMARKERS + KILL EFFECT
-- ============================================================
do
	local tisec  = ui.sections.target_info
	local hmsec  = ui.sections.hitmarkers
	local Players = game:GetService("Players")
	local TargetInfoTweenService = game:GetService("TweenService")

	-- ---- Target Info (ScreenGui, Active=false — не перехватывает клики) ----
	local ti_enabled   = false
	local ti_show_hp   = true
	local ti_show_tool = true
	local ti_line_glow = false
	local ti_bar_color = Library.Theme.accent  -- по дефолту цвет Accent меню, как у hitlogs

	local W, H = 260, 90
	local TI_BAR_X = 82
	local TI_BAR_W = W - TI_BAR_X - 8
	local ti_x = 12
	local ti_y = Camera.ViewportSize.Y - H - 12

	local TahomaXP = Fonts and Fonts.Get("TahomaXP") or nil
	local CoreGuiRef = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")

	local tiGui = Instance.new("ScreenGui")
	tiGui.Name            = "TIGui"
	tiGui.ResetOnSpawn    = false
	tiGui.DisplayOrder    = 9
	tiGui.IgnoreGuiInset  = true
	pcall(function() tiGui.Parent = CoreGuiRef end)
	if not tiGui.Parent then tiGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

	-- Главный фрейм (не Active — клики проходят насквозь)
	local tiCard = Instance.new("Frame", tiGui)
	tiCard.Size             = UDim2.fromOffset(W, H)
	tiCard.Position         = UDim2.fromOffset(ti_x, ti_y)
	tiCard.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	tiCard.BorderSizePixel  = 0
	tiCard.Visible          = false
	tiCard.Active           = false

	-- Hidden config flags: save/load Target Info position with each config.
	Library.Flags["ti_pos_x"] = Library.Flags["ti_pos_x"] or ti_x
	Library.Flags["ti_pos_y"] = Library.Flags["ti_pos_y"] or ti_y
	Library.SetFlags["ti_pos_x"] = function(value)
		ti_x = tonumber(value) or ti_x
		tiCard.Position = UDim2.fromOffset(ti_x, ti_y)
	end
	Library.SetFlags["ti_pos_y"] = function(value)
		ti_y = tonumber(value) or ti_y
		tiCard.Position = UDim2.fromOffset(ti_x, ti_y)
	end

	Instance.new("UICorner", tiCard).CornerRadius = UDim.new(0, 4)
	local s1 = Instance.new("UIStroke", tiCard)
	s1.Color = Color3.fromRGB(51,51,51); s1.Thickness = 1
	s1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	-- accent линия сверху — берёт цвет из темы библиотеки
	local tiAccent = Instance.new("Frame", tiCard)
	tiAccent.Size             = UDim2.new(1,0,0,2)
	tiAccent.BackgroundColor3 = Library and Library.Theme and Library.Theme["Accent"] or Color3.fromRGB(176,176,209)
	tiAccent.BorderSizePixel  = 0
	tiAccent.Active           = false
	tiAccent.ZIndex           = 10
	Instance.new("UICorner", tiAccent).CornerRadius = UDim.new(0,4)

	-- glow для accent-линии Target Info — тот же паттерн, что у watermark/keybinds Liner Glow
	local tiAccentGlow = Instance.new("ImageLabel", tiAccent)
	tiAccentGlow.Name = "AccentGlow"
	tiAccentGlow.ImageColor3 = tiAccent.BackgroundColor3
	tiAccentGlow.ScaleType = Enum.ScaleType.Slice
	tiAccentGlow.ImageTransparency = 0.8
	tiAccentGlow.Size = UDim2.new(1, 25, 1, 25)
	tiAccentGlow.AnchorPoint = Vector2.new(0.5, 0.5)
	tiAccentGlow.Image = "http://www.roblox.com/asset/?id=18245826428"
	tiAccentGlow.BackgroundTransparency = 1
	tiAccentGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
	tiAccentGlow.BorderSizePixel = 0
	tiAccentGlow.SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
	tiAccentGlow.Visible = false
	tiAccentGlow.Active = false
	tiAccentGlow.ZIndex = 1

	-- аватарка
	local tiAva = Instance.new("ImageLabel", tiCard)
	tiAva.Size             = UDim2.fromOffset(68, 68)
	tiAva.Position         = UDim2.fromOffset(4, 10)
	tiAva.BackgroundColor3 = Color3.fromRGB(19,19,19)
	tiAva.BorderSizePixel  = 0
	tiAva.Image            = ""
	tiAva.Active           = false
	Instance.new("UICorner", tiAva).CornerRadius = UDim.new(0,3)

	-- разделитель
	local tiDiv = Instance.new("Frame", tiCard)
	tiDiv.Size             = UDim2.fromOffset(1, H-12)
	tiDiv.Position         = UDim2.fromOffset(76, 6)
	tiDiv.BackgroundColor3 = Color3.fromRGB(51,51,51)
	tiDiv.BorderSizePixel  = 0
	tiDiv.Active           = false

	local function mkFont(o)
		if TahomaXP then o.FontFace = TahomaXP else o.Font = Enum.Font.Code end
	end

	local function mkLbl(txt, yOff)
		local l = Instance.new("TextLabel", tiCard)
		l.Size = UDim2.fromOffset(60,14); l.Position = UDim2.fromOffset(82, yOff)
		l.BackgroundTransparency = 1; l.Text = txt; l.TextSize = 12
		l.TextColor3 = Color3.fromRGB(134,134,134)
		l.TextXAlignment = Enum.TextXAlignment.Left; l.Active = false; mkFont(l)
		return l
	end
	local function mkVal(txt, yOff)
		local v = Instance.new("TextLabel", tiCard)
		v.Size = UDim2.fromOffset(160,14); v.Position = UDim2.fromOffset(82, yOff)
		v.BackgroundTransparency = 1; v.Text = txt; v.TextSize = 12
		v.TextColor3 = Color3.fromRGB(208,207,227)
		v.TextXAlignment = Enum.TextXAlignment.Right; v.Active = false; mkFont(v)
		return v
	end

	mkLbl("user", 10); local tiVUser = mkVal("-",    10)
	mkLbl("hp",   26); local tiVHp   = mkVal("-",    26)
	mkLbl("tool", 42); local tiVTool = mkVal("none", 42)

	-- hp бар
	local tiBarBg = Instance.new("Frame", tiCard)
	tiBarBg.Size             = UDim2.fromOffset(TI_BAR_W, 12)
	tiBarBg.Position         = UDim2.fromOffset(TI_BAR_X, H-18)
	tiBarBg.BackgroundColor3 = Color3.fromRGB(39,39,39)
	tiBarBg.BorderSizePixel  = 0; tiBarBg.Active = false
	Instance.new("UICorner", tiBarBg).CornerRadius = UDim.new(0,2)

	local tiBarFill = Instance.new("Frame", tiBarBg)
	tiBarFill.Size             = UDim2.fromOffset(0,12)
	tiBarFill.BackgroundColor3 = Color3.fromRGB(0,210,60)
	tiBarFill.BorderSizePixel  = 0; tiBarFill.Active = false
	Instance.new("UICorner", tiBarFill).CornerRadius = UDim.new(0,2)

	local tiBarTxt = Instance.new("TextLabel", tiBarBg)
	tiBarTxt.Size = UDim2.fromScale(1,1); tiBarTxt.BackgroundTransparency = 1
	tiBarTxt.Text = ""; tiBarTxt.TextSize = 9
	tiBarTxt.TextColor3 = Color3.fromRGB(20,20,20); tiBarTxt.Active = false; mkFont(tiBarTxt)

	-- перетаскивание через IsMouseButtonPressed (не через события GUI)
	local tiDrag = false
	local tiDS   = Vector2.new()
	local tiDO   = Vector2.new()
	local tiWas  = false
	local lastAva = nil

	-- Smooth data changes for Target Info
	local tiTextCache = {}
	local tiTextToken = {}
	local tiLastBarRatio = -1
	local tiTweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local function tiSetText(label, text)
		text = tostring(text)
		if tiTextCache[label] == text then return end
		tiTextCache[label] = text
		tiTextToken[label] = (tiTextToken[label] or 0) + 1
		local token = tiTextToken[label]

		task.spawn(function()
			if not label or not label.Parent then return end
			local out = TargetInfoTweenService:Create(label, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
			out:Play()
			out.Completed:Wait()
			if tiTextToken[label] ~= token or not label.Parent then return end
			label.Text = text
			TargetInfoTweenService:Create(label, tiTweenInfo, {TextTransparency = 0}):Play()
		end)
	end

	local function tiSetBar(ratio)
		ratio = math.clamp(ratio or 0, 0, 1)
		if math.abs(tiLastBarRatio - ratio) < 0.005 then return end
		tiLastBarRatio = ratio
		TargetInfoTweenService:Create(tiBarFill, tiTweenInfo, {
			Size = UDim2.fromOffset(math.floor(TI_BAR_W * ratio), 12),
			BackgroundColor3 = ti_bar_color
		}):Play()
	end

	cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function()
		local mp   = UserInputService:GetMouseLocation()
		local down = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)

		if down and not tiWas and ti_enabled then
			local ap = tiCard.AbsolutePosition
			local as = tiCard.AbsoluteSize
			if mp.X>=ap.X and mp.X<=ap.X+as.X and mp.Y>=ap.Y and mp.Y<=ap.Y+as.Y then
				tiDrag = true; tiDS = mp
				tiDO   = Vector2.new(tiCard.Position.X.Offset, tiCard.Position.Y.Offset)
			end
		end
		if not down then tiDrag = false end
		if tiDrag then
			local d = mp - tiDS
			ti_x = tiDO.X + d.X
			ti_y = tiDO.Y + d.Y
			tiCard.Position = UDim2.fromOffset(ti_x, ti_y)
			Library.Flags["ti_pos_x"] = math.floor(ti_x + 0.5)
			Library.Flags["ti_pos_y"] = math.floor(ti_y + 0.5)
		end
		tiWas = down

		-- обновляем цвет accent от темы
		if Library and Library.Theme then
			tiAccent.BackgroundColor3 = Library.Theme["Accent"] or Color3.fromRGB(176,176,209)
		end

		tiAccentGlow.ImageColor3 = tiAccent.BackgroundColor3
		tiAccentGlow.Visible = ti_line_glow and tiCard.Visible

		local menuOpen = false
		pcall(function()
			menuOpen = ui and ui.window and ui.window.__new and ui.window.__new.IsOpen or false
		end)

		-- Когда меню открыто — показываем preview с фейковыми данными, чтобы удобно настраивать Target Info.
		-- Когда меню закрыто — preview пропадает, и Target Info показывается только при настоящем target_player.
		local hasRealTarget = target_player ~= nil
		local previewMode = menuOpen
		tiCard.Visible = ti_enabled and (previewMode or hasRealTarget)
		tiAccentGlow.Visible = ti_line_glow and tiCard.Visible
		if not tiCard.Visible then return end

		if previewMode then
			lastAva = nil
			tiAva.Visible = true
			tiAva.Image = ""
			tiSetText(tiVUser, "preview")
			if ti_show_hp then
				tiSetText(tiVHp, "78/100")
				tiSetText(tiBarTxt, "78/100")
				tiSetBar(0.78)
			else
				tiSetText(tiVHp, "-")
				tiSetText(tiBarTxt, "")
				tiSetBar(0)
			end
			tiSetText(tiVTool, ti_show_tool and "weapon" or "none")
			return
		end

		tiSetText(tiVUser, target_player.Name)
		tiAva.Visible = true

		if lastAva ~= target_player then
			lastAva = target_player; tiAva.Image = ""
			task.spawn(function()
				local ok, img = pcall(function()
					return Players:GetUserThumbnailAsync(target_player.UserId,
						Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
				end)
				if ok and type(img)=="string" and lastAva==target_player then
					pcall(function() tiAva.Image = img end)
				end
			end)
		end

		if not target_player then return end

		local char = target_player.Character
		local hum  = char and char:FindFirstChildOfClass("Humanoid")
		if hum and ti_show_hp then
			local hp    = math.floor(hum.Health)
			local maxhp = math.floor(math.max(hum.MaxHealth,1))
			local ratio = math.clamp(hum.Health/maxhp, 0, 1)
			local str   = hp.."/"..maxhp
			tiSetText(tiVHp, str); tiSetText(tiBarTxt, str)
			tiSetBar(ratio)
		else
			tiSetText(tiVHp, "-")
			tiSetText(tiBarTxt, "")
			tiSetBar(0)
		end
		if char and ti_show_tool then
			local tool = char:FindFirstChildOfClass("Tool")
			tiSetText(tiVTool, tool and tool.Name or "none")
		else
			tiSetText(tiVTool, "none")
		end
	end))

	-- Target Info UI
	tisec:Toggle({Name = "Enabled", Value = false, Flag = "ti_enabled", Callback = function(bool)
		ti_enabled = bool
	end})
	tisec:Toggle({Name = "Line glow", Value = false, Flag = "ti_line_glow", Callback = function(bool)
		ti_line_glow = bool
	end})
	tisec:Toggle({Name = "Show HP bar", Value = true, Flag = "ti_show_hp", Callback = function(bool)
		ti_show_hp = bool
	end}):Colorpicker({Name = "HP bar color", Default = ti_bar_color, Value = ti_bar_color, Usealpha = false, Flag = "ti_bar_color", Callback = function(color)
		ti_bar_color = color.c
		TargetInfoTweenService:Create(tiBarFill, tiTweenInfo, {BackgroundColor3 = ti_bar_color}):Play()
	end})
	tisec:Toggle({Name = "Show tool", Value = true, Flag = "ti_show_tool", Callback = function(bool)
		ti_show_tool = bool
	end})

	-- ---- HITMARKERS ----
	-- (hm_enabled, hm_color и др. уже объявлены выше как upvalue)

	-- 4 линии хитмаркера
	local hmLines = {}
	local hmZero  = Vector2.new(0,0)
	for i = 1, 4 do
		hmLines[i] = cheat.utility.new_drawing("Line", {
			Visible   = false,
			Color     = hm_color,
			Thickness = hm_thick,
			ZIndex    = 10,
			From      = hmZero,
			To        = hmZero,
		})
	end

	cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
		if not hm_enabled or not hm_active then
			for i = 1, 4 do hmLines[i].Visible = false end
			return
		end

		hm_timer = hm_timer + delta
		local t   = math.min(hm_timer / hm_duration, 1)
		local fade = t

		local center = Camera.ViewportSize / 2
		local gap    = 3 + hm_size * 0.3 * t
		local sz     = hm_size * (1 - t * 0.3)

		local dirs = {
			Vector2.new( 1,  1), Vector2.new(-1,  1),
			Vector2.new(-1, -1), Vector2.new( 1, -1),
		}
		for i, d in ipairs(dirs) do
			hmLines[i].From         = center + d * gap
			hmLines[i].To           = center + d * (gap + sz)
			hmLines[i].Color        = hm_cur_color
			hmLines[i].Thickness    = hm_thick
			hmLines[i].Transparency = fade * 0.95
			hmLines[i].Visible      = true
		end

		if t >= 1 then
			hm_active = false
		end
	end))

	-- Kill Effect (белые светящиеся частицы из Drawing Circle)
	ke_enabled  = false
	local KE_COUNT    = 18
	local ke_color    = Color3.new(1, 1, 1)
	local ke_size_min = 3
	local ke_size_max = 10
	local ke_speed    = 80
	local ke_life_min = 0.4
	local ke_life_max = 0.8
	local ke_particles = {}
	for i = 1, KE_COUNT do
		ke_particles[i] = {
			obj = cheat.utility.new_drawing("Circle", {
				Filled      = true,
				Visible     = false,
				Color       = Color3.new(1, 1, 1),
				ZIndex      = 9,
				Radius      = 4,
				Transparency = 1,
			}),
			alive = false,
			x=0, y=0, vx=0, vy=0,
			life=0, maxLife=0, size=0,
		}
	end

	local function spawnKillEffect(screenPos)
		if not ke_enabled then return end
		for _, p in ke_particles do
			if not p.alive then
				local angle   = math.random() * math.pi * 2
				local speed   = ke_speed * (0.5 + math.random() * 0.8)
				p.x       = screenPos.X
				p.y       = screenPos.Y
				p.vx      = math.cos(angle) * speed
				p.vy      = math.sin(angle) * speed - 60
				p.maxLife = ke_life_min + math.random() * (ke_life_max - ke_life_min)
				p.life    = 0
				p.size    = ke_size_min + math.random() * (ke_size_max - ke_size_min)
				p.alive   = true
			end
		end
	end

	cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
		-- обрабатываем запрос на спавн частиц из hit_detection
		if ke_do_spawn and ke_spawn_pos then
			spawnKillEffect(ke_spawn_pos)
			ke_do_spawn = false
			ke_spawn_pos = nil
		end
		for _, p in ke_particles do
			if p.alive then
				p.life = p.life + delta
				local t = p.life / p.maxLife
				if t >= 1 then
					p.alive    = false
					p.obj.Visible = false
				else
					p.x = p.x + p.vx * delta
					p.y = p.y + p.vy * delta
					p.vy = p.vy + 120 * delta  -- гравитация
					p.obj.Position    = Vector2.new(p.x, p.y)
					p.obj.Radius      = p.size * (1 - t * 0.5)
					p.obj.Color       = ke_color
					p.obj.Transparency = t * 0.95
					p.obj.Visible     = true
				end
			else
				p.obj.Visible = false
			end
		end
	end))

	-- Hitmarker UI
	do
		local sec = hmsec
		-- ---- Hitmarker (крестик при попадании) ----
		sec:Toggle({Name = "Hitmarker", Value = false, Flag = "hm_enabled", Callback = function(bool)
			hm_enabled = bool
		end}):Colorpicker({Name = "Hitmarker color", Value = Color3.new(1,1,1), Usealpha = false, Flag = "hm_color", Callback = function(color)
			hm_color = color.c
		end})
		sec:Slider({Name = "Hitmarker size", Min = 3, Max = 30, Float = 1, Value = 8, Flag = "hm_size", Callback = function(v)
			hm_size = v
		end})
		sec:Slider({Name = "Hitmarker thickness", Min = 1, Max = 8, Float = 1, Value = 2, Flag = "hm_thick", Callback = function(v)
			hm_thick = v
		end})
		sec:Slider({Name = "Hitmarker fade time (ms)", Min = 50, Max = 800, Float = 10, Value = 180, Flag = "hm_duration", Callback = function(v)
			hm_duration = v / 1000
		end})

		-- ---- Kill effect (2D частицы при убийстве) ----
		sec:Toggle({Name = "Kill particles", Value = false, Flag = "ke_enabled", Callback = function(bool)
			ke_enabled = bool
		end}):Colorpicker({Name = "Particle color", Value = Color3.new(1,1,1), Usealpha = false, Flag = "ke_color", Callback = function(color)
			ke_color = color.c
		end})
		sec:Slider({Name = "Particle speed", Min = 10, Max = 200, Float = 5, Value = 80, Flag = "ke_speed", Callback = function(v)
			ke_speed = v
		end})
		sec:Slider({Name = "Particle min size", Min = 1, Max = 20, Float = 1, Value = 3, Flag = "ke_size_min", Callback = function(v)
			ke_size_min = v
		end})
		sec:Slider({Name = "Particle max size", Min = 1, Max = 30, Float = 1, Value = 10, Flag = "ke_size_max", Callback = function(v)
			ke_size_max = v
		end})
		sec:Slider({Name = "Particle lifetime (ms)", Min = 100, Max = 2000, Float = 50, Value = 600, Flag = "ke_lifetime", Callback = function(v)
			ke_life_min = v / 1000 * 0.5
			ke_life_max = v / 1000
		end})
	end

	-- ========== DEATH EFFECT (розовые частицы) ==========
	local de_enabled = false

	local DE_CONFIG = {
		MAIN_COLOR    = Color3.fromRGB(255, 100, 200),
		BRIGHT_COLOR  = Color3.fromRGB(255, 200, 230),
		GLOW_COLOR    = Color3.fromRGB(255, 50, 150),
		PARTICLE_COUNT = 40,
		PARTICLE_SIZE_MIN = 0.15,
		PARTICLE_SIZE_MAX = 0.4,
		PARTICLE_SPEED = 35,
		PARTICLE_LIFETIME = 0.7,
		LIGHT_CHANCE  = 0.3,
		LIGHT_BRIGHTNESS = 1,
		LIGHT_RANGE   = 2.5,
		SPARKLE_COUNT = 8,
		STAR_COUNT    = 20,
		RAY_COUNT     = 10,
		RAY_LENGTH    = 6,
		RAY_LIFETIME  = 0.35,
		AFFECT_OTHERS = true,
		AFFECT_SELF   = true,
	}

	local TweenSvc2 = game:GetService("TweenService")

	local function de_particle(position)
		local sz = DE_CONFIG.PARTICLE_SIZE_MIN + math.random() * (DE_CONFIG.PARTICLE_SIZE_MAX - DE_CONFIG.PARTICLE_SIZE_MIN)
		local part = Instance.new("Part")
		part.Shape = Enum.PartType.Ball; part.Size = Vector3.new(sz,sz,sz)
		part.Material = Enum.Material.Neon
		part.Color = math.random() > 0.3 and DE_CONFIG.MAIN_COLOR or DE_CONFIG.BRIGHT_COLOR
		part.Anchored = false; part.CanCollide = false; part.CastShadow = false
		part.Position = position + Vector3.new((math.random()-0.5)*2,(math.random()-0.5)*2+1,(math.random()-0.5)*2)
		part.Parent = workspace
		local light
		if math.random() < DE_CONFIG.LIGHT_CHANCE then
			light = Instance.new("PointLight")
			light.Brightness = DE_CONFIG.LIGHT_BRIGHTNESS; light.Range = DE_CONFIG.LIGHT_RANGE
			light.Color = DE_CONFIG.GLOW_COLOR; light.Parent = part
		end
		local dir = Vector3.new((math.random()-0.5)*2,(math.random()-0.5)*2,(math.random()-0.5)*2).Unit
		local bv = Instance.new("BodyVelocity")
		bv.Velocity = dir*(DE_CONFIG.PARTICLE_SPEED*(0.5+math.random()*0.8)); bv.MaxForce = Vector3.new(1e6,1e6,1e6); bv.Parent = part
		task.delay(0.1, function() if bv and bv.Parent then TweenSvc2:Create(bv,TweenInfo.new(0.4),{Velocity=Vector3.new(0,-5,0)}):Play() end end)
		local lt = DE_CONFIG.PARTICLE_LIFETIME*(0.7+math.random()*0.6)
		TweenSvc2:Create(part,TweenInfo.new(lt,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Transparency=1,Size=Vector3.new(0.02,0.02,0.02)}):Play()
		if light then TweenSvc2:Create(light,TweenInfo.new(lt),{Brightness=0,Range=0}):Play() end
		task.delay(lt+0.05, function() if part then part:Destroy() end end)
	end

	local function de_star(position)
		local part = Instance.new("Part")
		part.Size = Vector3.new(0.3,0.3,0.3); part.Transparency = 1; part.Anchored = true
		part.CanCollide = false; part.CastShadow = false
		part.Position = position + Vector3.new(0,1,0); part.Parent = workspace
		local att = Instance.new("Attachment"); att.Parent = part
		local em = Instance.new("ParticleEmitter")
		em.Texture = "rbxassetid://2273224484"
		em.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
		em.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.2,0.6),NumberSequenceKeypoint.new(0.7,0.4),NumberSequenceKeypoint.new(1,0)})
		em.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(0.5,0),NumberSequenceKeypoint.new(1,1)})
		em.Lifetime = NumberRange.new(0.7,1.2); em.Rate = 0; em.Speed = NumberRange.new(10,22)
		em.SpreadAngle = Vector2.new(180,180); em.Rotation = NumberRange.new(0,360)
		em.RotSpeed = NumberRange.new(-100,100); em.LightEmission = 1; em.LightInfluence = 0
		em.Acceleration = Vector3.new(0,-10,0); em.Orientation = Enum.ParticleOrientation.FacingCamera; em.Parent = att
		em:Emit(DE_CONFIG.STAR_COUNT)
		local l = Instance.new("PointLight"); l.Brightness = 2; l.Range = 6; l.Color = DE_CONFIG.MAIN_COLOR; l.Parent = part
		TweenSvc2:Create(l,TweenInfo.new(0.8),{Brightness=0,Range=0}):Play()
		task.delay(1.5, function() if part then part:Destroy() end end)
	end

	local function de_sparkle(position)
		local part = Instance.new("Part")
		part.Size = Vector3.new(0.2,0.2,0.2); part.Anchored = true; part.CanCollide = false
		part.CastShadow = false; part.Transparency = 1
		part.Position = position + Vector3.new((math.random()-0.5)*8,(math.random()-0.5)*6+1,(math.random()-0.5)*8)
		part.Parent = workspace
		local bb = Instance.new("BillboardGui"); bb.Size = UDim2.new(0,0,0,0); bb.AlwaysOnTop = false; bb.LightInfluence = 0; bb.Parent = part
		local img = Instance.new("ImageLabel"); img.Size = UDim2.new(1,0,1,0); img.BackgroundTransparency = 1
		pcall(function() img.Image = "rbxassetid://241876428" end)
		pcall(function() img.ImageColor3 = DE_CONFIG.BRIGHT_COLOR end)
		img.Parent = bb
		local ts = 80+math.random(0,60)
		TweenSvc2:Create(bb,TweenInfo.new(0.15,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,ts,0,ts)}):Play()
		task.delay(0.2,function()
			TweenSvc2:Create(bb,TweenInfo.new(0.4),{Size=UDim2.new(0,0,0,0)}):Play()
			TweenSvc2:Create(img,TweenInfo.new(0.4),{ImageTransparency=1}):Play()
			task.delay(0.45,function() if part then part:Destroy() end end)
		end)
	end

	local function de_ray(position, angle)
		local length = DE_CONFIG.RAY_LENGTH*(0.7+math.random()*0.6)
		local ray = Instance.new("Part"); ray.Size = Vector3.new(0.1,0.1,0.5)
		ray.Material = Enum.Material.Neon; ray.Color = DE_CONFIG.BRIGHT_COLOR
		ray.Anchored = true; ray.CanCollide = false; ray.CastShadow = false; ray.Transparency = 0.1
		local dir = Vector3.new(math.cos(angle)*math.cos(math.random()*math.pi-math.pi/2),math.sin(math.random()*math.pi-math.pi/2),math.sin(angle)*math.cos(math.random()*math.pi-math.pi/2)).Unit
		ray.CFrame = CFrame.lookAt(position,position+dir)*CFrame.new(0,0,-length/2)
		ray.Size = Vector3.new(0.1,0.1,length); ray.Parent = workspace
		TweenSvc2:Create(ray,TweenInfo.new(DE_CONFIG.RAY_LIFETIME,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=Vector3.new(0.01,0.01,length*1.5),Transparency=1}):Play()
		task.delay(DE_CONFIG.RAY_LIFETIME+0.05,function() if ray then ray:Destroy() end end)
	end

	local function de_createEffect(position)
		if not de_enabled then return end
		for i = 1, DE_CONFIG.PARTICLE_COUNT do task.spawn(de_particle, position) end
		de_star(position)
		for i = 1, DE_CONFIG.SPARKLE_COUNT do task.spawn(function() task.wait(math.random()*0.2); de_sparkle(position) end) end
		for i = 1, DE_CONFIG.RAY_COUNT do task.spawn(function() de_ray(position,(i/DE_CONFIG.RAY_COUNT)*math.pi*2+math.random()*0.3) end) end
	end

	-- подключаем к смерти игроков
	local function de_connectCharacter(character, isLocal)
		local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
		if not humanoid then return end
		humanoid.Died:Connect(function()
			local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
			if root then
				if (isLocal and DE_CONFIG.AFFECT_SELF) or (not isLocal and DE_CONFIG.AFFECT_OTHERS) then
					de_createEffect(root.Position)
				end
			end
		end)
	end

	local de_Players = game:GetService("Players")
	local de_LocalPlayer = de_Players.LocalPlayer
	local function de_connectPlayer(player)
		local isLocal = player == de_LocalPlayer
		if player.Character then task.spawn(de_connectCharacter, player.Character, isLocal) end
		player.CharacterAdded:Connect(function(char) de_connectCharacter(char, isLocal) end)
	end
	for _, p in ipairs(de_Players:GetPlayers()) do task.spawn(de_connectPlayer, p) end
	de_Players.PlayerAdded:Connect(de_connectPlayer)

	-- UI — Death Effect с кастомизацией каждого эффекта
	do
		local sec = hmsec

		sec:Toggle({Name = "Death effect", Value = false, Flag = "de_enabled", Callback = function(bool)
			de_enabled = bool
		end}):Colorpicker({Name = "DE Main color", Value = Color3.fromRGB(255,100,200), Usealpha = false, Flag = "de_main_color", Callback = function(color)
			DE_CONFIG.MAIN_COLOR = color.c
		end})
		local de_use_bright = false
		do
			local t = sec:Toggle({Name = "DE Secondary color", Value = false, Flag = "de_bright_tog", Callback = function(bool)
				de_use_bright = bool
				if not bool then
					DE_CONFIG.BRIGHT_COLOR = DE_CONFIG.MAIN_COLOR
				else
					if Library and Library.Flags and Library.Flags["de_bright_color"] then
						DE_CONFIG.BRIGHT_COLOR = Library.Flags["de_bright_color"].Color or DE_CONFIG.MAIN_COLOR
					end
				end
			end})
			t:Colorpicker({Name = "DE Secondary color", Value = Color3.fromRGB(255,200,230), Usealpha = false, Flag = "de_bright_color", Callback = function(color)
				if de_use_bright then
					DE_CONFIG.BRIGHT_COLOR = color.c
				end
			end})
		end

		sec:Slider({Name = "DE Ball count", Min = 5, Max = 80, Float = 1, Value = 40, Flag = "de_particle_count", Callback = function(v)
			DE_CONFIG.PARTICLE_COUNT = v
		end})
		sec:Slider({Name = "DE Ball speed", Min = 5, Max = 80, Float = 1, Value = 35, Flag = "de_particle_speed", Callback = function(v)
			DE_CONFIG.PARTICLE_SPEED = v
		end})
		sec:Slider({Name = "DE Ball lifetime (x0.1s)", Min = 1, Max = 20, Float = 1, Value = 7, Flag = "de_particle_life", Callback = function(v)
			DE_CONFIG.PARTICLE_LIFETIME = v / 10
		end})
		sec:Slider({Name = "DE Ray count", Min = 0, Max = 20, Float = 1, Value = 10, Flag = "de_ray_count", Callback = function(v)
			DE_CONFIG.RAY_COUNT = v
		end})
		sec:Slider({Name = "DE Ray length", Min = 1, Max = 20, Float = 1, Value = 6, Flag = "de_ray_length", Callback = function(v)
			DE_CONFIG.RAY_LENGTH = v
		end})
		sec:Slider({Name = "DE Sparkle count", Min = 0, Max = 20, Float = 1, Value = 8, Flag = "de_sparkle_count", Callback = function(v)
			DE_CONFIG.SPARKLE_COUNT = v
		end})
		sec:Slider({Name = "DE Star count", Min = 0, Max = 50, Float = 1, Value = 20, Flag = "de_star_count", Callback = function(v)
			DE_CONFIG.STAR_COUNT = v
		end})
		sec:Button({Name = "Test death effect", Callback = function()
			local char = de_LocalPlayer.Character
			if char then
				local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
				if root then
					local was = de_enabled
					de_enabled = true
					de_createEffect(root.Position)
					de_enabled = was
				end
			end
		end})
	end
end

local aspect_ratio, aspect_ratio_x, aspect_ratio_y = false, 1, 1
local thirdperson, thirdperson_key, thirdperson_distance = false, false, 10
do
	local espsec = ui.sections.player_esp
	local setsec = ui.sections.esp_settings
	local mscsec = ui.sections.visuals_misc

	local enemy_sets = cheat.EspLibrary.settings.enemy
	local enemy_main_sets = cheat.EspLibrary.settings.enemy.main_settings

	
	do
		espsec:Toggle({Name = "Enabled", Value = false, Flag = "esp_enabled", Callback = function(bool)
			enemy_sets.enabled = bool
			cheat.EspLibrary.icaca()
		end})

		do
			local toggle = espsec:Toggle({Name = "Box", Value = false, Flag = "esp_box", Callback = function(bool)
				enemy_sets.box = bool
				cheat.EspLibrary.icaca()
			end})
			toggle:Colorpicker({Name = "Box color left", Value = Color3.new(1, 1, 1), Usealpha = true, Flag = "esp_box_color_left", Callback = function(color)
				enemy_sets.box_color[1] = color.c
				enemy_sets.box_color[3] = color.a
				cheat.EspLibrary.icaca()
			end})
			toggle:Colorpicker({Name = "Box color right", Value = Color3.new(1, 1, 1), Usealpha = false, Flag = "esp_box_color_right", Callback = function(color)
				enemy_sets.box_color[2] = color.c
				cheat.EspLibrary.icaca()
			end})
			espsec:Slider({Name = "Box rotation", Min = 0, Max = 20, Float = 0.1, Value = 0, Flag = "esp_box_rotation", Callback = function(int)
				enemy_sets.box_rotation = int * 18
				cheat.EspLibrary.icaca()
			end})
		end

		do
			local toggle = espsec:Toggle({Name = "Health bar", Value = false, Flag = "esp_health_bar", Callback = function(bool)
				enemy_sets.health_bar = bool
				cheat.EspLibrary.icaca()
			end})
			toggle:Colorpicker({Name = "Bar color top", Value = Color3.new(1, 1, 1), Usealpha = false, Flag = "esp_health_bar_color_top", Callback = function(color)
				enemy_sets.health_bar_color[1] = color.c
				cheat.EspLibrary.icaca()
			end})
			toggle:Colorpicker({Name = "Bar color bottom", Value = Color3.new(1, 1, 1), Usealpha = false, Flag = "esp_health_bar_color_bottom", Callback = function(color)
				enemy_sets.health_bar_color[2] = color.c
				cheat.EspLibrary.icaca()
			end})
		end

		for _, element in {
			{"Name", "name"},
			{"Distance", "distance"},
			{"Weapon", "weapon"},
			{"Health text", "health_text"},
			{"Flags", "flags"},
			{"Skeleton", "skeleton"},
			} do
			espsec:Toggle({Name = element[1], Value = false, Flag = ("esp_" .. element[2]), Callback = function(bool)
				enemy_sets[element[2]] = bool
				cheat.EspLibrary.icaca()
			end}):Colorpicker({Name = (element[1] .. " color"), Value = Color3.new(1, 1, 1), Usealpha = true, Flag = ("esp_" .. element[2] .. "_color"), Callback = function(color)
				enemy_sets[element[2] .. "_color"] = {color.c, color.a}
				cheat.EspLibrary.icaca()
			end})
		end

		espsec:Slider({Name = "Skeleton update rate", Min = 0, Max = 1, Float = 0.01, Value = 0, Flag = "esp_skeleton_rate", Callback = function(int)
			enemy_main_sets.skeleton_rate = int
			cheat.EspLibrary.icaca()
		end})

		espsec:Toggle({Name = "Chams", Value = false, Flag = "esp_chams", Callback = function(bool)
			enemy_sets.chams = bool
			cheat.EspLibrary.icaca()
		end}):Colorpicker({Name = "Chams color", Value = Library.Theme.accent or Color3.new(1, 1, 1), Usealpha = false, Flag = "esp_chams_color", Callback = function(color)
			enemy_sets.chams_color = {color.c, color.a}
			cheat.EspLibrary.icaca()
		end})
		espsec:Toggle({Name = "Highlight", Value = false, Flag = "esp_highlight", Callback = function(bool)
			enemy_sets.highlight = bool
			cheat.EspLibrary.icaca()
		end}):Colorpicker({Name = "Highlight color", Value = Library.Theme.accent or Color3.new(1, 1, 1), Usealpha = true, Flag = "esp_highlight_color", Callback = function(color)
			enemy_sets.highlight_color = {color.c, color.a}
			cheat.EspLibrary.icaca()
		end})
		espsec:Dropdown({Name = "Chams style", Values = {"Glow", "Flat", "ForceField", "Glass", "Pulse", "Rainbow"}, Value = "Glow", Flag = "esp_chams_style", Multi = false, Callback = function(value)
			enemy_sets.chams_style = value or "Glow"
			cheat.EspLibrary.icaca()
		end})
		espsec:Slider({Name = "Chams glow factor", Min = 0, Max = 100, Float = 0.1, Value = 3, Flag = "esp_chams_glow_factor", Callback = function(int)
			enemy_sets.chams_glow_factor = int
			cheat.EspLibrary.icaca()
		end})

		local self_chams = cheat.EspLibrary.settings.self_chams

		espsec:Toggle({Name = "Self chams", Value = false, Flag = "esp_self_chams", Callback = function(bool)
			self_chams.enabled = bool
			pcall(function() cheat.EspLibrary.update_self_chams() end)
		end}):Colorpicker({Name = "Self chams color", Value = Library.Theme.accent or Color3.new(1, 1, 1), Usealpha = false, Flag = "esp_self_chams_color", Callback = function(color)
			self_chams.color = {color.c, color.a}
			pcall(function() cheat.EspLibrary.update_self_chams() end)
		end})

		espsec:Toggle({Name = "Self highlight", Value = false, Flag = "esp_self_highlight", Callback = function(bool)
			self_chams.highlight = bool
			pcall(function() cheat.EspLibrary.update_self_chams() end)
		end}):Colorpicker({Name = "Self highlight color", Value = Library.Theme.accent or Color3.new(1, 1, 1), Usealpha = true, Flag = "esp_self_highlight_color", Callback = function(color)
			self_chams.highlight_color = {color.c, color.a}
			pcall(function() cheat.EspLibrary.update_self_chams() end)
		end})

		espsec:Dropdown({Name = "Self chams style", Values = {"Ocean Gel", "Glow", "Flat", "ForceField", "Glass", "Pulse", "Rainbow"}, Value = "Ocean Gel", Flag = "esp_self_chams_style", Multi = false, Callback = function(value)
			self_chams.style = value or "Ocean Gel"
			pcall(function() cheat.EspLibrary.update_self_chams() end)
		end})

		espsec:Slider({Name = "Self chams glow factor", Min = 0, Max = 100, Float = 0.1, Value = 3, Flag = "esp_self_chams_glow_factor", Callback = function(int)
			self_chams.glow_factor = int
			pcall(function() cheat.EspLibrary.update_self_chams() end)
		end})

	end
	do
		local player_list = cheat.player_list
		local flag_settings = {
			["Target"] = false,
			["Team"] = false,
			["Friend"] = false,
			["Forcefield"] = false,
			["Premium"] = false
		}
		setsec:Dropdown({Name = "Flags", Values = {"Target", "Team", "Friend", "Forcefield", "Premium"}, Value = {}, Flag = "esp_selected_flags", Multi = true, Callback = function(tbl)
			for flag, value in flag_settings do
				flag_settings[flag] = false
			end
			for _, flag in tbl do
				flag_settings[flag] = true
			end
		end})

		local get_team = cheat.EspLibrary.get_team
		cheat.EspLibrary.register_flag("TARGET", LPH_NO_VIRTUALIZE(function(player, character, humanoid)
			return flag_settings["Target"] and player == target_player
		end))
		cheat.EspLibrary.register_flag("TEAM", LPH_NO_VIRTUALIZE(function(player, character, humanoid)
			return flag_settings["Team"] and get_team(player)
		end))
		cheat.EspLibrary.register_flag("FRIEND", LPH_NO_VIRTUALIZE(function(player, character, humanoid)
			return flag_settings["Friend"] and player_list[player] and player_list[player].friend
		end))
		cheat.EspLibrary.register_flag("FF", LPH_NO_VIRTUALIZE(function(player, character, humanoid)
			return flag_settings["Forcefield"] and not not _FindFirstChildOfClass(character, "ForceField")
		end))
		cheat.EspLibrary.register_flag("PREM", LPH_NO_VIRTUALIZE(function(player, character, humanoid)
			return flag_settings["Premium"] and player_list[player] and player_list[player].premium
		end))
	end
	do
		setsec:Dropdown({Name = "Checks", Values = {"Team check", "Dead check", "Distance check"}, Value = {}, Flag = "esp_checks", Multi = true, Callback = function(tbl)
			local funny = {
				["Team check"] = "team_check",
				["Dead check"] = "dead_check",
				["Distance check"] = "dist_check"
			}
			for flag_text, esp_var in funny do
				enemy_main_sets[esp_var] = false
			end
			for flag_text, esp_var in funny do -- O^2 my beloved... its 3 elements so i don't really care (9)
				for _, check_name in tbl do
					if (check_name ~= flag_text or enemy_main_sets[esp_var]) then
						continue
					end
					enemy_main_sets[esp_var] = true
					--print(esp_var)
				end
			end
			cheat.EspLibrary.icaca()
		end})
		setsec:Slider({Name = "Max distance", Min = 0, Max = 5000, Float = 100, Value = 600, Flag = "esp_max_distance", Callback = function(int)
			enemy_main_sets.max_distance = int
			cheat.EspLibrary.icaca()
		end})
		setsec:Toggle({Name = "Gradient spin", Value = false, Flag = "esp_gradient_spin", Callback = function(bool)
			enemy_main_sets.gradient_spin = bool
			cheat.EspLibrary.icaca()
		end})
		setsec:Slider({Name = "Gradient speed", Min = -20, Max = 20, Float = 0.1, Value = 0, Flag = "esp_gradient_speed", Callback = function(int)
			enemy_main_sets.gradient_speed = int * 18
			cheat.EspLibrary.icaca()
		end})

		setsec:Toggle({Name = "Arrow ESP", Value = false, Flag = "esp_arrow", Callback = function(bool)
			enemy_sets.arrow = bool
			cheat.EspLibrary.icaca()
		end})
		setsec:Slider({Name = "Arrow max distance", Min = 0, Max = 1000, Float = 1, Value = 100, Flag = "esp_arrow_max_dist", Callback = function(int)
			enemy_sets.arrow_max_dist = int
			cheat.EspLibrary.icaca()
		end})
		setsec:Slider({Name = "Arrow radius", Min = 50, Max = 1000, Float = 1, Value = 200, Flag = "esp_arrow_radius", Callback = function(int)
			enemy_sets.arrow_radius = int
			cheat.EspLibrary.icaca()
		end})
		setsec:Dropdown({
			Name = "Arrow elements",
			Values = {"Health", "Name", "Distance", "Box", "Item"},
			Value = {},
			Multi = true,
			Flag = "esp_arrow_elements",
			Callback = function(val)
				local map = {
					["Health"] = "health", ["health"] = "health",
					["Name"] = "name", ["name"] = "name",
					["Distance"] = "distance", ["distance"] = "distance",
					["Box"] = "box", ["box"] = "box",
					["Item"] = "item", ["item"] = "item",
				}
				local normalized = {}
				for _, item in val do
					local mapped = map[item]
					if mapped then table.insert(normalized, mapped) end
				end
				enemy_sets.arrow_elements = normalized
				cheat.EspLibrary.icaca()
			end
		})
		do
			local toggle = setsec:Toggle({Name = "Custom arrow HP color", Value = false, Flag = "esp_arrow_hp_custom", Callback = function(bool)
				enemy_sets.arrow_hp_color = bool and (Library.Flags["esp_arrow_hp_color"] and Library.Flags["esp_arrow_hp_color"].Color or Color3.fromRGB(64, 220, 90)) or nil
			end})
			toggle:Colorpicker({Name = "Arrow HP color", Value = Color3.fromRGB(64, 220, 90), Usealpha = false, Flag = "esp_arrow_hp_color", Callback = function(color)
				if Library.Flags["esp_arrow_hp_custom"] then
					enemy_sets.arrow_hp_color = color.c
				end
			end})
		end
	end
	do
		local old_fov = Camera.FieldOfView
		local fov_changer, fov_changer_size = false, 100
		mscsec:Toggle({Name = "FOV Changer", Value = false, Flag = "view_fov_changer", Callback = function(bool)
			fov_changer = bool
			Camera.FieldOfView = fov_changer and fov_changer_size or old_fov
		end})
		mscsec:Slider({Name = "Desired FOV", Min = 10, Max = 120, Float = 1, Value = 100, Flag = "view_fov_changer_size", Callback = function(int)
			fov_changer_size = int
			Camera.FieldOfView = fov_changer and fov_changer_size or old_fov
		end})
		mscsec:Toggle({Name = "Aspect ratio", Value = false, Flag = "view_aspect_ratio", Callback = function(bool)
			aspect_ratio = bool
		end})
		mscsec:Slider({Name = "Aspect X", Min = 0.01, Max = 1.1, Float = 0.01, Value = 1, Flag = "aspect_ratio_x", Callback = function(int)
			aspect_ratio_x = int
		end})
		mscsec:Slider({Name = "Aspect Y", Min = 0.01, Max = 1.1, Float = 0.01, Value = 1, Flag = "aspect_ratio_y", Callback = function(int)
			aspect_ratio_y = int
		end})
		mscsec:Toggle({Name = "Thirdperson", Value = false, Flag = "view_thirdperson", Callback = function(bool)
			thirdperson = bool
		end}):Keybind({Name = "Thirdperson", Mode = "Toggle", Key = Enum.KeyCode.N, Value = false, Flag = "view_thirdperson_keybind", Callback = function(bool)
			thirdperson_key = bool
		end})
		mscsec:Slider({Name = "Thirdperson distance", Min = 1, Max = 50, Float = 1, Value = 10, Flag = "view_thirdperson_distance", Callback = function(int)
			thirdperson_distance = int
		end})
		Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
			if Camera.FieldOfView ~= fov_changer_size then
				old_fov = Camera.FieldOfView
			end
			if not fov_changer then return end 
			Camera.FieldOfView = fov_changer_size
		end)
	end

end

do
	local movebox = ui.sections.movement
	local miscbox = ui.sections.misc
	local itembox = ui.sections.item

	local speedhack, speedhack_key, speedhack_speed = false, false, 100
	local flyhack, flyhack_key, flyhack_speed, flyhack_speed_y = false, false, 100, 100
	local bunnyhop = false

	--[[miscbox:Toggle({Name = "Roll view for spectators", Value = false, Flag = "anti_spectate", Callback = function(bool)
		projectscp.anti_spectate = bool
	end})
	miscbox:Toggle({Name = "Bypass speed restriction", Value = false, Flag = "movement_bypass", Callback = function(bool)
		movement_bypass = bool
	end})
	miscbox:Toggle({Name = "Anti SCP-096", Value = false, Flag = "anti_096", Callback = function(bool)
		projectscp.anti_096 = bool
	end})]]
	miscbox:Button({Name = "Rejoin", Confirm = true, Callback = function()
		if #Players:GetPlayers() <= 1 then
			LocalPlayer:Kick("\nRejoining...")
			wait()
			game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
		else
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
		end
	end})
	miscbox:Toggle({Name = "Bunnyhop", Value = false, Flag = "bunnyhop", Callback = function(bool)
		bunnyhop = bool
	end})

	-- ---- Indicator (имя цели над прицелом) ----
	miscbox:Toggle({Name = "Aim indicator", Value = false, Flag = "indicator_enabled", Callback = function(bool)
		if cheat._aimIndicator then
			cheat._aimIndicator.enabled = bool
		end
	end})

	movebox:Toggle({Name = "Speedhack", Value = false, Flag = "speedhack", Callback = function(bool)
		speedhack = bool
	end}):Keybind({Name = "Speedhack", Mode = "Toggle", Key = Enum.KeyCode.X, Value = false, Flag = "speedhack_key", Callback = function(bool)
		speedhack_key = bool
	end})
	movebox:Slider({Name = "Speedhack speed", Min = 0, Max = 500, Float = 1, Value = 100, Flag = "speedhack_speed", Callback = function(int)
		speedhack_speed = int
	end})

	movebox:Toggle({Name = "Flyhack", Value = false, Flag = "flyhack", Callback = function(bool)
		flyhack = bool
	end}):Keybind({Name = "Flyhack", Mode = "Toggle", Key = Enum.KeyCode.V, Value = false, Flag = "flyhack_key", Callback = function(bool)
		flyhack_key = bool
	end})
	movebox:Slider({Name = "Flyhack speed", Min = 0, Max = 500, Float = 1, Value = 100, Flag = "flyhack_speed", Callback = function(int)
		flyhack_speed = int
	end})
	movebox:Slider({Name = "Flyhack speed Y", Min = 0, Max = 500, Float = 1, Value = 100, Flag = "flyhack_speed_y", Callback = function(int)
		flyhack_speed_y = int
	end})

	cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
		local hrp = LocalPlayer.Character and _FindFirstChild(LocalPlayer.Character, "HumanoidRootPart")
		local hum = LocalPlayer.Character and _FindFirstChildOfClass(LocalPlayer.Character, "Humanoid")

		if hum and bunnyhop and _IsKeyDown(UserInputService, Enum.KeyCode.Space) then
			hum.Jump = true
		end
		if not hrp then return end

		local cameralook = (_Vector3new(1, 0, 1) * Camera.CFrame.LookVector).Unit
		local direction = Vector3.zero
		direction = _IsKeyDown(UserInputService, Enum.KeyCode.W) and direction + cameralook or direction;
		direction = _IsKeyDown(UserInputService, Enum.KeyCode.S) and direction - cameralook or direction;
		direction = _IsKeyDown(UserInputService, Enum.KeyCode.D) and direction + _Vector3new(-cameralook.Z, 0, cameralook.X) or direction;
		direction = _IsKeyDown(UserInputService, Enum.KeyCode.A) and direction + _Vector3new(cameralook.Z, 0, -cameralook.X) or direction;
		if direction ~= Vector3.zero then
			direction = direction.Unit
		end
		if flyhack and flyhack_key then
			local ydir = Vector3.zero
			ydir = _IsKeyDown(UserInputService, Enum.KeyCode.Space)	 and ydir + Vector3.yAxis or ydir;
			ydir = _IsKeyDown(UserInputService, Enum.KeyCode.LeftShift) and ydir - Vector3.yAxis or ydir;
			hrp.AssemblyLinearVelocity = _Vector3new(1, 0, 1) * direction * flyhack_speed + flyhack_speed_y * ydir
		elseif speedhack and speedhack_key then
			hrp.AssemblyLinearVelocity = _Vector3new(1, 0, 1) * direction * speedhack_speed + hrp.AssemblyLinearVelocity.Y * Vector3.yAxis
		end
	end))
end

-- ============================================================
--  CROSSHAIR  (4 линии, центр экрана, вращение + пульсация gap)
-- ============================================================
do
	local chsec = ui.sections.crosshair

	-- настройки
	local ch_enabled  = false
	local ch_size     = 10    -- длина каждой линии (px)
	local ch_gap      = 3     -- зазор от центра (px)
	local ch_thick    = 1     -- толщина линии
	local ch_color    = Color3.new(1, 1, 1)
	local ch_alpha    = 0     -- Drawing: 0 = непрозрачный, 1 = прозрачный
	local ch_spin     = false -- вращение
	local ch_speed    = 60    -- градусов в секунду
	local ch_angle    = 0     -- текущий угол (degrees)
	local ch_outline  = true  -- чёрная обводка

	-- пульсация (сужение/разжатие gap)
	local ch_pulse       = false  -- включена ли пульсация
	local ch_pulse_speed = 2      -- циклов в секунду
	local ch_pulse_min   = 1      -- минимальный gap при сжатии
	local ch_pulse_max   = 12     -- максимальный gap при расширении
	local ch_pulse_t     = 0      -- внутренний таймер [0..1]
	local ch_pulse_dir   = 1      -- 1 = растём, -1 = сжимаемся

	-- создаём 4 линии + 4 обводки (по одной на каждую линию)
	local lines = {}
	local outlines = {}
	local _zero = Vector2.new(0, 0)
	for i = 1, 4 do
		outlines[i] = cheat.utility.new_drawing("Line", {
			Visible   = false,
			Color     = Color3.new(0, 0, 0),
			Thickness = ch_thick + 2,
			ZIndex    = 1,
			From      = _zero,
			To        = _zero,
		})
		lines[i] = cheat.utility.new_drawing("Line", {
			Visible   = false,
			Color     = ch_color,
			Thickness = ch_thick,
			ZIndex    = 2,
			From      = _zero,
			To        = _zero,
		})
	end

	-- helper: обновить все линии по текущим параметрам + угол
	local function updateCrosshair(delta)
		if not ch_enabled then
			for i = 1, 4 do
				lines[i].Visible    = false
				outlines[i].Visible = false
			end
			return
		end

		-- вращение
		if ch_spin then
			ch_angle = (ch_angle + ch_speed * delta) % 360
		end

		-- пульсация gap (ping-pong)
		local current_gap = ch_gap
		if ch_pulse then
			ch_pulse_t = ch_pulse_t + delta * ch_pulse_speed * ch_pulse_dir
			if ch_pulse_t >= 1 then
				ch_pulse_t = 1
				ch_pulse_dir = -1
			elseif ch_pulse_t <= 0 then
				ch_pulse_t = 0
				ch_pulse_dir = 1
			end
			-- плавный ease in-out через синус
			local ease = (1 - math.cos(ch_pulse_t * math.pi)) * 0.5
			current_gap = ch_pulse_min + (ch_pulse_max - ch_pulse_min) * ease
		end

		local center = UserInputService:GetMouseLocation()
		local rad    = math.rad(ch_angle)

		local dirs = {
			Vector2.new( math.cos(rad),  math.sin(rad)),
			Vector2.new(-math.sin(rad),  math.cos(rad)),
			Vector2.new(-math.cos(rad), -math.sin(rad)),
			Vector2.new( math.sin(rad), -math.cos(rad)),
		}

		for i, dir in ipairs(dirs) do
			local from = center + dir * current_gap
			local to   = center + dir * (current_gap + ch_size)

			outlines[i].From      = from
			outlines[i].To        = to
			outlines[i].Color     = Color3.new(0, 0, 0)
			outlines[i].Thickness = ch_thick + 2
			outlines[i].Transparency = ch_alpha
			outlines[i].Visible   = ch_outline

			lines[i].From         = from
			lines[i].To           = to
			lines[i].Color        = ch_color
			lines[i].Thickness    = ch_thick
			lines[i].Transparency = ch_alpha
			lines[i].Visible      = true
		end
	end

	cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
		updateCrosshair(delta)
	end))

	-- UI
	chsec:Toggle({Name = "Enabled", Value = false, Flag = "ch_enabled", Callback = function(bool)
		ch_enabled = bool
	end}):Colorpicker({Name = "Color", Value = Color3.new(1, 1, 1), Usealpha = true, Flag = "ch_color", Callback = function(color)
		ch_color = color.c
		ch_alpha = 1 - color.a
	end})

	chsec:Toggle({Name = "Outline", Value = true, Flag = "ch_outline", Callback = function(bool)
		ch_outline = bool
	end})

	chsec:Slider({Name = "Length", Min = 1, Max = 60, Float = 1, Value = 10, Flag = "ch_size", Callback = function(v)
		ch_size = v
	end})

	chsec:Slider({Name = "Gap", Min = 0, Max = 30, Float = 1, Value = 3, Flag = "ch_gap", Callback = function(v)
		ch_gap = v
	end})

	chsec:Slider({Name = "Thickness", Min = 1, Max = 10, Float = 1, Value = 1, Flag = "ch_thick", Callback = function(v)
		ch_thick = v
	end})

	chsec:Toggle({Name = "Spin", Value = false, Flag = "ch_spin", Callback = function(bool)
		ch_spin = bool
		if not bool then ch_angle = 0 end
	end})

	chsec:Slider({Name = "Spin speed", Min = 10, Max = 720, Float = 10, Value = 60, Flag = "ch_speed", Callback = function(v)
		ch_speed = v
	end})

	chsec:Toggle({Name = "Pulse", Value = false, Flag = "ch_pulse", Callback = function(bool)
		ch_pulse = bool
		ch_pulse_t = 0
		ch_pulse_dir = 1
	end})

	chsec:Slider({Name = "Pulse speed", Min = 0.1, Max = 10, Float = 0.1, Value = 2, Flag = "ch_pulse_speed", Callback = function(v)
		ch_pulse_speed = v
	end})

	chsec:Slider({Name = "Pulse min gap", Min = 0, Max = 30, Float = 1, Value = 1, Flag = "ch_pulse_min", Callback = function(v)
		ch_pulse_min = v
	end})

	chsec:Slider({Name = "Pulse max gap", Min = 1, Max = 60, Float = 1, Value = 12, Flag = "ch_pulse_max", Callback = function(v)
		ch_pulse_max = v
	end})
end

local desync_enabled, desync_enabled_key = false, false
local character, hrp, head
local old_cframe, old_velocity, hrp_offset

do
	local dscsec = ui.sections.custom_desync
	local expsec = ui.sections.exploit

	local desync_visualize = false
	local desync_x_offset, desync_y_offset, desync_z_offset = 0, 0, 0
	local desync_x_rotate, desync_y_rotate, desync_z_rotate = 0, 0, 0
	local desync_random_rotation, desync_random_position = false, false
	local desync_random_position_range = 5

	local desync_velocity = false
	local desync_velocity_x, desync_velocity_y, desync_velocity_z = 0, 0, 0

	local forced_cframe

	local raksync, raksync_key, raksync_replicate_next = false, false, false

	local main_wireframe = Instance.new("WireframeHandleAdornment")
	main_wireframe.Parent = game:GetService("CoreGui").RobloxGui
	main_wireframe.Adornee = workspace
	main_wireframe.Color3 = Color3.new(1, 1, 1)
	main_wireframe.Transparency = 0
	main_wireframe.AlwaysOnTop = true
	main_wireframe.CFrame = CFrame.new()
	main_wireframe.Scale = Vector3.one
	main_wireframe.Thickness = 1
	main_wireframe.AdornCullingMode = Enum.AdornCullingMode.Automatic

	do --if SWG_Note:find("alpha") then
		local original_rate, original_bandwidth = getfflag("S2PhysicsSenderRate"), getfflag("PhysicsSenderMaxBandwidthBps")

		local desync_freeze, desync_freeze_key, desync_freeze_factor = false, false, 100
		local desync_ready, desync_turned_on = true, false

		local set_physics_rate = function(rate, bandwidth)
			print(rate, bandwidth)
			setfflag("S2PhysicsSenderRate", tostring(rate))
			setfflag("PhysicsSenderMaxBandwidthBps", tostring(bandwidth))
		end

		local get_hrp = function()
			local character = LocalPlayer.Character
			return character and _FindFirstChild(character, "HumanoidRootPart")
		end

		local toggle_desync = function(state, reason)
			if not state then
				desync_turned_on = false
				if reason then
					Library.Notification(reason, 2.5)
				end
				return set_physics_rate(original_rate, original_bandwidth)
			end

			local hrp = get_hrp()
			if not hrp then return toggle_desync(false, "No character found.") end

			forced_cframe = nil

			set_physics_rate(32767, 32767 * 32)

			desync_turned_on = true
			RunService.Heartbeat:Wait()

			for _ = 1, 3 do
				hrp.AssemblyLinearVelocity += Vector3.new(0, 1, 0)
				RunService.Heartbeat:Wait()
				if not hrp then
					return toggle_desync(false, "Character destroyed in preparation process.")
				end
			end

			desync_ready = false
			forced_cframe = hrp.CFrame

			local recorded_time = tick()
			repeat until tick() - recorded_time > 0.8

			Library.Notification("Don't move for until this notification goes away.", 3)

			task.wait(3)

			set_physics_rate(15, 15 * 32)

			desync_ready = true
			forced_cframe = nil
		end

		expsec:Toggle({Name = "Freeze desync", Value = false, Flag = "desync_freeze", Callback = function(bool)
			desync_freeze = bool
			if not desync_freeze then
				toggle_desync(false)
			end
		end}):Keybind({Name = "Freeze desync", Mode = "Toggle", Key = Enum.KeyCode.M, Value = false, Flag = "desync_freeze_key", Callback = function(bool)
			if not desync_ready then
				return Library.Notification("Freeze is not ready yet!", 2.5)
			end

			desync_freeze_key = bool
			if desync_freeze then
				task.spawn(toggle_desync, desync_freeze_key)
			end
		end})

		expsec:Slider({Name = "Freeze factor", Min = 0, Max = 500, Float = 10, Value = 100, Flag = "desync_freeze_factor", Callback = function(int)
			desync_freeze_factor = int
		end})

		local old = 0
		local isSleeping = false
		RunService.Heartbeat:Connect(function()
			if not (desync_turned_on) then
				return
			end

			local hrp = get_hrp()
			if not hrp then return end

			local now = tick()
			local factor = 1 / desync_freeze_factor
			if now - old >= factor then
				old = now
				isSleeping = not isSleeping
				sethiddenproperty(hrp, "NetworkIsSleeping", isSleeping)
				--[[sethiddenproperty(LocalPlayer, "MaximumSimulationRadius", 2^1023 * (isSleeping and 1 or -1)) 
				sethiddenproperty(LocalPlayer, "MaxSimulationRadius", 2^1023 * (isSleeping and 1 or -1)) 
				sethiddenproperty(LocalPlayer, "SimulationRadius", 2^1023 * (isSleeping and 1 or -1)) ]]
				--replicatesignal(game.Players.LocalPlayer.SimulationRadiusChanged, 2^1023 * (isSleeping and 1 or -1))
			end
		end)

		--[[RunService.Heartbeat:Connect(function()
			if not (desync_turned_on) then
				return
			end

			local hrp = get_hrp()
			if not hrp then return end

			if (forced_cframe) then
				hrp.CFrame = forced_cframe
				--hrp.AssemblyLinearVelocity = Vector3.zero
			end
		end)]]

		-- this desync was fucking made by D-D-D-D-DJ SWIMDROID
		-- ТЁЛКИ СНИМАЙТЕ ТРУСЫ		
	end
	
	if type(raknet) == "table" then
		expsec:Toggle({Name = "Raksync", Value = false, Flag = "desync_raksync", Callback = function(bool)
			raksync = bool
		end}):Keybind({Name = "Raksync", Mode = "Toggle", Key = Enum.KeyCode.M, Value = false, Flag = "desync_raksync_key", Callback = function(bool)
			raksync_key = bool
		end})
		--setfflag("S2PhysicsSenderRate", "15")

		local function disect(packetData)
			local iter = 0
			local hextable = {}
			local hex = buffer.tostring(packetData):gsub(".", function(char)
				iter += 1
				local st = string.format("%x", char:byte())
				local rs = (#st == 1 and "0" or "") .. st
				hextable[iter - 1] = rs
				return rs .. " " .. (iter % 8 == 0 and "\n" or "")
			end)
			return hextable, hex
		end
		
		local function write_timer(packetData, packet_timer)
			local axx = buffer.create(4)
			buffer.writeu32(axx, 0, packet_timer)
			local packet_timer_hex = disect(axx)
			for i = 0, 3 do
				local n = tonumber(packet_timer_hex[i], 16)
				buffer.writeu8(packetData, 8 - i --[[i + 5]], n)
			end
		end

		local old_packet_data, old_packet_timer
		local packet_timer_manipulation = tick()

		raknet.add_send_hook(function(packetData)
			local packetId = buffer.readu8(packetData, 0)
			if packetId == 0x1B then
				if not (raksync and raksync_key) then
					old_packet_timer = nil
					return true
				end
				
				local hextable, hex = disect(packetData)

				local packet_timer = ""
				local packet_id = ""
				for i = 1, 8 do
					packet_timer ..= hextable[i]
				end
				for i = 9, 16 do
					packet_id ..= hextable[i]
				end
				packet_timer, packet_id = tonumber(packet_timer, 16), tonumber(packet_id, 16)


				if not old_packet_timer then
					old_packet_timer = packet_timer
				end


				packet_timer = old_packet_timer
				write_timer(packetData, packet_timer)
				
				if tick() - packet_timer_manipulation >= 1 then
					old_packet_timer += 1
					packet_timer_manipulation = tick()
					old_packet_data = buffer.fromstring(buffer.tostring(packetData))
					raksync_replicate_next = true
				else
					old_packet_data = nil
					raksync_replicate_next = false
				end

			end
			return true
		end)
	end

	local shitcode, shitcode_tick, shitcode_factor = false, tick(), 60
	expsec:Toggle({Name = "FPS limiter", Flag = "old_swimhub_mode", Value = false, Callback = function(v)
		shitcode = v
		shitcode_tick = tick()
		task.spawn(function()
				while shitcode do
				if tick() - shitcode_tick > 1/shitcode_factor then
					shitcode_tick = tick()
					RunService.RenderStepped:Wait()
				end
			end
		end)
	end})
	expsec:Slider({Name = "FPS Limit", Min = 2, Max = 60, Float = 0.1, Value = 0, Flag = "shitcode_factor", Callback = function(int)
		shitcode_factor = int
	end})

	dscsec:Toggle({Name = "Enabled", Value = false, Flag = "desync_enabled", Callback = function(bool)
		desync_enabled = bool
	end}):Keybind({Name = "Desync", Mode = "Toggle", Key = Enum.KeyCode.B, Value = false, Flag = "desync_enabled_key", Callback = function(bool)
		desync_enabled_key = bool
	end})

	dscsec:Toggle({Name = "Visualize desync", Value = false, Flag = "desync_visualize", Callback = function(bool)
		desync_visualize = bool
	end}):Colorpicker({Name = "Visualization color", Value = Color3.new(1, 1, 1), Usealpha = true, Flag = "desync_visualize_color", Callback = function(color)
		main_wireframe.Color3 = color.c
		main_wireframe.Transparency = color.a
	end})

	dscsec:Slider({Name = "X offset", Min = -10, Max = 10, Float = 0.1, Value = 0, Flag = "desync_x_offset", Callback = function(int)
		desync_x_offset = int
	end})
	dscsec:Slider({Name = "Y offset", Min = -10, Max = 10, Float = 0.1, Value = 0, Flag = "desync_y_offset", Callback = function(int)
		desync_y_offset = int
	end})
	dscsec:Slider({Name = "Z offset", Min = -10, Max = 10, Float = 0.1, Value = 0, Flag = "desync_z_offset", Callback = function(int)
		desync_z_offset = int
	end})

	dscsec:Slider({Name = "X rotate", Min = 0, Max = 20, Float = 0.1, Value = 0, Flag = "desync_x_rotate", Callback = function(int)
		desync_x_rotate = math.rad(int * 18)
	end})
	dscsec:Slider({Name = "Y rotate", Min = 0, Max = 20, Float = 0.1, Value = 0, Flag = "desync_y_rotate", Callback = function(int)
		desync_y_rotate = math.rad(int * 18)
	end})
	dscsec:Slider({Name = "Z rotate", Min = 0, Max = 20, Float = 0.1, Value = 0, Flag = "desync_z_rotate", Callback = function(int)
		desync_z_rotate = math.rad(int * 18)
	end})

	dscsec:Toggle({Name = "Random rotation", Value = false, Flag = "desync_random_rotation", Callback = function(bool)
		desync_random_rotation = bool
	end})
	dscsec:Toggle({Name = "Random position", Value = false, Flag = "desync_random_position", Callback = function(bool)
		desync_random_position = bool
	end})
	dscsec:Slider({Name = "Random range", Min = 0, Max = 25, Float = 0.1, Value = 0, Flag = "desync_random_position_range", Callback = function(int)
		desync_random_position_range = int
	end})

	dscsec:Toggle({Name = "Velocity desync", Value = false, Flag = "desync_velocity", Callback = function(bool)
		desync_velocity = bool
	end})
	dscsec:Slider({Name = "Velocity X", Min = -16384, Max = 16384, Float = 512, Value = 0, Flag = "desync_velocity_x", Callback = function(int)
		desync_velocity_x = int
	end})
	dscsec:Slider({Name = "Velocity Y", Min = -16384, Max = 16384, Float = 512, Value = 0, Flag = "desync_velocity_y", Callback = function(int)
		desync_velocity_y = int
	end})
	dscsec:Slider({Name = "Velocity Z", Min = -16384, Max = 16384, Float = 512, Value = 0, Flag = "desync_velocity_z", Callback = function(int)
		desync_velocity_z = int
	end})

	RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
		character = LocalPlayer.Character
		if not character then return end
		humanoid = _FindFirstChildOfClass(character, "Humanoid")
		hrp = _FindFirstChild(character, "HumanoidRootPart")
		head = _FindFirstChild(character, "Head")
		if not (humanoid and hrp) then return end
		if not (desync_enabled and desync_enabled_key) then return end
		if (forced_cframe) then return end

		old_cframe = hrp.CFrame
		old_velocity = hrp.AssemblyLinearVelocity

		if (raksync and raksync_key) and (not raksync_replicate_next) then return end
		
		hrp_offset = _CFramenew(
			desync_x_offset,
			desync_y_offset,
			desync_z_offset
		) * CFrame.Angles(
			desync_x_rotate,
			desync_y_rotate,
			desync_z_rotate
		)
		if desync_random_position then
			hrp_offset = hrp_offset + (
				CFrame.Angles(
					(mathrandom() - mathrandom()) * 2 * math.pi,
					(mathrandom() - mathrandom()) * 2 * math.pi,
					(mathrandom() - mathrandom()) * 2 * math.pi
				) * CFrame.new(0, 0, -desync_random_position_range)
			).Position
		end
		if desync_random_rotation then
			hrp_offset = hrp_offset * CFrame.Angles(
				(mathrandom() - mathrandom()) * 2 * math.pi,
				(mathrandom() - mathrandom()) * 2 * math.pi,
				(mathrandom() - mathrandom()) * 2 * math.pi
			)
		end

		hrp.CFrame = old_cframe * hrp_offset
		if desync_velocity then
			hrp.AssemblyLinearVelocity = _Vector3new(
				desync_velocity_x,
				desync_velocity_y,
				desync_velocity_z
			)
		end

		RunService.RenderStepped:Wait()
		if not hrp then return end

		hrp.CFrame = old_cframe
		if desync_velocity then
			hrp.AssemblyLinearVelocity = old_velocity
		end
	end))

	local VERTICES = {
		-- left face
		_Vector3new(-1,-1,-1), _Vector3new(-1, 1,-1),
		_Vector3new(-1, 1,-1), _Vector3new(-1, 1, 1),
		_Vector3new(-1, 1, 1), _Vector3new(-1,-1, 1),
		_Vector3new(-1,-1, 1), _Vector3new(-1,-1,-1),
		-- right face
		_Vector3new( 1,-1,-1), _Vector3new( 1, 1,-1),
		_Vector3new( 1, 1,-1), _Vector3new( 1, 1, 1),
		_Vector3new( 1, 1, 1), _Vector3new( 1,-1, 1),
		_Vector3new( 1,-1, 1), _Vector3new( 1,-1,-1),
		-- connections
		_Vector3new(-1,-1,-1), _Vector3new( 1,-1,-1),
		_Vector3new(-1, 1,-1), _Vector3new( 1, 1,-1),
		_Vector3new(-1, 1, 1), _Vector3new( 1, 1, 1),
		_Vector3new(-1,-1, 1), _Vector3new( 1,-1, 1),
	}

	local function isBodyPart(name)
		return name == "Head" or name:find("Torso") or name:find("Leg") or name:find("Arm") or name:find("Hand") or name:find("Foot")
	end

	cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
		main_wireframe:Clear()

		if not (desync_visualize) then return end
		if not (desync_enabled and desync_enabled_key) then return end
		if not (old_cframe and hrp_offset) then return end

		local character = LocalPlayer.Character
		if not (character) then return end

		local parts = {}
		local c = 0
		for _, v in character:GetChildren() do
			if v:IsA("BasePart") and isBodyPart(v.Name) then
				c += 1
				parts[c] = {v.CFrame, v.Size}
			end
		end
		if c == 0 then return end

		local points = {}
		c = 0
		for _, part in parts do
			for _, vertex in VERTICES do
				c += 1
				points[c] = (old_cframe * hrp_offset):PointToWorldSpace(
					old_cframe:PointToObjectSpace(part[1]:PointToWorldSpace(vertex * part[2] * 0.5))
				) - workspace.WorldPivot.Position
			end
		end

		main_wireframe:AddLines(points)
	end))
end

do
	local worldbox = ui.sections.world_main_changer
	local miscbox = ui.sections.world_misc_changer
	do
		local lighting_changer, lighting_changing = false, false
		local old_lighting = {
			Ambient = Lighting.Ambient,
			OutdoorAmbient = Lighting.OutdoorAmbient,
			Brightness = Lighting.Brightness,
			ColorShift_Bottom = Lighting.ColorShift_Bottom,
			ColorShift_Top = Lighting.ColorShift_Top,
			GlobalShadows = Lighting.GlobalShadows,
			FogColor = Lighting.FogColor,
			FogEnd = Lighting.FogEnd,
			FogStart = Lighting.FogStart,
			ClockTime = Lighting.ClockTime,
		}
		local lighting_values = {
			Ambient = Color3.fromRGB(70, 70, 70),
			OutdoorAmbient = Color3.fromRGB(70, 70, 70),
			Brightness = 3,
			ColorShift_Bottom = Color3.new(),
			ColorShift_Top = Color3.new(),
			GlobalShadows = true,
			FogColor = Color3.fromRGB(192, 192, 192),
			FogEnd = 10000,
			FogStart = 0,
			ClockTime = 14.5,
		}

		local function capture_old_lighting()
			for k, _ in old_lighting do
				old_lighting[k] = Lighting[k]
			end
		end

		local append_changes = function()
			lighting_changing = true
			for k, v in (lighting_changer and lighting_values or old_lighting) do
				Lighting[k] = v
			end
			-- PropertyChanged can fire slightly later; keep guard alive briefly so old_lighting
			-- does not get overwritten by our custom values when toggling.
			task.delay(0.08, function()
				lighting_changing = false
			end)
		end

		worldbox:Toggle({Name = 'Lighting Changer', Flag = 'world_lighting_changer', Value = false, Callback = function(first)
			if first then capture_old_lighting() end
			lighting_changer = first
			append_changes()
		end})
		worldbox:Colorpicker({Name = 'Ambient', Flag = 'world_lighting_ambient', Value = Color3.fromRGB(70, 70, 70), Usealpha = false, Callback = function(Value)
			lighting_values.Ambient = Value.c
			append_changes()
		end})
		worldbox:Colorpicker({Name = 'Outdoor Ambient', Flag = 'world_lighting_outdoorambient', Value = Color3.fromRGB(70, 70, 70), Usealpha = false, Callback = function(Value)
			lighting_values.OutdoorAmbient = Value.c
			append_changes()
		end})
		worldbox:Slider({Name = 'Brightness', Flag = 'world_lighting_brightness', Value = 1, Min = -5, Max = 15, Float = 0.01, Callback = function(State)
			lighting_values.Brightness = State
			append_changes()
		end})
		worldbox:Colorpicker({Name = 'Color Shift Bottom', Flag = 'world_lighting_colorshift_bottom', Value = Color3.new(), Usealpha = false, Callback = function(Value)
			lighting_values.ColorShift_Bottom = Value.c
			append_changes()
		end})
		worldbox:Colorpicker({Name = 'Color Shift Top', Flag = 'world_lighting_colorshift_top', Value = Color3.new(), Usealpha = false, Callback = function(Value)
			lighting_values.ColorShift_Top = Value.c
			append_changes()
		end})
		worldbox:Toggle({Name = 'Global Shadows', Flag = 'world_lighting_globalshadows', Value = true, Callback = function(first)
			lighting_values.GlobalShadows = first
			append_changes()
		end})

		worldbox:Colorpicker({Name = 'Fog Color', Flag = 'world_lighting_fogcolor', Value = Color3.fromRGB(192, 192, 192), Usealpha = false, Callback = function(Value)
			lighting_values.FogColor = Value.c
			append_changes()
		end})
		worldbox:Slider({Name = 'Fog End', Flag = 'world_lighting_fogend', Value = 100,Min = 0,Max = 10000,Float = 100,Callback = function(State)
			lighting_values.FogEnd = State
			append_changes()
		end})
		worldbox:Slider({Name = 'Fog Start', Flag = 'world_lighting_fogstart', Value = 0,Min = 0,Max = 10000,Float = 100,Callback = function(State)
			lighting_values.FogStart = State
			append_changes()
		end})

		worldbox:Slider({Name = 'Clock Time', Flag = 'world_lighting_clocktime', Value = 14.5,Min = 0,Max = 24,Float = 0.1,Callback = function(State)
			lighting_values.ClockTime = State
			append_changes()
		end})

		for _, method in {"Ambient", "OutdoorAmbient", "Brightness", "ColorShift_Bottom", "ColorShift_Top", "GlobalShadows", "FogColor", "FogEnd", "FogStart", "ClockTime"} do
			Lighting:GetPropertyChangedSignal(method):Connect(function()
				if not lighting_changing then
					old_lighting[method] = Lighting[method]
				end
				if not lighting_changer then return end
				Lighting[method] = lighting_values[method]
			end)
		end
	end

	do
		do
			local atmosphere = _FindFirstChildOfClass(Lighting, "Atmosphere")
			local atmosphere_existed = atmosphere ~= nil
			if not atmosphere then
				atmosphere = Instance.new("Atmosphere")
				-- Do not parent it until Atmosphere Changer is enabled; otherwise fog appears even while disabled.
				atmosphere.Parent = nil
			end

			local atmosphere_changer, atmosphere_changing = false, false
			local old_atmosphere = {
				Density = atmosphere.Density,
				Offset = atmosphere.Offset,
				Color = atmosphere.Color,
				Decay = atmosphere.Decay,
				Glare = atmosphere.Glare,
				Haze = atmosphere.Haze
			}
			local atmosphere_values = {
				Density = 0.28,
				Offset = 1,
				Color = Color3.new(1, 1, 1),
				Decay = Color3.new(0.8, 0.8, 0.8),
				Glare = 1,
				Haze = 1
			}

			local function ensure_atmosphere()
				if atmosphere and atmosphere.Parent then return atmosphere end
				if not atmosphere then
					atmosphere = Instance.new("Atmosphere")
				end
				atmosphere.Parent = Lighting
				return atmosphere
			end

			local function capture_old_atmosphere()
				local current = _FindFirstChildOfClass(Lighting, "Atmosphere")
				atmosphere_existed = current ~= nil
				if current then
					atmosphere = current
					for k, _ in old_atmosphere do
						old_atmosphere[k] = atmosphere[k]
					end
				end
			end

			local append_changes = function()
				atmosphere_changing = true
				if atmosphere_changer then
					local atm = ensure_atmosphere()
					for k, v in atmosphere_values do
						atm[k] = v
					end
				else
					if atmosphere_existed then
						local atm = ensure_atmosphere()
						for k, v in old_atmosphere do
							atm[k] = v
						end
					else
						local atm = _FindFirstChildOfClass(Lighting, "Atmosphere")
						if atm then atm:Destroy() end
						atmosphere = nil
					end
				end
				task.delay(0.08, function()
					atmosphere_changing = false
				end)
			end

			miscbox:Toggle({Name = 'Atmosphere Changer', Flag = 'world_atmosphere_changer', Value = false,Callback = function(first)
				if first then capture_old_atmosphere() end
				atmosphere_changer = first
				append_changes()
			end})
			miscbox:Slider({Name = 'Density', Flag = 'world_atmosphere_density', Value = 0.9,Min = 0,Max = 1,Float = 0.01,Callback = function(State)
				atmosphere_values.Density = State
				append_changes()
			end})
			miscbox:Slider({Name = 'Offset', Flag = 'world_atmosphere_offset', Value = 1,Min = 0,Max = 1,Float = 0.01,Callback = function(State)
				atmosphere_values.Offset = State
				append_changes()
			end})
			miscbox:Colorpicker({Name = 'Color', Flag = 'world_atmosphere_color', Value = Color3.new(1, 1, 1), Usealpha = false, Callback = function(Value)
				atmosphere_values.Color = Value.c
				append_changes()
			end})
			miscbox:Colorpicker({Name = 'Decay', Flag = 'world_atmosphere_decay', Value = Color3.new(0.8, 0.8, 0.8), Usealpha = false, Callback = function(Value)
				atmosphere_values.Decay = Value.c
				append_changes()
			end})
			miscbox:Slider({Name = 'Glare', Flag = 'world_atmosphere_glare', Value = 1,Min = 0,Max = 20,Float = 0.1,Callback = function(State)
				atmosphere_values.Glare = State
				append_changes()
			end})
			miscbox:Slider({Name = 'Haze', Flag = 'world_atmosphere_haze', Value = 1,Min = 0,Max = 20,Float = 0.1,Callback = function(State)
				atmosphere_values.Haze = State
				append_changes()
			end})

			-- If the map did not originally have Atmosphere, we keep our created object unparented
			-- while disabled. Some executors can treat that as nil here, so guard this connection block.
			if atmosphere then
				for _, method in {"Density", "Offset", "Color", "Decay", "Glare", "Haze"} do
					atmosphere:GetPropertyChangedSignal(method):Connect(function()
						if not atmosphere_changing and atmosphere and atmosphere.Parent then
							old_atmosphere[method] = atmosphere[method]
						end
						if not atmosphere_changer then return end
						local atm = ensure_atmosphere()
						atm[method] = atmosphere_values[method]
					end)
				end
			end
		end
		do
			local bloom = _FindFirstChildOfClass(Lighting, "BloomEffect")
			if not bloom then
				bloom = Instance.new("BloomEffect")
				bloom.Parent = Lighting
				--print('had to make a new bloom... collar is blue but reck is ned')
			end
			local bloom_changer, bloom_changing = false, false
			local old_bloom = {
				Enabled = bloom.Enabled,
				Intensity = bloom.Intensity,
				Size = bloom.Size,
				Threshold = bloom.Threshold
			}
		local bloom_values = {
			Enabled = true,
			Intensity = 1,
				Size = 56,
				Threshold = 2
			}

			local append_changes = function()
				bloom_changing = true
				for k, v in (bloom_changer and bloom_values or old_bloom) do
					bloom[k] = v
				end
				bloom_changing = false
			end

			miscbox:Toggle({Name = 'Bloom Changer', Flag = 'world_bloom_changer', Value = false,Callback = function(first)
				bloom_changer = first
				append_changes()
			end})
			miscbox:Toggle({Name = 'Enabled', Flag = 'world_bloom_enabled', Value = false,Callback = function(first)
				bloom_values.Enabled = first
				append_changes()
			end})
			miscbox:Slider({Name = 'Intensity', Flag = 'world_bloom_intensity', Value = 1,Min = 0,Max = 5,Float = 0.01,Callback = function(State)
				bloom_values.Intensity = State
				append_changes()
			end})
			miscbox:Slider({Name = 'Size', Flag = 'world_bloom_size', Value = 56,Min = 0,Max = 80,Float = 1,Callback = function(State)
				bloom_values.Size = State
				append_changes()
			end})
			miscbox:Slider({Name = 'Threshold', Flag = 'world_bloom_threshold', Value = 2,Min = 0,Max = 10,Float = 0.1,Callback = function(State)
				bloom_values.Threshold = State
				append_changes()
			end})

			for _, method in {"Intensity", "Size", "Threshold"} do
				bloom:GetPropertyChangedSignal(method):Connect(function()
					if not bloom_changing then
						old_bloom[method] = bloom[method]
					end
					if not bloom_changer then return end
					bloom[method] = bloom_values[method]
				end)
			end
		end
	end
end

-- ---- settings page (встроенная в новую библиотеку) ----
ui.window.Init()

-- ---- Тоггл свечения watermark + keybinds (glow уже создан в Library:Window) ----
do
	local miscGlowSec = ui.sections.misc
	miscGlowSec:Toggle({
		Name     = "Watermark glow",
		Value    = false,
		Flag     = "wm_glow",
		Callback = function(bool)
			-- _setGlow создаётся в Library:Window (строки ~5688)
			local W = ui.window and ui.window.__new
			if W and W._setGlow then
				W._setGlow(bool)
			end
		end
	})
end

-- ---- hooks (silent aim / thirdperson) + ESP load ----
-- Глобальный флаг Remove Recoil — устанавливается из Gun Mods do-блока выше
-- (recoil_locked_cf и gun_remove_recoil объявлены там через upvalue)
local __newindex; __newindex = hookmetamethod(game, "__newindex", newcclosure(LPH_NO_VIRTUALIZE(function(self, idx, val)
	if self == Camera and idx == "CFrame" then
		if thirdperson and thirdperson_key then
			val = val + (val.LookVector * -thirdperson_distance)
		end
		if aspect_ratio then
			val = val * _CFramenew(
				0, 0, 0,
				aspect_ratio_x, 0, 0,
				0, aspect_ratio_y, 0,
				0, 0, 1
			)
		end
		-- Remove Recoil больше не трогает Camera.CFrame, чтобы не блокировать вращение камеры.
	end
	return __newindex(self, idx, val)
end)))

local __index; __index = hookmetamethod(game, '__index', newcclosure(LPH_NO_VIRTUALIZE(function(self, key)
	if checkcaller() then return __index(self, key) end
	if key == 'CFrame' and (self == hrp or self == head) and desync_enabled and desync_enabled_key and old_cframe then
		if self == hrp then
			return old_cframe or _CFramenew()
		end
		if self == head then
			return old_cframe and old_cframe * _CFramenew(
				0,
				hrp.Size.Y / 2 + head.Size.Y / 2,
				0
			) or _CFramenew()
		end
	end
	return __index(self, key)
end)))

local __namecall; __namecall = hookmetamethod(game, "__namecall", newcclosure(LPH_NO_VIRTUALIZE(function(self,...)
	if checkcaller() then return __namecall(self, ...) end
	local args = {...}
	local method = getnamecallmethod()
	-- silent aim: работает когда выбран режим Silent и метод включён
	if silent_methods[method] and aimbot_mode == "Silent" then
		local hitpart = target_part  -- атомарное чтение upvalue
		if not hitpart or not hitpart.Parent then
			return __namecall(self, ...)
		end

		local hitsize = hitpart.Size
		local orgpos = hitpart.Position
		local hitpos = orgpos + _Vector3new(
			(mathrandom() - mathrandom()) * (hitsize.X / 10),
			(mathrandom() - mathrandom()) * (hitsize.Y / 10),
			(mathrandom() - mathrandom()) * (hitsize.Z / 10)
		)

		if method == "Raycast" then
			local origin = args[1]
			local direction = args[2]
			local new_dir = silent_projectionoverride and (hitpos - origin) or (hitpos - origin).Unit * direction.Magnitude
			if silent_wallbang and new_dir.Magnitude >= direction.Magnitude then
				return {
					Instance = hitpart,
					Position = silent_magicbullet and _Vector3new(0/0, 0/0, 0/0) or hitpos,
					Distance = (hitpos - args[1]).Magnitude,
					Normal = (hitpos - orgpos).Unit,
					Material = hitpart.Material
				}
			end
			args[2] = new_dir
			return __namecall(self, unpack(args))
		end

		if method == "ScreenPointToRay" or method == "ViewportPointToRay" then
			local ray = __namecall(self, unpack(args))
			local origin = ray.Origin
			local direction = ray.Direction
			local new_dir = silent_projectionoverride and (hitpos - origin) or (hitpos - origin).Unit * direction.Magnitude
			if silent_wallbang and new_dir.Magnitude >= direction.Magnitude then
				local new_origin = (hitpart.CFrame * CFrame.new(0, hitpart.Size.Y, 0)).Position
				return Ray.new(
					(hitpart.CFrame * CFrame.new(0, hitpart.Size.Y, 0)).Position,
					hitpos - new_origin
				)
			end
			return Ray.new(origin, new_dir)
		end

		local ray = args[1]
		local origin = ray.Origin
		local direction = ray.Direction
		local new_dir = silent_projectionoverride and (hitpos - origin) or (hitpos - origin).Unit * direction.Magnitude
		if silent_wallbang and new_dir.Magnitude >= direction.Magnitude then
			return hitpart, silent_magicbullet and _Vector3new(0/0, 0/0, 0/0) or hitpos, (hitpos - orgpos).Unit, hitpart.Material
		end
		args[1] = Ray.new(origin, new_dir)
		return __namecall(self, unpack(args))
	end
	return __namecall(self, ...)
end)))

cheat.EspLibrary.load()
