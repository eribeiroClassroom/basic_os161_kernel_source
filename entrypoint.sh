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
echo $the_string | grep -oP '.*(?=system version)'
var=$(echo $the_string | grep -oP '.*(?=system version)')

string2="Put-your-group-name-here's"

if [[ "$var" == "$string2" ]]; then
  echo "No changes detected in group name string"
  exit 1  # Exit with a non-zero status code to indicate failure
else
  echo "Group-name string was changed"
fi






