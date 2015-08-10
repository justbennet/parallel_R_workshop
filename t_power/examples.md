## Trial run:  Power analysis for a _t_ test

### One at a time

We'll be looking at power analysis for a two-sided _t_ test.  We start by
generating some data, in this case 30 observations in each group, one with
mean 0 and one with mean 2.5, both with standard deviation of 5.  Then we run
the _t_ test.  See the file ```00t_test.R```.

Is there a discernable difference?  Repeat that after regenerating the data in
```mean.1``` and ```mean.2```.

Try it for a couple of different values of ```n```.

### Many in a row

The next step is to make sure we have the details of running many _t_ tests
and properly calculating the estimated power from them.  See the file
```01simulate.R```.  At this point, it is worth looking ahead to when
we will be repeating this for many combinations of values and to start using
variables for parameters, which is done at the top.

It is good practice to initialize arrays to the appropriate size to receive
data, which we do next.  The core of the simulation is in the ```for```
loop.

    for (i in 1:n.reps) {
      group.1 = rnorm(n=n, mean=mean.1, sd=sd.common)
      group.2 = rnorm(n=n, mean=mean.2, sd=sd.common)
      p.vals[i] = t.test(group.1, group.2)$p.value
    }

Here, the calculation of the _p_ value is being done repeatedly ```n.reps```
times, each time with a newly generated set of random data.  Each time
we run a simulation, we save the _p_ value into the array ```p.vals```.
Finally, at the end, we calculate the estimated power as the fraction
of the _p_values that are below our desired critical value, .05, with
```sum(p.vals <.05)/n.reps)```.

### Defining a function

If we are repeating our repetitions for many values, then it will be more
convenient in the long run to create a function and use it rather than
copying the ```for``` loop.  Using a function will also reduce the chance
of making errors by minimizing the number of things we will have to change
for each combination of parameters.  See file ```02power_function.R```.

All we are really doing here is making it possible to generate some data
sets, calculate the _p_ values for each, and then calculate the estimated
power by using a simple function.  The definition may be the hardest part,
so let us look at it.

    t.power.sim = function(n, n.reps=1000, mean.1=0.0, mean.2=2.5, sd.common=1.0) {
        . . . .
        return(power)
    }

First on that line is the name of the new function, ```t.power.sim```.  We
assign to that name the function about to be defined, which takes five
arguments, as it is defined here.  First, it takes ```n```, the sample
size; next, ```n.reps``` which is given a _default_ value of 1,000.

Assigning a default value can be useful if there are values that are, in
some sense, standard, i.e., that will be used repeatedly in the context of
this function.  When we call the function, if we do not specify a new value
for a named parameter, the default value will be used.

We also set default values for the two group means, ```mean.1``` and
```mean.2```, as well as for the common standard deviation,
```sd.common```.

The dots indicate what actually happens inside the function, which you can
see in the file.  One thing to note there is that we declare the array to
store the _p_ values _inside_ the function, so those values are not visible
outside the function.  Last, the function needs to _return_ something, in
this case, it returns the single value, the estimated power for this set of
simulated samples.

How would you change the definition to enable specification of different
standard deviations for each sample?

We test the function by simply running it once and printing some output.

### Running a simulation many times using ```for```

Now that we have a nice function, we can look at running our simulation for
many sample sizes, as this is what we started out to do.  See the file
```03simulate_n.R```.  Much of this file should be starting to look
familiar.  Here, we are going to run the simulation for samples sizes 20,
25, 30,...,100.  In this case, the values are evenly spaced, but they could
be arbitrary values, or values without a regular pattern.

Many people find the ```for (n in sample.sizes)``` easier to read than
```for (i in 1:n.reps)```, especially if they do not read code regularly.
Inside the loop, we run the power simulation function and save the result
to a temporary variable, ```tmp.power```, which we then append to an array.
Last, we create a data frame from the array of power estimates and the
sample sizes and print the results.

### Running the simulation using ```lapply```

Very little modification is needed to convert from the previous simulation
that uses ```for``` to one that uses ```lapply```.  Instead, we use

    power.list <- lapply(sample.sizes, FUN=t.power.sim,
                         n.reps=1000, mean.1=0.0, mean.2=2.5, sd.common=5.0)

which creates the result list directly instead of us having to calculate
a value and append it.  One other change is needed because the output is
a list instead of an array, and that is to use ```unlist(power.list)```
instead of just ```power.list``` when we create the data frame.

### C




