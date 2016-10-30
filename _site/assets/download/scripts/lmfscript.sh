#$ -pe mpislots-verbose 1
#$ -N Fe_lmf
#$ -q LowMemShortterm.q
#$ -cwd

. ~/.bash_profile
module load intel  libxc

#####export PATH=${HOME}/dev/lmto/bld/nonmpi/intel/15.0.2/o:$PATH

source '../LoopParams.sh'

##EXT='fe'
LOGFILE='log'
LMDIR='/users/k1465860/dev/lmto/bld/nonmpi/intel/15.0.2/o'
EXEC='lmfdmft'

U=$U ; n=$n ; J=$J ; Edc=`echo "scale=2;$U*($n-0.5)-$J*(0.5*$n-0.5)" | bc`
##COMMAND="$LMDIR/$EXEC $EXT `cat switches-for-lm` --ldadc=$Edc -job=1 --gprt "
COMMAND="$LMDIR/$EXEC $EXT --gprt --show -vso=0 --rs=2,0 `cat switches-for-lm` --ldadc=$Edc -job=1"

cd `pwd`
cat /tmp/sge.machines.$JOB_ID  >> $LOGFILE
echo " "  >> $LOGFILE
echo "++++++++++++++++++++++++++++++++++++" >> $LOGFILE
echo "++ "                                  >> $LOGFILE
echo "++ WORKDIR = "`pwd`                   >> $LOGFILE
echo "++ LMDIR   = $LMDIR "                 >> $LOGFILE
echo "++ EXT     = $EXT"                    >> $LOGFILE
echo "++ COMMAND = $COMMAND  "              >> $LOGFILE
echo "++ "                                  >> $LOGFILE
echo "++++++++++++++++++++++++++++++++++++" >> $LOGFILE
echo " Start date " `date` >> $LOGFILE
echo " "  >> $LOGFILE


### execution and redirection
$COMMAND  >> $LOGFILE
echo " "  >> $LOGFILE
echo " END date " `date` >> $LOGFILE

### Copy second line of eimp1.ext on EimpConverg.dat
IFS='%'
EIMPS=`awk 'NR==2 {print substr($0,index($0,$2)) }' eimp1.$EXT | cut -f 1 -d ']' | sed -r 's/,/   /g' `
echo "`cat ../CurrentIte`    $EIMPS" >> ../EimpConverg.dat
### Copy electron charge and magnetic moment on MagMomConverg.dat
echo " `cat ../CurrentIte`   `grep 'Electron charge'  log | awk '{print $3"    "$5}'` " >> ../MagMomConverg.dat
unset IFS
