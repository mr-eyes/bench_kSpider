#!/usr/bin/env bash
set -euo pipefail

RUNLOG=$(pwd)/profiling.log
echo "Run by `whoami` on `date`" > $RUNLOG


kCluster_pairwise=$(pwd)/../kCluster2/build/kCluster_pairwise

if ! [ -x "$(command -v kCluster)" ]; then
  echo 'Error: kCluster is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v ${kCluster_pairwise})" ]; then
  echo 'Error: kCluster_pairwise is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v cd-hit-est)" ]; then
  echo 'Error: CD-HIT is not installed.' >&2
  exit 1
fi


OK="\e[32m[OK] \e[0m"
PROCESSING="\e[33m[RUNNING] \e[0m"

mkdir -p oma_data/maps
mkdir -p oma_seqs

# echo "Downloading gene2refseq.gz ..."
# wget -N ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene2refseq.gz

# echo "Downloading oma-ref-seq.txt.gz ..."
# wget -N https://omabrowser.org/All/oma-refseq.txt.gz


echo -e "\e[33m\e[1m
██████╗ ██████╗ ███████╗██████╗  █████╗ ██████╗ ██╗███╗   ██╗ ██████╗ 
██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔══██╗██║████╗  ██║██╔════╝ 
██████╔╝██████╔╝█████╗  ██████╔╝███████║██████╔╝██║██╔██╗ ██║██║  ███╗
██╔═══╝ ██╔══██╗██╔══╝  ██╔═══╝ ██╔══██║██╔══██╗██║██║╚██╗██║██║   ██║
██║     ██║  ██║███████╗██║     ██║  ██║██║  ██║██║██║ ╚████║╚██████╔╝
╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝                                                                                                                                 
\e[0m"

#######################################
#             DOWNLOAD                #
#######################################

echo -e "\e[33m\e[1mDownloading.. \e[0m"

FILE=./oma_data/eukaryotes.cdna.fa.gz
if [ -f "$FILE" ]; then
    echo -e "${OK} $FILE exist, skipping.."
else 
    echo "Downloading eukaryotes.cdna.fa.gz"
    wget -N https://omabrowser.org/All/eukaryotes.cdna.fa.gz -O ${FILE}
fi


FILE=./oma_data/oma-groups.txt.gz
if [ -f "$FILE" ]; then
    echo -e "${OK} $FILE exist, skipping.."
else 
    echo "Downloading oma-groups.txt.gz"
    wget -N https://omabrowser.org/All/oma-groups.txt.gz -O ${FILE}
fi

#######################################
#            GENERATING MAPS          #
#######################################

echo -e "\e[33m\e[1mGenerating maps .. \e[0m"
FILE=./oma_data/maps/oma_group_to_species.pickle
if [ -f "$FILE" ]; then
    echo -e "${OK} groups_to_species.pickle exists, skipping.."
else
    echo "Generating oma-group-id -> species_list"
    python scripts/generate_maps.py groups_to_species
fi

#######################################
#         Extracting Species          #
#######################################

echo -e "\e[33m\e[1mExtracting Species .. \e[0m"


# Exp_1 : HUMAN GORGO PANTR PANPA PONAB NOMLE
FILE=./oma_seqs/exp_1
if [ -d "$FILE" ]; then
    echo -e "${OK} Exp_1 sequences found, skipping the extraction.."
else
    echo "Extracting [HUMAN GORGO PANTR PANPA PONAB NOMLE]"
    python scripts/filter_oma_groups.py  HUMAN GORGO PANTR PANPA PONAB NOMLE
fi

# <<'COMMENT'
# COMMENT

# Exp_2 : HUMAN GORGO AOTNA MOUSE JACJA MACMU ASTMX XIPMA URSAM PHACI
FILE=./oma_seqs/exp_2
if [ -d "$FILE" ]; then
    echo -e "${OK} Exp_2 sequences found, skipping the extraction.."
else
    echo "Extracting [HUMAN GORGO AOTNA MOUSE JACJA MACMU ASTMX XIPMA URSAM PHACI]"
    python scripts/filter_oma_groups.py  HUMAN GORGO AOTNA MOUSE JACJA MACMU ASTMX XIPMA URSAM PHACI
fi

# Exp_3 : HUMAN GORGO AOTNA MOUSE DROER DROEL DRORH DROBP DROSI DROBM
FILE=./oma_seqs/exp_3
if [ -d "$FILE" ]; then
    echo -e "${OK} Exp_3 sequences found, skipping the extraction.."
else
    echo "Extracting [HUMAN GORGO AOTNA MOUSE DROER DROEL DRORH DROBP DROSI DROBM]"
    python scripts/filter_oma_groups.py  HUMAN GORGO AOTNA MOUSE DROER DROEL DRORH DROBP DROSI DROBM
fi

# Exp_4 : HUMAN GORGO AOTNA MOUSE DANPL MEGSC ANODA CULSO TUPBE MANLE
FILE=./oma_seqs/exp_4
if [ -d "$FILE" ]; then
    echo -e "${OK} Exp_4 sequences found, skipping the extraction.."
else
    echo "Extracting [HUMAN GORGO AOTNA MOUSE DANPL MEGSC ANODA CULSO TUPBE MANLE]"
    python scripts/filter_oma_groups.py  HUMAN GORGO AOTNA MOUSE DANPL MEGSC ANODA CULSO TUPBE MANLE
fi


# Exp_5 : HUMAN GORGO BRUMA MOUSE ONCVO MEGSC SCHMA CULSO NEMVE SCHMD
FILE=./oma_seqs/exp_5
if [ -d "$FILE" ]; then
    echo -e "${OK} Exp_5 sequences found, skipping the extraction.."
else
    echo "Extracting [HUMAN GORGO BRUMA MOUSE ONCVO MEGSC SCHMA CULSO NEMVE SCHMD]"
    python scripts/filter_oma_groups.py  HUMAN GORGO BRUMA MOUSE ONCVO MEGSC SCHMA CULSO NEMVE SCHMD
fi


# Exp_6 : HUMAN BOTFB FUSC1 MOUSE ONCVO BLUGR CRYPA CULSO NECHA SCHMD
FILE=./oma_seqs/exp_6
if [ -d "$FILE" ]; then
    echo -e "${OK} Exp_6 sequences found, skipping the extraction.."
else
    echo "Extracting [HUMAN BOTFB FUSC1 MOUSE ONCVO BLUGR CRYPA CULSO NECHA SCHMD]"
    python scripts/filter_oma_groups.py  HUMAN BOTFB FUSC1 MOUSE ONCVO BLUGR CRYPA CULSO NECHA SCHMD
fi


# Exp_6 : HUMAN SCHJY FUSC1 MOUSE ONCVO PHLGI COPCI CANAL RHIOR SCHMD
FILE=./oma_seqs/exp_7
if [ -d "$FILE" ]; then
    echo -e "${OK} Exp_7 sequences found, skipping the extraction.."
else
    echo "Extracting [HUMAN SCHJY FUSC1 MOUSE ONCVO PHLGI COPCI CANAL RHIOR SCHMD]"
    python scripts/filter_oma_groups.py  HUMAN SCHJY FUSC1 MOUSE ONCVO PHLGI COPCI CANAL RHIOR SCHMD
fi


# Exp_6 : HUMAN BRARP PHAVU GORGO ORYSI PHYPR COPCI CANAL RHIOR RETFI
FILE=./oma_seqs/exp_8
if [ -d "$FILE" ]; then
    echo -e "${OK} Exp_8 sequences found, skipping the extraction.."
else
    echo "Extracting [HUMAN BRARP PHAVU GORGO ORYSI PHYPR COPCI CANAL RHIOR RETFI]"
    python scripts/filter_oma_groups.py  HUMAN BRARP PHAVU GORGO ORYSI PHYPR COPCI CANAL RHIOR RETFI
fi




echo -e "\e[33m\e[1m
██╗  ██╗ ██████╗██╗     ██╗   ██╗███████╗████████╗███████╗██████╗ 
██║ ██╔╝██╔════╝██║     ██║   ██║██╔════╝╚══██╔══╝██╔════╝██╔══██╗
█████╔╝ ██║     ██║     ██║   ██║███████╗   ██║   █████╗  ██████╔╝
██╔═██╗ ██║     ██║     ██║   ██║╚════██║   ██║   ██╔══╝  ██╔══██╗
██║  ██╗╚██████╗███████╗╚██████╔╝███████║   ██║   ███████╗██║  ██║
╚═╝  ╚═╝ ╚═════╝╚══════╝ ╚═════╝ ╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝                                                                                                                                                                          
\e[0m"

#######################################
#              Indexing               #
#######################################

echo -e "\e[33m\e[1mIndexing .. \e[0m"

for dir in oma_seqs/*     # list directories in the form "/tmp/dirname/"
do

    exp_id=${dir%*/}
    exp_id=${exp_id##*/}
    
    if ls ${dir}/*map 1> /dev/null 2>&1; then
        echo -e "${OK} ${exp_id} already indexed, skipping.."
    else
        echo -e "${PROCESSING} Indexing ${exp_id##*/} .."
        /usr/bin/time -v kCluster index_kmers -f ${dir}/*.fa -n  ${dir}/*.fa.names -k 31 2>>${RUNLOG}
        mv idx* ${dir}
    fi

done

#######################################
#              Pairwise               #
#######################################

echo -e "\e[33m\e[1mCalculating Pairwise similarity .. \e[0m"

# virtualQs
# Set here all virtualQs you want to process
# ---------------------
QsList="30,31"
# ---------------------


for dir in oma_seqs/*     # list directories in the form "/tmp/dirname/"
do

    exp_id=${dir%*/}
    exp_id=${exp_id##*/}
    exp_no=$(echo "${exp_id//[!0-9]/}")
    idx_prefix=${dir}/idx_exp${exp_no}

    if ls ${dir}/*kCluster.tsv 1> /dev/null 2>&1; then
        echo -e "${OK} ${exp_id} pairwise matrix already exist, skipping.."
    else
        echo -e "${PROCESSING} Generating ${exp_id##*/} pairwise TSV .."
        /usr/bin/time -v ${kCluster_pairwise} --idx=${idx_prefix} --qs=${QsList} 2>>${RUNLOG}
    fi

done


#######################################
#              Pivoting               #
#######################################

echo -e "\e[33m\e[1mPivoting .. \e[0m"

for dir in oma_seqs/*     # list directories in the form "/tmp/dirname/"
do

    exp_id=${dir%*/}
    exp_id=${exp_id##*/}
    exp_no=$(echo "${exp_id//[!0-9]/}")
    idx_prefix=${dir}/idx_exp${exp_no}

    if ls ${dir}/*pivoted.tsv 1> /dev/null 2>&1; then
        echo -e "${OK} ${exp_id} pivoted pairwise matrix already exist, skipping.."
    else
        echo -e "${PROCESSING} Pivoting ${exp_id##*/} pairwise TSV .."
        /usr/bin/time -v ${kCluster_pairwise} pivote --idx=${dir}/idx_exp${exp_no} --qs=${QsList} 2>>${RUNLOG}
    fi

done

#######################################
#            Clustering               #
#######################################

for dir in oma_seqs/*     # list directories in the form "/tmp/dirname/"
do
    mkdir -p ${dir}/clusters
    exp_id=${dir%*/}
    exp_id=${exp_id##*/}
    exp_no=$(echo "${exp_id//[!0-9]/}")
    idx_prefix=${dir}/idx_exp${exp_no}
    # echo -e "${PROCESSING} Clustering ${dir}/idx_exp${exp_no}_pivoted.tsv"
    echo -e "\e[33m\e[1mClustering ${dir}/idx_exp${exp_no}_pivoted.ts .. \e[0m"

    for THRESHOLD in {0..100..1};
    do
        THRESHOLD=$(printf "%02d" $THRESHOLD)
        FILE=${dir}/clusters/clusters_0.${THRESHOLD}%_idx_exp${exp_no}_pivoted.tsv


        ### Special case for 100%
        if [ ${THRESHOLD} == 100 ]; then
            THRESHOLD="1.00"
            FILE=${dir}/clusters/clusters_1.00%_idx_exp${exp_no}_pivoted.tsv
            if [ -f "$FILE" ]; then
            echo -e "${OK} ${FILE} exists, skipping.."
            else
                echo "Threshold 1.00%"
                kCluster cluster --qs ${QsList} --tsv ${dir}/idx_exp${exp_no}_pivoted.tsv --cutoff 1.00
                mv clusters_1.00%_idx_exp${exp_no}_pivoted.tsv ${dir}/clusters
            fi

        ### END Special case for 100%

        else        
            if [ -f "$FILE" ]; then
                echo -e "${OK} ${FILE} exists, skipping.."
            else
                echo "Threshold ${THRESHOLD}%"
                kCluster cluster --qs ${QsList} --tsv ${dir}/idx_exp${exp_no}_pivoted.tsv --cutoff 0.${THRESHOLD}
                mv clusters_0.${THRESHOLD}%_idx_exp${exp_no}_pivoted.tsv ${dir}/clusters
            fi
        fi
    done

done

#######################################
#            Assessement               #
#######################################

echo -e "\e[33m\e[1mAssessing clustering of ${dir}/idx_exp${exp_no}_pivoted.tsv .. \e[0m"


for dir in oma_seqs/*     # list directories in the form "/tmp/dirname/"
do
    mkdir -p ${dir}/clusters/assessement/{summaries,details}
    exp_id=${dir%*/}
    exp_id=${exp_id##*/}
    exp_no=$(echo "${exp_id//[!0-9]/}")
    idx_prefix=${dir}/idx_exp${exp_no}

    for kClusters_file in ${dir}/clusters/clusters_*.tsv;
    do
        echo "Assessing ${kClusters_file} .."
        python scripts/kCluster_assess_by_OMA.py ${kClusters_file}
        mv ${dir}/clusters/assessement*_summary.txt ${dir}/clusters/assessement/summaries
        mv ${dir}/clusters/assessement*tsv ${dir}/clusters/assessement/details
    done

done

#######################################
#            Visualization            #
#######################################


for dir in oma_seqs/*     # list directories in the form "/tmp/dirname/"
do
    echo -e "\e[33m\e[1mVisualizing clustering assessement of ${dir} .. \e[0m"
    python scripts/visualize_clustering_assessment.py ${dir}/clusters/assessement/summaries
done

echo -e "\e[33m\e[1m
 ██████╗██████╗       ██╗  ██╗██╗████████╗
██╔════╝██╔══██╗      ██║  ██║██║╚══██╔══╝
██║     ██║  ██║█████╗███████║██║   ██║   
██║     ██║  ██║╚════╝██╔══██║██║   ██║   
╚██████╗██████╔╝      ██║  ██║██║   ██║   
 ╚═════╝╚═════╝       ╚═╝  ╚═╝╚═╝   ╚═╝                                                                                                                                                                          
\e[0m"

declare -A WORDSIZE

WORDSIZE[75]=4
WORDSIZE[80]=5
WORDSIZE[85]=6
WORDSIZE[90]=8
WORDSIZE[95]=10
                    
#######################################
#            Clustering               #
#######################################


for dir in oma_seqs/*     # list directories in the form "/tmp/dirname/"
do
    exp_id=${dir%*/}
    exp_id=${exp_id##*/}
    exp_no=$(echo "${exp_id//[!0-9]/}")
    idx_prefix=${dir}/idx_exp${exp_no}

    mkdir -p ${dir}/cdhit/{summaries,details}

    for THRESHOLD in 75 80 85 90 95;
    do
        FILE=${dir}/cdhit/exp${exp_no}_${THRESHOLD}.cdhit
        if [ -f "$FILE" ]; then
            echo -e "${OK} ${FILE} found, skipping the clustering.."
        else
            echo "Clustering exp${exp_no}.fa with threshold ${THRESHOLD}%"
            /usr/bin/time -v cd-hit-est -c 0.${THRESHOLD} -T 0 -M 0 -n ${WORDSIZE[${THRESHOLD}]} -d 0 -i ${dir}/exp${exp_no}.fa -o ${FILE} 2>>${RUNLOG}
        fi
        
    done

done

                    
#######################################
#            Assessement              #
#######################################

for dir in oma_seqs/*     # list directories in the form "/tmp/dirname/"
do

    exp_id=${dir%*/}
    exp_id=${exp_id##*/}
    exp_no=$(echo "${exp_id//[!0-9]/}")

    for THRESHOLD_dir in ${dir}/cdhit/*clstr
    do
        THRESHOLD_NO=${THRESHOLD_dir%*/}
        THRESHOLD_NO=${THRESHOLD_NO##*/}
        echo ${THRESHOLD_dir}
        python scripts/cdhit_assess_by_OMA.py ${dir}/exp${exp_no}.fa ${THRESHOLD_dir}
    done


done

#######################################
#            Visualization            #
#######################################

for dir in oma_seqs/*
do
    python scripts/visualize_clustering_assessment.py ${dir}/cdhit/summaries
done

#Delta Corpse priest 1
echo -e "\e[92m\e[1m
████████▄   ▄██████▄  ███▄▄▄▄      ▄████████ 
███   ▀███ ███    ███ ███▀▀▀██▄   ███    ███ 
███    ███ ███    ███ ███   ███   ███    █▀  
███    ███ ███    ███ ███   ███  ▄███▄▄▄     
███    ███ ███    ███ ███   ███ ▀▀███▀▀▀     
███    ███ ███    ███ ███   ███   ███    █▄  
███   ▄███ ███    ███ ███   ███   ███    ███ 
████████▀   ▀██████▀   ▀█   █▀    ██████████ 
\e[0m"