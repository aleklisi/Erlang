-module(weather).
-compile([export_all,debug_info]).

add_randomness_element(Range) -> 
    {Min,Max} = Range,
    Diff = Max - Min,
    rand:uniform() * Diff + Min.

no_less_then_zero(Value) when Value > 0 -> Value;
no_less_then_zero(_) -> 0.

%Temprarure[C], result in kg/m^3
%based on real dependency from:
%https://en.wikipedia.org/wiki/Density_of_air
%tablename: Effect of temperature on properties of air
air_density_table(AirTemperature) when AirTemperature > 35 -> 1.1455;
air_density_table(AirTemperature) when AirTemperature > 30 -> 1.1644;
air_density_table(AirTemperature) when AirTemperature > 25 -> 1.1839;
air_density_table(AirTemperature) when AirTemperature > 20 -> 1.2041;
air_density_table(AirTemperature) when AirTemperature > 15 -> 1.2250;
air_density_table(AirTemperature) when AirTemperature > 10 -> 1.2466;
air_density_table(AirTemperature) when AirTemperature > 5 -> 1.2922;
air_density_table(AirTemperature) when AirTemperature > 0 -> 1.3163;
air_density_table(AirTemperature) when AirTemperature > -5 -> 1.3413;
air_density_table(AirTemperature) when AirTemperature > -10 -> 1.3673;
air_density_table(AirTemperature) when AirTemperature > -15 -> 1.3943;
air_density_table(_)-> 1.4224.

get_air_density(AirTemperature) ->
    Pom = AirTemperature + add_randomness_element({-4,4}),
    air_density_table(Pom).

%Windiness[%], result in [m/s]
get_wind_speed(WeatherModulePID) -> 
    Windiness = get_windiness(WeatherModulePID),
    WindSpeed = get_windspeed(WeatherModulePID),
    Diff = WindSpeed * Windiness / 100,
    no_less_then_zero(WindSpeed + add_randomness_element({-Diff, Diff})).

%result in [m/s]
get_windspeed(WeatherModulePID) -> 
    WeatherModulePID ! {getWindSpeed, self()},
    loop(windSpeedIs).

%result in [%]
get_windiness(WeatherModulePID) -> 
    WeatherModulePID ! {getWindiness, self()},
    loop(windinessIs).

%result in [C]
get_air_temperature(WeatherModulePID) -> 
    WeatherModulePID ! {getAirTemperature, self()},
    loop(airTemperatureIs).

loop(MessageFlag) ->
    receive
        {MessageFlag,Value} -> Value
    end.

weather_module_start(WindSpeedFile,WindinessFile,AirTemperatureFile) -> 
    WindSpeed = readfile(WindSpeedFile,"\r\n"),
    Windiness = readfile(WindinessFile,"\r\n"),
    AirTemperature = readfile(AirTemperatureFile,"\r\n"),
    %io:fwrite("WindSpeed: ~p\n",[WindSpeed]),
    %io:fwrite("Windiness: ~p\n",[Windiness]),
    %io:fwrite("AirTemperature: ~p\n",[AirTemperature]),
    spawn(weather,weather_module,[WindSpeed,Windiness,AirTemperature]).

weather_module(WindSpeed,Windiness,AirTemperature) ->
    [HSpeed|TSpeed] = WindSpeed,
    [HWindiness|TWindiness] = Windiness,
    [HTemp|TTemp] = AirTemperature,
    receive
        {getWindSpeed, PID} -> 
            PID ! {windSpeedIs,HSpeed},
            %io:fwrite("weather module ~p\n",[{getWindSpeed, PID}]), 
            weather_module(TSpeed ++ [HSpeed],Windiness,AirTemperature);
        {getWindiness, PID} -> 
            PID ! {windinessIs,HWindiness},
            %io:fwrite("weather module ~p\n",[{getWindiness, PID}]),    
            weather_module(WindSpeed,TWindiness ++ [HWindiness],AirTemperature);
        {getAirTemperature, PID} -> 
            PID ! {airTemperatureIs, HTemp},
            %io:fwrite("weather module ~p\n",[{getAirTemperature, PID}]),                         
            weather_module(WindSpeed,Windiness,TTemp ++ [HTemp]);
        endOfSymulation -> io:fwrite("Weather module: End of Symulation ~p\n",[self()]);
        SPAM -> io:fwrite("Weather module spam in ~p messqge: ~p\n", [self(),SPAM])
    end.

readfile(FileName,Separator) ->
    {ok, Binary} = file:read_file(FileName),
    List = string:tokens(erlang:binary_to_list(Binary),Separator),
    ListPom = lists:seq(1,length(List)),
    ReadInList = lists:zipwith(fun(X,_) -> string:to_float(X) end,List,ListPom),
    {Floats,_} = lists:unzip(ReadInList),
    Floats.