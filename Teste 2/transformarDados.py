import os
import shutil
import pandas as pd
import pdfplumber
import csv

caminhoArquivo = "pdf/Anexo_I.pdf"
arquivoCsv = "Anexo_I.csv"
nomeArquivoCompactado = "Teste_Bruno_Calazans_Carritilha"
diretorioDestino = "Anexo"

paginaInicial = 2

def copiarDados():
    cabecalho = None

    with open(arquivoCsv, mode = "w", newline = "", encoding="utf-8") as arquivo:
        escrever_csv = csv.writer(arquivo)

        with pdfplumber.open(caminhoArquivo) as pdf:
            for pagina in pdf.pages[paginaInicial:]:
                tabela = pagina.extract_table()

                if tabela:
                    if cabecalho is None:
                        cabecalho = tabela[0]
                        escrever_csv.writerow(cabecalho)

                for linha in tabela[1:]:
                    escrever_csv.writerow(linha)

    print("Tabela extraída com sucesso")

def compactar(arquivo):
    if arquivo:
        shutil.make_archive(arquivo, 'zip', '.', arquivoCsv)
        print("Arquivo compactado com sucesso!")

    else:
        print("Arquivo não existente")

def alterarAbreviacao():
    dataFrame = pd.read_csv(arquivoCsv, encoding="utf-8")

    dataFrame['OD'] = dataFrame['OD'].replace({'OD': 'Seg. Odontológica'})
    dataFrame['AMB'] = dataFrame['AMB'].replace({'AMB': 'Seg. Ambulatoria'})

    dataFrame.to_csv(arquivoCsv, index = False, encoding="utf-8")
    print("Abreviações alteradas com sucesso!")

def moverArquivos(diretorio, arquivo, nome):
    os.makedirs(diretorio, exist_ok=True)

    shutil.move(arquivo, os.path.join(diretorio, os.path.basename(arquivo)))
    shutil.move(nome, os.path.join(diretorio, os.path.basename(nome)))

    print("Arquivos movidos com sucesso!")

copiarDados()
compactar(nomeArquivoCompactado)
alterarAbreviacao()
moverArquivos(diretorioDestino, arquivoCsv, nomeArquivoCompactado + ".zip")