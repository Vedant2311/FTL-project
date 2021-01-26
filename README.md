# FTL-project (Results branch)

This branch is majorly regarding the generation of different experimental results for proper analysis of the different methods that were considered. You can find different codes here, that might have been modified slightly as compared to the files in the master branch. But the basic functionality of those codes would still remain the same. The basic details of these different codes are as follows:

## FTL Based methods
1. **DFTL_Orig.m**: Implementation of the Published DFTL method
2. **DFTL_Quad_S.m**: Having a continuously varying s_damping
3. **FTL_Mem.m**: Applying correction on position rather than the velocity
4. **FTL_Mem_1.m**: The same code as above, just that the value of s_damping is specifically set as 1.0 here
5. **DFTL_Quad_Combined.m**: Combining Position as well as Velocity corrections
6. **FTL_combine.m**: Naively combining to DFTL updates to conserve energy
7. **FTL_SE.m**: Implementing FTL using Symplectic Euler
8. **FTL_Mem_Blend.m**: Performs blending between standard FTL method and FTL_Mem

## Other standard methods for comparision
1. **Backward_Euler.m**: Implementing Backward Euler (without constraints)
2. **CS_BE.m**: Implementing Backward Euler (with constraints)
3. **Symplectic_Euler.m**: Implementing Symplectic Euler without constraints
4. **comp.m**: Comparing the simulation of DFTL_Orig and DFTL_Quad.

## Running the Experiments
You can find four different files that were used in the running the experiments as follows:
1. **experiment.m**: A general script for comparing velocities, energies etc.
2. **experiment_accuracy.m**: Performs the accuracy experiments (i.e comparing the methods with the standard constrainted Backward_Euler)
3. **experiment_gt.m**: Generates the plots for DFTL and constraint BE simulations
4. **experiment_simlation.m**: Plots the DFTL, FTL_Mem, and CS_BE simulations

The different images that would be formed can be found in the **results** directory; where corresponding to the directory of each method, the images obtained for the experiment involving that method would be stored. A detailed analysis of all these results can be found in the paper of **FTL_Analysis_results.pdf**

Some standard videos for comparing the simulations could be found in the directory of **Exp_videos**. The plot of **DFTL_BE.webm** was made by the script of **experiment_gt.m**, here the convention is that DFTL_Orig (with s_damping=1) is the Blue string and the CS_BE implementation is the Black string. 

The other plots of **vid_x.webm** can also be found in that directory, where this value of *x* would be the time step of the simulation (in seconds). The color convention here is that: 
```
DFTl_Orig with s=1 => Blue (b)
DFTL_Orig with s=0.9 => Green (g)
FTL_Mem with s=1 => Red (r)
FTL_Mem with s=0.9 => Magenta (m)
CS_BE => Black (k)
```
