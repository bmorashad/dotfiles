# This contains all entgra related functions

# Entgra Config
export work="$HOME/Work/Entgra"
export carbon="$work/carbon-device-mgt" 
export plugin="$work/carbon-device-mgt-plugins" 
export product="$work/product-iots"
export emm="$work/emm-proprietary-plugins"
export prorietary="$work/proprietary-product"
export community="$work/community-product"
export dist="$prorietary/distribution/ultimate/target/entgra-uem-ultimate-5.0.1-SNAPSHOT"
export patches="$dist/repository/components/patches"
export warBundles="$dist/repository/deployment/server/webapps"

set UI 'entgra' $UI
set UI 'mdm-reports' $UI
set UI 'store' $UI
set UI 'publisher' $UI

set PATH $dist/bin $PATH

# Reference on sed instead of rg --replace
# https://stackoverflow.com/questions/8225822/how-to-make-sed-remove-lines-not-matched-by-a-substitution

# escape path string
function escape_path
	 echo $argv | rg '/' --replace '\/'
end

function ctc 
	set -l dir (git diff-tree --no-commit-id --name-only -r $argv[1] | rg 'src/main/java.*|react-app/.*' --replace '' | sort -u| rg '(.*)' --replace ''$argv[2]'/$0' | fzf)
	if test "$dir" != ""
		cd $dir
	end
end

# helper function
function etb 
	cd $argv[2]
	begin; git diff --name-only -r $argv[1]; git ls-files --exclude-standard --others; end | rg 'src/main/java.*|react-app/.*' --replace '' | sort -u | sed "s#^#$argv[2]/#" 
end

function etba
	cd $argv[1]
	fd -t d | rg 'src/main/java.*|react-app/.*' --replace '' | sort -u | sed "s#^#$argv[1]/#" 
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

# build given packages by path (i.e emif <path-to-package>)
function emif
	set -l curr_dir (pwd)
	for x in $argv
		echo "[BUILDING] $x" | rg "BUILDING" --passthru --colors 'match:fg:magenta' --color always
		cd $x
		mvn clean install -Dmaven.test.skip=true
		if test "$status" -gt 0
			return 1
		end
	end
	cd $curr_dir
end

# deploy selected packages by path
function entupf
	set -l curr_dir (pwd)
	for x in $argv
		echo "[DEPLOYING] $x" | rg "$work" --replace "" | rg "DEPLOYING" --passthru --colors 'match:fg:magenta' --color always
		set -l war (ls $x/target | rg '.*war') 
		# ui-request-handler deployment exception
		if test "$war" = "ui-request-handler.war"
			set -l distWar (ls $warBundles/ | rg "$war")
			set -l warDir (echo $war | rg '.war' --replace '')
			set -l distWarDir (ls $warBundles/ | rg "$warDir" | rg "\.war" -v)
			set -l warRm $warBundles/$distWar
			set -l dirWarRm $warBundles/$distWarDir

			if test "$distWar" != ""
				echo "[DELETING] $warRm" | rg "$work" --replace "" | rg "DELETING" --passthru --colors 'match:fg:255,51,71' --color always
				rm -rf $warRm
			end
			if test "$distWarDir" != ""
				echo "[DELETING] $dirWarRm" | rg "$work" --replace "" | rg "DELETING" --passthru --colors 'match:fg:255,51,71' --color always
				rm -rf $dirWarRm
			end
			for ui in $UI
				set ui_name "$ui-$war"
				echo "[COPYING] $ui/target/$war --> $warBundles/$ui-$war" | rg "$work" --replace "" | rg "COPYING|-->" --passthru --colors 'match:fg:0,229,255' --color always
				cp $x/target/$war $warBundles/$ui_name
			end
			echo "------------------------------------------------" | rg "-" --colors 'match:fg:white'
			echo " DEPLOYED SUCCESSFULLY" | rg "DEPLOYED SUCCESSFULLY" --passthru --colors 'match:fg:green' --color always
			echo "------------------------------------------------" | rg "-" --colors 'match:fg:white'
		else if test "$war" != ""
			set -l distWar (ls $warBundles/ | rg "^$war")
			set -l warDir (echo $war | rg '.war' --replace '')
			set -l distWarDir (ls $warBundles/ | rg "^$warDir\$")
			set -l warRm $warBundles/$distWar
			set -l dirWarRm $warBundles/$distWarDir

			if test "$distWar" != ""
				echo "[DELETING] $warRm" | rg "$work" --replace "" | rg "DELETING" --passthru --colors 'match:fg:255,51,71' --color always
				rm -rf $warRm
			end
			if test "$distWarDir" != ""
				echo "[DELETING] $dirWarRm" | rg "$work" --replace "" | rg "DELETING" --passthru --colors 'match:fg:255,51,71' --color always
				rm -rf $dirWarRm
			end
			echo "[COPYING] $x/target/$war --> $warBundles" | rg "$work" --replace "" | rg "COPYING|-->" --passthru --colors 'match:fg:0,229,255' --color always
			cp $x/target/$war $warBundles
			echo "------------------------------------------------" | rg "-" --colors 'match:fg:white'
			echo " DEPLOYED SUCCESSFULLY" | rg "DEPLOYED SUCCESSFULLY" --passthru --colors 'match:fg:green' --color always
			echo "------------------------------------------------" | rg "-" --colors 'match:fg:white'
		else
			set -l jar (ls $x/target | rg '.*jar') 
			if test "$jar" != ""
				mkdir -p $patches
				set -l patchDirLs (ls $patches)
				set -l patch0000 (ls $patches | rg patch0000)
				set -l patch5000 (ls $patches | rg patch5000)
				if test "$patchDirLs" = ""
					set patchDir "patch5000"
				else if test "$patch5000" != ""
					set patchDir (math (ls $patches/ | rg '\w*[^\d]' --replace '' | sort -r | sed -n "1 p") + 1 | sed 's/^/patch/')
					else
					set patchDir "patch5000"
				end
				mkdir $patches/$patchDir
				echo "[COPYING] $x/target/$jar --> $patches/$patchDir" | rg "$work" --replace "" | rg "COPYING|-->" --passthru --colors 'match:fg:0,229,255' --color always
				cp $x/target/$jar $patches/$patchDir
				echo "------------------------------------------------" | rg "-" --colors 'match:fg:white'
				echo " DEPLOYED SUCCESSFULLY" | rg "DEPLOYED SUCCESSFULLY" --passthru --colors 'match:fg:green' --color always
				echo "------------------------------------------------" | rg "-" --colors 'match:fg:white'
			else
				echo "[ERROR] No target found" | rg "ERROR" --passthru --colors 'match:fg:255,51,71' --color always
				return 1
			end	
		end
	end
	cd $curr_dir
end

# build and deploy the fzf selected packages in selected order 
function ebdf
	set -l is_deploy
	if test "$argv[-1]" = "-no-deploy"
		set is_deploy 0
		set -e argv[-1]
	else
		set is_deploy 1
	end
	set -l curr_dir (pwd)
	set -l dirs
	if test (count $argv) -gt 2
		for x in $argv[-1..3]
			set dirs (etb $argv[1] $argv[2] | sed -n "$x p") $dirs
		end
	else
		set dirs (etb $argv | sed "s#$work/##" | fzf -m --reverse | sed "s#^#$work/#")
	end
	for x in $dirs
		emif $x
		if test "$status" -gt 0
			return 1
		end
		if test $is_deploy -eq 1
			entupf $x
			if test "$status" -gt 0
				return 1
			end
		end
	end
	cd $curr_dir
end

function ebdfa
	set -l is_deploy
	if test "$argv[-1]" = "-no-deploy"
		set is_deploy 0
		set -e argv[-1]
	else
		set is_deploy 1
	end
	set -l curr_dir (pwd)
	set -l dirs
	if test (count $argv) -gt 1
		for x in $argv[-1..2]
			set dirs (etba $argv[1] $argv[2] | sed -n "$x p") $dirs
		end
	else
		set dirs (etba $argv | sed "s#$work/##" | fzf -m --reverse | sed "s#^#$work/#")
	end
	for x in $dirs
		emif $x
		if test "$status" -gt 0
			return 1
		end
		if test $is_deploy -eq 1
			entupf $x
			if test "$status" -gt 0
				return 1
			end
		end
	end
	cd $curr_dir
end

function entbuild
	if test -d "$argv[1]"
		ebdfa $argv -no-deploy
	else
		ebdf $argv -no-deploy
	end
end

function entapply
	if test -d "$argv[1]"
		ebdfa $argv
	else
		ebdf $argv
	end
end

# entgra ui watch
function entuiwatch
	set ui (ls $emm/components/ui | rg ".*ui" | fzf --reverse)

	if test "$ui" != ""
		set warDir (ls $emm/components/ui/$ui/target | rg '\.war' --replace "")
		if test -d "$warBundles/$warDir"
			set reactApp $emm/components/ui/$ui/react-app/dist

			set builtIndex (ls $reactApp | rg 'index\.html')

			if test -z "$builtIndex"
				echo "[INFO] $ui/react-app/dist is empty" | rg "INFO" --colors match:fg:blue
				echo "[BUILDING] npm run dev on $warDir" | rg "BUILDING" --colors match:fg:magenta
				npm run --prefix $emm/components/ui/$ui/react-app dev
			end

			set rmWarDirFiles $warBundles/$warDir/index.html $warBundles/$warDir/main.css \
			$warBundles/$warDir/main.js $warBundles/$warDir/main.css.map \
			$warBundles/$warDir/main.js.map

			if ! test -L $reactApp/index.html && ! test -L $reactApp/main.css && ! test -L $reactApp/main.js &&
				! test -L $reactApp/main.css.map && ! test -L $reactApp/main.js.map

				echo "[REMOVING] $rmWarDirFiles" | rg "REMOVING" --colors match:fg:red
				rm -rf $rmWarDirFiles

				echo "[LINKING] Linking $ui/react-app/dist --> $warDir" | rg "LINKING|-->" --colors match:fg:blue
				ln -fs $warBundles/$warDir/index.html   $reactApp/index.html 	
				ln -fs $warBundles/$warDir/main.css     $reactApp/main.css 		
				ln -fs $warBundles/$warDir/main.js      $reactApp/main.js 		
				ln -fs $warBundles/$warDir/main.css.map $reactApp/main.css.map 	
				ln -fs $warBundles/$warDir/main.js.map  $reactApp/main.js.map 	
			end

			echo "[WATCHING] npm run watch on $warDir" | rg "WATCHING" --colors match:fg:green
			npm run --prefix $emm/components/ui/$ui/react-app watch
		else
				echo "[ERROR] $warDir cannot be found in $warBundles" | rg "ERROR" --passthru --colors 'match:fg:255,51,71' --color always
		end
	end
end

# GIT 

function ent_gdiff
	git diff --name-only $argv[1] | rg --passthru "src/main/java.*|react-app/.*" --replace "" | sort -u | fzf -m | xargs -ro git diff $argv[1]
end
