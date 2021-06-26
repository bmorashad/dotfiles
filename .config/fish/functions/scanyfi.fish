# Defined in - @ line 1
function scanyfi --wraps='nmap -sP  192.168.8.0/24' --wraps=scan_connected_ip_on_wifi --description 'alias scanyfi=scan_connected_ip_on_wifi'
  scan_connected_ip_on_wifi  $argv;
end
