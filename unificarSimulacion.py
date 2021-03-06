import xlsxwriter


workbook = xlsxwriter.Workbook('resultadoSimulacion.xlsx')
worksheet = workbook.add_worksheet()
myfile = open("params.txt", "r")
numNodos=int(myfile.readline())
numMuestras=int(myfile.readline())
etapas=int(myfile.readline())
matriz = [ [ 0 for i in range(numNodos) ] for j in range(etapas) ]

for i in range(0,numNodos):
    j=0
    l =open("output"+str(i)+".txt","r")
    l1 = l.readlines()
    for linea in l1:
        matriz[j][i]=float(linea.replace("\n",""))
        j+=1
    l.close()

for i in range(0,numNodos):
    worksheet.write(0, i, i)

# Iterate over the data and write it out row by row.
for i in range(0,numNodos):
    for j in range(0, etapas):
        worksheet.write(j+1, i, matriz[j][i])



workbook.close()