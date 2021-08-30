import numpy as np
data_dir = "smiles-data/"
src_data_name_list = ["train.src",
                      "test.src",
                      "val.src"
                      ]
tgt_data_name_list = ["train.tgt",
                      "test.tgt",
                      "val.tgt"
                      ]

train_proportion = 0.6
test_proportion = 0.2
val_proportion = 0.2

src_smiles_data = []
for file_name in src_data_name_list:
    with open(data_dir+file_name, "r") as f:
        src_smiles_data = src_smiles_data+f.readlines()

tgt_smiles_data = []
for file_name in tgt_data_name_list:
    with open(data_dir+file_name, "r") as f:
        tgt_smiles_data = tgt_smiles_data+f.readlines()

data_count = len(src_smiles_data)
random_index = np.random.permutation(data_count).tolist()
src_smiles_data = np.array(src_smiles_data)[random_index].tolist()
tgt_smiles_data = np.array(tgt_smiles_data)[random_index].tolist()

with open(data_dir+"random-train.src", "w") as src_f, open(data_dir+"random-train.tgt", "w") as tgt_f:
    src_f.writelines(src_smiles_data[:int(data_count*train_proportion)])
    tgt_f.writelines(tgt_smiles_data[:int(data_count*train_proportion)])

with open(data_dir+"random-test.src", "w") as src_f, open(data_dir+"random-test.tgt", "w") as tgt_f:
    src_f.writelines(src_smiles_data[int(data_count*train_proportion):
                                     -int(data_count*val_proportion)])
    tgt_f.writelines(tgt_smiles_data[int(data_count*train_proportion):
                                     -int(data_count*val_proportion)])

with open(data_dir+"random-val.src", "w") as src_f, open(data_dir+"random-val.tgt", "w") as tgt_f:
    src_f.writelines(src_smiles_data[-int(data_count*val_proportion):])
    tgt_f.writelines(tgt_smiles_data[-int(data_count*val_proportion):])

print(data_count, " data have been shuffled!")
