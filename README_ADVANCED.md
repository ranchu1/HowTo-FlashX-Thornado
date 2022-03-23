# How To Run Flash-X + Thornado (advanced)
This repository is created for run gravitational collapse using Flash-X+thornado.
It assumes you have passed 'How To Run Flash-X + Thornado' test: checked out FLASH5 and weaklib-tables.

	$module load git git-lfs; git lfs install
	$git clone git@code.ornl.gov:astro/weaklib-tables.git
	$cd weaklib-tables; git lfs pull

## Step by Step Setting up for running Flash-X+Thornado on Summit

#### 1. Login in and load necessary modules

	$ssh user@summit.olcf.ornl.gov
	$module purge; module load pgi spectrum-mpi essl netlib-lapack cuda hdf5 git
	$module load git-lfs; git lfs install

#### 2. Go to FLASH5 repository and check out the right branches

	$cd FLASH5-1
	## checkout out FLASH5 feature branch
	$git checkout collapse
	$git submodule update --init
	## checkout weaklib feature branch
	$cd lib/weaklib/source; git checkout dogpu_checks; git pull;
	## checkout thornado feature branch
	$cd ../../thornado/source/; git checkout multispecies_opacities; git pull;
	## back to FLASH5 root directory
	$cd ../../../;

#### 3. Set up object directory and compile the executable
	$./setup DeleptonizationWave -auto -1d +spherical -without-unit=Grid/GridSolvers/Multipole -unit=Grid/GridSolvers/Multipole_new +spark +pm4dev +newMpole -nxb=256 -maxblocks=6000 nE=16 swE=1 nSpecies=6 nNodes=2 nMoments=4 momentClosure=MINERBO thornadoSolver=FIXED_POINT_NESTED_AA thornadoOrder=ORDER_V -with-unit=source/physics/Eos/EosMain/WeakLib +weaklibACC +thornadoACC -objdir=delep1d_Ov_AA_MI_6S
	## compile the executable
	$cd delep1d_Ov_AA_MI_6S; make -j8

#### 4. Editing the parameter files
	$vi flash.par

#### 5. Run the executable like you normally would do on Summit. Here is an example for run with job submitting system
	$
