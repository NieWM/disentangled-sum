#!/bin/bash
# Copyright (c) 2018, salesforce.com, inc.

# All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause
# For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause

DEFAULT="controlcode"

if [ $# -eq 0 ]; then
    echo "Starting experiment with the default name: $DEFAULT"
else
    RUN_NAME=$1
    shift 1
fi

python -m torch.distributed.launch --nproc_per_node=8 -m src.main \
    --batch_size 10 \
    --gradient_accumulation_steps 8 \
    --max_input_length 1024 \
    --eval_every 6000 \
    --datadir /export/scisumm/filtered_s2orc_20190928/  \
    --eval_batch_size 8  \
    --max_eval_batches 100 \
    --learning_rate 3e-5 \
    --logdir results/${RUN_NAME:-$DEFAULT} \
    --tokenizer_name facebook/bart-large \
    --model_name_or_path sshleifer/student_cnn_6_6 \
    --input_type paper \
    --target_type both \
    --use_apex \
    --no_greedy_decode \
    --no_nucleus_decode \
    $@
