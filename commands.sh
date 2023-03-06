# The following commands were used to run the various tools on the MBARC dataset.
# The same experiments were run on the hot spring data using the paths to the necessary inputs.
# In order to run these commands, change the paths accordingly.
# All tools listed in this file are run from the command line.
# The machine learning commands are noted in separate notebooks.
# The input data files are provided here: https://drive.google.com/drive/u/0/folders/163FioZq0JmON4LGa-spdplsV3Qabme-a

## Assembly tools

# phyloFlash without modifications

perl phyloFlash.pl -lib mbarc-pf -read1 SRR3656745_1.fastq -read2 SRR3656745_2.fastq

# MetaSPAdes

python spades.py --meta --phred-offset 33 -1 SRR3656745_1.fastq -2 SRR3656745_2.fastq -o metaspades-mbarc

# Megahit

./megahit -1 SRR3656745_1.fastq  -2 SRR3656745_2.fastq  -m 1.0  -t 36  -o megahit-mbarc

## Analysis tools

# BBtools

# bbmap
# $i represents each reference genome in fasta format

for i in *.fasta;
do
    	sh bbmap.sh in=SRR3656745_1.fastq in2=SRR3656745_2.fastq ref=$i covstats=binmaps/${i}.cov bincov=bincov/${i}.bincov covbinsize=10000 nodisk;
done

# bbsplit

sh /scratch/rnd-rojas/assembly_stephanie/bbmap/bbsplit.sh in1=SRR3656745_1.fastq in2=SRR3656745_2.fastq \
ref=Clostridium_perfringensATCC_13124.fasta,Clostridium_thermocellumVPI_7372_ATCC_27405.fasta, \
Coraliomargarita_akajimensis_DSM_45221.fasta, \
Corynebacterium_glutamicum_ATCC_13032.fasta, \
Desulfosporosinus_acidiphilus_SJ4_DSM_22704.fasta, \
Desulfosporosinus_meridiei_DSM_13257.fasta, \
Desulfotomaculum_gibsoniae_DSM_7213.fasta, \
Echinicola_vietnamensis_DSM_17526.fasta, \
E.coli_K12_ATCC_700926.fasta, \
Fervidobacterium_pennivorans_DSM_9078.fasta, \
Frateuria_aurantia_DSM_6220.fasta, \
Halovivax_ruber_XH-70.fasta, \
Hirschia_baltica_ATCC_49814.fasta, \
Meiothermus_silvanus_DSM_9946.fasta, \
Natronobacterium_gregoryi_SP2.fasta, \
Natronococcus_occultus_DSM_3396.fasta, \
Nocardiopsis_dassonvillei_DSM_43111.fasta, \
Olsenella_uli_DSM_7084.fasta, \
Pseudomonas_stutzeri_RCH2.fasta, \
Salmonella_bongori_NCTC_12419.fasta, \
Salmonella_enterica_subsp._arizonae_serovar_62_z4_z23_-_strain_RSK2980.fasta, \
Segniliparus_rotundus_DSM_44985.fasta, \
Spirochaeta_smaragdinae_DSM_11293.fasta, \
Streptococcus_pyogenes_M1_GAS.fasta, \
Terriglobus_roseus_DSM_18391.fasta, \
Thermobacillus_composti_KWC4.fasta \
basename=bbsplit/out_%.fq

# shred
for reference in *.fasta; do sh shred.sh in=$reference out=shred100/${reference}.shred100.fasta length=100 overlap=6; done

# reformat
for i in *.fasta; do sh reformat.sh in=$i out=subsampleshred100/${i}.subsam.fasta samplereadstarget=16000; done

# stats
sh stats.sh in=contigs.fasta out=stats/meta-contigs-stats.txt score=f

# blast with silva db

blastn -db SILVA_119_SSURef_tax_silva.fasta -task megablast -out blast-silva.out -query scaffolds.fasta -outfmt 6 -perc_identity 100 -evalue 1e-30 -dust "yes" -num_threads 56
awk -F'\t' '{print $2}' blast-silva.out | sort | uniq > blast-silva.hit
fgrep -f blast-silva.hit SILVA_119_SSURef_tax_silva.fasta |  sed "s/^.*\[//g" | sort | uniq | awk '{print $1, $2}' |sort| uniq | sed 's/>\w\+//' | sed 's/.\w\+//' | sed 's/.\w\+//' | sed '/^$/d' | sed 's/^ *//g' > blast-silva.txt

# blast with img db

blastn -db isolate16s.fna -task megablast -out blast.img.out -query LIB.SSU.collection.fasta -outfmt 6 -perc_identity 100 -evalue 1e-30 -dust "yes" -num_threads 56
awk -F'\t' '{print $2}' blast.img.out | sort | uniq > blast.img.hit
fgrep -f blast.img.hit isolate16s.fna |  sed "s/^.*\[//g" | sort | uniq | awk '{print $1, $2}' |sort| uniq |wc
fgrep -f blast.img.hit isolate16s.fna |  sed "s/^.*\[//g" | sort | uniq | awk '{print $1, $2}' |sort| uniq
fgrep -f blast.img.hit isolate16s.fna |  sed "s/^.*\[//g" | sort | uniq | awk '{print $1, $2}' |sort| uniq > blast.img.txt

# barrnap

barrnap --incseq LIB.SSU.collection.fasta --outseq barrnap.fasta 2>&1

# spade

cd /scratch/rnd-rojas/assembly_stephanie/mockfastas/mockFastas;
for i in `ls *.fasta`; 
do 
    mkdir /scratch/rnd-rojas/assembly_stephanie/barrnap+ref/repeats/spade/${i%.fasta};
    cd /scratch/rnd-rojas/assembly_stephanie/barrnap+ref/repeats/spade/${i%.fasta}; 
    /scratch/rnd-rojas/assembly_stephanie/tools/SPADE/SPADE.py -in /scratch/rnd-rojas/assembly_stephanie/mockfastas/mockFastas/$i -f 'fasta' ; 
    cd /scratch/rnd-rojas/assembly_stephanie/mockfastas/mockFastas; 
done

# cd into one of the output directories
list=`find . -name 'repeat.gbk'`
count=0
for f in $list; do s=`head -1 $f`; let "count=count+`echo $s | cut -d ' ' -f3`"; done
echo $count

## Machine learning tools

# DNABERT
# Jupyter notebook is provided here: https://drive.google.com/drive/u/0/folders/1J2dXLEesjCKHrZgHAhBuZ6ZSX_CDTNLk
# Follow the notebook up until the 'Visualizing Results' section
# Execute the following commands from the command line

# Finetuning

cd examples
export KMER=6
export MODEL_PATH=/home/013879866/6
export DATA_PATH=sample_data/ft/$KMER
export OUTPUT_PATH=./ft/$KMER
python run_finetune.py \
    --model_type dna \
    --tokenizer_name=dna$KMER \
    --model_name_or_path $MODEL_PATH \
    --task_name dnaprom \
    --do_train \
    --do_eval \
    --data_dir $DATA_PATH \
    --max_seq_length 100 \
    --per_gpu_eval_batch_size=32   \
    --per_gpu_train_batch_size=32   \
    --learning_rate 2e-4 \
    --num_train_epochs 5.0 \
    --output_dir $OUTPUT_PATH \
    --evaluate_during_training \
    --logging_steps 100 \
    --save_steps 4000 \
    --warmup_percent 0.1 \
    --hidden_dropout_prob 0.1 \
    --overwrite_output \
    --weight_decay 0.01 \
    --n_process 8

# Predicting

export KMER=6
export MODEL_PATH=./ft/$KMER
export DATA_PATH=sample_data/ft/$KMER
export PREDICTION_PATH=./result/$KMER
python run_finetune.py \
    --model_type dna \
    --tokenizer_name=dna$KMER \
    --model_name_or_path $MODEL_PATH \
    --task_name dnaprom \
    --do_predict \
    --data_dir $DATA_PATH  \
    --max_seq_length 75 \
    --per_gpu_pred_batch_size=128   \
    --output_dir $MODEL_PATH \
    --predict_dir $PREDICTION_PATH \
    --n_process 48

# Calculating attention scores

export KMER=6
export MODEL_PATH=./ft/$KMER
export DATA_PATH=sample_data/ft/$KMER
export PREDICTION_PATH=./result/$KMER
python run_finetune.py \
    --model_type dna \
    --tokenizer_name=dna$KMER \
    --model_name_or_path $MODEL_PATH \
    --task_name dnaprom \
    --do_visualize \
    --visualize_data_dir $DATA_PATH \
    --visualize_models $KMER \
    --data_dir $DATA_PATH \
    --max_seq_length 81 \
    --per_gpu_pred_batch_size=16   \
    --output_dir $MODEL_PATH \
    --predict_dir $PREDICTION_PATH \
    --n_process 96

# Follow the rest of the previous notebook from the 'Visualizing Results' section

# DeLUCS

# The notebook can be found here: https://drive.google.com/drive/u/0/folders/1GBwolGHboBJYkMo85g5P-lmBpG1_r0Mz
# The modified src files can be found here: https://drive.google.com/drive/u/0/folders/1PastpOraCb_a5JWlZABHao0928zkUyMP