rm -rf checkpoints
rm -rf train-tensorboard

mkdir checkpoints
mkdir train-tensorboard

#--optimizer {adadelta,adam,adafactor,adagrad,lamb,nag,adamax,sgd
CUDA_VISIBLE_DEVICES=0 fairseq-train data-bin --optimizer adadelta  --lr 0.25 --clip-norm 0.1 --dropout 0.2 --max-tokens 4000 --arch fconv_iwslt_de_en --save-dir checkpoints --tensorboard-logdir  train-tensorboard --max-epoch 120 &> train.log
