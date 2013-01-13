# DirtyTalk

## Messaging System for Lua and LOVE

Based on the messaging system from [Programming Game AI by Example](http://www.ai-junkie.com/books/toc_pgaibe.html) by Mat Buckland.

### Example

An example can be found the `demo/` directory.

### Documentation

DirtyTalk is a singleton, so every time you require the module, you get the same
instance of it. No need to make a global version.

#### DirtyTalk:dispatch(delay, message, receiver, extra)

Creates messages to be send to other entities. Messages with a delay of 0 will
be sent immediately. *NOTE:* If you need to have a response to this message,
you can use the extra parameter.

- *delay*: Time until message should be sent
- *message*: Type of message sent
- *receiver*: Whom should receive this message
- *extra*: Additional information **OPTIONAL**

#### DirtyTalk:dispatchDelayedMessages(dt)

Checks delayed messages and dispatches them after their delay has passed.
Call this once per frame.

- *dt*: Time between frames
