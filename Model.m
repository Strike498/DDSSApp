clear all; clc; close all force;
rng default
mainDir = pwd;
addpath(genpath(mainDir));
Sys = SysSettings;
Projects = Project();
%% GUI Initialisation
DDSSApp(Projects)