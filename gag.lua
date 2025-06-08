local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local TeleportService   = game:GetService("TeleportService")
local HttpService       = game:GetService("HttpService")

-- your webhook URL here
local webhookURL = "https://discord.com/api/webhooks/1363752832913772544/B7bSWXh3uVzkiQ2ysIRDTEUsbcULN82nJ3dWFMIBBH-mpmdgelBVsgnDE6HSATpsTjfD"

-- helper to send Discord embed
local function sendPetEmbed(petName)
    local payload = {
        embeds = {{
            title       = "🎉 Pet Hatched!",
            description = "**" .. petName .. "** has just hatched!",
            color       = 0x00FF00,
            timestamp   = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    HttpService:PostAsync(
        webhookURL,
        HttpService:JSONEncode(payload),
        Enum.HttpContentType.ApplicationJson
    )
end

-- grab the pet-lookup table
local hatchFn = getupvalue(
                  getupvalue(
                    getconnections(ReplicatedStorage.GameEvents.PetEggService.OnClientEvent)[1].Function,
                  1),
                2
              )
local eggPets = getupvalue(hatchFn, 2)

local wantList = {
    "Disco Bee",
    "Dragonfly",
}

local foundGood = false
for _, egg in ipairs(CollectionService:GetTagged("PetEggServer")) do
    if egg:GetAttribute("OWNER") == game.Players.LocalPlayer.Name then
        local petName = eggPets[egg:GetAttribute("OBJECT_UUID")]
        print(petName, "Review")
        if table.find(wantList, petName) then
            -- highlight it in-game
            Instance.new("Highlight", egg)
            -- notify Discord
            sendPetEmbed(petName)
            foundGood = true
            break
        end
    end
end

if not foundGood then
    -- queue the same script on the next server
    queue_on_teleport("loadstring(game:HttpGet('https://pastebin.com/raw/GKkSPxnn'))()")
    -- hop to a new server
    TeleportService:Teleport(game.PlaceId)
end
