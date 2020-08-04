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
% commutator will be set. Since initial condition does require the
% tuning of the controller, it will set a Gain of the Controller (Gc) 
% ranged from 1 to 100. 

% The simulation time will coincide with the size of the unitstep imposed
% to the acceleration curve

simtime=accel_heigth_data(1,1);

% Finally, a commutator will be employed to switch among the available
% input data and getting outputs accordingly, where Selector=1 to set
% distance as input, Selector=2 to set speed instead, and Selector=3 to set
% acceleration. 

for Gc=1:100
    for Selector=1:3
        sim('Tracking_antenna_model')
        scope_d(Gc,Selector)=ans;
        error(Gc,Selector)=scope_d(Gc,Selector).error(1,1);
    end
end


% The easiest way to find out how the systems behave is to open the Scope
% Data with the Data Inspector, and start playing with the outputs
% accordingly. 

Simulink.sdi.clear
Simulink.sdi.openVariable('scope_d', scope_d)
Simulink.sdi.save('Distance_speed_acceleration.mldatx')

% This Data Inspector extension (.mdlatx) will serve later for comparing
% among the different gains for each magnitude to be controlled by only one
% integrator multiplied by a gain (Gc). But first, it is convenient to plot
% how the stady-state error behaves for each gain and magnitude. If looked
% at the for loop, it can be noticed that there is a matrix called error
% that iterates accordingly, and that is the matrix being plotted next:

error_plot=plot(error);
legend('Selector=1', 'Selector=2','Selector=3');

% As can be noticed, when speed and acceleration are controlled by an
% Integrator with Gc>1, the highest such gain the lowest the error.
% However, when the distance is the magnitude being tuned, the error
% oscillates at such point that the output turns highly unstable, as can be
% analized by means of observing the plots already saved at the .mldatx
% file.

% It can be then concluded, that an integraator with a gain higher than 1
% may not be the most suitable PID controller in such system when it comes
% to tune the distance tracked by the antenna. In the next class, several
% controllers will be tested to substitute the integrator Gc. Also, real
% values in regard of distance, speed and acceleration will be considered
% with the aim of getting this model closer to reality.


