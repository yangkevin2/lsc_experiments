# lsc_experiments
Scripts for running lsc model (from https://pubs.rsc.org/en/Content/ArticleLanding/2018/SC/c8sc00148k) on other datasets. 
Also contains scripts for running many experiments using the chemprop model and other baselines. 

Note that you need to initialize the lsc and chemprop submodules using "git submodule update --init --recursive"

Install requirements by running "source install.sh" from the scripts directory, which gives you the necessary conda envs. 

You can then run "source main.sh" from the scripts directory with the required arguments; see that file for details. This runs the Mayr model.
You can also run "source main2.sh" from the scripts directory with the required arguments to run the chemprop model and most baselines. 
The random forest baselines can be run by "source main2_rf.sh" from the scripts directory with the required arguments. 

Note: if you see an error about "rm: cannot remove ... " in run_model.sh (called from main.sh after generating features and splits) you can safely ignore it. 