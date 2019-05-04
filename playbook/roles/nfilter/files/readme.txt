1. so 라이브러리 파일은 setenv.sh 파일에 LD_LIBRARY_PATH 경로 추가

-rw-r--r-- 1 tomcat was  25243 Feb  8 10:35 libnperm.so
-rw-r--r-- 1 tomcat was  24186 Feb  8 10:35 libNSaferJNI.so
-rw-r--r-- 1 tomcat was 449983 Feb  8 10:35 libnsafer.so

# NSHC nfilter LIB PATH
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/sw/nshc/nfilter

2. jar 파일은 해당 배포 위치 WEB-INF/lib 경로에 복사

-rw-r----- 1 tomcat was  22580 Feb  8 12:39 nfsrv.1.9.11.jar
-rw-r----- 1 tomcat was   1442 Feb  8 12:39 nSafer.jar


