1. so 라이브러리 파일은 setenv.sh 파일에 LD_LIBRARY_PATH 경로 추가

-rw-r--r-- 1 tomcat was  2127016 Jul 17 13:29 libklib.so
-rw-r--r-- 1 tomcat was 28756533 Jul 17 13:29 libpcjapi.so

# NSHC nfilter LIB PATH
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/sw/petra

2. jar 파일은 해당 배포 위치 WEB-INF/lib 경로에 복사

-rw-r----- 1 tomcat was  22580 Feb  8 12:39 PetraCipherAPI.jar

