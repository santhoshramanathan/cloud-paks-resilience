import subprocess

print "Calculating size"

myCmd = 'kubectl top nodes | grep -v NAME'

process = subprocess.Popen(myCmd, stdout=subprocess.PIPE, shell=True)
cpus = 0
mems = 0

while True:
  line = process.stdout.readline()
  if line != '':
      print(line)
      info= line.split()
      cpu = info[1].strip("m")
      mem = info[3].strip("Mi")

      cpus += int(cpu)
      mems += int(mem)
  else:
    break

print ("Total CPU: " + str(cpus) + "m")
print ("Total Mem: " + str(mems) + "Mi")
