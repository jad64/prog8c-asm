sh ./_rm.sh

java -jar /home/jad/.prog8c/prog8c-12.3.4-all.jar -asmlist -ignorefootguns -target c64 ./src/main.p8
if [ $? -eq 0 ]
then

wine /home/jad/.wine/drive_d/bin/disasm64.exe -imain.bin -omain.dis

petcat -w2 -o ./build/start.prg -- ./src/start.bas
if [ $? -eq 0 ]
then

mv main.bin ./build/asm

c1541 < /home/jad/Projekty/prog8c-asm/dev/c1541.att > /dev/null
if [ $? -eq 0 ]
then

ls -l ./build/asm

sh ./_exec.sh

fi
fi
fi
