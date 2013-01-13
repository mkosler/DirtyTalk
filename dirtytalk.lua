---
-- @copyright Michael Kosler 2013
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software
-- and associated documentation files (the "Software"), to deal in the Software without restriction,
-- including without limitation the rights to use, copy, modify, merge, publish, distribute,
-- sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or substantial
-- portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
-- NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.




-----------------------------------------------------------------
--- Message class
-- Used to pass information between entities
-- DO NOT instantiate this directly,
-- MessageDispatcher will do this for you

local Message = {}
Message.__index = Message

--- Constructor
-- Can also use __call metamethods (i.e. Message(...))
-- @param delay Amount of time to delay the sending of the message, if 0 then send immediately
-- @param senderID Sending entity reference
-- @param receiverID Receiving entity reference
-- @param message Message type
-- @param extraInfo Table of extra information that may be required
function Message:new(delay, senderID, receiverID, message, extraInfo)
  return setmetatable({
    Delay = delay,
    SenderID = senderID,
    ReceiverID = receiverID,
    Message = message,
    ExtraInfo = extraInfo
  }, self)
end

function Message:__tostring()
  return string.format(
    'Message [%s] : { Delay = %f, Sender = %s, Receiver = %s }',
    self.Message, self.Delay, self.SenderDI, self.ReceiverID)
end

setmetatable(Message, {
  __call = Message.new,
  __newindex = function () error('Cannot add new field to Message') end
})

-----------------------------------------------------------------
--- MessageDispatcher class
-- A singleton that handles the sending and receiving of Messages

local MessageDispatcher = {}
MessageDispatcher.__index = MessageDispatcher

--- Constructor
-- Can also use __call metamethod (i.e. MessageDispatcher(...))
-- MessageDispatcher is a singleton, so you will not call this method
function MessageDispatcher:new()
  return setmetatable({
    _time = 0,
    _queue = {}
  }, self)
end

--- Creates and dispatches the message to the receiving entity
-- @param delay Amount of time to delay the sending of the message, if 0 then send immediately
-- @param senderID Sending entity reference
-- @param receiverID Receiving entity reference
-- @param message Message type
-- @param extraInfo Table of extra information that may be required
function MessageDispatcher:dispatch(delay, senderID, receiverID, message, extraInfo)
  local msg = Message(0, sender, receiver, message, extraInfo)

  if delay <= 0.0 then
    self:_discharge(msg)
  else
    msg.Delay = self._time + delay

    self._queue[#self._queue + 1] = msg
  end
end

--- Dispatches delayed Messages
-- CALL ONCE PER FRAME (i.e. during an update loop)
-- @param dt Time between frames
function MessageDispatcher:dispatchDelayedMessages(dt)
  self._time = self._time + dt

  while #self._queue > 0 and
        (0 < self._queue[#self._queue].Delay) and
        (self._queue[#self._queue].Delay < self._time) do
    self:_discharge(table.remove(self._queue))
  end
end

function MessageDispatcher:_discharge(msg)
  --msg.Receiver:handleMessage(msg)
end

setmetatable(MessageDispatcher, { 
  __call = MessageDispatcher.new,
  __newindex = function () error('Cannot add new field to MessageDispatcher') end
})

local singleton = MessageDispatcher()
return singleton
