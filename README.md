# Spark Vagrant build
## Synopsis

This project needs very little elaboration --  Vagrant and Virtualbox installation is of course necessary (and don't forget to download the Vagrant box with the first commented-outline in the Vagrantfile).  This build not only goes against the latest stable version of Spark as of time of writing (3.1.2) but also uses the open source Zulu JDK which circumvents the Oracle JDK license restrictions.

## Prerequisites (Hardware)

This was performed on my home Linux desktop (4 cores/4.2 GHz processors/64 GB memory).  Configuration was tested with Vagrant 2.2.6.  (If Vagrant is not installed, I've provided up-to-date instructions on that below.)

## Installation 

If Vagrant is not already installed, the following three steps need to be effected.  Instructions are detailed in my Greenplum installation repo found at: https://github.com/jonathan-armstrong-303/vagrant_greenplum_6-1-4_install

1. The Vagrant application itself [if not already installed] 
2. Virtualbox
3. Some external Vagrant packages (e.g., vagrant-scp, vagrant-disksize -- not always necessary, but nice to have.)
4. Last of all... don't forget to download the actual box image you want to use (which is found at the outset of my Vagrantfile commented out).
    
# Tests

Post-installation, Spark is started/stopped with commands found in spark_start.sh in this repo.
