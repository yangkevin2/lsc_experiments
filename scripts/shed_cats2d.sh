#!/bin/bash

dataset=$1
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/.."

$DIR/lsc/callChemblScript2.sh $dataset.sdf ${dataset}_SHED.fpf ${dataset}_CATS2D.fpf
