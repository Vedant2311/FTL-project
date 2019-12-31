# FTL-project

Simulating hair and fur is very common in the field of Computer Graphics. One of the main challenges for the simulations of these objects is to guarantee a zero extension in their length, since they are supposed to be non-deformable (Think of how things would be if you pull your hair along their length and they keep elongating like a spring!). One method to solve is problem is an extension of a technique called *Follow the Leader (FTL)* (http://robotics.stanford.edu/~latombe/papers/knotmaking/paper.pdf)

A method for solving this problem of Zero-stretch for dynamic simulations based on the FTL method has been presented as *Dynamic Follow the Leader (DFTL)* (https://matthias-research.github.io/pages/publications/FTLHairFur.pdf). The main issues with the method given in that paper are as follows:

  - It has a lot of artificial damping
  - No proof of correctness was given for this method
  
This work deals with tackling with these problems to improve the DFTL give an algorithm which solves the zero extension problem, is physically accurate (in the limits of the step size time tending to zero) and does not have such high artificial damping

## About the codes

All the codes are built on the same situation of an inextensible thread, assumed as a collection of some *n* number of particles, the distance between each of them to be fixed as *d*. The mass of each particles is *m* and the Gravity is taken as *g*. The user inputs the total number of particles, the time for the simulation, and the step size.

1. **Symplectic_Euler.m**: The system is implemented by the Symplectic Euler time integration. Here, the constraint for the fixed length is not taken into account

2. **FTL_SE.m**: The System is implemented by the Symplectic Euler time Integration, along with taking into consideration the constraint for fixed length of the string by the Follow the Leader method

3. **Backward_Euler.m**: The system is implemented by the Backward Euler time integration. Here, the constraint for the fixed length is not taken into account

4. **CS_BE.m**: The System is implemented by the Backward Euler time Integration, along with taking into consideration the constraint for fixed length of the string by taking gradients and Jacobians (i.e Not by the FTL method). This method is proven to be tending to the real world system in the limits of the step size to be zero

5. **DFTL_Orig.m**: The System is implemented by the Dynamic Follow the Leader Method, as mentioned in the Matthias paper

6. **FTL_new.m**: The new implementation for the DFTL having the property of energy conservation as well

## About the Videos

All the outputs are given on the situation of a thread of length 10m, consisting of 11 particles, with the mass of each particle being 1 Kg. The gravity constant is taken as 9.8 m/s2. The Spring constant is 1000 SI units and the damping constant is 5 SI units. Also, the time step is 0.0005s and the total time for the algorithm to run is 10 seconds. The names of the videos correspond to their respective algorithms. Also, the Default frame rate corresponds to 100 images per frame

## About the new method 

Since it was proved by us that the DFTL method actually converges to the true solution in the limit of the time step tending to 0, irrespective of the value of *s_damping* (this can be assumed by the reader for now), so any linear combination of these methods will also converge to the physical solution in the zero limits.

Now, since the energy of the old DFTL system is decreasing i.e artificially damping, so to prevent that it was tried that if the energy of the system decreases below a fixed threshold value, then the velocities of the system are updated by a FTL method (i.e a DFTL with *s_damping* =0). But then it can happen that the energy of the system would just shoot up, resulting in a very unstable update and that would keep on propagating in the further time steps. So for this issue, an other DFTL was added which would be **more damped** than the original DFTL and thus such unstable spikes would get prevented

This is a basic model with constant parameters. There is no guarantee of the total energy getting conserved, but there is a guarantee of this system performing better than the DFTL for the same set of parameters and a similar computational time (This is because it will only calculate new velocities of the particles in the case of the energy of the system differing a lot from the original energy and that is a very fast step in the DFTL method, as compared to the heavier step of obtaining the new positions). 

It will be interesting to see if this model can guarantee an error bound w.r.t the total energy of the system (if not this model exactly then some modification of it). Also, it is obvious to keep the parameters constant because to keep **variable** parameters, it would require searching and other algorithms for each time step computation to get a closer approximation to the real system and it will get pretty expensive as compared to a single DFTL pass. 
