import requests
import time
import os
import shutil
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

nomeAnexos = []
diretorioDestino = "Anexo"
nomeArquivoCompactado = "Anexos_compactados"

def obter_url():
    url = 'https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos'
    navegador = webdriver.Chrome()
    navegador.get(url)

    wait = WebDriverWait(navegador, 10)

    time.sleep(1)

    navegador.find_element(By.XPATH, '/html/body/div[5]/div/div/div/div/div[2]/button[3]').click()

    linkAnexos = [
        'Anexo I',
        'Anexo II'
    ]

    urls = []

    for nome in linkAnexos:
        try:
            elemento = wait.until(EC.presence_of_element_located((By.PARTIAL_LINK_TEXT, nome)))
            urls.append(elemento.get_attribute("href"))
        except:
            print(f"Link " + nome + " não encontrado.")

    navegador.quit()
    return urls

def baixar_documento(url, nomeAnexo):
    response = requests.get(url, stream = True)
    if response.status_code == 200:
        with open(nomeAnexo, "wb") as file:
            for arquivo in response.iter_content(chunk_size = 1024):
                file.write(arquivo)

        nomeAnexos.append(os.path.basename(nomeAnexo))

        print(f"Download concluído: " + nomeAnexo)
    else:
        print(f"Erro ao baixar: " + nomeAnexo)

def compactar_pdf(arquivos, diretorio, nomeArquivo):
    os.makedirs(diretorio, exist_ok = True)

    for arquivo in arquivos:
        shutil.move(arquivo, os.path.join(diretorio, os.path.basename(arquivo)))

    shutil.make_archive(nomeArquivo.replace(".zip", ""), 'zip', os.getcwd(), diretorio)

    print("Arquivos compactados com sucesso!")

urls = obter_url()

for i, url in enumerate(urls):
    baixar_documento(url, "Anexo_" + str(i + 1) +".pdf")

compactar_pdf(nomeAnexos, diretorioDestino, nomeArquivoCompactado)
