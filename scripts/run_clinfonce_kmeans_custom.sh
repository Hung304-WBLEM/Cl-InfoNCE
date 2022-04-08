#!/bin/sh


###################################
#     define variables     #
###################################
# train stuff
epoch=5;
save_freq=50;
learning_rate=0.03;
batch_size=8;


# data stuff
dataset="CUB";
gran_lvl=-1;
instruction="rank_H";
meta_file_train="meta_data_train.csv";
img_size=224;

# optimization
temp=0.2;
method="SupCon";
lr_scheduling="warmup";
# resume
if (! test -z "$2")
then
resume_model_path="$2/ckpt_epoch_$3.pth";
else
resume_model_path="";
fi
# linear eval
model_testing="ckpt_epoch_$epoch.pth";
# trail
trial=0;
# costomized name
customized_name=""

# data folder
data_folder="../data_processing/CUB"
data_root_name="images"
save_path="../train_related"

# kmeans clustering
warmup_epoch=0;
perform_cluster_epoch=1;
num_cluster=2500;


###################################
#         define command          #
###################################

# run supcon
run_command="CUDA_VISIBLE_DEVICES=$1 python ../clinfonce/main_clinfonce_kmeans.py --dataset $dataset \
--method $method \
--gran_lvl $gran_lvl \
--instruction $instruction \
--meta_file_train $meta_file_train \
--img_size $img_size \
--learning_rate $learning_rate \
--lr_scheduling $lr_scheduling \
--epochs $epoch \
--batch_size $batch_size \
--temp $temp \
--trial $trial \
--num_workers 20 \
--overwrite \
--save_freq $save_freq \
--model resnet50_original \
--data_folder $data_folder \
--data_root_name $data_root_name \
--save_path $save_path \
--warmup_epoch $warmup_epoch \
--perform_cluster_epoch $perform_cluster_epoch \
--num_cluster $num_cluster \
"

# add resume if specified
if (! test -z "$resume_model_path");
then
resume_command="\
--resume_model_path $resume_model_path
"
run_command="$run_command$resume_command"
fi

if (! test -z "$customized_name");
then
customized_name_command="\
--customized_name $customized_name
"
run_command="$run_command$customized_name_command"
fi



###################################
#               RUN               #
###################################
# display command
echo "======================";
echo $run_command;
echo "======================";

eval $run_command;





