#!/bin/bash

function GetCPUFree() {
    top -b -n 1 | grep Cpu | awk '{print int($8)}' | cut -f 1 -d "%"
}