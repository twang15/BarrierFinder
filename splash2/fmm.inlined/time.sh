rm -f time.txt
rm -f time.txt.reported

for((i=0; i<10; i++))
do

  make clean;make &>log  
  tail -1 log >> time.txt

done

awk '{print $3}' time.txt
