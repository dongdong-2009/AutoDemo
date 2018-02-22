#!/bin/bash

OPTIONS=    #Jmeter server other options.
options=${env.JmeterServerOption}    #pass jenkins variables to bash scripts
pwd

echo "Jmeter-server start"

jmeter-server $options

# If you want quit the jmeter-server ,please set JMeter property server.exitaftertest=true
#otherwise ，when start jmeter client add the '-X' options 
