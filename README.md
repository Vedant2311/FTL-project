# FTL-project

Simulating hair and fur is very common in the field of Computer Graphics. One of the main challenges for the simulations of these objects is to guarantee a zero extension in their length, since they are supposed to be non-deformable (Think of how things would be if you pull your hair along their length and they keep elongating like a spring!). One method to solve is problem is an extension of a technique called *Follow the Leader (FTL)* (http://robotics.stanford.edu/~latombe/papers/knotmaking/paper.pdf)

A method for solving this problem of Zero-stretch for dynamic simulations based on the FTL method has been presented as *Dynamic Follow the Leader (DFTL)* (https://matthias-research.github.io/pages/publications/FTLHairFur.pdf). The main issues with the method given in that paper are as follows:

  - No proof of correctness was given for this method
  - The velocity correction term actually gives an improper steady state velocity
  - An improper Energy curve
  - A lot of Artificial damping
  
This work deals with tackling with these problems to improve the DFTL give an algorithm which solves the zero extension problem, is physically accurate (in the limits of the step size time tending to zero) and does not have such high artificial damping

## About the codes

All the codes are built on the same situation of an inextensible thread, assumed as a collection of some *n* number of particles, the distance between each of them to be fixed as *d*. The mass of each particles is *m* and the Gravity is taken as *g*. The user inputs the total number of particles, the time for the simulation, and the step size. 

You can find the codes related to the FTL implementation in the directory **FTL_Codes** and some other standard time-integrator implementations of the given problem in the directory **Other_Codes**

## About the Videos

All the outputs are given on the situation of a thread of length 10m, consisting of 11 particles, with the mass of each particle being 1 Kg. The gravity constant is taken as 9.8 m/s2. The Spring constant is 1000 SI units and the damping constant is 5 SI units. Also, the time step is 0.05s and the total time for the algorithm to run is 8 or 10 seconds. The names of the videos correspond to their respective algorithms. Also, the Default frame rate corresponds to 100 images per frame. But for specifying different values other than the default ones, the following conventions are used:

  - TS/TimeStep: The time step for the given simulation result is the value specified after this (In s)
  - m: The mass of the particles for the given simulation is the float value given after this (In Kg)
  - r: The distance between consequtive particles on the string is the value described after it (In m)
  - S: The damping parameter *s_damping* for the DFTL simulation is the value given after this
  - N: The total number of particles in the string for the simulation (Including the hinged particle)
  - TotalTime: The total duration of the simulation is speicified after this (In secs)

## Summary of all the new algorithms for FTL

### DFTL_Quad

  - In the update rule of **v<sub>i</sub> = (p<sub>i</sub> - x<sub>i</sub>)/(&Delta;t) + s<sub>damping</sub>(-d<sub>i+1</sub>/&Delta;t)**, the **s<sub>damping</sub>** is varying as **f(t)** (such that it's value is closer to one when t&rarr;0 and closer to zero when t&rarr;T) rather than being a constant as in DFTL_Orig
  - Follows the same proof of correctness as the one for the DFTL method
  - Achieves a proper steady state velocity because of *s_damping* tending to 0 in the last time frames
  - Gets a **nearly** monotonus energy curve most of the times, as observed experimentally
  - Has lesser damping than the DFTL, without getting unstable. 
  - The method looks natural because of continuous varations in the *s_damping*
  - An issue that the value of s_damping is dependant on **t** and not on the **x,v** which makes it less flexible to external impulses or sudden external motions or interrupts given by the user
  
### FTL_Mem

  - Rather than the velocity correction equation **v<sub>i</sub> = (p<sub>i</sub> - x<sub>i</sub>)/(&Delta;t) + s<sub>damping</sub>(-d<sub>i+1</sub>/&Delta;t)** as used in the original implementation of DFTL, the correction is added to the position update, which becomes: **p<sub>i</sub> = x<sub>i</sub> + v<sub>i</sub>&Delta;t + f<sub>i</sub>(&Delta;t)<sup>2</sup> - s<sub>damping</sub>(d<sub>i+1</sub> + d<sub>i</sub>)/2**
  - Has this benefit of theoretical soundness because of doing the corrections **prior** to the FTL-update as compared to the DFTL implementation which does this correction **posterior** to the FTL-update
  - Follows a very straightforward proof, since the velocity update is trivial (**v<sub>i</sub> = (p<sub>i</sub> - x<sub>i</sub>)/(&Delta;t)**)
  - Achieves a proper steady state velocity, because of the **prior** corrections 
  - Monotonously decreases energy for *s_damping*=1. Does not have for lower values of it, since the method then tends to be behaving like the typical FTL
  - More stable and damped than DFTL
  - The method looks natural and behaves much like the DFTL method, but achieves a good theoretical improvement over it
  
### FTL_Combine
  
  - A DFTL **D<sub>1</sub>** (with *s_damping* as s<sub>1</sub>) is run and the total energy of the system **E<sub>total</sub>** is calculated and then it is compared with the initial Energy **E<sub>0</sub>** and then we check for **|E<sub>total</sub>-E<sub>0</sub>| < C**: if it's true then we continue with the next time-step, else we run the DFTL **D<sub>2</sub>** (with *s_damping* as s<sub>2</sub>) which will be unstable in nature and will help to increase the energy
  - Follows the same proof of correctness as the one for the DFTL method
  - Does **NOT** achieve a proper steady state velocity
  - Does **NOT** have a proper monotonous Energy curve
  - Has lesser damping than DFTL, but it **may** get unstable in some circumstances because of the unpredictable nature of the DFTL plots
  - The method seems unnatural because of the sudden bursts of Energies involved
  
### DFTL_Quad_Combine

  - Combining the principles of **DFTL_Mem** and **DFTL_Quad** and having both the position and velocity corrections as well as their corresponding coefficients (**s<sub>p</sub>** and **s<sub>v</sub>** respectvely) being time-varying as per the corresponding functions **f<sub>p</sub>(t)** and **f<sub>v</sub>(t)** respectively
  - The proof for the correctness of this algorithm will be pretty involved in it's general case and so that will need a better mathematical demonstration for it's correctness, a part we are leaving as of now
  - Achieves a proper steady state velocity
  - Does **NOT** follow a monotonous Energy curve and shows a peak in the Energy curve in th beginning
  - More stable and Damped than DFTL (In the physically relevant implementations)
  - The method looks Natural and behaves much like the DFTL method

### DFTL_Blend
  
  - Blending two different DFTLs with s_damping=0 and s_damping=1 respectively, as per applying binary search on a parameter &alpha; as described in https://www.cs.utah.edu/~ladislav/dinev18stabilizing/dinev18stabilizing.html
  - But it is **NOT** possible to blend two different DFTLs since both of them will be satisfying the string length constraints, and so for their blend to also satisfy this constraint; we would require that &alpha; is either 0 or 1
