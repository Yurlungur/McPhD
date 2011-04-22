{-# LANGUAGE TypeFamilies #-}

{-| An exploratory typeclass for Meshes.
-}
module Mesh.Classes (SpaceMesh (..)) where

import System.Random.Mersenne.Pure64

import Numerics ()
import SpaceTime.Classes

-- | A class for describing operations on meshes.
class SpaceMesh m where
  type MeshCell  m :: *
  type MeshFace  m :: *
  type MeshSpace m :: *
  size           :: m -> Int
  cell_find      :: m -> MeshSpace m -> Maybe (MeshCell m)         -- ^ Potentially O(mesh_size) lookup
  cell_neighbor  :: m -> MeshCell m -> MeshFace m -> MeshCell m    -- ^ Neighbor across a given face
  cell_neighbors :: m -> MeshCell m -> [(MeshFace m, MeshCell m)]  -- ^ All neighbors, with faces
  
  -- | Get the distance to exit a cell, and the face.
  cell_boundary   :: m -> MeshCell m -> MeshSpace m -> MeshFace m -> (Distance s, MeshFace m)
  
  -- | Is the location in the given cell of the mesh.
  is_in_cell      :: m -> MeshCell m -> MeshSpace m -> Bool
  
  -- | Is the location contained in this mesh?
  is_in_mesh      :: m -> MeshSpace m -> Bool
  
  -- | Allow position to be within epsilon of in, as long as direction is pointing inward.
  is_approx_in_cell :: m -> MeshCell m -> MeshSpace m -> Bool

  uniform_sample :: m -> PureMT -> (MeshSpace m, PureMT)

  uniform_sample_cell :: m -> MeshCell m -> PureMT -> (MeshSpace m, PureMT)
  
  
  
