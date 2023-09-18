# numerical-integration

One-dimensional numerical integration using the 
['NumericalIntegration'](https://github.com/tbs1980/NumericalIntegration) C++ library.

___

***Example.*** Integrate x² between 0 and 1 with desired relative error 1e-10 and 
using 200 subdivisions.

```haskell
example :: IO IntegralResult -- value, error estimate, error code
example = integration (\x -> x*x) 0 1 1e-10 200
```