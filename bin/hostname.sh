tty=$1
ssh_parameters=$(ps -t "$tty" -o command= | awk '/ssh/ && !/vagrant ssh/ && !/autossh/ && !/-W/ { $1=""; print $0; exit }')
if [ -n "$ssh_parameters" ]; then
 hostname=$(ssh -G $ssh_parameters 2>/dev/null | awk 'NR > 2 { exit } ; /^hostname / { print $2 }')
 [ -z "$hostname" ] && hostname=$(ssh -T -o ControlPath=none -o ProxyCommand="sh -c 'echo %%hostname%% %h >&2'" $ssh_parameters 2>&1 | awk '/^%hostname% / { print $2; exit }')
 hostname=$(echo "$hostname" | awk '\
 { \
   if ($1~/^[0-9.:]+$/) \
     print $1; \
   else \
     split($1, a, ".") ; print a[1] \
 }')
else
   hostname=$(command hostname -s)
fi

echo "$hostname"