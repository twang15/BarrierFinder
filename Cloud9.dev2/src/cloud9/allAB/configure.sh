# configure for allAB
while read f; do
  fName=`basename $f`

  #backup
  cp ../$f $fName.bak

  # configure
  cp $fName ../$f
done < file

# compile
make

# experiment

# restore
while read f; do
  fName=`basename $f`

  #backup
  cp $fName.bak ../$f
done < file
