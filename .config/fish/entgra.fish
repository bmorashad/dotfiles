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

set UI 'entgra' $UI
set UI 'mdm-reports' $UI
set UI 'store' $UI
set UI 'publisher' $UI

set PATH $dist/bin $PATH

function ctc 
	set -l dir (git diff-tree --no-commit-id --name-only -r $argv[1] | rg 'src/main/java.*' --replace '' | sort -u| rg '(.*)' --replace ''$argv[2]'/$0' | fzf)
	if test "$dir" != ""
		cd $dir
	end
end

# helper function
function etb 
	cd $argv[2]
	git diff --name-only -r $argv[1] | rg 'src/main/java.*' --replace '' | sort -u 
end

function etba
	cd $argv[1]
	fd -t d | rg 'src/main/java.*' --replace '' | sort -u
end

# fzf cd into a changed package
function ecd
	set -l dir (etb $argv[1] $argv[2] | fzf)
	if test "$dir" != ""
		cd $dir
	end

end

# list all changed packages
function elist
	set -l curr_dir (pwd)
	set -l dir (etb $argv[1] $argv[2] | sed -n "$argv[3] p")
	echo $dir
	cd $curr_dir
end

# build given packages by id  (i.e emif HEAD $carbon 2 1)
function emi
	set -l curr_dir (pwd)
	cd $argv[2]
	for x in $argv[3..-1]
		set -l dir (etb $argv[1] $argv[2] | sed -n "$x p")
		if test "$dir" != ""
			echo "[BUILDING] $dir" | rg "BUILDING" --passthru --colors 'match:fg:magenta' --color always
			cd $dir
			if test "$status" = 0
				mvn clean install -Dmaven.test.skip=true
			end
		end
	end
	cd $curr_dir
end
# build given packages by path (i.e emif HEAD $carbon <path-to-package>)
function emif
	set -l curr_dir (pwd)
	cd $argv[2]
	for x in $argv[3..-1]
		echo "[BUILDING] $x" | rg "BUILDING" --passthru --colors 'match:fg:magenta' --color always
		cd $x
		if test "$status" = 0
			mvn clean install -Dmaven.test.skip=true
		end
	end
	cd $curr_dir
end

# deploy given packages by id (i.e entup HEAD $carbon 2)
function entup 
	set -l curr_dir (pwd)
	cd $argv[2]
	for x in $argv[3..-1]
		set -l dir (etb $argv[1] $argv[2] | sed -n "$x p")
		if test "$dir" != ""
			echo "[UPDATING] $dir" | rg "$work" --replace "" | rg "UPDATING" --passthru --colors 'match:fg:0,229,255' --color always
			set -l war (ls $dir/target | rg '.*war') 
			# ui-request-handler deployment exception
			if test "$war" = "ui-request-handler.war"
				set -l distWar (ls $warBundles/ | rg "$war")
				set -l warDir (echo $war | rg '.war' --replace '')
				set -l distWarDir (ls $warBundles/ | rg "$warDir" | rg "\.war" -v)
				set -l warRm $warBundles/$distWar
				set -l dirWarRm $warBundles/$distWarDir

				if test "$warRm" != ""
					echo "[DELETING] $warRm" | rg "$work" --replace "" | rg "DELETING" --passthru --colors 'match:fg:255,51,71' --color always
					rm -rf $warRm
				end
				if test "$dirWarRm" != ""
					echo "[DELETING] $dirWarRm" | rg "$work" --replace "" | rg "DELETING" --passthru --colors 'match:fg:255,51,71' --color always

					rm -rf $dirWarRm
				end
				for ui in $UI
					set ui_name "$ui-$war"
					echo "[COPYING] $ui/target/$war --> $warBundles/$ui-$war" | rg "$work" --replace "" | rg "COPYING|-->" --passthru --colors 'match:fg:green' --color always
					cp $dir/target/$war $warBundles/$ui_name
				end
			else if test "$war" != ""
				set -l distWar (ls $warBundles/ | rg "^$war")
				set -l warDir (echo $war | rg '.war' --replace '')
				set -l distWarDir (ls $warBundles/ | rg "^$warDir\$")
				set -l warRm $warBundles/$distWar
				set -l dirWarRm $warBundles/$distWarDir

				if test "$warRm" != ""
					echo "[DELETING] $warRm" | rg "$work" --replace "" | rg "DELETING" --passthru --colors 'match:fg:255,51,71' --color always
					rm -rf $warRm
				end
				if test "$dirWarRm" != ""
					echo "[DELETING] $dirWarRm" | rg "$work" --replace "" | rg "DELETING" --passthru --colors 'match:fg:255,51,71' --color always

					rm -rf $dirWarRm
				end
				echo "[COPYING] $dir/target/$war --> $warBundles" | rg "$work" --replace "" | rg "COPYING|-->" --passthru --colors 'match:fg:green' --color always
				cp $dir/target/$war $warBundles
			else
				set -l jar (ls $dir/target | rg '.*jar') 
				if test "$jar" != ""
					set -l patchDirLs (ls $patches)
					set -l patch0000 (ls $patches | rg patch0000)
					set -l patch5000 (ls $patches | rg patch5000)
					if test "$patchDirLs" = ""
						set patchDir "patch5000"
					else if test "$patch5000" != ""
						set patchDir (math (ls $patches/ | rg '\w*[^\d]' --replace '' | sort -r | sed -n "1 p") + 1 | rg '\d*' --replace 'patch$0')
					else
						set patchDir "patch5000"
					end
					mkdir $patches/$patchDir
					echo "[COPYING] $dir/target/$jar --> $patches/$patchDir" | rg "$work" --replace "" | rg "COPYING|-->" --passthru --colors 'match:fg:green' --color always
					cp $dir/target/$jar $patches/$patchDir
				else
					echo "[ERROR] No target found" | rg "ERROR" --passthru --colors 'match:fg:255,51,71' --color always
				end	
			end
		else
			echo "[ERROR] No dir for given args" | rg "ERROR" --passthru --colors 'match:fg:255,51,71' --color always
		end
	end
	cd $curr_dir
end
# deploy selected packages by path
function entupf
	set -l curr_dir (pwd)
	cd $argv[2]
	for x in $argv[3..-1]
		echo "[UPDATING] $x" | rg "$work" --replace "" | rg "UPDATING" --passthru --colors 'match:fg:0,229,255' --color always
		set -l war (ls $x/target | rg '.*war') 
		# ui-request-handler deployment exception
		if test "$war" = "ui-request-handler.war"
			set -l distWar (ls $warBundles/ | rg "$war")
			set -l warDir (echo $war | rg '.war' --replace '')
			set -l distWarDir (ls $warBundles/ | rg "$warDir" | rg "\.war" -v)
			set -l warRm $warBundles/$distWar
			set -l dirWarRm $warBundles/$distWarDir

			if test "$warRm" != ""
				echo "[DELETING] $warRm" | rg "$work" --replace "" | rg "DELETING" --passthru --colors 'match:fg:255,51,71' --color always
				rm -rf $warRm
			end
			if test "$dirWarRm" != ""
				echo "[DELETING] $dirWarRm" | rg "$work" --replace "" | rg "DELETING" --passthru --colors 'match:fg:255,51,71' --color always

				rm -rf $dirWarRm
			end
			for ui in $UI
				set ui_name "$ui-$war"
				echo "[COPYING] $ui/target/$war --> $warBundles/$ui-$war" | rg "$work" --replace "" | rg "COPYING|-->" --passthru --colors 'match:fg:green' --color always
				cp $x/target/$war $warBundles/$ui_name
			end
		else if test "$war" != ""
			set -l distWar (ls $warBundles/ | rg "^$war")
			set -l warDir (echo $war | rg '.war' --replace '')
			set -l distWarDir (ls $warBundles/ | rg "^$warDir\$")
			set -l warRm $warBundles/$distWar
			set -l dirWarRm $warBundles/$distWarDir

			if test "$warRm" != ""
				echo "[DELETING] $warRm" | rg "$work" --replace "" | rg "DELETING" --passthru --colors 'match:fg:255,51,71' --color always
				rm -rf $warRm
			end
			if test "$dirWarRm" != ""
				echo "[DELETING] $dirWarRm" | rg "$work" --replace "" | rg "DELETING" --passthru --colors 'match:fg:255,51,71' --color always

				rm -rf $dirWarRm
			end
			echo "[COPYING] $x/target/$war --> $warBundles" | rg "$work" --replace "" | rg "COPYING|-->" --passthru --colors 'match:fg:green' --color always
			cp $x/target/$war $warBundles
		else
			set -l jar (ls $x/target | rg '.*jar') 
			if test "$jar" != ""
				set -l patchDirLs (ls $patches)
				set -l patch0000 (ls $patches | rg patch0000)
				set -l patch5000 (ls $patches | rg patch5000)
				if test "$patchDirLs" = ""
					set patchDir "patch5000"
				else if test "$patch5000" != ""
					set patchDir (math (ls $patches/ | rg '\w*[^\d]' --replace '' | sort -r | sed -n "1 p") + 1 | rg '\d*' --replace 'patch$0')
					else
					set patchDir "patch5000"
				end
				mkdir $patches/$patchDir
				echo "[COPYING] $x/target/$jar --> $patches/$patchDir" | rg "$work" --replace "" | rg "COPYING|-->" --passthru --colors 'match:fg:green' --color always
				cp $x/target/$jar $patches/$patchDir
			else
				echo "[ERROR] No target found" | rg "ERROR" --passthru --colors 'match:fg:255,51,71' --color always
			end	
		end
	end
	cd $curr_dir
end

# build and deploy packages by id in given order (i.e ebd HEAD $carbon 1 3 2)
function ebd
	emi $argv
	entup $argv
end
# build and deploy the fzf selected packages in selected order 
function ebdf
	set -l curr_dir (pwd)
	set dirs (etb $argv | fzf -m --reverse)
	for x in $dirs
		emif $argv $x
		entupf $argv $x
	end
	cd $curr_dir
end

function ebdfa
	set -l curr_dir (pwd)
	set dirs (etba $argv | fzf -m --reverse)
	for x in $dirs
		emif $argv $x
		entupf $argv $x
	end
	cd $curr_dir
end

# entgra ui watch
function entuiwatch
	set ui (ls $emm/components/ui | rg ".*ui" | fzf --reverse)

	if test "$ui" != ""
		set warDir (ls $emm/components/ui/$ui/target | rg '\.war' --replace "")
		set reactApp $emm/components/ui/$ui/react-app/dist

		set builtIndex (ls $reactApp | rg 'index\.html')

		if test -z "$builtIndex"
			echo "[INFO] $ui/react-app/dist is empty" | rg "INFO" --colors match:fg:blue
			echo "[BUILDING] npm run dev on $warDir" | rg "BUILDING" --colors match:fg:purple
			npm run --prefix $emm/components/ui/$ui/react-app dev
		end
		
		set rmWarDirFiles $warBundles/$warDir/index.html $warBundles/$warDir/main.css \
		$warBundles/$warDir/main.js $warBundles/$warDir/main.css.map \
		$warBundles/$warDir/main.js.map


		echo "[REMOVING] $rmWarDirFiles" | rg "REMOVING" --colors match:fg:red
		rm -rf $rmWarDirFiles

		echo "[LINKING] Linking $ui/react-app/dist --> $warDir" | rg "LINKING|-->" --colors match:fg:blue
		ln -fs $warBundles/$warDir/index.html   $reactApp/index.html 	
		ln -fs $warBundles/$warDir/main.css     $reactApp/main.css 		
		ln -fs $warBundles/$warDir/main.js      $reactApp/main.js 		
		ln -fs $warBundles/$warDir/main.css.map $reactApp/main.css.map 	
		ln -fs $warBundles/$warDir/main.js.map  $reactApp/main.js.map 	

		echo "[WATCHING] npm run watch on $warDir" | rg "WATCHING" --colors match:fg:green
		npm run --prefix $emm/components/ui/$ui/react-app watch
	end
end

# GIT 

function ent_gdiff
	git diff --name-only $argv[1] | rg --passthru "src/main/java.*" --replace "" | sort -u | fzf -m | xargs -ro git diff $argv[1]
end

