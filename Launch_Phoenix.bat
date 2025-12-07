@echo off
title Phoenix AI Cluster - 18GB VRAM
echo Starting Qwen 2.5 32B on 3-Way Split (2080 + 1060 + 1050Ti)...
echo.

cd /d "C:\Users\Home PC\Desktop\ai stuff"

koboldcpp.exe --usecuda 0 1 2 --gpulayers 40 --tensor_split 1.5 4.5 3 --contextsize 4096 --model Qwen2.5-32B-Instruct-Q4_K_M.gguf

echo.
echo CRASH DETECTED. Press any key to exit.
pause