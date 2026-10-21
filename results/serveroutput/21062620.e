Loading apps/binapps/pytorch/2.3.0-311-gpu-cu121
  Loading requirement: apps/binapps/anaconda3/2023.09
Device set to use cuda:0
Loading checkpoint shards:   0%|          | 0/2 [00:00<?, ?it/s]Loading checkpoint shards:  50%|█████     | 1/2 [01:15<01:15, 75.24s/it]Loading checkpoint shards: 100%|██████████| 2/2 [01:59<00:00, 56.91s/it]Loading checkpoint shards: 100%|██████████| 2/2 [01:59<00:00, 59.66s/it]
Device set to use cuda:0
  0%|          | 0/1 [00:00<?, ?it/s]Token indices sequence length is longer than the specified maximum sequence length for this model (211270 > 131072). Running this sequence through the model will result in indexing errors
This is a friendly reminder - the current text generation call will exceed the model's predefined maximum length (32768). Depending on the model, you may observe exceptions, performance degradation, or nothing at all.
You seem to be using the pipelines sequentially on GPU. In order to maximize efficiency please use a dataset
100%|██████████| 1/1 [04:16<00:00, 256.89s/it]100%|██████████| 1/1 [04:16<00:00, 256.90s/it]
