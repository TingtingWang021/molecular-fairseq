echo 'Cloning Moses github repository (for tokenization scripts)...'
git clone git@github.com:moses-smt/mosesdecoder.git

echo 'Cloning Subword NMT repository (for BPE pre-processing)...'
git clone git@github.com:rsennrich/subword-nmt.git

DATA_DIR=smiles-data

rm -rf $DATA_DIR/*tok* $DATA_DIR/*voc* $DATA_DIR/*bpe*
rm -rf data-bin
rm -rf pre-tensorboard

perl mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < $DATA_DIR/train.src > $DATA_DIR/train.tok.src
perl mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < $DATA_DIR/val.src > $DATA_DIR/val.tok.src
perl mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < $DATA_DIR/test.src > $DATA_DIR/test.tok.src
perl mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < $DATA_DIR/train.tgt > $DATA_DIR/train.tok.tgt
perl mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < $DATA_DIR/val.tgt > $DATA_DIR/val.tok.tgt
perl mosesdecoder/scripts/tokenizer/tokenizer.perl -l en < $DATA_DIR/test.tgt > $DATA_DIR/test.tok.tgt

python subword-nmt/learn_joint_bpe_and_vocab.py -i $DATA_DIR/train.tok.src -o $DATA_DIR/bpecode.src --write-vocabulary $DATA_DIR/voc.src
python subword-nmt/learn_joint_bpe_and_vocab.py -i $DATA_DIR/train.tok.tgt -o $DATA_DIR/bpecode.tgt --write-vocabulary $DATA_DIR/voc.tgt

python subword-nmt/apply_bpe.py -c $DATA_DIR/bpecode.src < $DATA_DIR/train.tok.src > $DATA_DIR/train.tok.bpe.src
python subword-nmt/apply_bpe.py -c $DATA_DIR/bpecode.src < $DATA_DIR/val.tok.src > $DATA_DIR/val.tok.bpe.src
python subword-nmt/apply_bpe.py -c $DATA_DIR/bpecode.src < $DATA_DIR/test.tok.src > $DATA_DIR/test.tok.bpe.src

python subword-nmt/apply_bpe.py -c $DATA_DIR/bpecode.tgt < $DATA_DIR/train.tok.tgt > $DATA_DIR/train.tok.bpe.tgt
python subword-nmt/apply_bpe.py -c $DATA_DIR/bpecode.tgt < $DATA_DIR/val.tok.tgt > $DATA_DIR/val.tok.bpe.tgt
python subword-nmt/apply_bpe.py -c $DATA_DIR/bpecode.tgt < $DATA_DIR/test.tok.tgt > $DATA_DIR/test.tok.bpe.tgt

mkdir data-bin
mkdir pre-tensorboard

fairseq-preprocess --source-lang src --target-lang tgt  --trainpref $DATA_DIR/train.tok.bpe --validpref $DATA_DIR/val.tok.bpe --testpref $DATA_DIR/test.tok.bpe  --destdir data-bin/  --tensorboard-logdir  pre-tensorboard
