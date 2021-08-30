# molecular-fairseq

We use fairseq to predict the molecular in chemical reactions.

How to use it:

1. Clone this repository

```shell
git clone https://github.com/TingtingWang021/molecular-fairseq.git

cd molecular-fairseq

unzip smiles-data.zip
```

2. Preprocess data

```shell
sudo chmod a+x preparedata.sh
./preparedata.sh
```

3. Train the model

```shell
sudo chmod a+x train.sh
./train.sh
```

4. Translation

```shell
sudo chmod a+x translation.sh
./translation.sh
```

5. Random selection

If you want to verify the data generalization ability yourself, you can use random selection to test, which will disrupt the data. Then you can translate the scrambled data again and view the results.

```shell
python3 randomselection.py
./translation.sh
```
