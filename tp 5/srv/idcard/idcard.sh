#user/bin/bash


machine_name=$(hostnamectl --static)
os=$(cat /etc/os-release | grep NAME | cut -d'"' -f2)
kernel=$(uname -r)
ip=$(ip a | grep inet | grep enp0s | cut -d ' ' -f8)
ramTotal=$( free -h --giga | grep Mem: | tr -s ' ' | cut -d '/' -f1 | cut -d ' ' -f2)
ramFree=$( free -h --giga | grep Mem: | tr -s ' ' | cut -d ' ' -f4)
storage=$(df -h / | grep / | tr -s '[:space:]' | cut -d' ' -f4)
process=$(ps aux --sort=-%mem | tail -n +2 | head -n 5)
cat=$( curl -s https://api.thecatapi.com/v1/images/search | cut -d '"' -f8)
echo "Machine name : $machine_name"
echo "0S $os and kernel version is $kernel"
echo "IP : $ip"
echo "RAM : $ramFree memory available on $ramTotal total memory"
echo "Disk : $storage space left"
echo "Top 5 processes by RAM usage :"
echo "$process" | sed 's/^/- /'
echo "Listening ports :"
ss -tulne | tail -n+2 | while read ss; do
    port=$(echo "$ss" | tr -s ' ' | cut -d ' ' -f5 | grep -v "::" | cut -d ":" -f2)
    protocol=$( echo "$ss" | tr -s ' ' | grep -v "::" | cut -d ' ' -f1)
    program=$(echo "$ss" | tr -s ' ' | cut -d ' ' -f9 | cut -d '/' -f3 | cut -d '.' -f1)
    echo "      - $port $protocol : $program"
done
echo "$PATH" | tr ':' '\n' | while read -r directory; do
    echo "  - $directory"
done
echo "Here is your random cat (jpg file) : $cat"




