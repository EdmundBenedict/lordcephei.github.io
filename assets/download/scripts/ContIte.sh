#!/bin/bash
################################################################################
# This script is meant to automatize partially
# the procedures to do a DMFT loop with LMFDMFT.
# A lot of operations still have to be done by hand by the user.
# This is done on purpose to let him/her check the coherence
# of input/output before launching successive jobs.
#
# It has to be launched in the working directory.
# Needed input directories are
# 1) lmfinput,
# 2) qmcinput and
# other directories are created by the script as long as new iterations are made.
#
# In 1) you put all the input files (ctrl, rst, sigm etc...)
# needed for all successive LMFDMFT runs
# You also can put here the submission script for LMFDMFT jobs.
#
# In 2) you put all the input files (PARAMS, Trans.dat)
# and scripts (atom_d.py, broad_sig.f90) needed for all successive CTQMC run.
# You can also put here the submission script for CTQMC jobs.
#
# What this script does is
# a) understand at what iterations of the loop you are (r/w file CurrentIte),
# b) create the directory for your next job (it#_xxxrun) with #=iteration , xxx=lmf/qmc
# c) copy all relevant input file, submission scripts and
#    run all the initialization procedures (e.g.
#    production of actqmc.cix files) needed to launch the job.
#
#        IT DOES NOT SUBMIT ANY JOB, NOR IT POSRPROCESSES OUTPUT FILES
#
###############################################################################


source 'LoopParams.sh'

Counter=1
echo ""                                                 >> $WD/$TFILE
echo "New series of $NIT iterations starts at: `date` " >> $WD/$TFILE

while [ $Counter -le $NIT ]


do

  cd $WD

  ### INPUT ITERATION
  if [ -f $ITEF ]; then
    IT=$( awk '{print $1}' $ITEF)
  else
     IT=0
     #echo -n 'Insert current iteration manually (first=0) : '
     #read IT
     echo $IT > $ITEF
  fi


  ### Create file to monitor Eimp convergence
  EIMPDAT=EimpConverg.dat
  if [ ! -f $EIMPDAT ]; then echo "# it      eimp1.$EXT line 2" > $EIMPDAT; fi



  ### If $IT=='0' then prepares the folder for empty sig.inp
  RUNTYPE='' ; ITQMC=''
  if [ ! -d $S0DIR ]; then
    RUNTYPE='sig0'
    ##  add DMFT tokens to the ctrl file
    echo "DMFT    PROJ=2 NLOHI=$WINDOW BETA=$BETA NOMEGA=$NOMEGA KNORM=0" >> $LMFIN/ctrl_in
    # compiles braod_sig.f90
    cd $QMCIN
    $COMP broad_sig.f90 -o $BRDEXE
    # create folder for empty sig.inp
    cd ../
    mkdir $S0DIR ; cd $S0DIR
    ln -sf ../$LMFIN/ctrl_in          ./ctrl_in    ; cp ctrl_in        ctrl.$EXT
    ln -sf ../$LMFIN/indmfl_in        ./indmfl_in  ; cp indmfl_in      indmfl.$EXT
    ln -sf ../$LMFIN/rsta_spinavg_in    ./rsta_in     ; cp rsta_in         rsta.$EXT
    ln -sf ../$LMFIN/site_in          ./site.$EXT
    ln -sf ../$LMFIN/atparms_in          ./atparms
    ##ln -sf ../$LMFIN/sigm_spinavg_in  ./sigm_in    ; cp sigm_in        sigm.$EXT
    cp     ../$LMFIN/switches-for-lm  .
    cp     ../$LMFIN/$SUBLMF          .
    ./$SUBLMF
    if [ -f sig.inp ]; then echo "empty self-energy created successfully : `date`"; fi
    if [ -f sig.inp ]; then echo "empty self-energy created successfully : `date`" >> $WD/$TFILE ; fi
  else
    ### Decide if LMF or CTQMC  and update CurrentIte
    if [ -d "it$IT"'_qmcrun' -o $IT == '0' ]; then
      ITQMC=$IT  ;   IT=$((IT+1))
      echo $IT > $ITEF
      RUNTYPE='LMF'
    else
      RUNTYPE='QMC'
    fi
    if [ -z $RUNTYPE ]; then echo "ERROR: RUNTYPE NOT DEFINED"; exit; fi
  fi




  #############################
  ###      the LMF run      ###
  #############################
  if [ $RUNTYPE == 'LMF' ]; then
    echo "Counter = $Counter ; DMFT iteration = $IT"
    if [ $IT != '1' ]; then
      SIGDIR="it$ITQMC"'_qmcrun' ; SIGINP="Sig.out.brd"
    else
      SIGDIR=$S0DIR              ; SIGINP="sig.inp"
    fi
    LMFRUN="it$IT"'_lmfrun' ; mkdir $LMFRUN
    cd $LMFRUN
    ln -sf ../$SIGDIR/$SIGINP         ./sig.inp_in ; cp sig.inp_in     sig.inp
    ln -sf ../$LMFIN/ctrl_in          ./ctrl_in    ; cp ctrl_in        ctrl.$EXT
    ln -sf ../$LMFIN/indmfl_in        ./indmfl_in  ; cp indmfl_in      indmfl.$EXT
    ln -sf ../$LMFIN/rsta_spinavg_in    ./rsta_in     ; cp rsta_in         rsta.$EXT
    ln -sf ../$LMFIN/site_in          ./site.$EXT
    ln -sf ../$LMFIN/atparms_in          ./atparms
    ##ln -sf ../$LMFIN/sigm_spinavg_in  ./sigm_in    ; cp sigm_in        sigm.$EXT
    cp     ../$LMFIN/switches-for-lm  .
    cp     ../$LMFIN/$SUBLMF          .

    # Submitting the job
    qsub $SUBLMF
    while [ ! -f delta.$EXT -a ! -f eimp1.$EXT ]; do sleep 300 ; done
    sleep 60
    echo "lmf iteration $IT done : `date`"
    echo "lmf iteration $IT done : `date`"  >> $WD/$TFILE
  fi





  #############################
  ###      the QMC run      ###
  #############################
  if [ $RUNTYPE == 'QMC' ]; then
    INPDIR="it$IT"'_lmfrun'
    STATDIR="it$((IT-1))"'_qmcrun'
    QMCRUN="it$IT"'_qmcrun'        ; mkdir $QMCRUN
    cd $QMCRUN
    echo "...Iteration $IT  ;  create $QMCRUN"
    echo "...Linking and copying input files"
    ln -sf ../$INPDIR/delta.$EXT   ./Delta_in
    cp Delta_in                    ./Delta.inp

    ln -sf ../$INPDIR/eimp1.$EXT   ./Eimp_in
    cp Eimp_in                     ./Eimp.inp

    ln -sf ../$QMCIN/Trans.dat     ./Trans.dat_in
    cp Trans.dat_in                ./Trans.dat
    cp ../$QMCIN/$ATOMEXE          .
    cp ../$QMCIN/PARAMS            .
    cp ../$QMCIN/$SUBQMC           .
    if [ -d ../$STATDIR/statusfiles ]
      then
      echo "...Copying status files from previous iteration"
      mkdir statusfiles
      cp ../$STATDIR/statusfiles/* ./statusfiles/
    else
      echo "...DIRECTORY ../$STATDIR/statusfiles NOT FOUND"
    fi

    echo 0 > CompletedRun


    # RECREATE ACTQMC.CIX AND INFO_ATOM.dat
    module load dmft
    IN=`sed -n '3p' ./Eimp.inp`
    IFS='#' read -ra OP <<< "$IN"
    ./$ATOMEXE J=$J l=2 cx=0.0 OCA_G=False qatom=0 "CoulombF='Ising'" HB2=False "${OP[0]}"


    # UPDATE PARAMS FILE
    echo "...Updating PARAMS file"
    # update ed values
    NLINE=`awk '/Ed/ { print NR ; exit}' PARAMS `
    IN=`sed -n '4p' ./Eimp.inp`
    IFS='#' read -ra ED <<< "$IN"
    sed -i "$NLINE""s/.*/${ED[0]}    # Impurity levels updated by bash script/" PARAMS
    # update mu
    NLINE=`awk '/QMC / { print NR ; exit}' PARAMS `
    IN=`sed -n '5p' ./Eimp.inp`
    IFS='#' read -ra MU <<< "$IN"
    sed -i "$NLINE""s/.*/${MU[0]} # QMC chemical potential by bash script /" PARAMS
    # add U,J,n, and beta
    echo "U    $U"    >> PARAMS
    echo "J    $J"    >> PARAMS
    echo "nf0  $n"    >> PARAMS
    echo "beta $BETA" >> PARAMS

    echo "...DONE"

    # Submitting the job
    qsub $SUBQMC
    while [ ! -h 'Sig.out.brd' -a ! -h 'g_qmc.dat' ]; do sleep 300 ; done
    sleep 60
    echo "qmc iteration $IT done : `date`"
    echo "qmc iteration $IT done : `date`"  >> $WD/$TFILE

    # INCREASE COUNTER
    let Counter=Counter+1

  fi
done
