module Set1Test where

import           Data.ByteString.Char8 (pack)
import           Hedgehog              (forAll, property, (===))
import qualified Hedgehog.Gen          as Gen
import           Hedgehog.Internal.Gen (MonadGen)
import qualified Hedgehog.Range        as Range
import           Test.Tasty            (TestTree, testGroup)
import           Test.Tasty.Hedgehog   (testProperty)
import           Test.Tasty.HUnit      (testCase, (@?=))

import           Set1                  (bsToHex, canonicalHex, challenge1,
                                        hexToByteString)

test_Set1 :: TestTree
test_Set1 =
  testGroup "Set1" [
    hexTests
  , challenge1Tests
  ]

challenge1Input :: String
challenge1Input = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"

challenge1Expected :: String
challenge1Expected = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

hexString :: MonadGen m => m String
hexString = Gen.list (Range.linear 0 100) Gen.hexit

hexTests :: TestTree
hexTests =
  testGroup "Hex" [
    testProperty "hex round trip" . property $ do
      hs <- canonicalHex <$> forAll hexString
      fmap bsToHex (hexToByteString hs) === Right hs
  , testProperty "ByteString to hex round trip" . property $ do
      bs <- forAll (Gen.bytes (Range.linear 0 1024))
      hexToByteString (bsToHex bs) === Right bs
  ]

challenge1Tests :: TestTree
challenge1Tests =
  testGroup "Challenge1" [
    testCase "Answer" $
      challenge1 challenge1Input @?= Right challenge1Expected
  , testCase "hexToByteString" $
      hexToByteString challenge1Input @?= Right (pack "I'm killing your brain like a poisonous mushroom")
  ]
