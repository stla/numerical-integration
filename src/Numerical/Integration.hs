{-|
Module      : Numerical.Integration
Description : One-dimensional numerical integration.
Copyright   : (c) Stéphane Laurent, 2023
License     : BSD3
Maintainer  : laurent_step@outlook.fr

One-dimensional numerical integration using the 'NumericalIntegration' C++ library.
-}
{-# LANGUAGE ForeignFunctionInterface #-}
module Numerical.Integration
  (integration, IntegralResult(..))
  where
import           Foreign.Marshal.Alloc (free, mallocBytes)
import           Foreign.Ptr           (FunPtr, Ptr, freeHaskellFunPtr)
import           Foreign.Storable      (peek, sizeOf)
import           Foreign.C             (CDouble(..), CInt(..))               

zeroDouble :: Double
zeroDouble = 0.0

-- zeroCDouble :: CDouble
-- zeroCDouble = 0.0

nanDouble :: Double
nanDouble = zeroDouble / zeroDouble

-- nanCDouble :: CDouble
-- nanCDouble = zeroCDouble / zeroCDouble

double2Cdouble :: Double -> CDouble
double2Cdouble = realToFrac

-- cdouble2double :: CDouble -> Double
-- cdouble2double = realToFrac


data IntegralResult = IntegralResult {
  _value :: Double,
  _error :: Double,
  _code  :: Int
} deriving Show

foreign import ccall safe "wrapper" funPtr
    :: (CDouble -> CDouble) -> IO (FunPtr (CDouble -> CDouble))

foreign import ccall safe "integration" c_integration
    :: FunPtr (CDouble -> CDouble) -> CDouble -> CDouble -> CDouble
    -> CDouble -> CInt -> Ptr CDouble -> Ptr CInt -> IO CDouble

-- | Numerical integration.
integration :: (CDouble -> CDouble)   -- ^ integrand
            -> Double                 -- ^ lower bound
            -> Double                 -- ^ upper bound
            -> Double                 -- ^ desired absolute error
            -> Double                 -- ^ desired relative error
            -> Int                    -- ^ number of subdivisions
            -> IO IntegralResult      -- ^ value, error estimate, error code
integration f lower upper absError relError subdiv = do
  errorEstimatePtr <- mallocBytes (sizeOf (0 :: CDouble))
  errorCodePtr <- mallocBytes (sizeOf (0 :: CInt))
  fPtr <- funPtr f
  let lower' = double2Cdouble lower
      upper' = double2Cdouble upper 
      absError' = double2Cdouble absError
      relError' = double2Cdouble relError
      subdiv' = fromIntegral subdiv
  result <-
    c_integration fPtr lower' upper' absError' relError' 
    subdiv' errorEstimatePtr errorCodePtr
  let result' = if isNaN result 
      then nanDouble 
      else realToFrac result
  errorEstimate <- peek errorEstimatePtr
  let errorEstimate' = if isNaN errorEstimate 
      then nanDouble 
      else realToFrac errorEstimate
  errorCode <- fromIntegral <$> peek errorCodePtr
  let out = IntegralResult {_value = result', _error = errorEstimate', _code = errorCode}
  free errorEstimatePtr
  free errorCodePtr
  freeHaskellFunPtr fPtr
  return out
