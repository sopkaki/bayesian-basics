data {                      // Data block
  int<lower=1> N;           // Sample size
  int<lower=1> K;           // Dimension of model matrix
  matrix [N, K] X;          // Model Matrix
  vector[N] y;              // Target variable
}

/*
transformed data {          // Transformed data block. Not used presently.
}
*/

parameters {                // Parameters block; declarations only
  vector[K] beta;           // Coefficient vector
  real<lower=0> sigma;      // Error scale
}

model {                     // Model block
  vector[N] mu;
  mu <- X * beta;           // Creation of linear predictor

  // priors
  beta ~ normal(0, 10);
  sigma ~ cauchy(0, 5);     // With sigma bounded at 0, this is half-cauchy

  // likelihood
  y ~ normal(mu, sigma);
}

generated quantities {
  real rss;
  real totalss;
  real<lower=0, upper=1> R2;
  vector[N] mu;

  mu <- X * beta;
  rss <- dot_self(y-mu);
  totalss <- dot_self(y-mean(y));
  R2 <- 1 - rss/totalss;
}