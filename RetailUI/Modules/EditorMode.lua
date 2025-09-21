--[[
    Copyright (c) Dmitriy. All rights reserved.
    Licensed under the MIT license. See LICENSE file in the project root for details.
]]

-- CUSTOM START
-- Create a frame to handle the event.
local eventFrame = CreateFrame("Frame")

-- Register the event we care about.
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Set the script to execute when the event fires.
eventFrame:SetScript("OnEvent", function(self, event, ...)
if event == "PLAYER_ENTERING_WORLD" then
    -- Create a string with the desired color and a 1px shadow.
    -- The format is |c followed by the color code in hexadecimal (AARRGGBB) for the text color
    -- and |Tinterface/worldstateframes/deathicon:1:1|t to create a small shadow effect.
    local legendaryColor = "|cFFFF8000"
    local resetColor = "|r"
    local shadow = "|Tinterface/worldstateframes/deathicon:1:1|t"
    local message = shadow .. legendaryColor .. "[RUI] Type /rui edit to modify UI, repeat to confirm." .. resetColor

    -- Print your welcome message to the chat.
    print(message)

    -- This line is crucial to ensure the message only shows once per login.
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
    end)
-- CUSTOM END

local RUI = LibStub('AceAddon-3.0'):GetAddon('RetailUI')
local moduleName = 'EditorMode'
local Module = RUI:NewModule(moduleName, 'AceConsole-3.0', 'AceHook-3.0', 'AceEvent-3.0')

local UnitFrameModule, CastingBarModule, ActionBarModule, MinimapModule, QuestTrackerModule, BuffFrameModule

Module.editorGridFrame = nil

local function CreateEditorGridFrame()
    local editorGridFrame = CreateFrame("Frame", 'RUI_EditorGridFrame', UIParent)
    editorGridFrame:SetPoint("TOPLEFT", 0, 0)
    editorGridFrame:SetSize(GetScreenWidth(), GetScreenHeight())
    editorGridFrame:SetFrameLevel(0)
    editorGridFrame:SetFrameStrata("BACKGROUND")

    do
        local texture = editorGridFrame:CreateTexture(nil, "BACKGROUND")
        texture:SetAllPoints(editorGridFrame)
        texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UI\\EditorGrid.blp", "REPEAT", "REPEAT")
        texture:SetTexCoord(0, 1, 0, 1)
        texture:SetVertTile(true)
        texture:SetHorizTile(true)
        texture:SetSize(32, 32)
        texture:SetAlpha(0.4)
    end

    editorGridFrame:Hide()
    return editorGridFrame
end

function Module:OnEnable()
    UnitFrameModule      = RUI:GetModule("UnitFrame")
    CastingBarModule     = RUI:GetModule("CastingBar")
    ActionBarModule      = RUI:GetModule("ActionBar")
    MinimapModule        = RUI:GetModule("Minimap")
    QuestTrackerModule   = RUI:GetModule("QuestTracker")
    BuffFrameModule      = RUI:GetModule("BuffFrame")

    self.editorGridFrame = CreateEditorGridFrame()
end

function Module:OnDisable() end

function Module:Show()
    if InCombatLockdown() then
        self:Printf(DEFAULT_CHAT_FRAME, "Cannot open settings while in combat")
        return
    end

    self.editorGridFrame:Show()

    ActionBarModule:ShowEditorTest()
    UnitFrameModule:ShowEditorTest()
    CastingBarModule:ShowEditorTest()
    MinimapModule:ShowEditorTest()
    QuestTrackerModule:ShowEditorTest()
    BuffFrameModule:ShowEditorTest()
end

function Module:Hide()
    self.editorGridFrame:Hide()

    ActionBarModule:HideEditorTest(true)
    UnitFrameModule:HideEditorTest(true)
    CastingBarModule:HideEditorTest(true)
    MinimapModule:HideEditorTest(true)
    QuestTrackerModule:HideEditorTest(true)
    BuffFrameModule:HideEditorTest(true)
end

function Module:IsShown()
    return self.editorGridFrame:IsShown()
end
