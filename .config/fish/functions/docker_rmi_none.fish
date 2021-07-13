# Defined via `source`
function docker_rmi_none --wraps='docker rmi (docker images -f dangling=true -q)' --wraps=docker\ rmi\ \(docker\ images\ -f\ \'dangling=true\'\ -q\) --description alias\ docker_rmi_none=docker\ rmi\ \(docker\ images\ -f\ \'dangling=true\'\ -q\)
  docker rmi (docker images -f 'dangling=true' -q) $argv; 
end
