####################
###  Simulate two normal populations n times, run a t test, estimate power
###  by the proportion of simulated results that are less than the desired
###  significance level.

###  Set parameters needed for simulation
set.seed(42)
n = 30; 
mean.1 = 0.0
mean.2 = 2.5
sd.common = 5.0
n.reps = 1000

###  Initialize results vector to zeros
p.vals = rep(0, n.reps)

###  Run n.reps simulations and save p.value for each
for (i in 1:n.reps) {
  group.1 = rnorm(n=n, mean=mean.1, sd=sd.common)
  group.2 = rnorm(n=n, mean=mean.2, sd=sd.common)
  p.vals[i] = t.test(group.1, group.2)$p.value
}

writeLines(c(
    ###  Write the first few p values and what proportion
    ###  were less than .05 to an output file.
    "\n\n",
    "Power calculation summary\n",
    "=========================\n\n",
    "The first five p values from ", n.reps, " simulations\n\n",
    sprintf("%8.4f", p.vals[1:5]), "\n\n",
    "Proportion of simulations where the difference\n",
    "between the means was detected:\n\n",
    sprintf("%8.4f", sum(p.vals <.05)/n.reps), "\n",
    "=========================\n\n",
    "\n\n"),
    "test.out", sep='')

