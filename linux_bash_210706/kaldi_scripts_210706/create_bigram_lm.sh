#!/bin/bash
date
#set-up for single machine or cluster based execution
. ./cmd.sh
#set the paths to binaries and other executables
[ -f path.sh ] && . ./path.sh

#basepath='/home/samudravijaya/kaldi/assamese17'

basepath=$PWD
lm_arpa_path=$basepath/data/local/lm
train_dict=dict
train_lang=lang_bigram
train_folder=train

# This specifies bigram or trigram. for bigram set n_gram=2 for tri_gram set n_gram=3
n_gram=2 

echo ============================================================================
echo "                   Training $n_gram -gram LM               	        "
echo ============================================================================

rm -rf $basepath/data/local/$train_dict/lexiconp.txt $basepath/data/local/$train_lang $basepath/data/local/tmp_$train_lang $basepath/data/$train_lang

mkdir -p $basepath/data/local/tmp_lang_bigram

utils/prepare_lang.sh --num-sil-states 3 data/local/$train_dict '!SIL' data/local/$train_lang data/$train_lang

#/home/Kaldi_Workspace/kaldi-master/tools/irstlm/bin/build-lm.sh -i $basepath/data/$train_folder/lm_train.txt -n $n_gram -o $basepath/data/local/tmp_lang_bigram/lm_phone_bg.ilm.gz
build-lm.sh -i $basepath/data/$train_folder/lm_train.txt -n $n_gram -o $basepath/data/local/tmp_lang_bigram/lm_phone_bg.ilm.gz

gunzip -c $basepath/data/local/tmp_lang_bigram/lm_phone_bg.ilm.gz | utils/find_arpa_oovs.pl data/$train_lang/words.txt  > data/local/tmp_lang_bigram/oov.txt

#gunzip -c $basepath/data/local/tmp_$train_lang/lm_phone_bg.ilm.gz | grep -v '<s> <s>' | grep -v '<s> </s>' | grep -v '</s> </s>' | grep -v 'SIL' | /home/Kaldi_Workspace/kaldi-master/src/lmbin/arpa2fst - | fstprint | utils/remove_oovs.pl data/local/tmp_$train_lang/oov.txt | utils/eps2disambig.pl | utils/s2eps.pl | fstcompile --isymbols=data/$train_lang/words.txt --osymbols=data/$train_lang/words.txt --keep_isymbols=false --keep_osymbols=false | fstrmepsilon > data/$train_lang/G.fst 
gunzip -c $basepath/data/local/tmp_$train_lang/lm_phone_bg.ilm.gz | grep -v '<s> <s>' | grep -v '<s> </s>' | grep -v '</s> </s>' | grep -v 'SIL' | arpa2fst - | fstprint | utils/remove_oovs.pl data/local/tmp_$train_lang/oov.txt | utils/eps2disambig.pl | utils/s2eps.pl | fstcompile --isymbols=data/$train_lang/words.txt --osymbols=data/$train_lang/words.txt --keep_isymbols=false --keep_osymbols=false | fstrmepsilon > data/$train_lang/G.fst 

#/home/Kaldi_Workspace/kaldi-master/src/fstbin/fstisstochastic data/$train_lang/G.fst 
fstisstochastic data/$train_lang/G.fst 

date
exit
