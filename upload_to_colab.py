#!/usr/bin/env python3
"""
Upload Preparation Script for Google Colab
Prepara e otimiza arquivos para upload no Colab training/dataset generation
"""

import os
import shutil
import zipfile
from pathlib import Path

def main():
    print("🚀 PREPARAÇÃO DE ARQUIVOS PARA GOOGLE COLAB")
    print("=" * 50)
    
    # Caminhos base
    base_path = Path("/Users/andre/Projeto-Valentina")
    models_path = base_path / "Models"
    dataset_path = base_path / "ValentinaNSFWLoRA"
    upload_prep_path = base_path / "colab_upload_ready"
    
    # Criar pasta de preparação
    upload_prep_path.mkdir(exist_ok=True)
    print(f"📁 Pasta de preparação: {upload_prep_path}")
    
    # Arquivos necessários
    required_files = {
        "midjourney_lora": models_path / "midjourney_LORA.safetensors",
        "dataset": dataset_path / "valentina_dataset.zip"
    }
    
    print("\n📋 VERIFICANDO ARQUIVOS NECESSÁRIOS:")
    
    # Verificar e copiar Midjourney LoRA
    midjourney_source = required_files["midjourney_lora"]
    if midjourney_source.exists():
        midjourney_dest = upload_prep_path / "midjourney_LORA.safetensors"
        shutil.copy2(midjourney_source, midjourney_dest)
        size_mb = midjourney_dest.stat().st_size / (1024*1024)
        print(f"✅ Midjourney LoRA: {size_mb:.1f}MB - {midjourney_dest}")
    else:
        print(f"❌ ERRO: Midjourney LoRA não encontrada em {midjourney_source}")
        return
    
    # Verificar e copiar Dataset
    dataset_source = required_files["dataset"]
    if dataset_source.exists():
        dataset_dest = upload_prep_path / "valentina_dataset.zip"
        shutil.copy2(dataset_source, dataset_dest)
        size_mb = dataset_dest.stat().st_size / (1024*1024)
        print(f"✅ Dataset original: {size_mb:.1f}MB - {dataset_dest}")
    else:
        print(f"❌ ERRO: Dataset não encontrado em {dataset_source}")
        return
    
    # Criar um README com instruções
    readme_content = """# Arquivos para Upload no Google Colab

## Arquivos Preparados:

### 1. midjourney_LORA.safetensors
- **Tamanho**: ~18MB
- **Uso**: Style LoRA para qualidade cinematográfica
- **Upload**: Necessário para ambos os notebooks (dataset generator + training)

### 2. valentina_dataset.zip
- **Tamanho**: ~6MB
- **Conteúdo**: 7 imagens de referência originais
- **Uso**: Treinamento LoRA (ou substitua pelo dataset premium se gerado)

## Instruções de Upload:

### Opção A: Upload Direto no Colab
1. Abra o notebook no Google Colab
2. Quando solicitado, use files.upload()
3. Selecione os arquivos desta pasta

### Opção B: Google Drive (Recomendado para arquivos grandes)
1. Faça upload para seu Google Drive
2. No Colab, monte o Drive: `from google.colab import drive; drive.mount('/content/drive')`
3. Copie os arquivos: `!cp /content/drive/MyDrive/path/file.safetensors /content/models/`

### Opção C: Wget/Curl (se os arquivos estiverem online)
1. Hospede os arquivos em algum serviço (GitHub LFS, Dropbox, etc.)
2. Use wget no Colab: `!wget URL -O /content/models/file.safetensors`

## Fluxo Recomendado:
1. Execute dataset generator (opcional) - Upload: midjourney_LORA.safetensors
2. Execute training notebook - Upload: dataset.zip + midjourney_LORA.safetensors

---
Preparado em: {preparado_em}
"""
    
    import datetime
    readme_path = upload_prep_path / "README.md"
    with open(readme_path, 'w') as f:
        f.write(readme_content.format(
            preparado_em=datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        ))
    
    print(f"📝 README criado: {readme_path}")
    
    # Listar arquivos finais
    print(f"\n📦 ARQUIVOS PRONTOS PARA UPLOAD:")
    for file in upload_prep_path.iterdir():
        if file.is_file():
            size_mb = file.stat().st_size / (1024*1024)
            print(f"   📄 {file.name} ({size_mb:.1f}MB)")
    
    total_size = sum(f.stat().st_size for f in upload_prep_path.iterdir() if f.is_file())
    total_mb = total_size / (1024*1024)
    
    print(f"\n🎯 RESUMO:")
    print(f"📊 Total para upload: {total_mb:.1f}MB")
    print(f"📁 Pasta: {upload_prep_path}")
    print(f"⏱️ Tempo estimado de upload (WiFi típico): {total_mb/10:.1f}-{total_mb/5:.1f} minutos")
    
    print(f"\n💡 PRÓXIMOS PASSOS:")
    print(f"1. Abra um dos notebooks no Google Colab")
    print(f"2. Quando solicitado, faça upload dos arquivos desta pasta")
    print(f"3. Ou copie os arquivos para seu Google Drive primeiro")
    
    print(f"\n✅ PREPARAÇÃO CONCLUÍDA!")

if __name__ == "__main__":
    main()
