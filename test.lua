local DirtyTalk = require 'dirtytalk'
local Entity = require 'entity'

local Michael = Entity("Michael")
local Doug    = Entity("Doug")

DirtyTalk:dispatch(3, Entity.Messages.EAT, Michael, { food = 'apple' })
DirtyTalk:dispatch(0, Entity.Messages.EAT, Doug, { food = 'orange' })
DirtyTalk:dispatch(0, Entity.Messages.TALK, Michael, { sender = Doug, respond = true })
DirtyTalk:dispatch(3, Entity.Messages.SLEEP, Doug)

local dt = 1.0
local time = 0
while time < 14.0 do
  print(string.format('%.2f seconds', time))
  DirtyTalk:dispatchDelayedMessages(dt)
  time = time + dt
end
