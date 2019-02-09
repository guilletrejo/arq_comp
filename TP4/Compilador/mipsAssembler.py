import sys
from Translator import Translator

if __name__ == '__main__':
	#Comprobacion de parametros de entrada
    if(len(sys.argv) < 2):
        print "ERROR: input file not specified" 
        exit(1)
    #Leemos las intrucciones del archivo de entrada
	#Declaramos el transalator que nos va a traducir de assembler a codigo maquina
    tr = Translator()
	#Declaramos la lista de instrucciones que se va a ir obteniendo del archivo source
    instructionList = list()
    with open(sys.argv[1],"r") as source:
        text = source.read()
        lastLine = text.split("\n")[-1]
        if "END" not in lastLine.split(";")[0]:
            print "ERROR: END instruction not detected"
            exit(1)
        instructionList = tr.getHexFromAsm(text)
    
    #Generamos el archivo de salida
    outputFileName = "out.coe"
	
	#Si pasamos un nombre del archivo de salida, se lo asignamos, sino le deja out
    if("-o" in sys.argv and (sys.argv.index("-o") < (len(sys.argv)-1))):
        outputFileName = sys.argv[sys.argv.index("-o")+1]
	#Abrimos el archivo de salida, le escribimos el vector de inicializacion seguido de todas las instrucciones
    with open(outputFileName, "w+") as outFile:
        outFile.write('memory_initialization_radix=16;\nmemory_initialization_vector=\n')
        for line in instructionList:
            separator = str()
			#Si es la ultima linea, terminamos con ; sino terminamos con ,
            if line == instructionList[-1]:
                separator = ';'
            else:
                separator = ',\n'
            outFile.write(line+separator)
			