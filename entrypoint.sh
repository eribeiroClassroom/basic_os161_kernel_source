#!/bin/sh -l


ls ~/
cd /github/workspace
echo "Original PATH variable in the container"
echo $PATH

echo "Updated PATH variable in the container"
export PATH=$PATH:/root/os161/tools/bin
echo $PATH

echo "Configuring OS/161"
cd kern/conf
./config DUMBVM

echo "Building OS/161 (Kernel-level)"
cd ../compile/DUMBVM
/root/os161/tools/bin/bmake depend
/root/os161/tools/bin/bmake

export HOME="/root/os161/root"

/root/os161/tools/bin/bmake install

echo "List of files in the directory"
ls -l 

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
# var=$(echo $the_string | grep -oP '.*(?=system version)')

# if [ "$var" != "Put-your-group-name-here's" ]
# then
#     echo "No changes in line containing Put-your-group-name-here's"
#     exit 1
# fi






