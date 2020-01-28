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

6. **FTL_combine.m**: The new implementation for the DFTL having the property of energy conservation as well, by combining two different DFTLS and a FTL

## About the Videos

All the outputs are given on the situation of a thread of length 10m, consisting of 11 particles, with the mass of each particle being 1 Kg. The gravity constant is taken as 9.8 m/s2. The Spring constant is 1000 SI units and the damping constant is 5 SI units. Also, the time step is 0.05s and the total time for the algorithm to run is 10 seconds. The names of the videos correspond to their respective algorithms. Also, the Default frame rate corresponds to 100 images per frame

## About the Combine method 

Since it was proved by us that the DFTL method actually converges to the true solution in the limit of the time step tending to 0, irrespective of the value of *s_damping* (this can be assumed by the reader for now), so any linear combination of these methods will also converge to the physical solution in the zero limits.

Now, since the energy of the old DFTL system is decreasing i.e artificially damping, so to prevent that it was tried that if the energy of the system decreases below a fixed threshold value, then the velocities of the system are updated by a FTL method (i.e a DFTL with *s_damping* =0). But then it can happen that the energy of the system would just shoot up, resulting in a very unstable update and that would keep on propagating in the further time steps. So for this issue, an other DFTL was added which would be **more damped** than the original DFTL and thus such unstable spikes would get prevented

This is a basic model with constant parameters. There is no guarantee of the total energy getting conserved, but there is a guarantee of this system performing better than the DFTL for the same set of parameters and a similar computational time (This is because it will only calculate new velocities of the particles in the case of the energy of the system differing a lot from the original energy and that is a very fast step in the DFTL method, as compared to the heavier step of obtaining the new positions). 

It will be interesting to see if this model can guarantee an error bound w.r.t the total energy of the system (if not this model exactly then some modification of it). Also, it is obvious to keep the parameters constant because to keep **variable** parameters, it would require searching and other algorithms for each time step computation to get a closer approximation to the real system and it will get pretty expensive as compared to a single DFTL pass. 

### Issues with this method (and FTL in general)
  
The amount of the Artificial damping depends on the Value of *s_damping* set by the user. Now, for the above method, it was an assumption that the DFTL has a nearly Monotonous behavior in terms of it's energy and that will be mainly **decreasing** for the values of *s_damping > 0* and **increasing** for the *s_damping >= 0*

Now, doing extensive experimental analysis for the given problem set, it was obtained that this kind of Energy pattern is not shown in general. And so, this method automatically would fail for more general cases where the User can decide upon any value of *s_damping* and that can result in the system getting sudden Energy Spikes which would result in the output being very unstable. Thus, this method is not bound to work for arbitary choices of *s_damping* and this is a problem for the **DFTL** method as well. Since, changing the value of *s_damping* (Keeping it positive still), the behavior of the output can get very unstable.

So, an interesting scope of improvement for this method is to find out a small range of the *s_damping* which should be set so that the simulations don't get unstable, as a function of the other parameters of the system (Like the **mass of the particles**, **time step**, **rope length** etc) and having obtained such stable regions, work with them to obtain a better solution. 

Also, another important issue with the method of DFTL is that that it saturates to the veloities of all of it's particles to be in the Vertically Downward direction and that makes the Particles move downwards and get corrected by the DFTL method subsequently. And so there is no overall movements of the particles, but their velocities are not correctly updated by the DFTL and so the system will be saturated to a state of the Horizontal velocities to be in the range of **e-14**, whlie the Verticle velocities will be in the order of **10 - 100**. So, the correct update for the DFTL velocities requires a correct selection for the value of *s_damping*

The MATLAB plots for the Energies of the FTL methods and the comparision plot for the DFTL energies are attached in this folder (Inaccurate to some extent due to the velocity error in the DFTL method but still can give a general overview of the change of the Energies). Also a sample excel file for the velocities of the particles during the course of the simulation has also been included in the folder. You can have a look at it's final values to see how the Y-component of the velocities of the particles never attains a 0 value. The corresponding energy plot is also included. But also, it we keep the value of *s_damping* to be very small, then during convergence, this vertical component of velocities of the particles tends to zero during the steady state

Thus, there is a tradeoff now. Either take the value of **s_damping -> 1** and get a stable behavior (But with large damping and an inaccurate calculation of velocity) OR take the value of **s_damping -> 0** and get a nearly unstable behavior (But with an accurate calculation of the velocities i.e. all the components of the particle velocities will tend to 0 during the steady-state as expected)


