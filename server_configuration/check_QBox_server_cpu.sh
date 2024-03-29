#!/bin/bash

# Usage: ./check_QBox_server_cpu.sh /proc/meminfo

if test $# -ne 1 
   then
   echo "Incorrect invocation of script. Usage: ./check_QBox_server_cpu.sh /proc/cpuinfo"
   exit 1  # Failure
fi

# Required minimum configuration
requiredCPUSpeedInMHz=1000     # 1 GHz

# Check if the CPU has speed >= 1 GHz
# TODO: CRIO_TASK_MODULE_SERVER_CONFIGURATION
    # Tasks:
    # 1) Add the line to populate the variable "cpuSpeedInMHz" with the CPU Speed in MHz.
    #    If there are multiple cores, make sure you filter to pick one to populate "cpuSpeedInMHz"
    #    This solution should work irrespective of number of cores or CPUs.
    # 2) Start the expression to populate the variable with "cat $1" which is the command line filename input. Check the Usage above. 
    # 3) Bash script can only do integer arithmetic. Include additional handling needed to strip the decimal part
    # 4) Execute the script before submission and confirm the output 
n=`cat $1 | grep 'cpu MHz' | cut -d: -f 2 | cut -d . -f 1`
vars=`echo $n | cut -d ' ' -f 1-`
#echo $vars
IFS=' '
read -ra a <<< "$vars"

cpuSpeedInMHz=0
for v in expr ${a[*]}
 do
 v_int=$(($v + 0))
 if test $v_int -ge $cpuSpeedInMHz
  then
  cpuSpeedInMHz=$v_int
 fi
done
#echo $max



if test $cpuSpeedInMHz -ge $requiredCPUSpeedInMHz
   then
   echo "CPU Speed of $cpuSpeedInMHz MHz is sufficient for QBox"
else 
   echo "Error: CPU Speed of $cpuSpeedInMHz MHz is insufficient for QBox"
   exit 1  # Failure
fi

exit 0 # Success
