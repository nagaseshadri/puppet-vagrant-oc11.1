# Oracle Commerce VM + Managed Environments - Vagrant + Puppet

Created by **Naga**rajan Seshadri  
Email <a.s.nagarajan@gmail.com>  
[Github homepage](https://github.com/nagaseshadri/puppet-vagrant-oc11.1)

## Supported Environments

- MacOSX
- Windows

## Pre-requisites

- A machine with atleast 16 GB RAM, as the VM would need atleast 8 GB allocated.
- The VM is designed to expand dynamically upto 60 GB - so its better to have atleast 75 GB of free space on your host machine

## Features

- Build an Oracle Commerce 11.1 Oracle Linux 6.6 based VM from Ground up using Vagrant + Puppet Modules/Manifests. 
- The same puppet configs can be used to configure and manage your managed environments - Dev/Test/Acceptance/Production

## Needed Software Installables

- Software installables to be made available in the /Software mount point - folder corresponding to /Users/Naga/Downloads/Commerce11  in the host machine (refer to **vagrant_config.tmp.yaml**)

| # | Software Name | Installable |
| --- | :----------- | :---------- |
| 1 | JDK | jdk-7u55-linux-x64.tar.gz |
| 2 | Gradle | gradle-2.2-all.zip |
| 3 | ATG 11.1 | V46005-01.zip |
| 4 | Endeca CAS 11.1 | V46393-01.zip |
| 5 | Endeca Tools & Frameworks 11.1 | V46389-01.zip |
| 6 | Endeca MDEX 6.5.1 | V46002-01.zip |
| 7 | Endeca Platform Service 11.1 | V45999-01.zip |
| 8 | Eclipse Luna | eclipse-jee-luna-SR1-linux-gtk-x86_64.tar.gz |
| 9 | Oracle XE 11gR2 | oracle-xe-11.2.0-1.0.x86_64.rpm.zip |
| 10 | SQL Developer 4.0.3.16| sqldeveloper-4.0.3.16.84-1.noarch.rpm |
| 11 | Oracle Weblogic 12c | wls_121200.jar |
| 12 | Oracle JDBC Driver | ojdbc6.jar |
| 13 | ATG DAS Protocol.jar | protocol.jar |

## Steps to set up and kickstart the Virtual Machine

- Download and install Oracle VirtualBox (latest version should be fine)
- Download and install Vagrant (latest version should be fine)
- Download all the necessary software (To Be Installed - see table above) and place it in a folder in your host machine. The Software listed above are all available [here](http://ppl.ug/LPZQYuf_xMI/) including the basebox 
- Download the base box (an Oracle Enterprise Linux 6.6 OS) for Vagrant manually from [here](https://www.dropbox.com/s/f5jk8tym60efisp/oel66.box?dl=0)(if not done already) and add it to vagrant boxes list using the following command
```
vagrant box add --name <<name>> <<path to the box file>>
```
- Make a copy of the [vagrant_config.tmp.yaml ](./vagrant_config.tmp.yaml) to create a vagrant_config.yaml ( This file is not checkedin to avoid merge issues - the tmp is only a reference file, the Vagrant config is looking for a file named vagrant_config.yaml ) and edit it according to your setup / needs
- Start the VM by running the following command from Terminal or Command prompt, this will try and import the base box and run provision to install the software needed - You can decide and update what to install by updating the classes section in [common.yaml](./hieradata/nodes/local/common.yaml)
```
vagrant up
```

## Planned for future

- Support for JBoss EAP
- Installing Commerce Reference Store 11.1

## References / Appendix

- Want to know more about **Vagrant**? Please read about vagrant [here](https://www.vagrantup.com/)
- Want to know more about **Puppet**, Please read about what puppet has to offer [here](https://puppetlabs.com/)
- Want to know more about **VirtualBox**, Please read the documentation [here](https://www.virtualbox.org/)

## Issues

- Please feel free to raise any issues that you find [here](https://github.com/nagaseshadri/puppet-vagrant-oc11.1/issues/new), I will try and look at it ASAP
