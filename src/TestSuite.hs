-- | An executable to run all of the tests
import Test.Framework (defaultMain, testGroup)

-- Modules under test:
import Test.RandomParticle_test as RandomParticle
import Test.RandomValues_test as RandomValues
import Mesh.Tests as Mesh

all_tests = [ testGroup "RandomParticle tests" RandomParticle.tests, 
              testGroup "RandomValue tests"    RandomValues.tests, 
              testGroup "Mesh tests"           Mesh.tests]

main :: IO ()
main = defaultMain all_tests
