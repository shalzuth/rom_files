ServantReservationItemData = class("ServantReservationItemData")
function ServantReservationItemData:ctor(serverData)
  self.date = serverData.date
  self.actIDs = serverData.actids
end
