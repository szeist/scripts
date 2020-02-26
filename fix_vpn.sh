#!/bin/bash

nmcli -p connection modify emarsys-remote-access ipv4.never-default no
nmcli -p connection modify emarsys-remote-access ipv4.ignore-auto-dns no
nmcli -p connection modify emarsys-remote-access ipv4.dns-priority -42

