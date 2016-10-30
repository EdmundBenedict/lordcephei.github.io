#!/bin/bash

## loop file handling
EIMPDAT='EimpConverg.dat' # to help in monitoring the convergence of the loop
ITEF='CurrentIte'         # to keep trak of the current iteration index
TFILE='LoopTime.dat'      # Keep track of execution time
WD=`pwd`

## LMF file handling
EXT='fe'                    # extension
LMFIN="lmfinput"            # input folder of the lmfdmft runs
SUBLMF='scriptlmf_auto.sh'  # submission script of the lmfdmft runs
S0DIR="siginp0"             # empty self-energy folder

## QMC file handling
QMCIN="qmcinput"            # input folder of the ctqmc runs
SUBQMC='scriptqmc_auto.sh'  # submission script of the ctqmc runs
ATOMEXE='atom_d.py'         # atomic problem solver
BRDEXE='broad_sig.x'        # broadening program
COMP='gfortran'             # fortran compiler for broad_sig.f90
RUNF='CompletedRun'         # to keep trak of numbers of repeated CTQMC runs



# PARAMETERS OF THE CALCULATION
NIT=3
U='5.0'                   # Hubbard U in eV
J='0.8'                   # Hund's coupling in eV
n='6.0'                   # Nominal occupation number of correlated orbitals
BETA='50.0'               # Inverse temperature in eV{^-1}
NOMEGA='2000'             # Number of Matsubara frequencies
WINDOW='4,11'             # Projection window in band index
