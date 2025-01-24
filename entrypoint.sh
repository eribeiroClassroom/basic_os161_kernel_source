#!/bin/bash


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

# Set (or re-set) the HOME variable otherwise 
# GitHub will set it to HOME = "/github/home/"
export HOME="/root"

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
string1=$(echo $the_string | grep -oP '.*(?=system version)')
first_three=${string1:0:3}
echo $first_three

# Template string 
string2="Put"

# Test fails if no changes are detected 
if [ "$first_three" = "$string2" ]; then
  echo "Group-name string wasn't changed"
  exit 1
else
  echo "Group-name string changed"
fi
 





