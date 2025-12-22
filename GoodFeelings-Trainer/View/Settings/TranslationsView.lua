local Buttons = require("UI").Buttons
local JsonHelper = require("Core/JsonHelper")
local Language = require("Core/Language")
local Notification = require("UI").Notification

local configPath = "Config/JSON/Settings.json"
local langFolder = "lang" -- Leaving this here so other authors don't have to adjust their language pack 

local config
local availableLangs = {}
local selectedLangIndex = 1
local languageRadio = { index = 1 }
local languageOptions = {}
local initialized = false 

local function LoadAvailableLanguages()
    availableLangs = {}
    languageOptions = {}
    config = JsonHelper.Read(configPath) or { Lang = "en" }

    local files = dir(langFolder) or {}
    for _, file in ipairs(files) do
        local filename = type(file) == "table" and file.name or file
        if type(filename) == "string" and filename:match("%.json$") then
            local langName = filename:gsub("%.json$", "")
            table.insert(availableLangs, langName)
            table.insert(languageOptions, langName)
            if langName == config.Lang then
                selectedLangIndex = #availableLangs
            end
        end
    end
    languageRadio.index = selectedLangIndex
end

local function SetLanguage(lang)
    config.Lang = lang
    JsonHelper.Write(configPath, config)
    Language.Load(lang)

    local loadMessage = Language.Get("loadmessage")
    if loadMessage and loadMessage ~= "" then
        Notification.Success(loadMessage)
    end
end

local function LanguageMenuView()
    if not initialized then
        LoadAvailableLanguages()
        initialized = true
    end

    Buttons.Option(L("languagemenu.reload.label"), L("languagemenu.reload.tip"), function()
        LoadAvailableLanguages()
    end)

    Buttons.Break(L("languagemenu.tip"))

    Buttons.Radio("", languageRadio, languageOptions, "", function()
        local lang = availableLangs[languageRadio.index]
        selectedLangIndex = languageRadio.index
        SetLanguage(lang)
    end)
end

return {
    title = "Translations",
    view = LanguageMenuView
}
