# OpenCL Usage
Learning how to use OpenCL and its properties on STAN.
This file is going to contain descriptions, code snippets, experiments and explanations of how to use OpenCl to make use of GPU for the purpose of learning HPC via STAN. 
The first thing to remember is that just because you have a GPU does not mean your STAN program is going to run faster. GPU s are useful for matrix operations. If your program does not have matrix operations that feed into the processors of the GPU which speed up computations there is no reason for your calculations to be done faster.    
0) Particulars of STAN
1) What is CUDA https://en.wikipedia.org/wiki/CUDA
   CUDA stands for Compute Unified Device Architecture and is an application programming interface. It allows the usage of GPU resources via C, C++, Fortran. It also supports openCL. 
2) openCL stands for Open Computer Language which is a programming framework that allows communication across CPUs and GPUs.
3) Why NVIDIA
4) How to use cmdSTAN
5) Experimental Results
