#!/bin/bash
conda init bash
# . ~/.bashrc

# . /home/schnablelab/anaconda3/etc/profile.d/conda.sh
conda activate homotools
qrygene=$1
genome=$2

# output directory
outdir=/srv/shiny-server/sample-apps/hello/Output/$genome

if [ ! -d $outdir ]; then
	mkdir $outdir
fi

# homomine command
hm=/home/ubuntu/homotools/homomine

# genome data
dbdir=/home/ubuntu/mounteds3/sorghumHM_Local/DataBase

# run homomine
if [ ! -f ${outdir}/${qrygene}/${qrygene}.homomine.report.html ]; then
	cd $outdir
	perl $hm \
		--qrygene $qrygene \
		--qrydir ${dbdir}/BTX623.v.5.1 \
		--qrybase BTX623.v.5.1 \
		--tgtdir ${dbdir}/$genome \
		--tgtbase $genome
fi