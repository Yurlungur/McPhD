module Particle.Null where

import Particle.Classes

data Position  = Position
data Direction = Direction

data NullParticle = NullParticle

position :: NullParticle -> Position
position _ = Position

direction :: NullParticle -> Direction
direction _ = Direction
