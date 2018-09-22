local Police = false
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    if (GetClockHours() <= 6 or GetClockHours() >= 19) and GetPlayerWantedLevel(PlayerId()) ~= 0 then
        ClearPlayerWantedLevel(PlayerId())
    elseif (GetClockHours() >= 7 and GetClockHours() <= 18) and GetPlayerWantedLevel(PlayerId()) ~= 0 then
      if Police == true and GetPlayerWantedLevel(PlayerId()) >=3 and GetRelationshipBetweenGroups(GetHashKey("police"), GetHashKey("PLAYER")) ~= 5 then
		  SetPoliceIgnorePlayer(PlayerId(), false)
      SetRelationshipBetweenGroups(5, GetHashKey("police"), GetHashKey("PLAYER"))
      SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("police"))
      Police = false
      end      
      if Police == false and GetPlayerWantedLevel(PlayerId()) <= 2 then
      SetRelationshipBetweenGroups(4, GetHashKey("police"), GetHashKey("PLAYER"))
      SetRelationshipBetweenGroups(4, GetHashKey("PLAYER"), GetHashKey("police"))
    	SetPoliceIgnorePlayer(PlayerId(), true)
      Police = true
      end
      if Police == true and GetPlayerWantedLevel(PlayerId()) == 0 then
      SetRelationshipBetweenGroups(3, GetHashKey("police"), GetHashKey("PLAYER"))
      SetRelationshipBetweenGroups(3, GetHashKey("PLAYER"), GetHashKey("police"))
    	SetPoliceIgnorePlayer(PlayerId(), false)
      Police = false
      end
    end