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
0.70::actual_temp_low.

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

correct_temp_reading :-
    actual_temp_low,
    not(faulty_temp_sensor),
    not(power_failure).

incorrect_temp_reading :-
    faulty_temp_sensor.

no_heating :-
    not(heating_on).

lights_not_turning_on :-
    light_switch_on,
    not(light_on).

% queries
evidence(motion_detected(living_room), false).
evidence(light_on, false).
evidence(heating_on, false).
evidence(incorrect_temp_reading, true).
query(faulty_motion_sensor(living_room)).
query(power_failure).
query(faulty_light_sensor).
query(faulty_thermostat).
query(faulty_temp_sensor).
query(faulty_motion_sensor(hallway)).
query(no_heating).
query(lights_not_turning_on).