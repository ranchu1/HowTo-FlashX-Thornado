# How To Run Flash-X + Thornado
This repository is created for how to run Thornado from Flash-X and view the result.

##  Step by Step Setting up for Flash-X+Thornado

##### 1. Check out Flash-X:

	$git clone git@github.com:Flash-X/Flash-X.git

##### 2. Check out submodules

	$cd Flash-X
	$git submodule update --init

   You should see the sha versions information for weaklib and thornado. 
   For example:

	Submodule path 'lib/thornado/source': checked out '2557cd8d47ef13240e83f8ab60c6721caf13f209'
	Submodule path 'lib/weaklib/source': checked out '7800d09539e242c2b3b92fdca70976cfce8f6070'

   Sometimes you will need to switch to a special feature branch, or check out the latest master branch for the submodules.
   If so, do step 3. If not, go to step 4.

##### 3, (optional) Checkout a special branch/version of submodule

   For example, if you want to checkout the latest thornado master branch, or other feature branch

	$cd lib/thornado/source
	$git checkout [feature_branch_name]
	$git pull
	$cd ../../..

##### 4, (optional) If you need to switch Flash-X to desired branch

	$git checkout [feature_branch_name]

##### 5, Check if you have the right makefile for your machine: `Flash-X/sites/YourMachineName/Makefile.h`
   You can copy other's makefile as a template and make changes for your machine as needed.
   For example, Summit has its makefiles under `sites/summit.olcf.ornl.gov`.

##### 6, Set up your object directory using the default setting up syntax and compile the executable

   ###### Test 1: streaming Doppler shift
   Let's start with something simple, streaming doppler shift test.
   You can use the default setting up syntax by

	$source/Simulation/SimulationMain/StreamingDopplerShift/README

   If you did step 5 correctly, you should see compiling for submodule(s), (thornado for streaming doppler shift test) and

	cp libthornado.a ../../../object
	cp *.mod ../../../include
	+ cd ../../../
	Copying data files: 2 copied
	Copied flash.par as flash.par
	SUCCESS

   and a new directory `doppler_MI_16E_OrderV_1D` be created.
   Go the that object directory and compile the executable:

	$cd doppler_MI_16E_OrderV_1D
	$make -j8

   If everything is compiled correctly, you will see `SUCCESS`.
   You can use the default parameter setting (in flash.par file) and run the executable by

	$./flashx

   The program runs while writing out result to `*.dat` and hdf5 data files.
   A log file `*.log` is also generated.
   If not interruption occurs, the program will run until it hits the walltime, max time (`tmax` in unit of s), or max iteration (`nend`).

   ###### Test 2: relaxation test (on hold on Flash-X)

   ###### Test 3: deleptonization test

##### 7, Check the result

   - ###### Compare with baseline data (sfocu)
     `Flash-X/tools/sfocu` tool

   - ###### View the data

       1. VisIt: https://wci.llnl.gov/simulation/computer-codes/visit
       2. MATLAB: [matlabScripts](matlabScripts)
       3. Jupyter notebook: [jupyterScripts](jupyterScripts)

### Ask For Help
- R. Chu : rchu@vols.utk.edu
