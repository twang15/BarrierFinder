#!/bin/bash

cd Data
pdflatex table.tex
mkdir ../Pdf
cp table.pdf ../Pdf/
