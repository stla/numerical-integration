import Numerical.Integration
import Data.Complex 
import Numeric.Integration.TanhSinh

examplex2 :: IO IntegralResult -- value, error estimate, error code
examplex2 = integration (\x -> x*x) 0 1 1e-5 200


example :: IO IntegralResult -- value, error estimate, error code
example = integration (\t -> 8 * cos(2*t/(1-t)) / (64*(1-t)**2 + t**2)) 0 1 1e-4 100000

value :: Double -- approx 1.7677e-7
value = exp (-6) * pi / (2 * exp 10)


example' :: IO IntegralResult -- value, error estimate, error code
example' = integration (\t -> 6 * cos(2*t/(1-t)) / (36*(1-t)**2 + t**2)) 0 1 1e-4 50000

value' :: Double -- approx 9.6513e-6 
value' = exp (-6) * pi / (2 * exp 6)


example'' :: IO IntegralResult -- value, error estimate, error code
example'' = integration (\t -> 5 * cos(2*t/(1-t)) / (25*(1-t)**2 + t**2)) 0 1 1e-4 250000

value'' :: Double -- approx 7.131404e-05
value'' = exp (-6) * pi / (2 * exp 4)

--- tanh-sinh
tanhsinh :: Result
tanhsinh = absolute 1e-6 $ parTrap (\t -> 5 * cos(2*t/(1-t)) / (25*(1-t)**2 + t**2)) 0 1



-- -- Bessel z = 2 :+ 3


-- data Bessel = Bessel { 
--     _result :: Complex CDouble
--   , _errors :: (CDouble, CDouble)
--   , _codes  :: (Int, Int)
-- } deriving Show

-- j0_re :: IO IntegralResult -- value, error estimate, error code
-- j0_re = integration (\t -> (cos(2 * sin(t)) * cosh(3*sin(t))) / pi) 0 pi 1e-5 5000

-- j0_im :: IO IntegralResult -- value, error estimate, error code
-- j0_im = integration (\t -> -(sin(2 * sin(t)) * sinh(3*sin(t))) / pi) 0 pi 1e-5 5000

-- j0 :: Complex CDouble -> IO Bessel
-- j0 z = do
--   let a = realPart z
--       b = imagPart z
--   re <- integration (\t -> (cos(a * sin(t)) * cosh(b * sin(t))) / pi) 0 pi 1e-5 5000
--   im <- integration (\t -> -(sin(a * sin(t)) * sinh(b * sin(t))) / pi) 0 pi 1e-5 5000
--   return Bessel {
--       _result = (_value re) :+ (_value im) 
--     , _errors = (_error re, _error im)
--     , _codes  = (_code re, _code im)
--   }

-- jn :: CDouble -> Complex CDouble -> IO Bessel
-- jn n z = do
--   let a = realPart z
--       b = imagPart z
--   re <- integration (\t -> (cos(a * sin(t) + n * t) * cosh(b * sin(t))) / pi) 0 pi 1e-5 5000
--   im <- integration (\t -> -(sin(a * sin(t) + n * t) * sinh(b * sin(t))) / pi) 0 pi 1e-5 5000
--   return Bessel {
--       _result = (_value re) :+ (_value im) 
--     , _errors = (_error re, _error im)
--     , _codes  = (_code re, _code im)
--   }
