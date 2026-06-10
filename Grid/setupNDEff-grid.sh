#!/bin/bash

# we cannot rely on "whoami" in a grid job. We have no idea what the local username will be.
# Use the GRID_USER environment variable instead (set automatically by jobsub).
USERNAME=${GRID_USER}
echo "Got username"

export WORKDIR=${_CONDOR_JOB_IWD} # if we use the RCDS the localProducts area will be placed in $CONDOR_DIR_INPUT
if [ ! -d "$WORKDIR" ]; then
  export WORKDIR=`echo ~`
fi

# _CONDOR_JOB_IWD is /srv
echo "Check work dir _CONDOR_JOB_IWD: ls -l ${_CONDOR_JOB_IWD}"
ls -l ${_CONDOR_JOB_IWD}
cd ${_CONDOR_JOB_IWD}

echo "See where are at: pwd"
pwd

# Copy the untarred folder and remove the CVMFS linked read-only version
# because recompile need to modify files
# which can't be done in the CVMFS read-only version
echo "git clone --recurse-submodules -b EtrimAnalysis https://github.com/mhanrahan27/DUNE_ND_GeoEff.git "
git clone --recurse-submodules -b EtrimAnalysis https://github.com/mhanrahan/DUNE_ND_GeoEff.git
echo "cd ${_CONDOR_JOB_IWD}/DUNE_ND_GeoEff/Grid"
cd ${_CONDOR_JOB_IWD}/DUNE_ND_GeoEff/Grid
echo "source setupsForOsc.sh"
source setupsForOsc.sh
#echo "cmake -DPYTHON_EXECUTABLE:FILEPATH=`which python` ."
#cmake -DPYTHON_EXECUTABLE:FILEPATH=`which python` .
# echo "make -j geoEff"
# make -j geoEff

# echo "cd ${_CONDOR_JOB_IWD}/DUNE_ND_GeoEff/app"
# cd ${_CONDOR_JOB_IWD}/DUNE_ND_GeoEff/app
echo "running Etrim analysis: make "
make
