Table_Seat_flowersea = {
[1]={id = 1, StandPot = {1.777, 4.114, -15.111}, SeatPot = {1.556, 5.139, -14.587}, Dir = 180},
[2]={id = 2, SeatPot = {2.014, 5.139, -14.51}},
----------
}
setmetatable(Table_Seat_flowersea[2],{__index = Table_Seat_flowersea[1]})
return Table_Seat_flowersea
