import tkinter as tk
from tkinter import filedialog
from tkinter import messagebox
import re

class Deco:
    def __init__(self):
        self.window = tk.Tk()
        self.textArea = tk.Text(self.window, wrap=tk.WORD, height=25, width=80)
        self.createWindow()
        self.showGui()
        self.codigoMaquina

    def createWindow(self):
        self.window.title("Decoder")
        self.window.geometry("700x600")

        titleLabel = tk.Label(self.window, text="Text Analyzer", font=("Arial", 16))
        titleLabel.pack(pady=10)

        button1 = tk.Button(self.window, text="Import file", command=self.selectFile)
        button1.pack(pady=10)
        button2 = tk.Button(self.window, text="Save file", command=self.saveFile)
        button2.pack(pady=10)
        button3 = tk.Button(self.window, text="Decode", command=self.decode)
        button3.pack(pady=10)

        exitButton = tk.Button(self.window, text="Exit", command=self.exitApp)
        exitButton.pack(pady=5)
        self.textArea.pack(pady=10)
        

    def selectFile(self):
        file = filedialog.askopenfilename(filetypes=[("Text Files", "*.txt"), ("ASM Files", "*.asm")], title="Select file")
        if file:
            self.loadFile(file)

    def loadFile(self, file):
        with open(file, 'r', encoding='utf-8') as f:
            content = f.read()
        self.textArea.delete('1.0', tk.END)
        self.textArea.insert(tk.END, content)

    
    def decode(self):
        def convertirOp(parte1):
            if (parte1 == "add"):
                return "00000000000100000"
            elif (parte1 == "sub"):
                return  "00000000000100010"
            elif (parte1 == "and"):
                return  "00000000000100100"
            elif (parte1 == "slt"):
                return  "00000000000101010"
            elif (parte1 == "or"):
                return  "00000000000100101"
            elif (parte1 == "addi"):
                return "001000"
            elif (parte1 == "ori"):
                return "001101"
            elif (parte1 == "andi"):
                return "001100"
            elif (parte1 == "lw"):
                return "100011"
            elif (parte1 == "sw"):
                return "101011"
            elif (parte1 == "slti"):
                return "001010"
            elif (parte1 == "beq"):
                return "000100"
            else:
                return "opcion invalida"
        
        def convertirDir(dir):
            numero = dir[1:]

            try:
                ultimo_entero = int(numero)
            except ValueError:
                messagebox.showinfo(f"El último carácter '{numero}' no es un número entero.")
                return "00000"

            nBinario = bin(ultimo_entero)[2:].zfill(5)
            
            return nBinario

        contenido = ""
        contenidoOriginal = ""
        contenidoBinario = ""
        self.codigoMaquina = ""
        lines = self.textArea.get('1.0', tk.END).strip().splitlines()
        for linea in lines:
            linea = linea.strip()

            partes = linea.split(' ')
        
            contenidoOriginal += linea + "\n"

            if len(partes) >= 4:
                parte1 = partes[0].lower()
                parte2 = partes[1]
                parte3 = partes[2]
                parte4 = partes[3]

                op = convertirOp(parte1)
                dirMemoria2 = convertirDir(parte2)
                dirOperando1 = convertirDir(parte3)
                dirOperando2 = convertirDir(parte4)

                if len(op) > 6:
                    ultimos_11 = op[-11:]

                    newLinea = f"{op[:6]}_{dirOperando1}_{dirOperando2}_{dirMemoria2}_{ultimos_11[:5]}_{ultimos_11[5:]}"
                    contenido += newLinea + "\n"
                    contenidoBinario += f"{op[:6]}_{dirOperando1}_{dirOperando2}_{dirMemoria2}_{ultimos_11[:5]}_{ultimos_11[5:]}\n"

                elif len(op) == 6:
                    inmediato = dirOperando2.zfill(16)
                    newLinea = f"{op}_{dirOperando1}_{dirMemoria2}_{inmediato}"
                    contenido += newLinea + "\n"
                    contenidoBinario += f"{op}_{dirOperando1}_{dirMemoria2}_{inmediato}\n"

                else :
                    print("Error en el comando", parte1)

            elif(partes[0].lower() == "nop" and len(partes) == 2):
                entero = partes[1]

                try:
                     cantidad= int(entero)
                except ValueError:
                    messagebox.showinfo(f"El último carácter '{entero}' no es un número entero.")
                    continue

                for _ in range(cantidad) :
                    newLinea = f"000000_00000_00000_00000_00000_000000"
                    contenido += newLinea + "\n"
                    contenidoBinario += f"000000_00000_00000_00000_00000_000000\n"
                
            elif(partes[0].lower() == "nop"):
                newLinea = f"000000_00000_00000_00000_00000_000000"
                contenido += newLinea + "\n"
                contenidoBinario += f"000000_00000_00000_00000_00000_000000\n"
                
            else :
                print("La línea no contiene suficientes partes:", linea)

        self.textArea.delete('1.0', tk.END)
        self.textArea.insert(tk.END, "Contenido original:\n")
        self.textArea.insert(tk.END, contenidoOriginal + "\n")

        self.textArea.insert(tk.END, "Contenido decodificado:\n")
        self.textArea.insert(tk.END, contenido + "\n")

        self.codigoMaquina = contenidoBinario


    def saveFile(self):
        if not self.codigoMaquina:
            messagebox.showinfo("Error", "No hay contenido decodificado para guardar.")
            return


        file = filedialog.asksaveasfilename(defaultextension=".txt", filetypes=[("Text Files", "*.txt")])
        if file:
            with open(file, 'w', encoding='utf-8') as file:
                file.write(self.codigoMaquina)

    def exitApp(self):
        self.window.quit()

    def showGui(self):
        self.window.mainloop()

if __name__ == "__main__":
    Deco()
