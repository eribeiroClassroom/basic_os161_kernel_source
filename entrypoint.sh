#!/bin/sh -l


ls ~/
cd /github/workspace
echo $PATH
export PATH=$PATH:/root/os161/tools/bin
echo $PATH

# Build OS/161 (Kernel-level)
cd kern/conf
./config DUMBVM
cd ../compile/DUMBVM
/root/os161/tools/bin/bmake depend
cd /github/workspace
/root/os161/tools/bin/bmake
cd /github/workspace
/root/os161/tools/bin/bmake install

# Build OS/161 (Userland)
cd /github/workspace
/root/os161/tools/bin/bmake includes
cd /github/workspace
/root/os161/tools/bin/bmake
cd /github/workspace
/root/os161/tools/bin/bmake install

# Run the OS/161 kernel and save the output to a file
cd /root/os161/root/
/root/os161/tools/bin/sys161 kernel q > output.txt 
cat output.txt

the_string=$(grep "DUMBVM" "output.txt")
echo $the_string | grep -oP '.*(?=system version)'
var=$(echo $the_string | grep -oP '.*(?=system version)')

if [ "$var" != "Put-your-group-name-here's" ]
then
    echo "No changes in line containing Put-your-group-name-here's"
    exit 1
fi






