# Train a contribution classifier

* After annotation, we can construct a small dataset for training a contribution classifier
at sentence-level. First, prepare the data in the right format:
    ```sh
    python mkdata.py \
        --annotation-file results/bert-annot.txt \
        --data-file train-small.jsonl \
        --target-dir data \
        --add-special-position-token
    ```

Annotation file and the source data file has to be the same, because the same random seed is used to subset the data.
`--add-special-position-token` will add one of three tokens which specifies the "position" of the sentence in the abstract.
The idea behind this is that contributions (main findings) tend to appear at later part of the abstracts.


* The following command will fine-tune SciBERT on the data.
    ```sh
    python run_classifier.py \
        --data_dir data \
        --output_dir exp \
        --do_train \
        --do_eval \
        --fp16 \
        --logging_steps 50 \
        --logdir bert_exp \
        --num_train_epochs 10
    ```

* Run the following command to apply the learned model on the existing dataset to re-dump over all the abstracts.
    ```sh
    ./infer.sh ORIGINAL_DATA EXP ID GPU_ID
    ```
    where ID represents which splits to run inference on (cf. infer.sh).


### Use the contribution classifier to evaluate summaries

The learned model can also be used to measure the purity score by labeling generated summaries.
After training the model and running inference on valid/test set, run the following:

```sh
./eval_output.sh MODE EXP1 EXP2 ...
```
where `MODE` is either of `contribution` or `other`, depending on which mode to measure purity.
Mode is followed by system outputs (experiments) generated by summarization model inference.

