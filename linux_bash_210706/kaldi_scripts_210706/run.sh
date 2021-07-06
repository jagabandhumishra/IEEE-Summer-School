#!/bin/bash
clear
date
#set-up for single machine or cluster based execution
. ./cmd.sh
#set the paths to binaries and other executables
[ -f path.sh ] && . ./path.sh
train_cmd=run.pl
decode_cmd=run.pl

numLeavesMLLT=2000
numGaussMLLT=16000
numLeavesSAT=2000
numGaussSAT=16000
numGaussUBM=400
numLeavesSGMM=7000
numGaussSGMM=9000

nsenone=2000
ngauss=16

train_nj=4
decode_nj=4

#================================================
#	SET SWITCHES
#================================================

mfcc_extract_sw=1

mono_train_sw=0
mono_test_sw=0

tri1_train_sw=0
tri1_test_sw=0

tri2_train_sw=0
tri2_test_sw=0

tri3_train_sw=0
tri3_test_sw=0

sgmm_train_sw=0
sgmm_test_sw=0

dnn_train_sw=0
dnn_test_sw=0

#================================================
# Set Directories
#================================================

train_dir1=data/train
train_lang_dir=data/lang_bigram

test_dir1=data/test
test_lang_dir1=data/lang_bigram

graph_dir1=graph_test_bigram
decode_dir1=decode_test_bigram

#================================================
# Database dependent preparatory work 
#================================================

# The following set of commands were executed in advance
#  to check that the linguistic resources are in proper order.
./create_wav_scp.sh
#./generate_lm_input_file.sh
./create_bigram_lm.sh
date
#===============================================================

if [ $mfcc_extract_sw == 1 ]; then
  echo =======================================================================
  echo "         MFCC Feature Extration & CMVN for Training        "
  echo =======================================================================
  #extract MFCC features and perfrom CMVN
  mfccdir=mfcc
  for x in train test ; do 
	steps/make_mfcc.sh --cmd "$train_cmd" --nj 20 data/$x exp/make_mfcc/$x $mfccdir || exit 1;
 	steps/compute_cmvn_stats.sh data/$x exp/make_mfcc/$x $mfccdir || exit 1;
	utils/fix_data_dir.sh data/$x
	utils/validate_data_dir.sh data/$x
  done
  date
fi

if [ $mono_train_sw == 1 ]; then
  echo =======================================================================
  echo "                   MonoPhone Training                	        "
  echo =======================================================================
  steps/train_mono.sh  --nj "$train_nj" --cmd "$train_cmd" $train_dir1 $train_lang_dir exp/mono || exit 1; 
fi

if [ $mono_test_sw == 1 ]; then
  echo =======================================================================
  echo "                   MonoPhone Testing             	        "
  echo =======================================================================
  utils/mkgraph.sh --mono $test_lang_dir1 exp/mono exp/mono/$graph_dir1 || exit 1;
  steps/decode.sh --nj "$decode_nj" --cmd "$decode_cmd" exp/mono/$graph_dir1 $test_dir1 exp/mono/$decode_dir1 || exit 
  # The following line was introduced by chief on 10-JUN-2019
  grep WER exp/mono/decode*/wer*
  date
fi

if [ $tri1_train_sw == 1 ]; then
  echo =======================================================================
  echo "           tri1 : Deltas + Delta-Deltas Training      "
  echo =======================================================================
  steps/align_si.sh --boost-silence 1.25 --nj "$train_nj" --cmd "$train_cmd" $train_dir1 $train_lang_dir exp/mono exp/mono_ali || exit 1; 
  for sen in $nsenone; do 
    for gauss in $ngauss; do 
	gauss=$(($sen * $gauss)) 
	steps/train_deltas.sh --cmd "$train_cmd" $sen $gauss $train_dir1 $train_lang_dir exp/mono_ali exp/tri1 || exit 1;
    done
  done
fi

if [ $tri1_test_sw == 1 ]; then
  echo =======================================================================
  echo "           tri1 : Deltas + Delta-Deltas  Decoding            "
  echo =======================================================================
  utils/mkgraph.sh $test_lang_dir1 exp/tri1 exp/tri1/$graph_dir1 || exit 1;
steps/decode.sh --nj "$decode_nj" --cmd "$decode_cmd"  exp/tri1/$graph_dir1 $test_dir1 exp/tri1/$decode_dir1 || exit 1;
  grep WER exp/tri1/decode*/wer*
  date
fi

if [ $tri2_train_sw == 1 ]; then
  echo =======================================================================
  echo "                 tri2 : LDA + MLLT Training                    "
  echo =======================================================================
  steps/align_si.sh --nj "$train_nj" --cmd "$train_cmd" $train_dir1 $train_lang_dir exp/tri1 exp/tri1_ali || exit 1;
  steps/train_lda_mllt.sh --cmd "$train_cmd" --splice-opts "--left-context=4 --right-context=4" $numLeavesMLLT $numGaussMLLT $train_dir1 $train_lang_dir exp/tri1_ali exp/tri2 || exit 1;
fi

if [ $tri2_test_sw == 1 ]; then
  echo =======================================================================
  echo "                 tri2 : LDA + MLLT Decoding                "
  echo =======================================================================
  utils/mkgraph.sh $test_lang_dir1 exp/tri2 exp/tri2/$graph_dir1 || exit 1;
steps/decode.sh --nj "$decode_nj" --cmd "$decode_cmd" exp/tri2/$graph_dir1 $test_dir1 exp/tri2/$decode_dir1 || exit 1;
  grep WER exp/tri2/decode*/wer*
  date
fi

if [ $tri3_train_sw == 1 ]; then
  echo =======================================================================
  echo "              tri3 : LDA + MLLT + SAT Training               "
  echo =======================================================================
  # Align tri2 system with train data.
  steps/align_si.sh --nj "$train_nj" --cmd "$train_cmd" \
 --use-graphs true $train_dir1 $train_lang_dir exp/tri2 exp/tri2_ali || exit 1;
  # From tri2 system, train tri3 which is LDA + MLLT + SAT.
  steps/train_sat.sh --cmd "$train_cmd" \
   $numLeavesSAT $numGaussSAT $train_dir1 $train_lang_dir exp/tri2_ali exp/tri3 || exit 1;
  steps/align_fmllr.sh --nj "$train_nj" --cmd "$train_cmd" \
   $train_dir1 $train_lang_dir exp/tri3 exp/tri3_ali || exit 1;
fi

if [ $tri3_test_sw == 1 ]; then
  echo =======================================================================
  echo "              tri3 : LDA + MLLT + SAT Decoding    Start             "
  echo =======================================================================
  utils/mkgraph.sh $test_lang_dir1 exp/tri3 exp/tri3/$graph_dir1 || exit 1;
  steps/decode_fmllr.sh --nj "$decode_nj" --cmd "$decode_cmd" exp/tri3/$graph_dir1 $test_dir1 exp/tri3/$decode_dir1 || exit 1;
  grep WER exp/tri3/decode*/wer*
  date
fi

if [ $sgmm_train_sw == 1 ]; then
  echo =======================================================================
  echo "                        SGMM2 Training                      "
  echo =======================================================================
  steps/train_ubm.sh --cmd "$train_cmd" \
   $numGaussUBM $train_dir1 $train_lang_dir exp/tri3_ali exp/ubm4 || exit 1;
  steps/train_sgmm2.sh --cmd "$train_cmd" $numLeavesSGMM $numGaussSGMM \
   $train_dir1 $train_lang_dir exp/tri3_ali exp/ubm4/final.ubm exp/sgmm2_4 || exit 1;
fi

if [ $sgmm_test_sw == 1 ]; then
  echo =======================================================================
  echo "                        SGMM2 Testing                     "
  echo =======================================================================
  utils/mkgraph.sh $test_lang_dir1 exp/sgmm2_4 exp/sgmm2_4/$graph_dir1 || exit 1;
  steps/decode_sgmm2.sh --nj "$decode_nj" --cmd "$decode_cmd" --transform-dir exp/tri3/$decode_dir1 exp/sgmm2_4/$graph_dir1 $test_dir1 exp/sgmm2_4/$decode_dir1 || exit 1;
  grep WER exp/sgmm2_4/decode*/wer*
  date
fi

if [ $dnn_train_sw == 1 ]; then
  echo =======================================================================
  echo "                    DNN Hybrid Training tri3 Aligned                  "
  echo =======================================================================
  # DNN hybrid system training parameters
  dnn_mem_reqs="mem_free=1.0G,ram_free=0.2G"
  dnn_extra_opts="--num_epochs 20 --num-epochs-extra 10 --add-layers-period 1 --shrink-interval 3"
  steps/nnet2/train_tanh.sh --mix-up 5000 --initial-learning-rate 0.015 \
    --final-learning-rate 0.002 --num-hidden-layers 4  \
    --num-jobs-nnet "$train_nj" --cmd "$train_cmd" "${dnn_train_extra_opts[@]}" \
    $train_dir1 $train_lang_dir exp/tri3_ali exp/DNN_tri3_aligned
fi

if [ $dnn_test_sw == 1 ]; then
  echo =======================================================================
  echo "                    DNN Hybrid Testing tri3 Aligned                  "
  echo =======================================================================
  dnn_mem_reqs="mem_free=1.0G,ram_free=0.2G"
  dnn_extra_opts="--num_epochs 20 --num-epochs-extra 10 --add-layers-period 1 --shrink-interval 3"

  # The following line was introduced by chief on 10-JUN-2019
  mkdir exp/DNN_tri3_aligned/$decode_dir1
  steps/nnet2/decode.sh --cmd "$decode_cmd" --nj "$decode_nj" "${decode_extra_opts[@]}" \
 --transform-dir exp/tri3/$decode_dir1 exp/tri3/$graph_dir1 $test_dir1 \
  exp/DNN_tri3_aligned/$decode_dir1 | tee exp/DNN_tri3_aligned/$decode_dir1/decode.log
  grep WER exp/DNN_tri3_aligned/decode*/wer*
  date


echo =======================================================================
echo "                     Training Testing Over                      "
echo =======================================================================

# The following block was introduced by chief on 10-JUN-2019
touch summary_WER.txt
echo "" >> summary_WER.txt;
echo "   WER(%) as a function of # of iterations for various acoustic models" >> summary_WER.txt
echo "" | perl -ne ' print "\niter ";foreach $x (1..20){printf "%5d",$x};' >> summary_WER.txt
for model in mono tri1 tri2 tri3 sgmm DNN_ ; do 
  echo "" >> summary_WER.txt;  echo -n "$model "  >> summary_WER.txt
  for iter in {1..20}; do
     perl -ne 'if ($_ =~ /WER (\d+\.\d)/){printf "%5.1f", $1} ' exp/$model*/decode*gram/wer_$iter >> summary_WER.txt
  done
done
echo "" >> summary_WER.txt;
tail summary_WER.txt

fi
date
