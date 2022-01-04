#!/bin/bash

# Bash Colors
RED='\033[1;31m'
NC='\033[0m' # No Color
ORANGE='\033[1;33m'    
BLUE='\033[1;34m'      
PURPLE='\033[1;35m'     
CYAN='\033[1;36m'       
WHITE='\033[1;37m'
GREEN='\033[1;32m'

# This contains all entgra related functions

# Entgra Config
export work="$HOME/Work/Entgra"
export carbon="$work/carbon-device-mgt" 
export plugin="$work/carbon-device-mgt-plugins" 
export product="$work/product-iots"
export emm="$work/emm-proprietary-plugins"
export community="$work/community-product"
export prorietary="$work/proprietary-product"
export dist="$prorietary/distribution/ultimate/target/entgra-uem-ultimate-5.0.1-SNAPSHOT"
export patches="$dist/repository/components/patches"
export warBundles="$dist/repository/deployment/server/webapps"

UI=("entgra" "mdm-reports" "store" "publisher")

export PATH=$dist/bin:$PATH

# escape path string
function escape_path {
	 echo $@ | sed 's#/#\\\/#g'
}


# list all changed packages
function elist {
	curr_dir=$(pwd)
	dir=$(etb $1 $2 | sed -n "$3 p")
	echo $dir
	cd $curr_dir
}

# fzf cd into a changed package
function ecd {
	dir=$(etb $1 $2 | fzf)
	if test "$dir" != ""
	then
		cd $dir
	fi
}

# helper function
function etb {
	cd $2
	(git diff --name-only -r $1; git ls-files --exclude-standard --others) | sed -n 's#src/main/java.*\|react-app/.*##gp' | sort -u | sed "s#^#$2/#" 
}

function etba {
	cd $1
	find -type d | sed 's/\.\///' | sed -n 's#src/main/java.*\|react-app/.*##gp' | sort -u | sed "s#^#$1/#"
}

# build given packages by path (i.e emif <path-to-package>)
function emif {
	curr_dir=$(pwd)
	for x in $@
	do
		echo -e "[${PURPLE}BUILDING${NC}] $x"
		cd $x
		mvn clean install -Dmaven.test.skip=true
		if test "$?" -gt 0
		then
			return 1
		fi
	done
	cd $curr_dir
}

# deploy selected packages by path
function entupf {
	curr_dir=$(pwd)
	for x in $@
	do
		echo -e "[${PURPLE}DEPLOYING${NC}] $x" | sed "s#$work##g"
		war=$(ls $x/target | grep '.*war') 
		# ui-request-handler deployment exception
		if test "$war" = "ui-request-handler.war"
		then
			distWar=$(ls $warBundles/ | grep "$war")
			warDir=$(echo $war | sed -n 's#.war##gp')
			distWarDir=$(ls $warBundles/ | grep "$warDir" | grep "\.war" -v)

			warRm=()
			dirWarRm=()
			for w in $distWar; do warRm+=($warBundles/$w); done
			for w in $distWarDir; do dirWarRm+=($warBundles/$w); done
			warRm=${warRm[@]}
			dirWarRm=${dirWarRm[@]}

			if test "$warRm" != ""
			then
				echo -e "[${RED}DELETING${NC}] $warRm" | sed "s#$work##g"
				rm -rf $warRm
			fi
			if test "$dirWarRm" != ""
			then
				echo -e "[${RED}DELETING${NC}] $dirWarRm" | sed "s#$work##g"
				rm -rf $dirWarRm
			fi
			for ui in ${UI[@]}
			do
				ui_name="$ui-$war"
				echo -e "[${CYAN}COPYING${NC}] $ui/target/$war ${GREEN}-->${NC} $warBundles/$ui-$war" | sed "s#$work##g"
				cp $x/target/$war $warBundles/$ui_name
			done
			echo -e "${WHITE}------------------------------------------------${NC}"
			echo -e " ${GREEN}DEPLOYED SUCCESSFULLY${NC}"
			echo -e "${WHITE}------------------------------------------------${NC}"
		elif test "$war" != ""
		then
			distWar=$(ls $warBundles/ | grep "^$war")
			warDir=$(echo $war | sed -n 's#.war##gp')
			distWarDir=$(ls $warBundles/ | grep "^$warDir\$")
			warRm=$warBundles/$distWar
			dirWarRm=$warBundles/$distWarDir

			if test "$distWar" != ""
			then
				echo -e "[${RED}DELETING${NC}] $warRm" | sed "s#$work##g"
				rm -rf $warRm
			fi
			if test "$distWarDir" != ""
			then
				echo -e "[${RED}DELETING${NC}] $dirWarRm" | sed "s#$work##g"
				rm -rf $dirWarRm
			fi
			echo -e "[${CYAN}COPYING${NC}] $x/target/$war ${GREEN}-->${NC} $warBundles" | sed "s#$work##g"
			cp $x/target/$war $warBundles
			echo -e "${WHITE}------------------------------------------------${NC}"
			echo -e " ${GREEN}DEPLOYED SUCCESSFULLY${NC}"
			echo -e "${WHITE}------------------------------------------------${NC}"
		else
			jar=$(ls $x/target | grep '.*jar') 
			if test "$jar" != ""
			then
				mkdir -p $patches
				patchDirLs=$(ls $patches)
				patch0000=$(ls $patches | grep patch0000)
				patch5000=$(ls $patches | grep patch5000)
				if test "$patchDirLs" = ""
				then
					patchDir="patch5000"
				elif test "$patch5000" != ""
				then
					patchDir=$(expr $(ls $patches/ |  sed -n 's/[a-zA-Z]*[^0-9]//gp' | sort -r | sed -n "1 p") + 1 | sed 's/^/patch/')
				else
					patchDir="patch5000"
				fi
				mkdir $patches/$patchDir
				echo -e "[${CYAN}COPYING${NC}] $x/target/$jar ${GREEN}-->${NC} $patches/$patchDir" | sed "s#$work##g"
				cp $x/target/$jar $patches/$patchDir
				echo -e "${WHITE}------------------------------------------------${NC}"
				echo -e " ${GREEN}DEPLOYED SUCCESSFULLY${NC}"
				echo -e "${WHITE}------------------------------------------------${NC}"
			else
				echo -e "[${RED}ERROR${NC}] No target found"
				return 1
			fi	
		fi
	done
	cd $curr_dir
}

# build and deploy the fzf selected packages in selected order 
function ebdf {
	declare is_deploy
	if test "${@: -1}" = "-no-deploy"
	then
		is_deploy=0
		set -- "${@: 1: $#-1}"
	else
		is_deploy=1
	fi
	curr_dir=$(pwd)
	dirs=()
	if test "$#" -gt 2
	then
		for x in ${@:3};do
			dirs+=($(etb $1 $2 | sed -n "$x p"))
		done
	else
		dirs=$(etb $@ | sed "s#$work/##" | awk '{ print NR " " $1 }' | fzf -m --reverse | awk '{print $2}' | sed "s#^#$work/#")
	fi
	dirs=${dirs[@]}
	for x in $dirs
	do
		emif $x
		if test "$?" -gt 0
		then
			return 1
		fi
		if test $is_deploy -eq 1
		then
			entupf $x
			if test "$?" -gt 0
			then
				return 1
			fi
		fi
	done
	cd $curr_dir
}

function ebdfa {
	declare is_deploy
	if test "${@: -1}" = "-no-deploy"
	then
		is_deploy=0
		set -- "${@: 1: $#-1}"
	else
		is_deploy=1
	fi
	curr_dir=$(pwd)
	dirs=()
	if test "$#" -gt 1
	then
		for x in ${@:2};do
			dirs+=($(etba $1 $2 | sed -n "$x p"))
		done
	else
		dirs=$(etba $@ | sed "s#$work/##" | awk '{ print NR " " $1 }' | fzf -m --reverse | awk '{print $2}' | sed "s#^#$work/#")
	fi
	dirs=${dirs[@]}
	for x in $dirs
	do
		emif $x
		if test "$?" -gt 0
		then
			return 1
		fi
		if test $is_deploy -eq 1
		then
			entupf $x
			if test "$?" -gt 0
			then
				return 1
			fi
		fi
	done
	cd $curr_dir
}

function entbuild {
	if test -d "$1"
	then
		ebdfa $@ -no-deploy
	else
		ebdf $@ -no-deploy
	fi
}

function entapply {
	if test -d "$1"
	then
		ebdfa $@
	else
		ebdf $@
	fi
}

# entgra ui watch
function entuiwatch {
	ui=$(ls $emm/components/ui | grep ".*ui" | fzf --reverse)

	if test "$ui" != ""
	then
		warDir=$(ls $emm/components/ui/$ui/target | sed -n 's#\.war##gp')
		if test -d "$warBundles/$warDir"
		then
			reactApp=$emm/components/ui/$ui/react-app/dist

			builtIndex=$(ls $reactApp | grep 'index\.html')

			if test -z "$builtIndex"
			then
				echo -e "[${BLUE}INFO${NC}] $ui/react-app/dist is empty"
				echo -e "[${PURPLE}BUILDING${NC}] npm run dev on $warDir"
				npm run --prefix $emm/components/ui/$ui/react-app dev
			fi
			rmWarDirFiles="$warBundles/$warDir/index.html $warBundles/$warDir/main.css \
				$warBundles/$warDir/main.js $warBundles/$warDir/main.css.map \
				$warBundles/$warDir/main.js.map"


			if ! test -L $reactApp/index.html && ! test -L $reactApp/main.css && ! test -L $reactApp/main.js &&
				! test -L $reactApp/main.css.map && ! test -L $reactApp/main.js.map
						then
							echo -e "[${RED}REMOVING${NC}] $rmWarDirFiles"
							rm -rf $rmWarDirFiles

							echo -e "[${BLUE}LINKING${NC}] Linking $ui/react-app/dist ${BLUE}-->${NC} $warDir"
							ln -fs $warBundles/$warDir/index.html   $reactApp/index.html 	
							ln -fs $warBundles/$warDir/main.css     $reactApp/main.css 		
							ln -fs $warBundles/$warDir/main.js      $reactApp/main.js 		
							ln -fs $warBundles/$warDir/main.css.map $reactApp/main.css.map 	
							ln -fs $warBundles/$warDir/main.js.map  $reactApp/main.js.map 	
			fi

			echo -e "[${GREEN}WATCHING${NC}] npm run watch on $warDir"
			npm run --prefix $emm/components/ui/$ui/react-app watch
		else
				echo -e "[${RED}ERROR${NC}] $warDir cannot be found in $warBundles"
		fi
	fi
}
