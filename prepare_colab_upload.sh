#!/bin/zsh

# 📤 Script de Preparação para Upload no Google Colab
# Projeto Valentina - Preparação de Arquivos

echo "🎯 PREPARANDO ARQUIVOS PARA GOOGLE COLAB"
echo "========================================"

# Definir caminhos
PROJECT_DIR="/Users/andre/Projeto-Valentina"
MODELS_DIR="$PROJECT_DIR/Models"
DATASET_DIR="$PROJECT_DIR/ValentinaNSFWLoRA"
TEMP_DIR="$PROJECT_DIR/colab_upload_temp"

# Criar diretório temporário
echo "📁 Criando diretório temporário..."
mkdir -p "$TEMP_DIR"

# Verificar se os arquivos existem
echo "\n🔍 Verificando arquivos necessários..."

# 1. Midjourney LoRA
MIDJOURNEY_LORA="$MODELS_DIR/midjourney_LORA.safetensors"
if [[ -f "$MIDJOURNEY_LORA" ]]; then
    echo "✅ midjourney_LORA.safetensors encontrada"
    LORA_SIZE=$(stat -f%z "$MIDJOURNEY_LORA")
    echo "   Tamanho: $(echo "scale=1; $LORA_SIZE/1024/1024" | bc -l) MB"
    cp "$MIDJOURNEY_LORA" "$TEMP_DIR/"
else
    echo "❌ midjourney_LORA.safetensors NÃO encontrada em $MIDJOURNEY_LORA"
fi

# 2. Dataset da Valentina
DATASET_ZIP="$DATASET_DIR/valentina_dataset.zip"
if [[ -f "$DATASET_ZIP" ]]; then
    echo "✅ valentina_dataset.zip encontrado"
    DATASET_SIZE=$(stat -f%z "$DATASET_ZIP")
    echo "   Tamanho: $(echo "scale=1; $DATASET_SIZE/1024/1024" | bc -l) MB"
    cp "$DATASET_ZIP" "$TEMP_DIR/"
else
    echo "❌ valentina_dataset.zip NÃO encontrado em $DATASET_ZIP"
fi

echo "\n📋 INSTRUÇÕES DE UPLOAD:"
echo "========================"
echo "1. Abra o Google Colab"
echo "2. Carregue um dos notebooks:"
echo "   • valentina_dataset_generator_colab.ipynb (gerar dataset premium)"
echo "   • valentina_colab_facial_lora_trainer_flux.ipynb (treinar LoRA)"
echo ""
echo "3. Execute as células até chegar no upload"
echo "4. Use o widget de upload para enviar os arquivos de:"
echo "   📁 $TEMP_DIR"
echo ""
echo "5. Arquivos para upload:"
if [[ -f "$TEMP_DIR/midjourney_LORA.safetensors" ]]; then
    echo "   ✅ midjourney_LORA.safetensors"
fi
if [[ -f "$TEMP_DIR/valentina_dataset.zip" ]]; then
    echo "   ✅ valentina_dataset.zip"
fi

echo "\n💡 DICA: Os arquivos são pequenos (~24MB total), o upload será rápido!"

# Abrir o diretório no Finder para facilitar
echo "\n📂 Abrindo diretório de upload no Finder..."
open "$TEMP_DIR"

echo "\n🎉 Preparação concluída! Arquivos prontos para upload no Colab."
