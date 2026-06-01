--!strict

-- Polaxory Signal Run v0 — Backrooms vertical slice course.
--
-- Builds the minimum liminal-corridor surface a fresh player can use to drive
-- the receipt loop without the test harness:
--
--   round_started     fires when the player crosses the EnterTrigger plate
--   round_completed   fires when the player reaches the ExitTrigger plate
--   reward_granted    fires alongside round_completed (server grants reward)
--   reward_claimed    fires when the player clicks Claim on the reward panel
--   next_round_started fires when the player clicks Run Again
--
-- The UI binding for Claim / Run Again already exists in
-- src/client/RoundCompletionRewardPanel.client.luau. This file only wires
-- the world-side triggers, the corridor geometry, and a thin per-player
-- debounce so a single physical touch produces a single call.
--
-- Aesthetic: yellow-wallpaper walls, tan-carpet floor, gray drop-ceiling
-- with sparse fluorescent point lights. No exterior. Backrooms vertical
-- slice v0, hand-built — the inference-driven generation pipeline that
-- produces this course from a prompt is the next product block, not this
-- commit's scope.

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local RoundCompletionRewards = require(script.Parent:WaitForChild("RoundCompletionRewards"))

local COURSE_FOLDER_NAME = "PolaxoryBackroomsSlice0"
local START_DEBOUNCE_SECONDS = 2
local FINISH_DEBOUNCE_SECONDS = 2

local CORRIDOR_LENGTH = 60
local CORRIDOR_WIDTH = 16
local CORRIDOR_HEIGHT = 10
local WALL_THICKNESS = 1

local FLOOR_COLOR = Color3.fromRGB(180, 156, 96)
local WALL_COLOR = Color3.fromRGB(220, 188, 96)
local CEILING_COLOR = Color3.fromRGB(160, 156, 144)
local LIGHT_COLOR = Color3.fromRGB(255, 244, 210)
local TRIGGER_ENTER_COLOR = Color3.fromRGB(120, 180, 90)
local TRIGGER_EXIT_COLOR = Color3.fromRGB(200, 90, 90)

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

local function makeLabel(text: string, parent: Part, color: Color3)
	local gui = Instance.new("BillboardGui")
	gui.Adornee = parent
	gui.Size = UDim2.fromOffset(260, 80)
	gui.StudsOffset = Vector3.new(0, 5, 0)
	gui.AlwaysOnTop = true
	gui.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 0.25
	label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	label.TextColor3 = color
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.Text = text
	label.Parent = gui
end

local existing = Workspace:FindFirstChild(COURSE_FOLDER_NAME)
if existing ~= nil then
	existing:Destroy()
end

local courseFolder = Instance.new("Folder")
courseFolder.Name = COURSE_FOLDER_NAME
courseFolder.Parent = Workspace

-- Floor: yellowed carpet tile look.
local floor = makePart(
	"Floor",
	Vector3.new(0, 0, 0),
	Vector3.new(CORRIDOR_WIDTH, 1, CORRIDOR_LENGTH),
	FLOOR_COLOR,
	Enum.Material.Fabric
)
floor.Parent = courseFolder

-- Walls: yellow wallpaper running the length of the corridor.
local leftWall = makePart(
	"WallLeft",
	Vector3.new(-(CORRIDOR_WIDTH / 2 + WALL_THICKNESS / 2), CORRIDOR_HEIGHT / 2, 0),
	Vector3.new(WALL_THICKNESS, CORRIDOR_HEIGHT, CORRIDOR_LENGTH),
	WALL_COLOR,
	Enum.Material.Plaster
)
leftWall.Parent = courseFolder

local rightWall = makePart(
	"WallRight",
	Vector3.new(CORRIDOR_WIDTH / 2 + WALL_THICKNESS / 2, CORRIDOR_HEIGHT / 2, 0),
	Vector3.new(WALL_THICKNESS, CORRIDOR_HEIGHT, CORRIDOR_LENGTH),
	WALL_COLOR,
	Enum.Material.Plaster
)
rightWall.Parent = courseFolder

-- End caps so the corridor reads as enclosed, not a tunnel into the void.
local backWall = makePart(
	"WallBack",
	Vector3.new(0, CORRIDOR_HEIGHT / 2, -(CORRIDOR_LENGTH / 2 + WALL_THICKNESS / 2)),
	Vector3.new(CORRIDOR_WIDTH + WALL_THICKNESS * 2, CORRIDOR_HEIGHT, WALL_THICKNESS),
	WALL_COLOR,
	Enum.Material.Plaster
)
backWall.Parent = courseFolder

local frontWall = makePart(
	"WallFront",
	Vector3.new(0, CORRIDOR_HEIGHT / 2, CORRIDOR_LENGTH / 2 + WALL_THICKNESS / 2),
	Vector3.new(CORRIDOR_WIDTH + WALL_THICKNESS * 2, CORRIDOR_HEIGHT, WALL_THICKNESS),
	WALL_COLOR,
	Enum.Material.Plaster
)
frontWall.Parent = courseFolder

-- Drop ceiling: gray tile slab.
local ceiling = makePart(
	"Ceiling",
	Vector3.new(0, CORRIDOR_HEIGHT, 0),
	Vector3.new(CORRIDOR_WIDTH + WALL_THICKNESS * 2, 1, CORRIDOR_LENGTH),
	CEILING_COLOR,
	Enum.Material.SmoothPlastic
)
ceiling.Parent = courseFolder

-- Fluorescent fixtures: tiny neon strips with PointLight, four down the corridor.
local LIGHT_COUNT = 4
local LIGHT_SPACING = CORRIDOR_LENGTH / (LIGHT_COUNT + 1)
for i = 1, LIGHT_COUNT do
	local z = -(CORRIDOR_LENGTH / 2) + LIGHT_SPACING * i
	local fixture = makePart(
		string.format("Light_%d", i),
		Vector3.new(0, CORRIDOR_HEIGHT - 0.55, z),
		Vector3.new(4, 0.1, 1),
		LIGHT_COLOR,
		Enum.Material.Neon
	)
	fixture.Parent = courseFolder

	local light = Instance.new("PointLight")
	light.Color = LIGHT_COLOR
	light.Brightness = 1.8
	light.Range = 18
	light.Shadows = true
	light.Parent = fixture
end

-- Spawn: a recessed plate near the back wall so the player materializes inside the corridor.
local spawn = Instance.new("SpawnLocation")
spawn.Name = "EnterRoom"
spawn.Anchored = true
spawn.CanCollide = true
spawn.Position = Vector3.new(0, 1, -(CORRIDOR_LENGTH / 2) + 4)
spawn.Size = Vector3.new(6, 1, 4)
spawn.Color = FLOOR_COLOR
spawn.Material = Enum.Material.Fabric
spawn.TopSurface = Enum.SurfaceType.Smooth
spawn.BottomSurface = Enum.SurfaceType.Smooth
spawn.Neutral = true
spawn.Parent = courseFolder

-- Triggers: thin painted floor plates. EnterTrigger sits a few studs forward
-- of spawn so the player crosses it as they walk into the corridor.
local enterTrigger = makePart(
	"EnterTrigger",
	Vector3.new(0, 1.05, -(CORRIDOR_LENGTH / 2) + 12),
	Vector3.new(CORRIDOR_WIDTH - 2, 0.2, 3),
	TRIGGER_ENTER_COLOR,
	Enum.Material.Neon
)
enterTrigger.Parent = courseFolder

local exitTrigger = makePart(
	"ExitTrigger",
	Vector3.new(0, 1.05, (CORRIDOR_LENGTH / 2) - 6),
	Vector3.new(CORRIDOR_WIDTH - 2, 0.2, 3),
	TRIGGER_EXIT_COLOR,
	Enum.Material.Neon
)
exitTrigger.Parent = courseFolder

makeLabel("ROOM 0 / ENTER", enterTrigger, Color3.fromRGB(180, 240, 160))
makeLabel("EXIT / CLAIM SIGNAL", exitTrigger, Color3.fromRGB(255, 200, 200))

-- Soften ambient lighting so the fluorescents read as the actual light source.
Lighting.Ambient = Color3.fromRGB(60, 56, 40)
Lighting.OutdoorAmbient = Color3.fromRGB(80, 76, 60)
Lighting.Brightness = 1.2
Lighting.GlobalShadows = true

enterTrigger.Touched:Connect(function(otherPart: BasePart)
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

exitTrigger.Touched:Connect(function(otherPart: BasePart)
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
	"[Polaxory] Backrooms Slice 0 corridor armed:",
	COURSE_FOLDER_NAME,
	"enter=",
	enterTrigger.Name,
	"exit=",
	exitTrigger.Name
)
