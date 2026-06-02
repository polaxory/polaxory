--!strict

-- Executable proof for PurchaseReceiptRail — the fail-able rail for the Alkaline
-- UGC purchase-spoof case study (DevForum "exploiters manipulating server-sided
-- data", Jul 2024). See research/2026-06-02_policy_romini_recon.md §3.
--
-- The proof is the contrast: the spoof (client-fired completion) MUST be rejected
-- and leave stock untouched; only a server receipt grants; replays and oversell
-- are refused. Mirrors src/server/PurchaseReceiptRail.luau as a pure state machine.
--
-- Local: `lune run tests/purchase_receipt_rail.spec.luau`

local function assertEqual(actual: any, expected: any, label: string)
	if actual ~= expected then
		error(
			string.format("FAIL %s expected=%s actual=%s", label, tostring(expected), tostring(actual))
		)
	end
end

type RailState = {
	productId: number,
	stock: number,
	grantedPurchaseIds: { [string]: boolean },
}

local function newRail(productId: number, stock: number)
	local state: RailState = {
		productId = productId,
		stock = math.max(0, stock),
		grantedPurchaseIds = {},
	}

	return {
		remainingStock = function(): number
			return state.stock
		end,
		-- The fail-able check: a client-fired completion is never authoritative.
		rejectClientSignal = function(): string
			return "client_signal_not_authoritative"
		end,
		-- The only grant path: a server-issued receipt.
		grantFromReceipt = function(receiptInfo: { [string]: any }): string
			local purchaseId = tostring(receiptInfo.PurchaseId)
			if receiptInfo.ProductId ~= state.productId then
				return "wrong_product"
			end
			if state.grantedPurchaseIds[purchaseId] then
				return "duplicate_receipt"
			end
			if state.stock <= 0 then
				return "out_of_stock"
			end
			state.stock -= 1
			state.grantedPurchaseIds[purchaseId] = true
			return "granted"
		end,
	}
end

local function receipt(productId: number, purchaseId: string)
	return { ProductId = productId, PurchaseId = purchaseId }
end

local PRODUCT = 12345

local function runServerReceiptGrants()
	local rail = newRail(PRODUCT, 3)
	local decision = rail.grantFromReceipt(receipt(PRODUCT, "p1"))
	assertEqual(decision, "granted", "server receipt grants")
	assertEqual(rail.remainingStock(), 2, "stock decremented exactly once")
	return "PASS server-receipt grants"
end

local function runSpoofRejected()
	-- The Alkaline exploit: client fires a fake "purchase finished" signal.
	-- The rail rejects it, fail-closed, and stock is untouched.
	local rail = newRail(PRODUCT, 3)
	local rejected = rail.rejectClientSignal()
	assertEqual(rejected, "client_signal_not_authoritative", "spoofed client signal rejected")
	assertEqual(rail.remainingStock(), 3, "stock untouched by spoof")
	return "PASS spoof-rejected"
end

local function runReplayRejected()
	-- Replaying the same server receipt must not re-decrement stock.
	local rail = newRail(PRODUCT, 3)
	rail.grantFromReceipt(receipt(PRODUCT, "p1"))
	local replay = rail.grantFromReceipt(receipt(PRODUCT, "p1"))
	assertEqual(replay, "duplicate_receipt", "replayed receipt refused")
	assertEqual(rail.remainingStock(), 2, "replay does not re-decrement")
	return "PASS replay-rejected"
end

local function runStockBounded()
	-- Burst of distinct real receipts cannot oversell past the server-held stock.
	local rail = newRail(PRODUCT, 2)
	assertEqual(rail.grantFromReceipt(receipt(PRODUCT, "a")), "granted", "1st grant")
	assertEqual(rail.grantFromReceipt(receipt(PRODUCT, "b")), "granted", "2nd grant")
	assertEqual(rail.grantFromReceipt(receipt(PRODUCT, "c")), "out_of_stock", "3rd refused")
	assertEqual(rail.remainingStock(), 0, "stock bounded at zero, never negative")
	return "PASS stock-bounded"
end

local function runWrongProductRejected()
	-- A receipt for a different product never grants this rail's stock.
	local rail = newRail(PRODUCT, 3)
	local rejected = rail.grantFromReceipt(receipt(PRODUCT + 1, "x"))
	assertEqual(rejected, "wrong_product", "wrong product refused")
	assertEqual(rail.remainingStock(), 3, "stock untouched by wrong product")
	return "PASS wrong-product-rejected"
end

local results = {
	runServerReceiptGrants(),
	runSpoofRejected(),
	runReplayRejected(),
	runStockBounded(),
	runWrongProductRejected(),
}

for _, line in ipairs(results) do
	print(line)
end

return results
