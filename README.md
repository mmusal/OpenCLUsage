# OpenCL with STAN Usage

# Basic Concepts: 
Before going into details we need a very short introduction to CPUs and GPUs. Floating point and arithmatic logic units are where the calculations are done in a computer. In a modern computer these exist in CPUs and GPUs (FPUs used to be stand alone components). So we should look into their details somewhat before anything else.

# What is a Central Processing Unit: 
"A CPU, a general purpose computing device, being the brains of your computer carries out instruction sets which is a machine code." 
https://www.howtogeek.com/694869/what-is-a-cpu-and-what-does-it-do/  
On a typical laptop a CPU there usually exists multiple cores. Common numbers of these are 2,4,8. On a workstation or server there will be a lot more. Each CPU core has its own set of registeries where calculations can happen. However just because you have more cores does not mean the speed of your procedures will linearly increase.  
When you have multiple cores as most modern computers do, you need the operating sytem and applications to help put the processes together. If you do not have this supporting act then only one CPU is used. One CPU core is a lot faster than a core in a GPU however there are a lot more cores in a GPU.

# What is a Graphical Processing Unit: 
A GPU core is similar to a CPU core but has a lot less involved instruction sets. This means what they can achieve is limited in context. GPUs become useful if what you would like to achieve is a set of calculations which can be run in parallel. This is clear for the case of Deep Learning where operations can be done independent of each other. However in the case of MCMCs utilized for Bayesian computation, the advantage is not immediately evident. It is straightforward to assign each chain of the MCMC to a separate core and if that is the only thing to be done it is better to assign it to CPU core. On the other hand there are many cases where you are applying a GLM model and/or involve matrix calculations that can be done in parallel for instance Cholesky decomposition, this is where we might incur an advantage. The development of GPU usage for STAN is listed in  https://arxiv.org/pdf/1907.01063.pdf  
There is more on GPU usage for data science tasks by NVIDIA https://developer.nvidia.com/blog/cuda-refresher-reviewing-the-origins-of-gpu-computing/
# How are they put together:  
Learning how to use OpenCL and its properties on STAN.
This file is going to contain descriptions, code snippets, experiments and explanations of how to use OpenCl to make use of GPU for the purpose of learning HPC via STAN. 
I am using an Ubuntu 20.04 LTS workstation. We need to present our hardware for comparison purposes we consult https://livingthelinuxlifestyle.wordpress.com/2019/08/19/how-to-use-the-lshw-command-to-view-computer-hardware-in-linux/ and https://manpages.ubuntu.com/manpages/bionic/man1/clinfo.1.htmlto understand the machine we are working on. 

#CPU  
sudo lshw -short -class processor  
AMD Ryzen Threadripper 3990X 64-Core Processor  
#RAM  
sudo lshw -short -class memory  
/0/9                                      memory         256GiB System Memory
/0/9/0                                    memory         32GiB DIMM DDR4 Synchronous Unbuffered (Unregistered) 3200 MHz (0.3 ns)  
/0/9/1                                    memory         32GiB DIMM DDR4 Synchronous Unbuffered (Unregistered) 3200 MHz (0.3 ns)  
/0/9/2                                    memory         32GiB DIMM DDR4 Synchronous Unbuffered (Unregistered) 3200 MHz (0.3 ns)  
/0/9/3                                    memory         32GiB DIMM DDR4 Synchronous Unbuffered (Unregistered) 3200 MHz (0.3 ns)  
/0/9/4                                    memory         32GiB DIMM DDR4 Synchronous Unbuffered (Unregistered) 3200 MHz (0.3 ns)  
/0/9/5                                    memory         32GiB DIMM DDR4 Synchronous Unbuffered (Unregistered) 3200 MHz (0.3 ns)  
/0/9/6                                    memory         32GiB DIMM DDR4 Synchronous Unbuffered (Unregistered) 3200 MHz (0.3 ns)  
/0/9/7                                    memory         32GiB DIMM DDR4 Synchronous Unbuffered (Unregistered) 3200 MHz (0.3 ns)  

#Graphics cards  
clinfo --human --list    
Platform #0: NVIDIA CUDA    
 +-- Device #0: NVIDIA GeForce RTX 3090  
 `-- Device #1: NVIDIA GeForce RTX 3090  

The first thing to remember is that just because you have a GPU does not mean your STAN program is going to run faster. GPU s are useful for matrix operations. If your program does not have matrix operations that feed into the processors of the GPU which speed up computations there is no reason for your calculations to be done faster. The functions that are faster via GPUs and OpenCL without further coding is listed https://mc-stan.org/docs/2_29/stan-users-guide/opencl.html  

0) Particulars of STAN
1) https://en.wikipedia.org/wiki/CUDA What is CUDA 
   CUDA stands for Compute Unified Device Architecture and is an application programming interface. It allows the usage of GPU resources via C, C++, Fortran. It also supports openCL. It is a propriety framework of NVIDIA 
2) https://www.khronos.org/events/accelerating-machine-learning-with-opencl openCL stands for Open Computer Language which is a programming framework that allows communication across CPUs and GPUs. OpenCL is not used when the covariate argument to the GLM functions is a row_vector.
3) CUDA vs OpenCL https://www.run.ai/guides/nvidia-cuda-basics-and-best-practices/cuda-vs-opencl However in order to operate OpenCL you need to install runtime and since we have NVIDIA GPUs we will be using NVIDIA API CUDA. AMD, INTEL has their own software. 
4) Experimental Results
First we need to present our hardware that Ubuntu uses. The link https://livingthelinuxlifestyle.wordpress.com/2019/08/19/how-to-use-the-lshw-command-to-view-computer-hardware-in-linux/ specifies useful commands. 

#The program to eventually run on CmdStan obtained from https://mc-stan.org/cmdstanr/articles/opencl.html for a logistic regression model with 150000 iterations where 100000 is warmup:

for i in {1..3}; do ./rpubsfirststan sample num_warmup=100000 num_samples=50000 data file=./firstopenCL.r output file=output file=withcl_${i} opencl platform=0 device=1 &done

note that if we did not want to use the GPU, the only thing we would need to do is 
for i in {1..3}; do ./rpubsfirststan sample num_warmup=100000 num_samples=50000 data file=./firstopenCL.r output file=output file=withcl_${i} &done

but in order to run this the things that need to be done:
0) I am assuming you have already installed STAN.

a) What type of GPU s do you have? I have NVIDIA 3090 so I need to install CUDA for the OpenCL runtime https://mc-stan.org/docs/2_29/cmdstan-guide/parallelization.html .

c) Results from a model with and without OpenCL. Logistic Regression model with 100,000 warmup and 50,000 Sampling iterations. 
Without OpenCL
Elapsed Time: 6370.38 seconds (Warm-up)
               3109.77 seconds (Sampling)
               9480.14 seconds (Total)

 Elapsed Time: 6344.14 seconds (Warm-up)
               3080.23 seconds (Sampling)
               9424.37 seconds (Total)


 Elapsed Time: 5940.8 seconds (Warm-up)
               3095.2 seconds (Sampling)
               9036 seconds (Total)


############################
With OpenCl
 Elapsed Time: 2340.08 seconds (Warm-up)
               1187.99 seconds (Sampling)
               3528.07 seconds (Total)

 Elapsed Time: 2341.58 seconds (Warm-up)
               1188.26 seconds (Sampling)
               3529.83 seconds (Total)

 Elapsed Time: 2340.57 seconds (Warm-up)
               1189.59 seconds (Sampling)
               3530.17 seconds (Total)
               
 When we reduce the number of iterations by an order of 10 we see the time adjust linearly: 
for i in {1..3}; do ./rpubsfirststan sample num_warmup=10000 num_samples=5000 data file=./firstopenCL.r output file=output file=withcl_${i} opencl platform=0 device=1 &done  
 the total run time reduces by the same amount. 
  Elapsed Time: 235.384 seconds (Warm-up)
               119.256 seconds (Sampling)
               354.64 seconds (Total)

 Elapsed Time: 235.603 seconds (Warm-up)
               119.366 seconds (Sampling)
               354.969 seconds (Total)

 Elapsed Time: 235.726 seconds (Warm-up)
               119.346 seconds (Sampling)
               355.072 seconds (Total)

Now that we have demonstrated the utility of GPUs in our program let us start changing our STAN program we have used in our upcoming paper regarding the effect of social determinants of health on covid mortality in the counties of California.
# GLM Application Work 
The baseline model we have is listed in nogpugeneralinteractionswithspatial.stan. This model is developed for a particular biweek that recorded mortality figures in Californian counties. The model is run for 10,000 warmup and 5,000 sampling iterations.  
 Elapsed Time: 154.279 seconds (Warm-up)  
               81.201 seconds (Sampling)  
               235.48 seconds (Total)  
 Elapsed Time: 154.384 seconds (Warm-up)  
               81.235 seconds (Sampling)  
               235.619 seconds (Total)  
 Elapsed Time: 155.548 seconds (Warm-up)  
               81.305 seconds (Sampling)  
               236.853 seconds (Total)  
As can be seen from this stan program the function to_row_vector is used to identify the correct covariate index. We need to change this because OpenCL does not work with to_row_vector besides even without GPUs if we can vectorize this operation our model should run faster.

