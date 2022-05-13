Step1,	load modules (Necessary for each login)

	$source module_load_default.sh


-------------------------------------------------
Step2, 	git clone the source code (Optional, Need only ONCE)

	$git clone git@github.com:SOURCE_CODE

	Example 1: $git clone git@github.com:Flash-X/Flash-X.git 


-------------------------------------------------
Step3,	git clone and download the weaklib tables (Optional, Need only ONCE)

	$git clone git@code.ornl.gov:astro/weaklib-tables.git
	$cd ~/weaklib-tables
	$git lfs pull


-------------------------------------------------
Step4,	set up Flash-X environments (Necessary CHECK for EACH TIME)

	$cd ~/Flash-X
	$git pull --recurse-submodules=yes
	$git submodule update --init
	$git submodule update --init source/Grid/GridMain/AMR/Paramesh4/PM4_package

	Go to the feature branch, or checkout the latest committes, as needed:

	- for Flash-X feature branch:

		$git checkout FEATURE_BRANCH

		Example: $git checkout delep_Ov
		
	- for weaklib feature branch:

		$cd lib/weaklib/source; git pull; git checkout FEATURE_BRANCH

		Example: $git checkout master

	- for thornado feature branch:

		$cd lib/thornado/source; git pull; git checkout FEATURE_BRANCH

		Example: $git checkout master


-------------------------------------------------
Step5,	set up a test as needed and compile the executable. Here is an example:

	$cd ~/Flash-X
	$./setup StreamingDopplerShift -auto -1d +cartesian -nxb=16 nE=16 swE=1 nSpecies=1 nNodes=2 nMoments=4 momentClosure=MINERBO thornadoOrder=ORDER_V -parfile=flash.par -objdir=doppler_MI_16E_OrderV_1D
	$cd doppler_MI_16E_OrderV_1D; make -j8

	If the environment is set correctly and the complier does not fail, you should see executable 'flashx' and the parafile 'flash.par'.


-------------------------------------------------
Step6, 	set up a directory on scratch with all the necessary files. Here is an example:

	$cd $MEMBERWORK/ast136
	$mkdir test_dir; cd test_dir
	$cp ~/Flash-X/doppler_MI_16E_OrderV_1D/flashx .
	$cp ~/Flash-X/doppler_MI_16E_OrderV_1D/flash.par .

	Link the tables if you need them:
	$ln -s ~/weaklib-tables/SFHo/LowRes/wl-*.h5 .


-------------------------------------------------
Step7,	write jsub setting files for submitting job or use keyboard input commend.

	Example of jsub setting files is provided in this same folder and here is how to use:

	to submit a job:
	$bsub run_flash_gpu.lsf

	to check the job:
	$jobstat -u USER_NAME

	When the job is finished or ended, you will find all the out put under this same directory.
