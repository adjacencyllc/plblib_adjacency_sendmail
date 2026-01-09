@echo off
copy bin\lib_adjacency_sendmail.plc .\release\ /y
copy src\lib_adjacency_sendmail.inc .\release\ /y
copy doc\lib_adjacency_sendmail.md .\release\ /y
echo Contents of /release directory
dir .\release\*
