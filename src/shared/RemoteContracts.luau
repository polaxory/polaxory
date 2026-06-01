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
}

function RemoteContracts.get(eventName: string)
	return RemoteContracts.Events[eventName]
end

return RemoteContracts
