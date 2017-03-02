if Gold == nil then
	_G.Gold = class({})
end

function Gold:UpdatePlayerGold(unitvar)
	local playerID = UnitVarToPlayerID(unitvar)
	if playerID and playerID > -1 then
		PlayerResource:SetGold(playerID, 0, false)
		local allgold = PlayerTables:GetTableValue("arena", "gold")
		allgold[playerID] = PLAYER_DATA[playerID].SavedGold
		PlayerTables:SetTableValue("arena", "gold", allgold)
	end
end

function Gold:ClearGold(unitvar)
	Gold:SetGold(unitvar, 0)
end

function Gold:SetGold(unitvar, gold)
	local playerID = UnitVarToPlayerID(unitvar)
	PLAYER_DATA[playerID].SavedGold = math.floor(gold)
	Gold:UpdatePlayerGold(playerID)
end

function Gold:ModifyGold(unitvar, gold, bReliable, iReason)
	if gold > 0 then
		Gold:AddGold(unitvar, gold)
	elseif gold < 0 then
		Gold:RemoveGold(unitvar, -gold)
	end
end

function Gold:RemoveGold(unitvar, gold)
	local playerID = UnitVarToPlayerID(unitvar)
	PLAYER_DATA[playerID].SavedGold = math.max((PLAYER_DATA[playerID].SavedGold or 0) - math.ceil(gold), 0)
	Gold:UpdatePlayerGold(playerID)
end

function Gold:AddGold(unitvar, gold)
	local playerID = UnitVarToPlayerID(unitvar)
	PLAYER_DATA[playerID].SavedGold = (PLAYER_DATA[playerID].SavedGold or 0) + math.floor(gold)
	Gold:UpdatePlayerGold(playerID)
end

function Gold:AddGoldWithMessage(unit, gold, optPlayerID)
	local player = optPlayerID and PlayerResource:GetPlayer(optPlayerID) or PlayerResource:GetPlayer(UnitVarToPlayerID(unit))
	SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, unit, math.floor(gold), player)
	Gold:AddGold(optPlayerID or unit, gold)
end

function Gold:GetGold(unitvar)
	local playerID = UnitVarToPlayerID(unitvar)
	return math.floor(PLAYER_DATA[playerID].SavedGold or 0)
end
--lua _G.TEMPTIMER = Timers:CreateTimer(function() for i = 0, 8 do HeroList:GetHero(i):SetModelScale(RandomInt(0, 100) / 10); end return 0.5 end)
--lua Timers:RemoveTimer(TEMPTIMER)
--lua ARENA_SETTINGS.DelaysFromLast = {10}