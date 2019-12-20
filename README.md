# FTL-project

Simulating hair and fur is very common in the field of Computer Graphics. One of the main challenges for the simulations of these objects is to guarantee a zero extension in their length, since they are supposed to be non-deformable (Think of how things would be if you pull your hair along their length and they keep elongating like a spring!). One method to solve is problem is an extension of a technique called *Follow the Leader (FTL)* (http://robotics.stanford.edu/~latombe/papers/knotmaking/paper.pdf)

A method for solving this problem of Zero-stretch for dynamic simulations based on the FTL method has been presented as *Dynamic Follow the Leader (DFTL)* (https://matthias-research.github.io/pages/publications/FTLHairFur.pdf). The main issues with the method given in that paper are as follows:

  - It has a lot of artificial damping
  - No proof of correctness was given for this method
  

