import subprocess


myCmd = 'kubectl top nodes | grep -v NAME'

process = subprocess.Popen(myCmd, stdout=subprocess.PIPE, shell=True)
while True:
  line = process.stdout.readline()
  if line != '':
      print(line)
  else:
    break

#while IFS= read -r node
#do
#  echo $node
#  cpu=$(echo $node | awk '{print $2}')
#  mem=$(echo $node | awk '{print $4}')
#  echo $cpu $mem
#done < <()
