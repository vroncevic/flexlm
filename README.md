<img align="right" src="https://raw.githubusercontent.com/vroncevic/flexlm/dev/docs/flexlm_logo.png" width="25%">

# Shell script for license management

**flexlm** is shell tool for operating **[Flex License Manager](https://www.openlm.com/what-is-flexlm-what-is-flexnet-2/)**.

Developed in **[bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell))** code: **100%**.

[![flexlm_shell_checker](https://github.com/vroncevic/flexlm/actions/workflows/flexlm_shell_checker.yml/badge.svg)](https://github.com/vroncevic/flexlm/actions/workflows/flexlm_shell_checker.yml)

The README is used to introduce the modules and provide instructions on
how to install the modules, any machine dependencies it may have and any
other information that should be provided before the modules are installed.

[![GitHub issues open](https://img.shields.io/github/issues/vroncevic/flexlm.svg)](https://github.com/vroncevic/flexlm/issues) [![GitHub contributors](https://img.shields.io/github/contributors/vroncevic/flexlm.svg)](https://github.com/vroncevic/flexlm/graphs/contributors)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Installation](#installation)
- [Usage](#usage)
- [Dependencies](#dependencies)
- [Shell tool structure](#shell-tool-structure)
- [Docs](#docs)
- [Copyright and licence](#copyright-and-licence)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Installation

![Debian Linux OS](https://raw.githubusercontent.com/vroncevic/flexlm/dev/docs/debtux.png)

Navigate to release **[page](https://github.com/vroncevic/flexlm/releases)** download and extract release archive.

To install **flexlm** type the following
```
tar xvzf flexlm-x.y.tar.gz
cd flexlm-x.y
cp -R ~/sh_tool/bin/   /root/scripts/flexlm/ver.x.y/
cp -R ~/sh_tool/conf/  /root/scripts/flexlm/ver.x.y/
cp -R ~/sh_tool/log/   /root/scripts/flexlm/ver.x.y/
```

Self generated setup script and execution
```
./flexlm_setup.sh 

[setup] installing App/Tool/Script flexlm
	Sun 05 Dec 2021 01:15:58 PM CET
[setup] copy App/Tool/Script structure
[setup] remove github editor configuration files
[setup] set App/Tool/Script permission
[setup] create symbolic link of App/Tool/Script
[setup] done

/root/scripts/flexlm/ver.2.0/
├── bin/
│   ├── center.sh
│   ├── check_license.sh
│   ├── display_logo.sh
│   ├── flexlm.sh
│   ├── load_licenses.sh
│   ├── start_license.sh
│   └── stop_license.sh
├── conf/
│   ├── flexlm.cfg
│   ├── flexlm.logo
│   ├── flexlm_util.cfg
│   └── licenses.cfg
└── log/
    └── flexlm.log

3 directories, 12 files
lrwxrwxrwx 1 root root 42 Dec  5 13:15 /root/bin/flexlm -> /root/scripts/flexlm/ver.2.0/bin/flexlm.sh
```

Or You can use docker to create image/container.

### Usage

```
# Create symlink for shell tool
ln -s /root/scripts/flexlm/ver.x.y/bin/flexlm.sh /root/bin/flexlm

# Setting PATH
export PATH=${PATH}:/root/bin/

# Start Cadence License Server
flexlm 

flexlm ver.2.0
Sun 05 Dec 2021 01:16:52 PM CET

[check_root] Check permission for current session? [ok]
[check_root] Done

                                               
     ████  ██                  ██              
    ░██░  ░██                 ░██              
   ██████ ░██  █████  ██   ██ ░██ ██████████   
  ░░░██░  ░██ ██░░░██░░██ ██  ░██░░██░░██░░██  
    ░██   ░██░███████ ░░███   ░██ ░██ ░██ ░██  
    ░██   ░██░██░░░░   ██░██  ░██ ░██ ░██ ░██  
    ░██   ███░░██████ ██ ░░██ ███ ███ ░██ ░██  
    ░░   ░░░  ░░░░░░ ░░   ░░ ░░░ ░░░  ░░  ░░   
                                               
	                             
	Info   github.io/flexlm ver.2.0
	Issue  github.io/issue
	Author vroncevic.github.io

  [USAGE] flexlm [OPTIONS]
  [OPTIONS]
  [COMMAND] start | stop | restart | status
  [VENDOR NAME] cadence | mentor
  # Start license server
  flexlm start mentor
  [help | h] print this option
```

### Dependencies

**flexlm** requires next modules and libraries
* sh_util [https://github.com/vroncevic/sh_util](https://github.com/vroncevic/sh_util)

### Shell tool structure

**flexlm** is based on MOP.

Shell tool structure
```
sh_tool/
├── bin/
│   ├── center.sh
│   ├── check_license.sh
│   ├── display_logo.sh
│   ├── flexlm.sh
│   ├── load_licenses.sh
│   ├── start_license.sh
│   └── stop_license.sh
├── conf/
│   ├── flexlm.cfg
│   ├── flexlm.logo
│   ├── flexlm_util.cfg
│   └── licenses.cfg
└── log/
    └── flexlm.log
```

### Docs

[![Documentation Status](https://readthedocs.org/projects/flexlm/badge/?version=latest)](https://flexlm.readthedocs.io/projects/flexlm/en/latest/?badge=latest)

More documentation and info at
* [https://apmodule.readthedocs.io/en/latest/](https://apmodule.readthedocs.io/en/latest/)
* [https://www.gnu.org/software/bash/manual/](https://www.gnu.org/software/bash/manual/)
* [http://csweb.cs.wfu.edu/flexlm_programming_guide](http://csweb.cs.wfu.edu/~torgerse/Kokua/Irix_6.5.21_doc_cd/usr/share/Insight/library/SGI_bookshelves/SGI_Developer/books/FLEXlm_PG/sgi_html/index.html)[![flexlm_shell_checker](https://github.com/vroncevic/flexlm/actions/workflows/flexlm_shell_checker.yml/badge.svg)](https://github.com/vroncevic/flexlm/actions/workflows/flexlm_shell_checker.yml)

### Copyright and licence

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Copyright (C) 2016 - 2024 by [vroncevic.github.io/flexlm](https://vroncevic.github.io/flexlm)

**flexlm** is free software; you can redistribute it and/or modify
it under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

Lets help and support FSF.

[![Free Software Foundation](https://raw.githubusercontent.com/vroncevic/flexlm/dev/docs/fsf-logo_1.png)](https://my.fsf.org/)

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://my.fsf.org/donate/)
