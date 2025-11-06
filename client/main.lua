

local pos = vec4(53.0448, -1894.7394, 21.6000-0.9, 52.7274)

Citizen.CreateThread(function (threadId)
	local garden = Garden:new(pos.xyz, 5,5)

     while true do
          Wait(0)
          garden:update()
	end
end)
