:: batch
grep --binary-files=without-match ^
	--exclude-dir=.cvs ^
	--exclude-dir=.git ^
	--exclude-dir=.hg ^
	--exclude-dir=.svn ^
	--exclude=*.swp ^
	--exclude=cscope.* ^
	--exclude=filelist ^
	--exclude=tags ^
	%*
