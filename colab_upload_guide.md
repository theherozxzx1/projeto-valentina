# 📤 Guia de Upload para Google Colab

Este guia explica como enviar seus arquivos locais (dataset e modelos LoRA) para o ambiente do Google Colab.

## 🎯 Arquivos Necessários

Você precisará dos seguintes arquivos do seu Mac:

1.  **LoRA de Estilo Midjourney:**
    *   Caminho local: `/Users/andre/Projeto-Valentina/Models/midjourney_LORA.safetensors`
    *   Destino no Colab: `/content/models/midjourney_LORA.safetensors`

2.  **Dataset da Valentina:**
    *   Caminho local: `/Users/andre/Projeto-Valentina/ValentinaNSFWLoRA/valentina_dataset.zip`
    *   Destino no Colab: Será carregado e depois extraído para `/content/dataset/instance_images`
    *   *Alternativa*: Se você usar o `valentina_dataset_generator_colab.ipynb` primeiro, você fará o download de `valentina_hq_dataset.zip` e depois o usará para o treinamento.

## 🚀 Métodos de Upload para o Colab

### Método 1: Upload Direto no Notebook Colab (RECOMENDADO PARA ESTES ARQUIVOS)

É o método mais simples para arquivos que estão no seu computador.

1.  **Execute a Célula de Upload:** Nos notebooks Colab (`valentina_dataset_generator_colab.ipynb` ou `valentina_colab_facial_lora_trainer_flux.ipynb`), haverá uma célula de código que usa `from google.colab import files` seguido por `files.upload()`.
2.  **Clique em "Choose Files":** Quando você executar essa célula, um botão de upload aparecerá.
3.  **Navegue e Selecione:** Selecione os arquivos (`midjourney_LORA.safetensors`, `valentina_dataset.zip`) da pasta que o script `prepare_colab_upload.sh` organizou para você (provavelmente `/Users/andre/Projeto-Valentina/colab_upload_temp`).
4.  **Aguarde:** O upload começará e o progresso será mostrado.

**Vantagens:**
*   Simples e direto.
*   Integrado ao ambiente Colab.

### Método 2: Sincronizar com Google Drive

Útil para arquivos maiores ou se você quiser mantê-los no seu Drive.

1.  **Upload para o Google Drive:** No seu navegador, acesse o Google Drive e faça upload dos arquivos para uma pasta.
2.  **Monte o Drive no Colab:**
    ```python
    from google.colab import drive
    drive.mount('/content/drive')
    ```
    Siga as instruções para autorizar.
3.  **Copie os Arquivos para a Sessão Colab:**
    ```python
    # Exemplo para a LoRA Midjourney
    !mkdir -p /content/models
    !cp "/content/drive/MyDrive/SUA_PASTA_NO_DRIVE/midjourney_LORA.safetensors" "/content/models/"

    # Exemplo para o dataset
    !cp "/content/drive/MyDrive/SUA_PASTA_NO_DRIVE/valentina_dataset.zip" "/content/"
    # Depois, no Colab, você descompactaria o ZIP para /content/dataset
    ```

**Vantagens:**
*   Bom para arquivos que você usa frequentemente ou são grandes.
*   Persistência entre sessões (os arquivos ficam no Drive).

### Método 3: `wget` ou `curl` (Menos comum para arquivos locais)

Se seus arquivos estivessem hospedados em um servidor web com um link direto.

```python
!mkdir -p /content/models
!wget -O /content/models/midjourney_LORA.safetensors URL_DIRETA_PARA_MIDJOURNEY_LORA
!wget -O /content/valentina_dataset.zip URL_DIRETA_PARA_DATASET_ZIP
```

## ⚙️ Usando o Script `prepare_colab_upload.sh`

Para facilitar a localização dos arquivos no seu Mac ao usar o **Método 1**:

1.  Abra seu terminal.
2.  Navegue até o diretório do projeto: `cd /Users/andre/Projeto-Valentina`
3.  Torne o script executável (apenas uma vez): `chmod +x prepare_colab_upload.sh`
4.  Execute o script: `./prepare_colab_upload.sh`

O script criará uma pasta `colab_upload_temp` dentro de `/Users/andre/Projeto-Valentina` com os arquivos necessários. Use essa pasta ao selecionar arquivos no widget de upload do Colab.
