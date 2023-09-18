import Numerical.Integration


example :: IO IntegralResult -- value, error estimate, error code
example = integration (\t -> 8 * cos(2*t/(1-t)) / (64*(1-t)**2 + t**2)) 0 1 1e-4 100000

value :: Double -- approx 1.7677e-7
value = exp (-6) * pi / (2 * exp 10)


example' :: IO IntegralResult -- value, error estimate, error code
example' = integration (\t -> 6 * cos(2*t/(1-t)) / (36*(1-t)**2 + t**2)) 0 1 1e-4 50000

value' :: Double -- approx 9.6513e-6 
value' = exp (-6) * pi / (2 * exp 6)


-- Bessel z = 2 :+ 3

j0_re :: IO IntegralResult -- value, error estimate, error code
j0_re = integration (\t -> (cos(2 * sin(t)) * cosh(3*sin(t))) / pi) 0 pi 1e-5 5000

j0_im :: IO IntegralResult -- value, error estimate, error code
j0_im = integration (\t -> -(sin(2 * sin(t)) * sinh(3*sin(t))) / pi) 0 pi 1e-5 5000

