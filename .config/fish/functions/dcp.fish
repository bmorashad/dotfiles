# Defined via `source`
function dcp --wraps=docker-compose --description 'alias dcp=docker-compose'
  docker-compose $argv; 
end
