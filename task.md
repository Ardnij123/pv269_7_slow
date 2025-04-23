# Exercise 7

As part of this exercise

- create two WDLs and run them in terra.
- Discuss the results, runtime, cost, and your experience.
- Share which jobs specifically you consider as your final submission.

1) Create a WDL that processes an assembly as an input and outputs the lengths of all gaps
    - (sum of all unknown sequences or Ns).
    - Use grep for counting and allow preemptible.

2) Create a similar WDL but parallelize it to process each sequence within the assembly individually;
    - again report the total number of unknown sequences in the whole assembly.
