# ChkPnt

ChkPnt tracks the games a player owns or wants, and where they are with each one: what they're playing, what's waiting, and what's done.

## Games and the Collection

**Game**:
One game on one Platform in one kind of copy, as tracked by the player. The same release owned on two Platforms, or as both a Physical and a Digital copy, is two Games.
_Avoid_: Item, title, entry

**Platform**:
Whatever the player files a Game under, named as they choose (e.g. "PS5", "PC", "Steam"). ChkPnt does not enforce a hardware or storefront meaning.
_Avoid_: System, console

**Physical**:
A Game whose copy is a physical product, such as a disc or cartridge. On the Wishlist or Ordered, it is the kind of copy the player intends to own.
_Avoid_: Boxed, disc, format

**Digital**:
A Game whose copy is a download or licence rather than a physical product.
_Avoid_: Format

**Collection**:
Every Game the player owns, divided into Physical and Digital. A Game on the Wishlist or Ordered is not in the Collection.
_Avoid_: Library, owned games

## Status

**Status**:
Where a Game stands for the player. A Game has at most one Status; a Game in the Collection may have none.
_Avoid_: State

**Wishlist**:
The Status of a Game the player wants but has not bought.
_Avoid_: Wish List, wanted

**Ordered**:
The Status of a Game the player has bought but has not yet received.
_Avoid_: Pre-ordered, incoming

**Backlog**:
The Status of a Game the player owns and intends to play but has not started, or has put down meaning to return to. The word means this Status only, not every unplayed Game.
_Avoid_: Pile of shame, to play

**Playing**:
The Status of a Game the player is working through towards an end.
_Avoid_: In progress, active

**Ongoing**:
The Status of a Game with no real end that the player keeps returning to, such as an MMO or a live multiplayer game.
_Avoid_: Frequently played, live service

**Completed**:
The Status of a Game where the player reached the end they cared about, usually the credits. ChkPnt does not track 100% completion.
_Avoid_: Finished, beaten

**Abandoned**:
The Status of a Game the player stopped playing with no intention of returning. A Game the player means to come back to belongs in the Backlog instead.
_Avoid_: On hold, paused, dropped

A Game in the Collection with no Status is simply in the Collection; there is no name for that condition.
_Avoid_: Owned, In Collection (as Status names)

**Status Change**:
The moment a Game took its current Status.
_Avoid_: Date added

## Guides

**Guide**:
Help for playing a specific Game, attached to that Game.
_Avoid_: Walkthrough, FAQ

**Text Guide**:
A Guide downloaded as a file and read in ChkPnt's own reader, which remembers the player's place.
_Avoid_: TXT guide

**Web Guide**:
A Guide kept as a link to a page hosted elsewhere and opened in an embedded browser.
_Avoid_: HTML guide, link guide
