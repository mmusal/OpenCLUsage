# OpenCL Usage
Learning how to use OpenCL and its properties on STAN.
This file is going to contain descriptions, code snippets, experiments and explanations of how to use OpenCl to make use of GPU for the purpose of learning HPC via STAN. 
The first thing to remember is that just because you have a GPU does not mean your STAN program is going to run faster. GPU s are useful for matrix operations. If your program does not have matrix operations that feed into the processors of the GPU which speed up computations there is no reason for your calculations to be done faster.    
0) Particulars of STAN
1) https://en.wikipedia.org/wiki/CUDA What is CUDA 
   CUDA stands for Compute Unified Device Architecture and is an application programming interface. It allows the usage of GPU resources via C, C++, Fortran. It also supports openCL. It is a propriety framework of NVIDIA 
2) https://www.khronos.org/events/accelerating-machine-learning-with-opencl openCL stands for Open Computer Language which is a programming framework that allows communication across CPUs and GPUs. 
3) CUDA vs OpenCL https://www.run.ai/guides/nvidia-cuda-basics-and-best-practices/cuda-vs-opencl
4) Why NVIDIA
5) How to use cmdSTAN
6) Experimental Results
