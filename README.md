# OpenCL Usage
Learning how to use OpenCL and its properties on STAN.
This file is going to contain descriptions, code snippets, experiments and explanations of how to use OpenCl to make use of GPU for the purpose of learning HPC via STAN. 
I am using an Ubuntu 20.04 LTS workstation. There are two graphic processing units on it however since we need to present our hardware for comparison purposes we consult https://livingthelinuxlifestyle.wordpress.com/2019/08/19/how-to-use-the-lshw-command-to-view-computer-hardware-in-linux/ to understand the machine we are working on. 

The first thing to remember is that just because you have a GPU does not mean your STAN program is going to run faster. GPU s are useful for matrix operations. If your program does not have matrix operations that feed into the processors of the GPU which speed up computations there is no reason for your calculations to be done faster.    
0) Particulars of STAN
1) https://en.wikipedia.org/wiki/CUDA What is CUDA 
   CUDA stands for Compute Unified Device Architecture and is an application programming interface. It allows the usage of GPU resources via C, C++, Fortran. It also supports openCL. It is a propriety framework of NVIDIA 
2) https://www.khronos.org/events/accelerating-machine-learning-with-opencl openCL stands for Open Computer Language which is a programming framework that allows communication across CPUs and GPUs. OpenCL is not used when the covariate argument to the GLM functions is a row_vector.
3) CUDA vs OpenCL https://www.run.ai/guides/nvidia-cuda-basics-and-best-practices/cuda-vs-opencl However in order to operate OpenCL you need to install runtime and since we have NVIDIA GPUs we will be using NVIDIA API CUDA. AMD, INTEL has their own software. 
4) Why NVIDIA
5) How to use cmdSTAN
6) Experimental Results
First we need to present our hardware that Ubuntu uses. The link https://livingthelinuxlifestyle.wordpress.com/2019/08/19/how-to-use-the-lshw-command-to-view-computer-hardware-in-linux/ specifies useful commands. 

#The program to eventually run on CmdStan obtained from https://mc-stan.org/cmdstanr/articles/opencl.html for a logistic regression model with 150000 iterations where 100000 is warmup:

for i in {1..3}; do ./rpubsfirststan sample num_warmup=100000 num_samples=50000 data file=./firstopenCL.r output file=output file=withcl_${i} opencl platform=0 device=1 &done

note that if we did not want to use the GPU, the only thing we would need to do is 
for i in {1..3}; do ./rpubsfirststan sample num_warmup=100000 num_samples=50000 data file=./firstopenCL.r output file=output file=withcl_${i} &done

but in order to run this the things that need to be done:
0) I am assuming you have already installed STAN.

a) What type of GPU s do you have? I have NVIDIA 3090 so I need to install CUDA for the OpenCL runtime https://mc-stan.org/docs/2_29/cmdstan-guide/parallelization.html .

c) 

