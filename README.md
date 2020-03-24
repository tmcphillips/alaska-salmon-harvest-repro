# all_harvest_repro

This repo allows the analysis associated with the dataset with identifier [doi:10.5063/F1BV7DV0](https://knb.ecoinformatics.org/view/doi:10.5063/F1BV7DV0) to be re-executed on any computer that has Git, Docker, and GNU Make installed. The analysis can be run either noninteractively via the *`run`* Make target at the command line, or interactively in an RStudio instance running in a container started using the *`start`* Make target. The Makefile includes targets for building the Docker image that contains all software dependencies.

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

	And use *`git status`* to confirm that the contents of the repo have not changed since it was cloned.

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
	docker run -it --rm -p 8787:8787 --volume /mnt/c/Users/tmcphill/OneDrive/GitRepos/all-harvest-repro:/mnt/all-harvest-repro tmcphillips/all-harvest-repro:latest bash -ic 'make -C /mnt/all-har
	vest-repro/analysis run'
	make: Entering directory '/mnt/all-harvest-repro/analysis'
	R -e "rmarkdown::render('All_Harvest.Rmd',output_file='All_Harvest.html')"
	> rmarkdown::render('All_Harvest.Rmd',output_file='All_Harvest.html')
	processing file: All_Harvest.Rmd
	|...                                                                   |   5%
	ordinary text without R code
	|.......                                                               |  10%
	label: setup (with options)
	List of 1
	$ include: logi FALSE
	|..........                                                            |  14%
	ordinary text without R code
	|.............                                                         |  19%
	label: unnamed-chunk-1
	Attaching package: 'dplyr'
	The following objects are masked from 'package:stats':
		filter, lag
	The following objects are masked from 'package:base':
		intersect, setdiff, setequal, union
	|.................                                                     |  24%
	ordinary text without R code
	|....................                                                  |  29%
	label: unnamed-chunk-2
	|.......................                                               |  33%
	ordinary text without R code
	|...........................                                           |  38%
	label: unnamed-chunk-3
	Joining, by = c("year", "SASAP.Region", "species")
	|..............................                                        |  43%
	ordinary text without R code
	|.................................                                     |  48%
	label: unnamed-chunk-4
	|.....................................                                 |  52%
	ordinary text without R code
	|........................................                              |  57%
	label: unnamed-chunk-5 (with options)
	List of 1
	$ eval: symbol F
	|...........................................                           |  62%
	ordinary text without R code
	|...............................................                       |  67%
	label: unnamed-chunk-6
	|..................................................                    |  71%
	ordinary text without R code
	|.....................................................                 |  76%
	label: unnamed-chunk-7
	|.........................................................             |  81%
	ordinary text without R code
	|............................................................          |  86%
	label: unnamed-chunk-8 (with options)
	List of 5
	$ message   : symbol F
	$ warning   : symbol F
	$ eval      : symbol T
	$ fig.width : num 8
	$ fig.height: num 10
	|...............................................................       |  90%
	ordinary text without R code
	|...................................................................   |  95%
	label: unnamed-chunk-9
	|......................................................................| 100%
	ordinary text without R code
	output file: All_Harvest.knit.md
	/usr/local/bin/pandoc +RTS -K512m -RTS All_Harvest.utf8.md --to html4 --from markdown+autolink_bare_uris+tex_math_single_backslash+smart --output All_Harvest.html --email-obfuscation none --
	self-contained --standalone --section-divs --template /usr/local/lib/R/site-library/rmarkdown/rmd/h/default.html --no-highlight --variable highlightjs=1 --variable 'theme:bootstrap' --includ
	e-in-header /tmp/RtmptCD3ex/rmarkdown-str85114df12.html --mathjax --variable 'mathjax-url:https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML' --lua-filter /usr/local/
	lib/R/site-library/rmarkdown/rmd/lua/pagebreak.lua --lua-filter /usr/local/lib/R/site-library/rmarkdown/rmd/lua/latex-div.lua
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



