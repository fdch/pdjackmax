#!/bin/sh

# CAPTURE 1 2   -->  MAX (adc 1 2)
jack_connect system:capture_1 Max:in1
jack_connect system:capture_2 Max:in2

# MAX (dac 1 2) --> PLAYBACK (1 2) 
jack_connect Max:out1 system:playback_1
jack_connect Max:out2 system:playback_2

# MAX (dac 1 2) --> PD (adc 1 2)
jack_connect Max:out1 pure_data:input0
jack_connect Max:out2 pure_data:input1

# PD (dac 1 2)  --> Max (adc 1 2)
jack_connect pure_data:output0 Max:in3
jack_connect pure_data:output1 Max:in4

# PD (dac 1 2) --> PLAYBACK (1 2) 
jack_connect pure_data:output0 system:playback_1
jack_connect pure_data:output1 system:playback_2


