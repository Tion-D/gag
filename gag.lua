local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local localPlayer = Players.LocalPlayer

localPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local webhookURL = "https://discord.com/api/webhooks/1363752832913772544/B7bSWXh3uVzkiQ2ysIRDTEUsbcULN82nJ3dWFMIBBH-mpmdgelBVsgnDE6HSATpsTjfD"

local function sendPetEmbed(petName)
    local payload = HttpService:JSONEncode({
        embeds = {{
            title = "🎉 Pet Hatched!",
            description = "**" .. petName .. "** has just hatched!",
            color = 0x00FF00,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    })

    request({
        Url = webhookURL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = payload
    })
end


local hatchFn = getupvalue(
                getupvalue(
                    getconnections(ReplicatedStorage.GameEvents.PetEggService.OnClientEvent)[1].Function,
                  1),
                2
              )
local eggPets = getupvalue(hatchFn, 2)

local wantList = {
    "Disco Bee",
    "Dragonfly"
}

local foundGood = false
for _, egg in ipairs(CollectionService:GetTagged("PetEggServer")) do
    if egg:GetAttribute("OWNER") == game.Players.LocalPlayer.Name then
        local petName = eggPets[egg:GetAttribute("OBJECT_UUID")]
        print(petName, "Review")
        if table.find(wantList, petName) then
            Instance.new("Highlight", egg)
            sendPetEmbed(petName)
            foundGood = true
            break
        end
    end
end

if not foundGood then
    --queue_on_teleport("loadstring(game:HttpGet('https://pastebin.com/raw/GKkSPxnn'))()")
    task.wait(5)
    TeleportService:Teleport(game.PlaceId)
end
