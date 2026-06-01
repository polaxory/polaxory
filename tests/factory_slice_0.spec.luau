-- TestEZ wiring placeholder. These cases are the next executable tests once packages are vendored.

return {
	"TaskContracts rejects unknown task types",
	"Carrier can claim MoveResource and cannot claim ClearJam",
	"Fixer can claim ClearJam and cannot claim MoveResource",
	"ResourceExecutor cannot overdraw source inventory",
	"ResourceExecutor cannot exceed target capacity",
	"SupervisorAgent suggests MoveResource when extractor is full",
}
