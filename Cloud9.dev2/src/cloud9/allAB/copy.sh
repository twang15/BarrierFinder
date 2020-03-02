files=(`cat file`)

for f in ${files[@]}
do
  cp ../$f .
done
