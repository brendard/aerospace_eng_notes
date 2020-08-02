%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%              Script for tracking a satellite                          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This a model for controlling distance, speed and acceleration of a
% tracking antenna, and the model was taken from a tutorial given by the
% School of Engineering & Computer Science at University of Hertfordshire,
% corresponding to the lecture of Aerospace Systems Modelling & Control.

% The corresponding model is the one shown in the image, and completely
% reproduced at Simulink Environment. That image is saved on the repository
% as Tracking_antenna_model.png, but will be depicted here as antenna_image

antenna_image = imread('Tracking_antenna_model.png');
imshow(antenna_image)

% After showing the image that will be simulated at Simulink, whose
% schematic is named as First_order_model_portfolio.slx, it is time to
% perform the primary calculations.

close all
clear

%% Input data for Simulink model

Distance=1;         % It will be represented by a straight line
Speed_slope=0.01;   % It will represented by a ramp with a slope=0.01

% In this instance, acceleration will be represented by a parabolic curve, 
% whose peak value will equal to unity

t = (0:0.01:1)'; 
impulse = t==0; 
unitstep = t>=0;
accel_heigth_data=size(unitstep);
Acceleration= [(1:accel_heigth_data(1,1))',t.^2.*unitstep];   

%% Setting initial values to controller, simulation time and commutator

% In this stage, initial values of the controller, simulation time and
% commutator will be set. Since initial condition does not require any
% tuning of the controller, it will be assumed as one with unitary transfer
% function

Gc=1;

% The simulation time will coincide with the size of the unitstep imposed
% to the acceleration curve

simtime=accel_heigth_data(1,1);

% Finally, a commutator will be employed to switch among the available
% input data and getting outputs accordingly, where Selector=1 to set
% distance as input, Selector=2 to set speed instead, and Selector=3 to set
% acceleration.

for Selector=1:3
sim('Tracking_antenna_model')
scope_d(:,Selector)=ans;
end

% The easiest way to find out how the systems behave is to open the Scope
% Data with the Data Inspector, and starts playing with the outputs
% accordingly. 

Simulink.sdi.clear
Simulink.sdi.openVariable('scope_d', scope_d)
Simulink.sdi.save('Distance_speed_acceleration.mldatx')

% This Data Inspector extension (.mdlatx) will serve later to apply PID
% Controller Design based on Transfer Function completely scripted on
% MATLAB, as explained at:

url = 'http://ctms.engin.umich.edu/CTMS/index.php?example=Introduction&section=ControlPID';
web(url)

%% PID Controller Design
