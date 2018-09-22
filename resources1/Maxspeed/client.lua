Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
	SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), (112.5/2.236936))
    end
end)