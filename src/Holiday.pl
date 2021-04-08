:- use_module(library(http/json)).
:- use_module(library(http/http_open)).
:- use_module(library(clpfd)).
:- use_module(library(apply)).
:- use_module(library(http/http_ssl_plugin)).
%:- json_objectneededfact(date:atom,nameEn:atom).
%get the list of holiday information from this apl
getJson(Data):-
http_open('https://canada-holidays.ca/api/v1/provinces/BC',In,[]),
%copy_stream_data(In,user_output),
json_read_dict(In,Data),
close(In).

%returns the nearst holiday for today(global time)
nearestHoliday(K):-
getJson(Data),
N=Data.get('province'),
P=N.get('nextHoliday'),
K=P.get('date').

%check if the given day is a holiday
isTodayHoliday(Y,M,D):-
M<10,
D<10,
number_string(Y,YY),number_string(M,MM),number_string(D,DD),
string_concat(YY,"-0",X1),string_concat(X1,MM,X2),
string_concat(X2,"-0",X3),string_concat(X3,DD,X4),
nearestHoliday(K),K==X4.
isTodayHoliday(Y,M,D):-
M>=10,
D>=10,
number_string(Y,YY),number_string(M,MM),number_string(D,DD),
string_concat(YY,"-",X1),string_concat(X1,MM,X2),
string_concat(X2,"-",X3),string_concat(X3,DD,X4),
nearestHoliday(K),K==X4.
isTodayHoliday(Y,M,D):-
M<10,
D>=10,
number_string(Y,YY),number_string(M,MM),number_string(D,DD),
string_concat(YY,"-0",X1),string_concat(X1,MM,X2),
string_concat(X2,"-",X3),string_concat(X3,DD,X4),
nearestHoliday(K),K==X4.
isTodayHoliday(Y,M,D):-
M>=10,
D<10,
number_string(Y,YY),number_string(M,MM),number_string(D,DD),
string_concat(YY,"-",X1),string_concat(X1,MM,X2),
string_concat(X2,"-0",X3),string_concat(X3,DD,X4),
nearestHoliday(K),K==X4.

