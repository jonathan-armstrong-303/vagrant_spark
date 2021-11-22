# Spark Vagrant build
## Synopsis

This project needs very little elaboration --  Vagrant and Virtualbox installation is of course necessary (and don't forget to download the Vagrant box with the first commented-outline in the Vagrantfile).

## Prerequisites (Hardware)

This was performed on my home Linux desktop (4 cores/4.2 GHz processors/64 GB memory) and allocated 12GB RAM to each of the four Greenplum nodes in Vagrant (admittedly 4GB less than the minimum recommended) running Ubuntu 20.04.

Configuration was tested with Vagrant 2.2.6.  (If Vagrant is not installed, I've provided up-to-date instructions on that below.)

## Installation 

Note that there are five sections regarding installation prerequisites.  [The tl;dr]:

1. The Vagrant application itself [if not already installed]
2. Virtualbox
3. Some external Vagrant packages (e.g., vagrant-scp, vagrant-disksize -- not always necessary, but nice to have.)

All of the requisite instructions are detailed in my Greenplum installation repo found at: https://github.com/jonathan-armstrong-303/vagrant_greenplum_6-1-4_install
    
# Tests

Post-installation, Spark is started/stopped with commands found in spark_start.sh in this repo.
