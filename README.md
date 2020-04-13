# FTL-project

Simulating hair and fur is very common in the field of Computer Graphics. One of the main challenges for the simulations of these objects is to guarantee a zero extension in their length, since they are supposed to be non-deformable (Think of how things would be if you pull your hair along their length and they keep elongating like a spring!). One method to solve is problem is an extension of a technique called *Follow the Leader (FTL)* (http://robotics.stanford.edu/~latombe/papers/knotmaking/paper.pdf)

A method for solving this problem of Zero-stretch for dynamic simulations based on the FTL method has been presented as *Dynamic Follow the Leader (DFTL)* (https://matthias-research.github.io/pages/publications/FTLHairFur.pdf). The main issues with the method given in that paper are as follows:

  - No proof of correctness was given for this method
  - The velocity correction term actually gives an improper steady state velocity
  - An improper Energy curve
  - A lot of Artificial damping
  
This work deals with tackling with these problems to improve the DFTL give an algorithm which solves the zero extension problem, is physically accurate (in the limits of the step size time tending to zero) and does not have such high artificial damping

New Approach: Stabilizing Integrators using https://www.cs.utah.edu/~ladislav/dinev18stabilizing/dinev18stabilizing.html

## About the codes

All the codes are built on the same situation of an inextensible thread, assumed as a collection of some *n* number of particles, the distance between each of them to be fixed as *d*. The mass of each particles is *m* and the Gravity is taken as *g*. The user inputs the total number of particles, the time for the simulation, and the step size. 

You can find the codes related to the FTL implementation in the directory **FTL_Codes** and some other standard time-integrator implementations of the given problem in the directory **Other_Codes**

## About the Videos

All the outputs are given on the situation of a thread of length 10m, consisting of 11 particles, with the mass of each particle being 1 Kg. The gravity constant is taken as 9.8 m/s2. The Spring constant is 1000 SI units and the damping constant is 5 SI units. Also, the time step is 0.05s and the total time for the algorithm to run is 8 or 10 seconds. The names of the videos correspond to their respective algorithms. Also, the Default frame rate corresponds to 100 images per frame

But for specifying different values other than the default ones, the following conventions are used:
  
  - TS/TimeStep: The time step for the given simulation result is the value specified after this
  - m: The mass of the particles for the given simulation is the float value given after this
  - r: The distance between consequtive particles on the string is the value described after it
  - S: The damping parameter *s_damping* for the DFTL simulation is the value given after this
  - N: The total number of particles in the string for the simulation (Including the hinged particle)

## About the Quad Method

The DFTL having improper steady state velocities is a very big issue indeed. But, there was also an observation that this method actually converges to the proper values of the velocities if the values of *s_damping* is tending to zero. So, here rather than having a fixed *s_damping*, it is implemented as a function which is going from 0.8 to 0.1 in a continuous manner, thus increasing the energy in the later stages appropriately as well has having the direction and value of the velocities of the particles to be physically consistent. 

The plots and videos for this method as included with their corresponding name. Also, this method seems to have a better performance than the typical DFTL method, though with an assumption that the total time for the Animation is not much more than the time taken for the system to reach the steady state, else the improvement won't be that significantly observable. A comparision for the trace obtained for this method and the trace corresponding to the DFTL with the string of mass 500 grams and length 50 cm is attached in the corresponding folder

Thus, inspite of the unpredictable energy pattern of the DFTL method, since the lower values of *s_damping* are very unstable, we can say that this method will in-general behave better than the DFTL method. Also, it is trivial to say that it will behave **at most** as damped as the original DFTL method. Also, by a thorough experimental analysis, it was found that this method shows a nearly monotnous energy trend, despite of the uneven energy trends in the individual DFTL simulations

## About the Mem Method

Rather than considering the changes in the positions of the other particles and incorporating them in the velocities of each particle, an other approach would be to do the same correction thing, but this time for the PBD positions of each particles. So here, the changes in the positions of the particles during the most recent correction step would be stored (i.e. in the **n-1**th time instant) and these will be used to obtain the **p_n** terms for each particles (i.e. the positions before the correction step)

Note that, this method has the benefit of adding the correction for the uneven mass distribution **prior** to the actual FTL correction step, rather than account for the uneven mass distribution **after** the actual FTL correction step. This has a direct benefit of reporting proper velocities and showing a correct monotonously decreasing energy plot as expected. Also to avoid for the damping, a parameter of *s_damping* is introduced in this method, which is the same as the one in the DFTL method (With the values again being in the range of **0-1**)

An important observation for this method is that it seems to be more damped than the DFTL method, with one reason being the initial increase of Energy in the DFTL plots, which is not seen in the case of this method. Comparision videos are included in the corresponding folder

## Some failed approaches

While trying to find an improvement for the not-so-trivial method, various methods were employed and experimented in the high time step setting, and subsequently compared with the DFTL method. A big hindrance while trying to find any improvements ober this method is the fact that this method is very fast and seems to be performing the minimum computations. Some of the prominent methods developed during this process are as follows:

### Combine Method

Since it was proved by us that the DFTL method actually converges to the true solution in the limit of the time step tending to 0, irrespective of the value of *s_damping* (this can be assumed by the reader for now), so any linear combination of these methods will also converge to the physical solution in the zero limits.

Now, if we assume that the energy of the original DFTL system is decreasing monotonously, then to prevent that it was tried that if the energy of the system decreases below a fixed threshold value, then the velocities of the system are updated by a FTL method (i.e a DFTL with *s_damping* =0). But then it can happen that the energy of the system would just shoot up, resulting in a very unstable update and that would keep on propagating in the further time steps. So for this issue, an other DFTL was added which would be more damped than the original DFTL and thus such unstable spikes would get prevented. As it can be seen, the computational requirements for this method will nearly be the same for the Original DFTL method

Now, it was very trivial to assume that the positive values of *s_damping* will mean a system with monotonously decreasing energy, and monotonously increasing for negative values. Indeed, it was found that the system follows a very vague energy curve (even for the case when *s_damping* equals 1, which was posed in the paper as the theoretical solution for the uneven mass distribution). So, the behavior of the system becomes very unstable and there won't be any guarantee that the system will indeed behave the way we want it to be. Also, because of the sudden shifts in the *s_damping* value, the system seems to be behaving in an unnatural manner

### Quad Combine method

Just like in the **DFTL_Quad** method, the value of *s_damping* is kept to be changing monotonously, it was tried to apply the same principle to the **FTL_Mem** method, where a similar *s_damping* is used, as the multiplying factor for the correction term involved corresponding to the positions of the particles. It was also considered having the velocity correction term as well and varying it's *s_damping* as well

If we refer to the *s_damping* for the positions and velocites as *s_p* and *s_v* respectively, then the following major observations were obtained

  - On decreasing only the *s_v*, having *s_p* as 0 gives the **DFTL_Quad** method
  - On decreasing only the *s_p*, having *s_v* as 0 gives the system which has better performance than **FTL_Mem**, but is still more damped than the DFTL result
  - On decreasing both the *s_v* and *s_p* makes the system much more damped and this has no physical significance either
  - On increasing one and decreasing the other while having their sum to be a constant, simulates a behavior much similar to the one obtained from the DFTL with *s_damping* as the same constant 

Thus, this method could act as a good theoretical improvement over DFTL, just that it will be **at least** as damped as the DFTL method. Also, an other important observation regarding this method was that that the energy plots for the physically feasible implementations of this method were not monotonically decreasing. Rather, they were having a significant increase in the energy in the beginning of the simulation (This jump was kind of negligible for the **DFTL_Quad** method)

### Other methods which will not work for this problem

  - Blending FTL and DFTL (*s_damping* = 1) with varying weights such that the total energy of the system nearly remains constant. This method will have an overhead of finding the weights, thus making the computation much slower

## Summary of all the major methods discussed here

### DFTL_Quad

  - Follows the same proof of correctness as the one for the DFTL method
  - Achieves a proper steady state velocity because of *s_damping* tending to 0 in the last time frames
  - Gets a **nearly** monotonus energy curve most of the times, as observed experimentally
  - Has lesser damping than the DFTL, without getting unstable. 
  - The method looks natural because of continuous varations in the *s_damping*
  
### FTL_Mem

  - Follows a very straightforward proof, since the velocity update is trivial
  - Achieves a proper steady state velocity, because of the **prior** corrections 
  - Monotonously decreases energy for *s_damping*=1. Does not have for lower values of it, since the method then tends to be behaving like the typical FTL
  - More stable and damped than DFTL
  - The method looks natural and behaves much like the DFTL method, but achieves a good theoretical improvement over it
  
### FTL_Combine

  - Follows the same proof of correctness as the one for the DFTL method
  - Does **NOT** achieve a proper steady state velocity
  - Does **NOT** have a proper monotonous Energy curve
  - Has lesser damping than DFTL, but it **may** get unstable in some circumstances because of the unpredictable nature of the DFTL plots
  - The method seems unnatural because of the sudden bursts of Energies involved
  
### DFTL_Quad_Combine

  - The proof for the correctness of this algorithm will be pretty involved in it's general case and so that will need a better mathematical demonstration for it's correctness, a part we are leaving as of now
  - Achieves a proper steady state velocity
  - Does **NOT** follow a monotonous Energy curve and shows a peak in the Energy curve in th beginning
  - More stable and Damped than DFTL (In the physically relevant implementations)
  - The method looks Natural and behaves much like the DFTL method
