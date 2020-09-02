#!/bin/sh

kldload -n cpuctl

if /sbin/sysctl hw.model | grep "AMD" > /dev/null;
then
   echo "Detected AMD Ryzen CPU"

   for x in /dev/cpuctl*; do
      cpucontrol -m 0xc0011022=0x510000 $x
      cpucontrol -m 0xc001102b=0x1808cc16 $x
      cpucontrol -m 0xc0011020=0
      cpucontrol -m 0xc0011021=0x40
   done

   echo "MSR register values for Ryzen applied"

elif /sbin/sysctl hw.model | grep "Intel" > /dev/null;
then
   echo "Detected Intel CPU"

   for x in /dev/cpuctl*; do
     cpucontrol -m 0x1a4=0xf $x
   done

   echo "MSR register values for Intel applied"

else
   echo "No supported CPU detected"
fi
