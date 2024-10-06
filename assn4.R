assn4 <- function(n = 200, A, omega, w = rep(0, n))
{
#----------------------------------------------------------------------
#  R function to investigate the behavior of the periodogram.
#  Data generated from this function will be from the model
#    x_t = sum_{j=1}^k A[j]*cos{2*pi*omega[j]*(t-1)} + w_t, 
#  for t = 1, ... n, where k is the length of A and omega, and
#  w_t is a noise series. (If no noise is desired, then w = 0.)
#   
#  INPUT: n = a positive integer scalar containing the length of the
#             of the series.  The default is n = 200.
#         A = a nonnegative real vector of length k containing the
#             amplitudes of the frequency components.  The maximum
#             number of amplitudes is four.  The lengths of A and 
#             of omega must be equal.  There is no default.
#         omega = a positive real vector with elements less than or
#             equal to 0.5 containing the frequencies.  The maximum
#             number of frequencies is four.  The lengths of A and
#             of omega must be equal.  There is no default.
#         w = a real vector of length n containing noise to add to
#             sinusoid.  If no noise is desired, w = 0, the default.
#
#  The function assn4.prob1 creates a time plot of x and of the
#  natural logarithm of the standardized periodogram.  The function
#  returns a list containing the following objects.
#  OUTPUT: x = a real vector of length n containing the series.
#          freqs = a real vector of length [n/2]+1 containing the
#              periodogram frequencies.
#          fhat = a real vector of length [n/2]+1 containing the
#              periodogram.
#
#  REQUIRES: External functions below (see STA5362-functions.R).
#         1. perdgm - function to compute the periodogram.
#         2. plotsp - function to plot the natural log of the
#                     standardized periodogram.
#----------------------------------------------------------------------
#  Check user input.
  if(length(A) != length(omega)) 
    stop("\nThe lengths of A and omega must be equal.\n")
  if(min(A) < 0)
    stop("\nAll amplitudes must be nonnegative.\n")
  if(min(omega) <= 0 || max(omega) > 0.5)
    stop("\nAll frequencies must be between 0 and 0.5.\n")
# Compute noise vector, data, and periodogram.
  x <- rep(0, length.out = n)
  k <- length(A)
  for(j in 1:k) 
    x <- x + A[j]*cos(2*pi*omega[j]*(0:(n-1)))
  x <- x + w
  fhat <- perdgm(x)
# Create plots.
  par(mfrow = c(1, 2))
  plot(1:n, x, type = "l", xlab = "t", ylab = expression(x[t]),
       main = "Series Realization")
  plotsp(fhat, n, var(x), main = "Log of Standardized Perioodogram")
# Return realization, periodogram frequencies and values.
  return(list(x = x, freqs = freqs(n), fhat = fhat))
}
