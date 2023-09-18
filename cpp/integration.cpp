#define _USE_MATH_DEFINES

#include <iostream> 
#include <cmath>
#include <Eigen/Eigenvalues>
#include <ComputeGaussKronrodNodesWeights.h>
#include <GaussKronrodNodesWeights.h>
#include <Integrator.h>
#include <functional>

extern "C" {

class Integrand {
 private:
  std::function<double(double)> f;

 public:
  Integrand(std::function<double(double)>& f_) : f(f_) {}
  double operator()(const double& x) const { return f(x); }
};

double integration(double f(double),
                   double lower,
                   double upper,
                   double relError,
                   int subdiv,
                   double* errorEstimate,
                   int* errorCode) {
  // Define the integrand.
  std::function<double(double)> f_ = [&](double x) { return f(x); };
  Integrand integrand(f_);
  // Define the integrator.
  Eigen::Integrator<double> integrator(subdiv);
  // Define a quadrature rule.
  Eigen::Integrator<double>::QuadratureRule rule =
      Eigen::Integrator<double>::GaussKronrod201;
  // Define the desired absolute error.
  double absError = 0.0;
  // Integrate.
  double result = integrator.quadratureAdaptive(integrand, lower, upper,
                                                absError, relError, rule);
  *errorEstimate = integrator.estimatedError();
  *errorCode = integrator.errorCode();
  return result;
}
}