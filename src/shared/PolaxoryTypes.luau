export type ResourceKind = "Ore" | "Plate"
export type StationKind = "Extractor" | "Machine" | "Output"
export type WorkerRole = "Carrier" | "Fixer"
export type TaskState = "Queued" | "Claimed" | "Running" | "Done" | "Failed"

export type Station = {
	id: string,
	kind: StationKind,
	capacity: number,
	inventory: { [ResourceKind]: number },
}

export type Worker = {
	id: string,
	role: WorkerRole,
	stationId: string?,
	currentTaskId: string?,
}

export type FactoryTask = {
	id: string,
	type: string,
	state: TaskState,
	workerId: string?,
	sourceStationId: string?,
	targetStationId: string?,
	resourceKind: ResourceKind?,
	amount: number?,
	reason: string?,
}

export type BlackboardSnapshot = {
	stations: { [string]: Station },
	workers: { [string]: Worker },
	tasks: { [string]: FactoryTask },
	tick: number,
}

return nil
