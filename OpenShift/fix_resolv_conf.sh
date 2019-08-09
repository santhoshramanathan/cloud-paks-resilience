for i in master worker1 worker2 worker3 infra storage1 storage2 storage3
> do
> echo $i
> ssh $i 'echo "namesever 8.8.8.8" >  /etc/origin/node/resolv.conf'
> done
