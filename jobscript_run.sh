#!/bin/bash --login
#SBATCH -p gpuA       #  gpuA, gpuL
#SBATCH -G 1                  # 1 GPU
#SBATCH -t 4-0                # Wallclock limit (1-0 is 1 day, 4-0 is the max permitted)
#SBATCH -n 1                  # One Slurm task
#SBATCH -c 8     
#SBATCH -e results/serveroutput/%j.e
#SBATCH -o results/serveroutput/%j.o

# Purge modules
module purge
module load apps/binapps/pytorch/2.3.0-311-gpu-cu121
source activate cup



#Request the number of GPUs needed (adjust as per your requirement)
NUM_GPUS=1
# Run with -u flag so print statements should print immediately
nvidia-smi

# Function to find free GPUs
find_free_gpus() {
    # Use nvidia-smi to list all GPUs and their memory usage
    nvidia-smi --query-gpu=index,memory.used --format=csv,noheader,nounits | \
    awk '$2 == 0 {print $1}' | head -n $1
}

# Find free GPUs
FREE_GPUS=$(find_free_gpus $NUM_GPUS)
echo $FREE_GPUS 
echo $NUM_GPUS
# Check if enough GPUs are free
if [ $(echo $FREE_GPUS | wc -w) -lt $NUM_GPUS ]; then
    echo "Not enough free GPUs available. Exiting."
    exit 1
fi

# Assign free GPUs to CUDA_VISIBLE_DEVICES

echo "Using GPUs: $FREE_GPUS"
FREE_GPUS_ARRAY=($FREE_GPUS)

# CUDA_VISIBLE_DEVICES=${FREE_GPUS_ARRAY[0]} python tests.py
# CUDA_VISIBLE_DEVICES=${FREE_GPUS_ARRAY[0]} python run.py --dataset beauty --system-model meta-llama/Llama-3.2-3B-Instruct
CUDA_VISIBLE_DEVICES=${FREE_GPUS_ARRAY[0]} python run.py \
  --dataset beauty \
  --system-model Qwen/Qwen2.5-3B-Instruct \
  --sim-model Qwen/Qwen2.5-1.5B-Instruct