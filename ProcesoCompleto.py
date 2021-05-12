import os
import sys
import time
import subprocess

numNodos=15



for i in range(1):
    numMuestras = 50
    os.system('del /f s02.edges.dat')
    os.system('del /f s01.edges.dat')
    os.system('del /f coordenadas.xlsx')
    os.system('matlab.exe -r "redConectada_JoseFlorez"')

    time.sleep(20)
    os.system('copy coordenadas.xlsx Proyecto_de_grado /Y')
    for j in range(1):
        etapas = 5
        for k in range(1):
            f= open("params.txt","w+")
            f.write(str(numNodos)+ "\n")
            f.write(str(numMuestras)+ "\n")
            f.write(str(etapas)+ "\n")
            f.close()


            with open('s02.edges.dat', 'rt') as fin:
                with open('s01.edges.dat', 'wt') as fout:
                    for i, line in enumerate(fin):
                        if i != 0:
                            resp=line.replace('",','\n')
                            resp2=resp.replace('"','')
                            fout.write(resp2)

            os.system('copy params.txt simulador /Y')
            os.system('copy params.txt Proyecto_de_grado /Y')
            os.system('copy s01.edges.dat simulador /Y')
            os.system('python simulador/generador.py')
            os.system('python unificarSimulacion.py')

            os.system('copy resultadoSimulacion.xlsx Proyecto_de_grado /Y')
            file="C:\\Program Files\\R\\R-4.0.3\\bin\\Rscript.exe"

            os.chdir(r"Proyecto_de_grado")
            os.system('"'+file +'"'+' validacion.R')

            os.chdir(r"..")


