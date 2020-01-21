import subprocess

print "Calculating size"

myCmd = 'oc get pvc --no-headers'

process = subprocess.Popen(myCmd, stdout=subprocess.PIPE, shell=True)
total = 0

while True:
  line = process.stdout.readline()
  if line != '':
      print(line)
      info= line.split()
      stor = info[3]

      total += int(stor)
  else:
    break

total /= 10**9
print ("Total Storage: " + str(total) + " GB")
