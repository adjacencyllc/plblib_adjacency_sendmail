@echo off
copy bin\lib_adjacency_sendmail.plc .\release\ /y
copy src\lib_adjacency_sendmail.inc .\release\ /y
copy doc\lib_adjacency_sendmail.md .\release\ /y

echo Release files copied. To create a release on github:
echo git checkout main (or master)
echo git pull
echo git tag vx.y.z
echo git push origin vx.y.z

echo Contents of /release directory
dir .\release\*
