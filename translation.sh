fairseq-generate data-bin/ --path checkpoints/checkpoint_best.pt  --batch-size 128 --beam 5 >result.txt

grep ^H result.txt | cut -f3- > temp2.txt

sed -r 's/(@@ )| (@@ ?$)//g' < temp2.txt  > temp3.txt

perl mosesdecoder/scripts/generic/multi-bleu.perl smiles-data/test.tok.tgt < temp3.txt 
perl mosesdecoder/scripts/tokenizer/detokenizer.perl -l en < temp3.txt  > predict.txt
perl mosesdecoder/scripts/generic/multi-bleu.perl smiles-data/test.tgt < predict.txt 

fairseq-score -s predict.txt -r smiles-data/test.tgt --sentence-bleu
