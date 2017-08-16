tty=$1
 ssh_parameters=$(ps -t "$tty" -o command= | awk '/ssh/ && !/vagrant ssh/ && !/autossh/ && !/-W/ { $1=""; print $0; exit }')
if [ -n "$ssh_parameters" ]; then
 username=$(ssh -G $ssh_parameters 2>/dev/null | awk 'NR > 2 { exit } ; /^user / { print $2 }')
 [ -z "$username" ] && username=$(ssh -T -o ControlPath=none -o ProxyCommand="sh -c 'echo %%username%% %r >&2'" $ssh_parameters 2>&1 | awk '/^%username% / { print $2; exit }')
else
 username=$(ps -t "$tty" -o user= -o pid= -o ppid= -o command= | awk '
   !/ssh/ { user[$2] = $1; ppid[$3] = 1 }
   END {
     for (i in user)
       if (!(i in ppid))
       {
         print user[i]
         exit
       }
   }
 ')
fi

 echo "$username"