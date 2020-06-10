# Shell script for license management.

***flexlm*** is shell tool for operating Flex License Manager.

Developed in bash code: ***100%***.

The README is used to introduce the modules and provide instructions on
how to install the modules, any machine dependencies it may have and any
other information that should be provided before the modules are installed.

[![GitHub issues open](https://img.shields.io/github/issues/vroncevic/flexlm.svg)](https://github.com/vroncevic/flexlm/issues)
 [![GitHub contributors](https://img.shields.io/github/contributors/vroncevic/flexlm.svg)](https://github.com/vroncevic/flexlm/graphs/contributors)

<!-- START doctoc -->
**Table of Contents**

- [Installation](https://github.com/vroncevic/flexlm#installation)
- [Usage](https://github.com/vroncevic/flexlm#usage)
- [Dependencies](https://github.com/vroncevic/flexlm#dependencies)
- [Shell tool structure](https://github.com/vroncevic/flexlm#shell-tool-structure)
- [Docs](https://github.com/vroncevic/flexlm#docs)
- [Copyright and Licence](https://github.com/vroncevic/flexlm#copyright-and-licence)
<!-- END doctoc -->

### INSTALLATION

Navigate to release [page](https://github.com/vroncevic/flexlm/releases) download and extract release archive.

To install modules type the following:

```
tar xvzf flexlm-x.y.z.tar.gz
cd flexlm-x.y.z
cp -R ~/sh_tool/bin/   /root/scripts/flexlm/ver.1.0/
cp -R ~/sh_tool/conf/  /root/scripts/flexlm/ver.1.0/
cp -R ~/sh_tool/log/   /root/scripts/flexlm/ver.1.0/
```

![alt tag](https://raw.githubusercontent.com/vroncevic/flexlm/dev/docs/setup_tree.png)

Or You can use docker to create image/container.

### USAGE

```
# Create symlink for shell tool
ln -s /root/scripts/flexlm/ver.1.0/bin/flexlm.sh /root/bin/flexlm

# Setting PATH
export PATH=${PATH}:/root/bin/

# Start Cadence License Server
flexlm start cadence
```

### DEPENDENCIES

This module requires these other modules and libraries:

* sh_util https://github.com/vroncevic/sh_util

### SHELL TOOL STRUCTURE

***flexlm*** is based on MOP.

Shell tool structure:
```
.
├── bin/
│   ├── check_license.sh
│   ├── flexlm.sh
│   ├── load_licenses.sh
│   ├── start_license.sh
│   └── stop_license.sh
├── conf/
│   ├── flexlm.cfg
│   ├── flexlm_util.cfg
│   └── licenses.cfg
└── log/
    └── flexlm.log
```

### DOCS

[![Documentation Status](https://readthedocs.org/projects/flexlm/badge/?version=latest)](https://flexlm.readthedocs.io/projects/flexlm/en/latest/?badge=latest)

More documentation and info at:

* https://flexlm.readthedocs.io/en/latest/

### COPYRIGHT AND LICENCE

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)


Copyright (C) 2018 by https://vroncevic.github.io/flexlm

This tool is free software; you can redistribute it and/or modify
it under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

