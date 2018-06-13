-- 
-- MpManagerModul - GasStationExtended
-- 
-- @Interface: 1.5.3.1 b1841
-- @Author: LS-Modcompany/kevink98 
-- @Date: 03.06.2018
-- @Version: 1.0.0.0
-- 
-- @Support: LS-Modcompany
-- 

local version = "1.0.0.0 (03.06.2018)";

MpManagerModul = {};
g_debug.write(-2, "load MpManagerModul GasStationExtended %s", version);

function MpManagerModul:load()
	for _,object in pairs(g_currentMission.onCreateLoadedObjects) do
		if object.gasTriggerDirtyFlag ~= nil then
			object.fillFuel = MpManagerModul.fillFuel(object.fillFuel);
		end;
	end;	
	g_mpManager:removeUpdateable(MpManagerModul);
end;

function MpManagerModul.fillFuel(old)
	return function(s, vehicle, ...)
		g_mpManager.moneyStats:setActiveMoneyState(g_mpManager.moneyStats.STATE_GASSTATION);
		local v = vehicle;
		if vehicle.attacherVehicle ~= nil then
			v = vehicle.attacherVehicle;
			if vehicle.attacherVehicle.attacherVehicle ~= nil then
				v = vehicle.attacherVehicle.attacherVehicle;
			end;
		end;		
		g_mpManager.moneyStats.activeMoneyGasStationV = v;
		g_mpManager.moneyStats.activeMoneyGasStationS = s;
		local delta = old(s,vehicle,...);
		if g_mpManager.moneyStats.activeMoneyGasStationVehicles[g_mpManager.moneyStats.activeMoneyGasStationV] ~= nil then
			g_mpManager.moneyStats.activeMoneyGasStationVehicles[g_mpManager.moneyStats.activeMoneyGasStationV].delta = g_mpManager.moneyStats.activeMoneyGasStationVehicles[g_mpManager.moneyStats.activeMoneyGasStationV].delta + delta;			
		end;	
		g_mpManager.moneyStats:setActiveMoneyState(g_mpManager.moneyStats.STATE_NONE);
		return delta;
	end;
end;

g_mpManager:addUpdateable(MpManagerModul, MpManagerModul.load);