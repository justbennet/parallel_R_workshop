####################
###  Simulate two normal populations and run a t test
###

group.1 = rnorm(n=30, mean=0.0, sd=5)
group.2 = rnorm(n=30, mean=2.5, sd=5)

t.stat <- t.test(group.1, group.2)$p.value
cat("The t statistic for this sample was:  ", t.stat, "\n\n")

