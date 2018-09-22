local blips = {
    -- Example {title="", colour=, id=, x=, y=, z=},
	{title="Drug Lab", color=2, id=140, x=-77.722381591797, y=6223.626953125, z=31.089864730835},
	{title="Club", colour=48, id=121, x=-1395.9016113281, y=-607.93939208984, z=30.319543838501},
	{title="Nite Club", colour=3, id=121, x=-346.18237304688, y=165.31571960449, z=86.390754699707},
	{title="Club", colour=48, id=121, x=-1395.9016113281, y=-607.93939208984, z=30.319543838501},
	{title="Beach Bar", colour=47, id=102, x=1374.25, y=-2711.89, z=2.31},
	{title="Garage", colour=30, id=50, x = 69.852645874023, y = 117.0472946167, z = 79.126907348633}, -- UPS Garage
	{title="Garage", colour=30, id=50, x = 907.38049316406, y = -175.86546325684,z = 74.130157470703}, -- UBER Garage
	{title="Garage", colour=30, id=50, x = 1508.8854980469,y = 3908.5732421875,z = 30.031631469727}, -- Fishing Garage
	{title="Garage", colour=30, id=50, x = -319.82263183594, y = -942.8408203125,z = 31.080617904663}, -- Medical Weed Garage
	{title="Garage", colour=30, id=50, x = 222.68756103516,y = 222.95631408691,z = 105.41331481934}, -- Bank Driver Garage
	{title="Garage", colour=30, id=50, x = 401.42602539063, y = -1631.7053222656,z = 29.291942596436}, -- Mechanic Garage
	{title="Garage", colour=30, id=50, x = 964.514770507813, y = -1020.13879394531,z = 40.8475074768066}, -- Delivery Garage
	{title="Garage", colour=30, id=50, x = -1900.7344970703, y = -560.89245605469, z = 11.802397727966}, -- Lawyer Garage
  }

Citizen.CreateThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.9)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)
