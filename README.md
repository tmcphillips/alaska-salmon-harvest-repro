# all_harvest_repro

## Overview

The purpose of is repo to enable the analysis associated with the dataset [doi:10.5063/F1BV7DV0](https://knb.ecoinformatics.org/view/doi:10.5063/F1BV7DV0) to be re-executed on any computer that has Git, Docker, and GNU Make installed.

The analysis can be run either noninteractively via the *`make run`* command, or interactively in an RStudio instance running in a container started with the command *`make start`*. The *`make clean`* command deletes previously computed outputs, and *`git status`* can be used to confirm that previously results have been deleted, and again to verify that recomputed outputs are identical to the originals. The Makefile includes targets for building the Docker image that contains all software dependencies.

## Tutorials

The tutorials below demonstrate how to use the tools and data in this repo to reproduce the original analysis.

### Tutorial 1 - Rerunning the analysis noninteractiely at the command line

1. Ensure that Git, Docker, and GNU Make are installed on your MacOS, Linux or Windows computer:

	```
	$ git --version
	git version 2.11.0

	$ docker --version
	Docker version 19.03.5, build 633a0ea838

	$ make --version
	GNU Make 4.1
	Built for x86_64-pc-linux-gnu
	Copyright (C) 1988-2014 Free Software Foundation, Inc.
	License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
	This is free software: you are free to change and redistribute it.
	There is NO WARRANTY, to the extent permitted by law.
	```

2. Clone this Git repo:

	```
	$ git clone https://github.com/tmcphillips/all-harvest-repro.git
	```

	List the contents of the `analysis` subdirectory:

	```
	all-harvest-repro$ ls -l analysis/
	total 2412
	-rw-r--r-- 1 tmcphill tmcphill 2116643 Mar 24 15:49 All_Harvest.html
	-rw-r--r-- 1 tmcphill tmcphill   12338 Mar 24 15:49 All_Harvest.Rmd
	-rwxr-xr-x 1 tmcphill tmcphill     226 Mar 24 15:49 All_Harvest.Rproj
	-rw-r--r-- 1 tmcphill tmcphill  332060 Mar 24 15:49 Harvest_All_Sectors.csv
	-rw-r--r-- 1 tmcphill tmcphill     139 Mar 24 15:49 Makefile
	```

	And use *`git status`* to confirm that the contents of the repo have not changed since it was cloned:

	```
	all-harvest-repro$ git status
	On branch master
	Your branch is up-to-date with 'origin/master'.
	nothing to commit, working tree clean
	```

3. Delete the products of the analysis using *`make clean`*:

	```
	tmcphill@circe:~/GitRepos/all-harvest-repro$ make clean
	docker run -it --rm -p 8787:8787 --volume /mnt/c/Users/tmcphill/OneDrive/GitRepos/all-harvest-repro:/mnt/all-harvest-repro tmcphillips/all-harvest-repro:latest bash -ic 'make -C /mnt/all-har
	vest-repro/analysis clean'
	make: Entering directory '/mnt/all-harvest-repro/analysis'
	rm -rf Harvest_All_Sectors.csv All_Harvest.html
	make: Leaving directory '/mnt/all-harvest-repro/analysis'
	```

	List the `analysis` directory again, noting that the files `All_Harvest.html` and `Harvest_All_Sectors.csv` are no longer present:

	```
	tmcphill@circe:~/GitRepos/all-harvest-repro$ ls -l analysis/
	total 16
	-rw-r--r-- 1 tmcphill tmcphill 12338 Mar 24 15:49 All_Harvest.Rmd
	-rwxr-xr-x 1 tmcphill tmcphill   226 Mar 24 15:49 All_Harvest.Rproj
	-rw-r--r-- 1 tmcphill tmcphill   139 Mar 24 15:49 Makefile
	```

	And note that *`git status`* confirms the two outputs of the analysis have been deleted:

	```
	all-harvest-repro$ git status
	On branch master
	Your branch is up-to-date with 'origin/master'.
	Changes not staged for commit:
	(use "git add/rm <file>..." to update what will be committed)
	(use "git checkout -- <file>..." to discard changes in working directory)

			deleted:    analysis/All_Harvest.html
			deleted:    analysis/Harvest_All_Sectors.csv

	no changes added to commit (use "git add" and/or "git commit -a")
	```

4. Execute the analysis using *`make run`*:

	```
	tmcphill@circe:~/GitRepos/all-harvest-repro$ make run
	docker run -it --rm -p 8787:8787 --volume /mnt/c/Users/tmcphill/OneDrive/GitRepos/all-harvest-repro:/mnt/all-harvest-repro tmcphillips/all-harvest-repro:latest bash -ic 'make -C /mnt/all-harvest-repro/analysis run'
	make: Entering directory '/mnt/all-harvest-repro/analysis'
	R -e "rmarkdown::render('All_Harvest.Rmd',output_file='All_Harvest.html')"
	> rmarkdown::render('All_Harvest.Rmd',output_file='All_Harvest.html')
	processing file: All_Harvest.Rmd
	|...                                                                   |   5%
	ordinary text without R code
	.
	.
	.
	label: unnamed-chunk-9
	|......................................................................| 100%
	ordinary text without R code
	output file: All_Harvest.knit.md
	/usr/local/bin/pandoc +RTS -K512m -RTS All_Harvest.utf8.md --to html4 --from markdown+autolink_bare_uris+tex_math_single_backslash+smart --output All_Harvest.html --email-obfuscation none --self-contained --standalone --section-divs --template /usr/local/lib/R/site-library/rmarkdown/rmd/h/default.html --no-highlight --variable highlightjs=1 --variable 'theme:bootstrap' --include-in-header /tmp/RtmptCD3ex/rmarkdown-str85114df12.html --mathjax --variable 'mathjax-url:https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML' --lua-filter /usr/local/lib/R/site-library/rmarkdown/rmd/lua/pagebreak.lua --lua-filter /usr/local/lib/R/site-library/rmarkdown/rmd/lua/latex-div.lua
	Output created: All_Harvest.html
	>
	make: Leaving directory '/mnt/all-harvest-repro/analysis'
	```

5. Confirm that the files deleted using *`make clean`* have been restored:

	```
	all-harvest-repro$ ls -l analysis/
	total 2412
	-rw-r--r-- 1 tmcphill tmcphill 2116643 Mar 24 15:58 All_Harvest.html
	-rw-r--r-- 1 tmcphill tmcphill   12338 Mar 24 15:49 All_Harvest.Rmd
	-rwxr-xr-x 1 tmcphill tmcphill     226 Mar 24 15:49 All_Harvest.Rproj
	-rw-r--r-- 1 tmcphill tmcphill  332060 Mar 24 15:57 Harvest_All_Sectors.csv
	-rw-r--r-- 1 tmcphill tmcphill     139 Mar 24 15:49 Makefile
	```

	And that the repo has been restored to its initial state:

	```
	all-harvest-repro$ git status
	On branch master
	Your branch is up-to-date with 'origin/master'.
	nothing to commit, working tree clean
	```

### Tutorial 2 - Rerunning the analysis with RStudio



## Licensing

The files in the `analysis` directory of the repo are licensed under the Creative Commons Attribution 4.0 International License, the license under which the data set was originally distributed. To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/

All other contents of this repo are licensed under the MIT license and therefore can be reused in products with more restrictive licenses. See https://mit-license.org/.

