:- [rules].

%manufacturing lifecycle facts---------------------
% Vulnerability facts
vulnerable_m(fabrication_machine, compromised_software, fabrication).
vulnerable_m(waveguide1, waveguide_misalignment, fabrication).

% Create fact
create_m(fabrication_machine, pic, fabrication).

% Cause facts
causes_m(compromised_software, compromised_circuitry, pic).
causes_m(waveguide_misalignment, signal_leakage, waveguide1).

% Target fact
targets_m(hardware_trojan, compromised_software, fabrication).

%deployment facts----------------------------------
% Set deployed components
deployed_component(pic).
deployed_component(waveguide1).
deployed_component(waveguide2).
deployed_component(modulator).
deployed_component(photodetector).
deployed_component(control_circuitry).
deployed_component(laser).
deployed_component(power_supply).
deployed_component(lidar_system).
deployed_component(av).

% Contain relationships
contain_d(av, lidar_system).
contain_d(lidar_system, pic).
contain_d(pic, waveguide1).
contain_d(pic, modulator).

% Depend relationships
depend_d(modulator, waveguide1).

% Generate relationships
generate_d(modulator, modulated_light).

% Receive relationships
receive_d(waveguide2, modulated_light).

% Causes relationships
causes_d(restricted_sensing_radius, unstable_obstruction_identification, av).
causes_d(degraded_signal_production, restricted_sensing_radius, lidar_system).
causes_d(signal_leakage, degraded_signal_production, pic).
causes_d(compromised_circuitry, compromised_circuitry, modulator).
causes_d(signal_leakage, signal_leakage, modulator).
causes_d(signal_leakage, signal_leakage, modulated_light).
causes_d(signal_leakage, signal_leakage, waveguide2).

% Trigger relationships
triggers_d(signal_diminution, signal_diminution, waveguide2).
triggers_d(signal_diminution, signal_diminution, modulated_light).
triggers_d(signal_diminution, signal_diminution, modulator).
triggers_d(signal_diminution, signal_diminution, av).
triggers_d(signal_diminution, signal_diminution, lidar_system).
triggers_d(signal_diminution, signal_diminution, pic).

% Target relationship
targets_d(optical_snooping, signal_leakage).

% Effect relationship
effect_d(optical_snooping, signal_leakage, signal_diminution).