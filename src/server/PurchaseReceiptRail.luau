--!strict

-- PurchaseReceiptRail — server-authoritative limited-stock purchase grant.
--
-- CASE STUDY (the issue this rail provably fails):
--   2026 DevForum "exploiters manipulating server-sided data" (Alkaline). A UGC
--   limited drained its entire stock in minutes because the game granted the item
--   on a CLIENT-FIREABLE purchase-completion signal (PromptProductPurchaseFinished):
--   "exploiters could completely bypass the purchase and trick the server into
--   thinking the purchase went through." See research/2026-06-02_policy_romini_recon.md §3.
--
-- THE RAIL (server authority by construction):
--   1. A grant is honored ONLY from a server-authoritative receipt
--      (MarketplaceService.ProcessReceipt — the engine calls it after real payment;
--      the client cannot fire it). Client-fired completion signals are rejected,
--      fail-closed. This is the fail-able check.
--   2. Each receipt grants at most once (idempotent on PurchaseId) — replays don't
--      re-decrement stock.
--   3. Stock is held and decremented server-side, bounded at zero — never oversold.
--
-- This is what Romini et al. *claim* ("no exploitable RemoteEvents") but generate
-- as commentary; here it is mechanically enforced.

local MarketplaceService = game:GetService("MarketplaceService")
local ServerScriptService = game:GetService("ServerScriptService")

local TELEMETRY_FOLDER_NAME = "PolaxoryTelemetryEvents"

local PurchaseReceiptRail = {}

type RailState = {
	productId: number,
	stock: number,
	grantedPurchaseIds: { [string]: boolean },
}

local state: RailState = {
	productId = 0,
	stock = 0,
	grantedPurchaseIds = {},
}

local function emitTelemetry(name: string, payload: { [string]: any })
	local folder = ServerScriptService:FindFirstChild(TELEMETRY_FOLDER_NAME)
	if folder == nil then
		return
	end
	local event = folder:FindFirstChild(name)
	if event ~= nil and event:IsA("BindableEvent") then
		event:Fire(payload)
	end
end

-- Configure the rail with the gated product and its server-held stock ceiling.
function PurchaseReceiptRail.configure(productId: number, stock: number)
	state.productId = productId
	state.stock = math.max(0, stock)
	state.grantedPurchaseIds = {}
end

function PurchaseReceiptRail.remainingStock(): number
	return state.stock
end

-- THE FAIL-ABLE CHECK. A client-fired "I bought it" signal is never authoritative.
-- This is the exact path the Alkaline exploit used; the rail rejects it, fail-closed,
-- and never touches stock. Returns a machine-checkable rejection reason.
function PurchaseReceiptRail.rejectClientSignal(
	player: Player,
	_payload: { [string]: any }?
): string
	local reason = "client_signal_not_authoritative"
	emitTelemetry("PurchaseSpoofRejected", {
		productId = state.productId,
		reason = reason,
	})
	print(string.format("[Polaxory] purchase_spoof_rejected: %s for %s", reason, player.Name))
	return reason
end

-- The ONLY grant path. receiptInfo comes from MarketplaceService.ProcessReceipt,
-- which the engine populates after a real, paid transaction. Returns a string
-- decision ("granted" | "duplicate_receipt" | "wrong_product" | "out_of_stock")
-- so the logic is testable without the Roblox enum.
function PurchaseReceiptRail.grantFromReceipt(receiptInfo: { [string]: any }): string
	local purchaseId = tostring(receiptInfo.PurchaseId)
	local productId = receiptInfo.ProductId

	if productId ~= state.productId then
		return "wrong_product"
	end

	-- Idempotent: a replayed receipt is acknowledged as granted but does NOT
	-- decrement stock again. (Roblox semantics: return PurchaseGranted so the
	-- receipt clears and is not re-prompted.)
	if state.grantedPurchaseIds[purchaseId] then
		return "duplicate_receipt"
	end

	if state.stock <= 0 then
		return "out_of_stock"
	end

	state.stock -= 1
	state.grantedPurchaseIds[purchaseId] = true

	emitTelemetry("PurchaseGranted", {
		productId = state.productId,
		remainingStock = state.stock,
	})
	print(
		string.format(
			"[Polaxory] purchase_granted: product %d, %d left",
			state.productId,
			state.stock
		)
	)
	return "granted"
end

-- Wire the rail as the authoritative receipt processor. Any prior client-trusting
-- grant path should be deleted, not merely supplemented — the rail is fail-closed.
function PurchaseReceiptRail.installReceiptHandler()
	MarketplaceService.ProcessReceipt = function(receiptInfo)
		local decision = PurchaseReceiptRail.grantFromReceipt(receiptInfo)
		if decision == "granted" or decision == "duplicate_receipt" then
			return Enum.ProductPurchaseDecision.PurchaseGranted
		end
		-- Out of stock / wrong product: do not grant, do not consume the receipt,
		-- so Roblox can retry or the player is refunded by the platform.
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	print("[Polaxory] purchase receipt rail installed (server-authoritative)")
end

return PurchaseReceiptRail
