# numerical-integration

One-dimensional numerical integration using the 
['NumericalIntegration'](https://github.com/tbs1980/NumericalIntegration) C++ library.

___

***Example.*** Integrate x² between 0 and 1 with desired relative error 1e-5 and 
using 200 subdivisions. Exact value: 1/3.

```haskell
example :: IO IntegralResult -- value, error estimate, error code
example = integration (\x -> x*x) 0 1 1e-5 200
-- IntegralResult {_value = 0.3333333333333334, _error = 3.7007434154171895e-15, _code = 0}
```

The error code 0 indicates the success.