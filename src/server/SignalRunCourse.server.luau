--!strict

-- Polaxory Signal Run v0 — minimum graybox course.
--
-- Builds the smallest physical surface a fresh player can use to drive the
-- receipt loop without the test harness:
--
--   round_started     fires when the player first walks onto StartPad
--   round_completed   fires when the player walks onto FinishPad
--   reward_granted    fires alongside round_completed (server grants reward)
--   reward_claimed    fires when the player clicks Claim on the reward panel
--   next_round_started fires when the player clicks Run Again
--
-- The UI binding for Claim / Run Again already exists in
-- src/client/RoundCompletionRewardPanel.client.luau. This file only wires
-- the world-side triggers and a thin per-player debounce so a single
-- physical touch produces a single startRound / completeRound call.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local RoundCompletionRewards = require(script.Parent:WaitForChild("RoundCompletionRewards"))

local COURSE_FOLDER_NAME = "PolaxorySignalRunCourse"
local START_DEBOUNCE_SECONDS = 2
local FINISH_DEBOUNCE_SECONDS = 2

local lastStartByPlayer: { [Player]: number } = {}
local lastFinishByPlayer: { [Player]: number } = {}

local function makePart(
	name: string,
	position: Vector3,
	size: Vector3,
	color: Color3,
	material: Enum.Material
): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = true
	part.Position = position
	part.Size = size
	part.Color = color
	part.Material = material
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	return part
end

local function findPlayerFromTouch(otherPart: BasePart): Player?
	local character = otherPart.Parent
	if character == nil then
		return nil
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid == nil then
		return nil
	end
	return Players:GetPlayerFromCharacter(character)
end

local function shouldFire(now: number, last: number?, debounce: number): boolean
	if last == nil then
		return true
	end
	return (now - last) >= debounce
end

local existing = Workspace:FindFirstChild(COURSE_FOLDER_NAME)
if existing ~= nil then
	existing:Destroy()
end

local courseFolder = Instance.new("Folder")
courseFolder.Name = COURSE_FOLDER_NAME
courseFolder.Parent = Workspace

-- Platform: 60 studs long, 24 wide, thin slab at y = 0.
local platform = makePart(
	"Platform",
	Vector3.new(0, 0, 0),
	Vector3.new(24, 1, 60),
	Color3.fromRGB(120, 120, 130),
	Enum.Material.Concrete
)
platform.Parent = courseFolder

-- SpawnLocation: small blue pad at one end. Roblox auto-handles player spawning.
local spawn = Instance.new("SpawnLocation")
spawn.Name = "PolaxorySpawn"
spawn.Anchored = true
spawn.CanCollide = true
spawn.Position = Vector3.new(0, 1, -22)
spawn.Size = Vector3.new(6, 1, 6)
spawn.Color = Color3.fromRGB(80, 140, 220)
spawn.Material = Enum.Material.Neon
spawn.TopSurface = Enum.SurfaceType.Smooth
spawn.BottomSurface = Enum.SurfaceType.Smooth
spawn.Parent = courseFolder

-- StartPad: green pad a few studs forward of spawn.
local startPad = makePart(
	"StartPad",
	Vector3.new(0, 1, -10),
	Vector3.new(8, 1, 4),
	Color3.fromRGB(60, 200, 120),
	Enum.Material.Neon
)
startPad.Parent = courseFolder

-- FinishPad: red pad at the far end.
local finishPad = makePart(
	"FinishPad",
	Vector3.new(0, 1, 22),
	Vector3.new(8, 1, 4),
	Color3.fromRGB(220, 80, 60),
	Enum.Material.Neon
)
finishPad.Parent = courseFolder

-- Two thin sign labels so a fresh player can orient without docs.
local function makeLabel(text: string, parent: Part, color: Color3)
	local gui = Instance.new("BillboardGui")
	gui.Adornee = parent
	gui.Size = UDim2.fromOffset(220, 60)
	gui.StudsOffset = Vector3.new(0, 4, 0)
	gui.AlwaysOnTop = true
	gui.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 0.3
	label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	label.TextColor3 = color
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.Text = text
	label.Parent = gui
end

makeLabel("START", startPad, Color3.fromRGB(60, 220, 120))
makeLabel("FINISH", finishPad, Color3.fromRGB(220, 100, 80))

startPad.Touched:Connect(function(otherPart: BasePart)
	local player = findPlayerFromTouch(otherPart)
	if player == nil then
		return
	end
	local now = os.clock()
	if not shouldFire(now, lastStartByPlayer[player], START_DEBOUNCE_SECONDS) then
		return
	end
	lastStartByPlayer[player] = now
	RoundCompletionRewards.startRound(player)
end)

finishPad.Touched:Connect(function(otherPart: BasePart)
	local player = findPlayerFromTouch(otherPart)
	if player == nil then
		return
	end
	local now = os.clock()
	if not shouldFire(now, lastFinishByPlayer[player], FINISH_DEBOUNCE_SECONDS) then
		return
	end
	lastFinishByPlayer[player] = now
	RoundCompletionRewards.completeRound(player)
end)

Players.PlayerRemoving:Connect(function(player: Player)
	lastStartByPlayer[player] = nil
	lastFinishByPlayer[player] = nil
end)

print(
	"[Polaxory] Signal Run graybox course armed:",
	platform.Name,
	"+",
	startPad.Name,
	"+",
	finishPad.Name
)
