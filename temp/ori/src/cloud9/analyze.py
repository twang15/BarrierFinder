import sys

length = 0
output = ""

with open("traces.log") as f:
    line = f.readline()

    while line:
        if length < len(line):
            length = len(line)
            output = line
        line = f.readline()

# discard trailing '\n'
output = output[0:len(output)-1]
length = len(output)
 
# decide
#if length == 0:
#    print ("Empty trace: something is wrong!!!")
#    sys.exit(0)
#elif length <= 70:
#    if length%7 == 0:
#        expected = length/7
#    else:
#        print("Error: bad trace: {}".format(output))
#        sys.exit(0)
#else:
#    part2 = length - 70
#    if part2 % 9 == 0:
#        expected = 10 + part2/9
#    else:
#        print("Error: bad trace: {}".format(output))
#        sys.exit(0)

actual = 0
i = 0
barriers = set()

while i < length:
    if output[i].isdigit() and output[i+1] == 'Z':
        if output[i+4] == 'X' and output[i+5] == 'Y' and output[i+6] == 'Y':
            barriers.add(int(output[i]))
            i += 7
            actual += 1
        else:
            print("Error: bad trace: {}".format(output))
            sys.exit(0)
    elif output[i].isdigit() and output[i+1].isdigit() and output[i+2] == 'Z':
        if output[i+6] == 'X' and output[i+7] == 'Y' and output[i+8] == 'Y':
            barriers.add(int(output[i:i+2]))
            i += 9
            actual += 1
        else:
            print("Error: bad trace: {}".format(output))
            sys.exit(0)


print ("Barriers found: {}".format(len(barriers)))
print ("Barriers: {}".format(sorted(barriers)))
print ("Full traces: {}".format(output))
