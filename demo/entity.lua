local DirtyTalk = require 'dirtytalk'

local Entity = {}
Entity.__index = Entity

--- Message types
Entity.Messages = {
  EAT = 'EAT',
  TALK = 'TALK',
  SLEEP = 'SLEEP',
  WAKE_UP = 'WAKE_UP'
}

function Entity:new(name)
  return setmetatable({
    name = name
  }, self)
end

function Entity:__tostring()
  return string.format(
    'Entity [%s]',
    self.name)
end

function Entity:handleMessage(msg)
  local s = '[' .. self.name .. ']'
  if msg.message == Entity.Messages.EAT then
    print(s, string.format(
      "I'm really going to chow down on this %s!",
      msg.extra.food))
  elseif msg.message == Entity.Messages.TALK then
    print(s, string.format(
      "Hello, %s!",
      msg.extra.sender.name))
    if msg.extra.respond then
      DirtyTalk:dispatch(0, Entity.Messages.TALK, msg.extra.sender, { sender = self })
    end
  elseif msg.message == Entity.Messages.SLEEP then
    print(s, "Time to go to bed...")
    DirtyTalk:dispatch(10.0, Entity.Messages.WAKE_UP, self)
  elseif msg.message == Entity.Messages.WAKE_UP then
    print(s, "That was a good nap.")
  end
end

return setmetatable(Entity, { __call = Entity.new })
