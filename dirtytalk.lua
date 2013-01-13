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
--- PriorityQueue class
-- Required to implement the MessageDispatcher

local PriorityQueue = {}
PriorityQueue.__index = PriorityQueue

function PriorityQueue:new()
  return setmetatable({
    _items = {}
  }, self)
end

function PriorityQueue:push(o)
  for i,v in ipairs(self._items) do
    if o > v then
      table.insert(self._items, i, o)
      return
    end
  end

  table.insert(self._items, o)
end

function PriorityQueue:top()
  return self._items[#self._items]
end

function PriorityQueue:empty()
  return #self._items == 0
end

function PriorityQueue:pop()
  return table.remove(self._items)
end

setmetatable(PriorityQueue, { __call = PriorityQueue.new })

-----------------------------------------------------------------
--- Message class
local Message = {}
Message.__index = Message

function Message:new(dispatchTime, message, receiver, extra)
  return setmetatable({
    message = message,
    dispatchTime = dispatchTime,
    receiver = receiver,
    extra = extra
  }, self)
end

function Message:__tostring()
  return string.format(
    'Message [%s] { Delay = %f, Receiver = %s }',
    self.message, self.dispatchTime, self.receiver)
end

function Message:__lt(o)
  return self.dispatchTime < o.dispatchTime
end

setmetatable(Message, { __call = Message.new })

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
    _queue = PriorityQueue()
  }, self)
end

--- Creates and dispatches the message to the receiving entity
-- Handles both immediate messages and delayed messages
-- NOTE: If you need to respond to the sent message, place the sender in the extra slot
-- @param delay Time until message should be sent
-- @param message Type of message sent
-- @param receiver Receiver of the message
-- @param extra Extra information (single or table)
function MessageDispatcher:dispatch(delay, message, receiver, extra)
  local msg = Message(0, message, receiver, extra)

  if delay <= 0.0 then
    self:_discharge(msg)
  else
    msg.dispatchTime = self._time + delay
    self._queue:push(msg)
  end
end

--- Dispatches delayed Messages
-- CALL ONCE PER FRAME (i.e. during an update loop)
-- @param dt Time between frames
function MessageDispatcher:dispatchDelayedMessages(dt)
  self._time = self._time + dt

  while not self._queue:empty() and
        self._queue:top().dispatchTime < self._time do
    self:_discharge(self._queue:pop())
  end
end

function MessageDispatcher:_discharge(msg)
  msg.receiver:handleMessage(msg)
end

setmetatable(MessageDispatcher, { 
  __call = MessageDispatcher.new,
  __newindex = function () error('Cannot add new field to MessageDispatcher') end
})

local singleton = MessageDispatcher()
return singleton
