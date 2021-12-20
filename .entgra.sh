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
export prorietary="$work/proprietary-product"
export dist="$prorietary/distribution/ultimate/target/entgra-uem-ultimate-5.0.1-SNAPSHOT"
export patches="$dist/repository/components/patches"
export warBundles="$dist/repository/deployment/server/webapps"

UI=("entgra" "mdm-reports" "store" "publisher")

export PATH=$dist/bin:$PATH

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
	(git diff --name-only -r $1; git ls-files --exclude-standard --others) | rg 'src/main/java.*' --replace '' | sort -u | rg '(.*)' --replace ''$2'/$0'
}

function etba {
	cd $1
	fd -t d | rg 'src/main/java.*' --replace '' | sort -u | rg '(.*)' --replace ''$1'/$0'
}

# build given packages by id  (i.e emi HEAD $carbon 2 1)
function emi {
	curr_dir=$(pwd)
	cd $2
	# ${@:3:}
	for x in ${@:3}
	do
		dir=$(etb $1 $2 | sed -n "$x p")
		if test "$dir" != ""
		then
			echo -e "[${PURPLE}BUILDING${NC}] $dir"
			cd $dir
			mvn clean install -Dmaven.test.skip=true
			if test "$?" -gt 0
			then
				return 1
			fi
		fi
	done
	cd $curr_dir
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

# deploy given packages by id (i.e entup HEAD $carbon 2)
function entup {
	curr_dir=$(pwd)
	cd $2
	for x in ${@:3}
	do
		dir=$(etb $1 $2 | sed -n "$x p")
		if test "$dir" != ""
		then
			echo -e "[${CYAN}UPDATING${NC}] $dir" | rg "$work" --replace ""
			war=$(ls $dir/target | rg '.*war') 
			# ui-request-handler deployment exception
			if test "$war" = "ui-request-handler.war"
			then
				distWar=$(ls $warBundles/ | rg "$war")
				warDir=$(echo $war | rg '.war' --replace '')
				distWarDir=$(ls $warBundles/ | rg "$warDir" | rg "\.war" -v)


				warRm=()
				dirWarRm=()
				for w in $distWar; do warRm+=($warBundles/$w); done
				for w in $distWarDir; do dirWarRm+=($warBundles/$w); done
				warRm=${warRm[@]}
				dirWarRm=${dirWarRm[@]}

				if test "$warRm" != ""
				then
					echo -e "[${RED}DELETING${NC}] $warRm" | rg "$work" --replace ""
					rm -rf $warRm
				fi
				if test "$dirWarRm" != ""
				then
					echo -e "[${RED}DELETING${NC}] $dirWarRm" | rg "$work" --replace ""
					rm -rf $dirWarRm
				fi
				for ui in ${UI[@]}
				do
					ui_name="$ui-$war"
					echo -e "[${GREEN}COPYING${NC}] $ui/target/$war ${GREEN}-->${NC} $warBundles/$ui-$war" | rg "$work" --replace ""
					cp $dir/target/$war $warBundles/$ui_name
				done
				echo -e "${WHITE}------------------------------------------------${NC}"
				echo -e " ${PURPLE}DEPLOYED SUCCESSFULLY${NC}"
				echo -e "${WHITE}------------------------------------------------${NC}"
			elif test "$war" != ""
			then
				distWar=$(ls $warBundles/ | rg "^$war")
				warDir=$(echo $war | rg '.war' --replace '')
				distWarDir=$(ls $warBundles/ | rg "^$warDir\$")
				warRm=$warBundles/$distWar
				dirWarRm=$warBundles/$distWarDir

				if test "$warRm" != ""
				then
					echo -e "[${RED}DELETING${NC}] $warRm" | rg "$work" --replace ""
					rm -rf $warRm
				fi
				if test "$dirWarRm" != ""
				then
					echo -e "[${RED}DELETING${NC}] $dirWarRm" | rg "$work" --replace ""
					rm -rf $dirWarRm
				fi
				echo -e "[${GREEN}COPYING${NC}] $dir/target/$war ${GREEN}-->${NC} $warBundles" | rg "$work" --replace ""
				cp $dir/target/$war $warBundles
				echo -e "${WHITE}------------------------------------------------${NC}"
				echo -e " ${PURPLE}DEPLOYED SUCCESSFULLY${NC}"
				echo -e "${WHITE}------------------------------------------------${NC}"
			else
				jar=$(ls $dir/target | rg '.*jar') 
				if test "$jar" != ""
				then
					patchDirLs=$(ls $patches)
					patch0000=$(ls $patches | rg patch0000)
					patch5000=$(ls $patches | rg patch5000)
					if test "$patchDirLs" = ""
					then
						patchDir="patch5000"
					elif test "$patch5000" != ""
					then
						patchDir=$(expr $(ls $patches/ | rg '\w*[^\d]' --replace '' | sort -r | sed -n "1 p") + 1 | rg '\d*' --replace 'patch$0')
					else
						patchDir="patch5000"
					fi
					mkdir $patches/$patchDir
					echo -e "[${GREEN}COPYING${NC}] $dir/target/$jar ${GREEN}-->${NC} $patches/$patchDir" | rg "$work" --replace ""
					cp $dir/target/$jar $patches/$patchDir
					echo -e "${WHITE}------------------------------------------------${NC}"
					echo -e " ${PURPLE}DEPLOYED SUCCESSFULLY${NC}"
					echo -e "${WHITE}------------------------------------------------${NC}"
				else
					echo -e "[${RED}ERROR${NC}] No target found"
					return 1
				fi	
			fi
		else
			echo -e "[${RED}ERROR${NC}] No dir for given args"
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
		echo -e "[${CYAN}UPDATING${NC}] $x" | rg "$work" --replace ""
		war=$(ls $x/target | rg '.*war') 
		# ui-request-handler deployment exception
		if test "$war" = "ui-request-handler.war"
		then
			distWar=$(ls $warBundles/ | rg "$war")
			warDir=$(echo $war | rg '.war' --replace '')
			distWarDir=$(ls $warBundles/ | rg "$warDir" | rg "\.war" -v)

			warRm=()
			dirWarRm=()
			for w in $distWar; do warRm+=($warBundles/$w); done
			for w in $distWarDir; do dirWarRm+=($warBundles/$w); done
			warRm=${warRm[@]}
			dirWarRm=${dirWarRm[@]}

			if test "$warRm" != ""
			then
				echo -e "[${RED}DELETING${NC}] $warRm" | rg "$work" --replace ""
				rm -rf $warRm
			fi
			if test "$dirWarRm" != ""
			then
				echo -e "[${RED}DELETING${NC}] $dirWarRm" | rg "$work" --replace ""
				rm -rf $dirWarRm
			fi
			for ui in ${UI[@]}
			do
				ui_name="$ui-$war"
				echo -e "[${GREEN}COPYING${NC}] $ui/target/$war ${GREEN}-->${NC} $warBundles/$ui-$war" | rg "$work" --replace ""
				cp $x/target/$war $warBundles/$ui_name
			done
			echo -e "${WHITE}------------------------------------------------${NC}"
			echo -e " ${PURPLE}DEPLOYED SUCCESSFULLY${NC}"
			echo -e "${WHITE}------------------------------------------------${NC}"
		elif test "$war" != ""
		then
			distWar=$(ls $warBundles/ | rg "^$war")
			warDir=$(echo $war | rg '.war' --replace '')
			distWarDir=$(ls $warBundles/ | rg "^$warDir\$")
			warRm=$warBundles/$distWar
			dirWarRm=$warBundles/$distWarDir

			if test "$warRm" != ""
			then
				echo -e "[${RED}DELETING${NC}] $warRm" | rg "$work" --replace ""
				rm -rf $warRm
			fi
			if test "$dirWarRm" != ""
			then
				echo -e "[${RED}DELETING${NC}] $dirWarRm" | rg "$work" --replace ""
				rm -rf $dirWarRm
			fi
			echo -e "[${GREEN}COPYING${NC}] $x/target/$war ${GREEN}-->${NC} $warBundles" | rg "$work" --replace ""
			cp $x/target/$war $warBundles
			echo -e "${WHITE}------------------------------------------------${NC}"
			echo -e " ${PURPLE}DEPLOYED SUCCESSFULLY${NC}"
			echo -e "${WHITE}------------------------------------------------${NC}"
		else
			jar=$(ls $x/target | rg '.*jar') 
			if test "$jar" != ""
			then
				patchDirLs=$(ls $patches)
				patch0000=$(ls $patches | rg patch0000)
				patch5000=$(ls $patches | rg patch5000)
				if test "$patchDirLs" = ""
				then
					patchDir="patch5000"
				elif test "$patch5000" != ""
				then
					patchDir=$(expr $(ls $patches/ | rg '\w*[^\d]' --replace '' | sort -r | sed -n "1 p") + 1 | rg '\d*' --replace 'patch$0')
				else
					patchDir="patch5000"
				fi
				mkdir $patches/$patchDir
				echo -e "[${GREEN}COPYING${NC}] $x/target/$jar ${GREEN}-->${NC} $patches/$patchDir" | rg "$work" --replace ""
				cp $x/target/$jar $patches/$patchDir
				echo -e "${WHITE}------------------------------------------------${NC}"
				echo -e " ${PURPLE}DEPLOYED SUCCESSFULLY${NC}"
				echo -e "${WHITE}------------------------------------------------${NC}"
			else
				echo -e "[${RED}ERROR${NC}] No target found"
				return 1
			fi	
		fi
	done
	cd $curr_dir
}

# build and deploy packages by id in given order (i.e ebd HEAD $carbon 1 3 2)
function ebd {
	emi $@
	if test "$?" -gt 0
	then
		return 1
	fi
	entup $@
	if test "$?" -gt 0
	then
		return 1
	fi
}

# build and deploy the fzf selected packages in selected order 
function ebdf {
	curr_dir=$(pwd)
	dirs=()
	if test "$#" -gt 2
	then
		for (( i=$#;i>=3;i-- ));do
			dirs+=$(etb $1 $2 | sed -n "${!i} p")
		done
	else
		dirs=$(etb $@ | fzf -m --reverse)
	fi
	dirs=${dirs[@]}
	for x in $dirs
	do
		emif $x
		if test "$?" -gt 0
		then
			return 1
		fi
		entupf $x
		if test "$?" -gt 0
		then
			return 1
		fi
	done
	cd $curr_dir
}

function ebdfa {
	curr_dir=$(pwd)
	dirs=()
	if test "$#" -gt 1
	then
		for (( i=$#;i>=2;i-- ));do
			dirs+=$(etb $1 $2 | sed -n "${!i} p")
		done
	else
		dirs=$(etba $@ | fzf -m --reverse)
	fi
	dirs=${dirs[@]}
	for x in $dirs
	do
		emif $x
		if test "$?" -gt 0
		then
			return 1
		fi
		entupf $x
		if test "$?" -gt 0
		then
			return 1
		fi
	done
	cd $curr_dir
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
	ui=$(ls $emm/components/ui | rg ".*ui" | fzf --reverse)

	if test "$ui" != ""
	then
		warDir=$(ls $emm/components/ui/$ui/target | rg '\.war' --replace "")
		reactApp=$emm/components/ui/$ui/react-app/dist

		builtIndex=$(ls $reactApp | rg 'index\.html')

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
	fi
}
