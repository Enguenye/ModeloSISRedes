from dynamics import red


myfile = open("params.txt", "r")
numNodos=int(myfile.readline())
numMuestras=int(myfile.readline())
etapas=int(myfile.readline())

for i in range(0,numNodos):
    out="output"+str(i)
    red(numMuestras,1,etapas,i,"s01.edges.dat",out)