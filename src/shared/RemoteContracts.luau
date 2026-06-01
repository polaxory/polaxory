--!strict

local RemoteContracts = {}

RemoteContracts.Events = {
	ApproveSupervisorSuggestion = {
		rateLimitPerMinute = 20,
		permission = "PlayerOwnsFactory",
		schema = {
			suggestionId = "string",
		},
	},
	RequestFactorySnapshot = {
		rateLimitPerMinute = 30,
		permission = "PlayerOwnsFactory",
		schema = {},
	},
	ClaimRewardRequested = {
		rateLimitPerMinute = 12,
		permission = "PlayerOwnsRoundReward",
		direction = "client_to_server",
		schema = {
			sessionKey = "string?",
		},
	},
	RunAgainRequested = {
		rateLimitPerMinute = 12,
		permission = "PlayerOwnsRoundReward",
		direction = "client_to_server",
		schema = {
			sessionKey = "string?",
		},
	},
	RoundRewardStateChanged = {
		rateLimitPerMinute = 60,
		permission = "ServerAuthority",
		direction = "server_to_client",
		schema = {
			event = "string",
			sessionKey = "string",
			reward = "table?",
			reason = "string?",
		},
	},
}

function RemoteContracts.get(eventName: string)
	return RemoteContracts.Events[eventName]
end

return RemoteContracts
