# all_harvest_repro

This repo allows the analysis associated with the dataset with identifier [doi:10.5063/F1BV7DV0](https://knb.ecoinformatics.org/view/doi:10.5063/F1BV7DV0) to be re-executed on any computer that has Git, Docker, and GNU Make installed. The analysis can be run either via the `run` Make target at the command line, or interactively in an RStudio instance running in a container started using the `start` Make target.  The Makefile includes targets for building the Docker image that contains all software dependencies.

### Tutorial

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

2. Clone this Git repo.



3. Start a terminal session and make this repo the default directory.

4. Confirm that the contents of the repo have not changed since it was cloned.

5. Delete the products of the analysis using the `clean` Make target.

6. Note that the two outputs of the analysis have been deleted.

7. Run the analysis using the `run` Make target.

8. Confirm that the files deleted using the `clean` Make target have been restored and that the repo is now in its initial state.

9.

