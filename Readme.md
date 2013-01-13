# DirtyTalk

## Messaging System for Lua and LOVE

Based on the messaging system from [Programming Game AI by Example](http://www.ai-junkie.com/books/toc_pgaibe.html) by Mat Buckland.

### Example

    local DirtyTalk = require 'dirtytalk'

    -- Simple test Entity class
    -- Only requirement for your entity class is a handleMessage function:
    -- i.e. Entity:handleMessage(msg)
    local Entity = require 'entity'

    local michael = Entity('Michael', 0, 0, 10, 10)
    local doug = Entity('Doug', 50, 50, 10, 10)

    -- Dispatch a delayed message
    DirtyTalk:dispatch(3.0, michael, doug, "TALK")

    -- Dispatch an immediate message
    DirtyTalk:dispatch(0, michael, doug, "STAY")

    -- Dispatch an immediate message with additional information
    DirtyTalk:dispatch(0, doug, michael, "MOVE", { left = 5, up = 10 })

    -- Simulated game loop
    -- Message will be displayed after 3.0 seconds
    local time = 0.0
    while time < 5.0 do
      DirtyTalk:dispatchDelayedMessages(0.5)
      time = time + 0.5
    end
