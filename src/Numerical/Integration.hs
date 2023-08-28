{-# LANGUAGE ForeignFunctionInterface #-}
module Numerical.Integration
  (integration, example)
  where
import           Foreign.Marshal.Alloc (free, mallocBytes)
import           Foreign.Ptr           (FunPtr, Ptr, freeHaskellFunPtr)
import           Foreign.Storable      (peek, sizeOf)

foreign import ccall safe "wrapper" funPtr
    :: (Double -> Double) -> IO(FunPtr (Double -> Double))

foreign import ccall safe "integration" c_integration
    :: FunPtr (Double -> Double) -> Double -> Double -> Double -> Int
    -> Ptr Double -> Ptr Int -> IO Double

-- | Numerical Integration.
integration :: (Double -> Double)       -- ^ integrand
            -> Double                   -- ^ lower bound
            -> Double                   -- ^ upper bound
            -> Double                   -- ^ desired relative error
            -> Int                      -- ^ number of subdivisions
            -> IO (Double, Double, Int) -- ^ value, error estimate, error code
integration f lower upper relError subdiv = do
  errorEstimatePtr <- mallocBytes (sizeOf (0 :: Double))
  errorCodePtr <- mallocBytes (sizeOf (0 :: Int))
  fPtr <- funPtr f
  result <-
    c_integration fPtr lower upper relError subdiv errorEstimatePtr errorCodePtr
  errorEstimate <- peek errorEstimatePtr
  errorCode <- peek errorCodePtr
  let out = (result, errorEstimate, errorCode)
  free errorEstimatePtr
  free errorCodePtr
  freeHaskellFunPtr fPtr
  return out

example :: IO (Double, Double, Int)
example = integration (\x -> x*x) 0 1 1e-10 200