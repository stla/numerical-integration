{-# LANGUAGE ForeignFunctionInterface #-}
module Numerical.Integration
  (integration, IntegralResult(..))
  where
import           Foreign.Marshal.Alloc (free, mallocBytes)
import           Foreign.Ptr           (FunPtr, Ptr, freeHaskellFunPtr)
import           Foreign.Storable      (peek, sizeOf)
import           Foreign.C             (CDouble(..), CInt(..))               

data IntegralResult = IntegralResult {
  _value :: CDouble,
  _error :: CDouble,
  _code  :: Int
} deriving Show

foreign import ccall safe "wrapper" funPtr
    :: (CDouble -> CDouble) -> IO (FunPtr (CDouble -> CDouble))

foreign import ccall safe "integration" c_integration
    :: FunPtr (CDouble -> CDouble) -> CDouble -> CDouble -> CDouble -> CInt
    -> Ptr CDouble -> Ptr CInt -> IO CDouble

-- | Numerical integration.
integration :: (CDouble -> CDouble)     -- ^ integrand
            -> CDouble                  -- ^ lower bound
            -> CDouble                  -- ^ upper bound
            -> CDouble                  -- ^ desired relative error
            -> CInt                     -- ^ number of subdivisions
            -> IO IntegralResult        -- ^ value, error estimate, error code
integration f lower upper relError subdiv = do
  errorEstimatePtr <- mallocBytes (sizeOf (0 :: CDouble))
  errorCodePtr <- mallocBytes (sizeOf (0 :: CInt))
  fPtr <- funPtr f
  result <-
    c_integration fPtr lower upper relError subdiv errorEstimatePtr errorCodePtr
  errorEstimate <- peek errorEstimatePtr
  errorCode <- fromIntegral <$> peek errorCodePtr
  let out = IntegralResult {_value = result, _error = errorEstimate, _code = errorCode}
  free errorEstimatePtr
  free errorCodePtr
  freeHaskellFunPtr fPtr
  return out
