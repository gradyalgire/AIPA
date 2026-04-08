% probability facts
0.05::faulty_motion_sensor(living_room). 
0.05::faulty_motion_sensor(hallway).
0.02::faulty_light_sensor.
0.03::faulty_temp_sensor.
0.01::faulty_thermostat.
0.01::power_failure.
0.80::movement(living_room).
0.60::movement(hallway).
0.90::light_switch_on.
0.65::heating_wanted.

% rules
motion_detected(living_room):-
    not(faulty_motion_sensor(living_room)),
    movement(living_room),
    not(power_failure).
    
motion_detected(hallway):-
    not(faulty_motion_sensor(hallway)),
    movement(hallway),
    not(power_failure).
    
light_on :-
    not(faulty_light_sensor),
    light_switch_on,
    not(power_failure).
    
heating_on :-
    not(faulty_thermostat),
    heating_wanted,
    not(power_failure).

% queries
evidence(motion_detected(living_room), false).
evidence(light_on, false).
evidence(heating_on, false).
query(faulty_motion_sensor(living_room)).
query(power_failure).
query(faulty_light_sensor).
query(faulty_thermostat).

    