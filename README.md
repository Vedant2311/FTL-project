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

