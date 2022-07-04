  functions {
    real icar_normal_lpdf(row_vector phi, int N, int[] node1, int[] node2) {
      return -0.5 * dot_self(phi[node1] - phi[node2])
      + normal_lpdf(sum(phi) | 0, 0.0001 * N);
    }}
data { 
  int<lower=1> T;//number of time periods
  int START;
  int END;
  int<lower=0> N;//number of spatial areas
  int<lower=0> N_edges;
  int<lower=1, upper=N> node1[N_edges];  // node1[i], node2[i] neighbors
  int<lower=1, upper=N> node2[N_edges];  // node1[i] < node2[i]
  int<lower=0>  y[T,N];              // count outcomes
  real  x[73,N];              // sociodem
  matrix [T,N] log_E;
  vector [N] NormICU1[T] ;
  vector [N] VacPop[T] ;
  real<lower=0> scaling_factor;  // scales the variance of the spatial effects
}
transformed data {
  //Providing a matrix with a single index returns the specified row. For instance, if m is a matrix, then m[2] is the second row. 
  int ITER=END-START+1;
}

parameters {
  real <lower = 0> sigma [ITER];
  real beta[1,4];
  real zeta[1];
  real chi[1];
  real beta0[1];
  real<lower=0,upper=1> rho[ITER];
  row_vector[N] phi;
  matrix [ITER,N] theta;
}
transformed parameters {
  
  matrix[1,N] alpha [ITER] ;
  //x dimensions go to 73 
  {
    matrix [ITER,N] convolved_re;
    for(t in START:END) {
      convolved_re[t-START+1] = (sqrt(rho[t-START+1] / scaling_factor) * phi + sqrt(1 - rho[t-START+1]) * theta[t-START+1])*sigma[t-START+1]; 
      alpha[t-START+1][1,1:N]=exp(log_E[t,1:N]+
                                    beta0[1]+to_row_vector(convolved_re[t-START+1])+
                                    beta[1,1]*to_row_vector(x[1])+beta[1,2]*to_row_vector(x[2])+beta[1,3]*to_row_vector(x[3])+
                                    beta[1,4]*to_row_vector(x[4])+
                                    beta[1,5]*to_row_vector(x[5])+
                                    beta[1,6]*to_row_vector(x[5+t-1])+
                                    beta[1,7]*to_row_vector(x[5+ITER+t-1])+
                                    chi[1]*to_row_vector(NormICU1[t-1])+
                                    zeta[1]*to_row_vector(VacPop[t-1])); 
      
    }
    
  }
}
model {
  //index here is 1 for alpha since there is only
  target += poisson_lpmf(y[START,1:N] | alpha[1][1,1:N]);
  
  for(t in START:END){
    sigma[t-START+1]~normal(0,10);}
  
  phi~icar_normal(N,node1,node2);  
  chi[1]~normal(0,10);
  zeta[1]~normal(0,10);
  beta[1]~normal(0,10);
  beta0~normal(0,10);
  rho ~ beta(2, 2);
  for(t in START:END){
    theta[t-START+1] ~ normal(0,1);
    
  }
}
