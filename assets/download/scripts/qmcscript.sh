#$ -pe mpislots-verbose 20
#$ -N Fe-qmc
#$ -q LowMemShortterm.q
#$ -cwd

. ~/.bash_profile
source '../LoopParams.sh'
echo "=  STARTING DATE : "`date`
module load dmft


CTQMC=`which ctqmc`

# retrieve status files
cd `pwd`
if [ -d statusfiles ] ; then mv statusfiles/* .; fi


export I_MPI_PMI_EXTENSIONS=on
mpirun -machinefile /tmp/sge.machines.$JOB_ID -n $NSLOTS $CTQMC

if [ ! -d statusfiles ] ; then mkdir statusfiles; fi
mv status.* statusfiles


### update CompletedRun index
cd `pwd`
if [ -f $RUNF ]; then IT=$( awk '{print $1+1}' $RUNF); fi
echo $IT > $RUNF

### create beckup directory
BCKDIR="run$IT"
mkdir $BCKDIR
mv *.log *.out *.dat *.err  $BCKDIR
cp PARAMS $BCKDIR ;   echo ' ' >> $BCKDIR/PARAMS
echo "total tasks = $NSLOTS " >> $BCKDIR/PARAMS
mv $BCKDIR/Trans.dat       .
mv $BCKDIR/info_atom_d.dat .
ln -sf $BCKDIR/Gf.out      .

### broad Sigma
cp ../qmcinput/$BRDEXE $BCKDIR
cd $BCKDIR
echo 'Sig.out 150 l "55  20  150" k "1 2 3 4 5"'| ./$BRDEXE > broad.log
ln -sf `pwd`/Sig.out.brd ../

echo "=  ENDING DATE : "`date`
