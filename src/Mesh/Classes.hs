{-# LANGUAGE TypeFamilies, FlexibleContexts #-}

{-| A typeclass for Meshes.

Each mesh is designed for use on a specific space. It defines its own
cell and face indexing schemes. -}

module Mesh.Classes (SpaceMesh (..)
                    , Neighbor (..)
                    , BoundaryCondition (..)) where

import System.Random.Mersenne.Pure64

import Numerics ()
import SpaceTime.Classes

-- | A datatype representing the possible neighbors of a cell.
data Neighbor c = Cell { neighbor_cell :: c }
                | Void -- ^ Edge of the simulation
                | Self -- ^ Cell is it's own neighbor. E.g. reflection
                deriving Show

-- TODO: Ok, this is nice (and much nicer than incorporating the
-- "exceptional" cases in the base type). A typical pattern in Haskell
-- is to use the Either type for situations as this:
--
-- > type Neighbor c = Either NeighborException c
-- > data NeighborException = Void | Same
--
-- This has the advantage that you can make use of the predefined
-- Monad and MonadError instances of the Either type. However, there's
-- nothing wrong with using a dedicated type such as Neighbor, and
-- if you need the instances, you can easily define them yourself.

data BoundaryCondition = Vacuum | Reflection deriving Show

-- | A class for describing operations on meshes.
class (Space (MeshSpace m)) => SpaceMesh m where
  type MeshCell  m :: *
  type MeshFace  m :: *
  type MeshSpace m :: *

  -- | Number of cells in the mesh
  size :: m -> Int

  -- | Potentially O(mesh_size) lookup
  cell_find :: m -> MeshSpace m -> Maybe (MeshCell m)

  -- | Neighbor across a given face
  cell_neighbor :: m -> MeshCell m -> MeshFace m -> Neighbor (MeshCell m)

  -- | All neighbors, with faces
  cell_neighbors :: m -> MeshCell m -> [(MeshFace m, Neighbor (MeshCell m))]

  -- | Get the distance to exit a cell, and the face.
  cell_boundary :: m -> MeshCell m -> MeshSpace m
                   -> (Distance (MeshSpace m), MeshFace m)

  -- | Is the location in the given cell of the mesh?
  is_in_cell :: m -> MeshCell m -> MeshSpace m -> Bool

  -- | Is the location contained in this mesh?
  is_in_mesh :: m -> MeshSpace m -> Bool

  -- | Allow position to be within epsilon of in, as long as direction
  -- is pointing inward.
  is_approx_in_cell :: m -> MeshCell m -> MeshSpace m -> Bool

  -- | Sample a location uniformly thoughout the mesh
  uniform_sample :: m -> PureMT -> (MeshSpace m, PureMT)

  -- | Sample a location unformly in the given cell.
  uniform_sample_cell :: m -> MeshCell m -> PureMT -> (MeshSpace m, PureMT)
