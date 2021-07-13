# Defined via `source`
function jh11 --wraps='export JAVA_HOME=/opt/jdk-11.0.6/ && sudo ln -svf /opt/jdk-11.0.6/bin/java /usr/bin/java && set PATH /opt/jdk-11.0.6/bin $PATH' --description 'alias jh11=export JAVA_HOME=/opt/jdk-11.0.6/ && sudo ln -svf /opt/jdk-11.0.6/bin/java /usr/bin/java && set PATH /opt/jdk-11.0.6/bin $PATH'
  export JAVA_HOME=/opt/jdk-11.0.6/ && sudo ln -svf /opt/jdk-11.0.6/bin/java /usr/bin/java && set PATH /opt/jdk-11.0.6/bin $PATH $argv; 
end
