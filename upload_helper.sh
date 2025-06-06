#!/bin/zsh
# Upload Helper for Google Colab - Valentina LoRA Project
# Métodos alternativos para upload de arquivos grandes

echo "🚀 GOOGLE COLAB UPLOAD HELPER"
echo "=============================="

# Caminhos
PROJECT_DIR="/Users/andre/Projeto-Valentina"
UPLOAD_DIR="$PROJECT_DIR/colab_upload_ready"
MIDJOURNEY_LORA="$UPLOAD_DIR/midjourney_LORA.safetensors"
DATASET_ZIP="$UPLOAD_DIR/valentina_dataset.zip"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "\n${BLUE}📋 Opções de Upload:${NC}"
echo "1. Preparar arquivos localmente (recomendado primeiro)"
echo "2. Upload via Google Drive CLI (gdrive)"
echo "3. Upload via rclone (se configurado)"
echo "4. Criar links de download temporários"
echo "5. Verificar arquivos preparados"

echo -e "\n${YELLOW}Escolha uma opção (1-5):${NC}"
read option

case $option in
    1)
        echo -e "\n${BLUE}🔧 Preparando arquivos...${NC}"
        cd "$PROJECT_DIR"
        python3 upload_to_colab.py
        
        echo -e "\n${GREEN}✅ Arquivos preparados em:${NC} $UPLOAD_DIR"
        echo -e "${YELLOW}💡 Próximo passo:${NC} Faça upload manual no Colab ou use as opções 2-4"
        ;;
        
    2)
        echo -e "\n${BLUE}📤 Upload via Google Drive CLI...${NC}"
        
        # Verificar se gdrive está instalado
        if ! command -v gdrive &> /dev/null; then
            echo -e "${RED}❌ gdrive não encontrado.${NC}"
            echo -e "${YELLOW}💡 Instale com:${NC} brew install gdrive"
            echo -e "${YELLOW}💡 Configure com:${NC} gdrive account add"
            exit 1
        fi
        
        # Criar pasta no Drive
        echo "📁 Criando pasta 'ValentinaColab' no Google Drive..."
        FOLDER_ID=$(gdrive files mkdir "ValentinaColab" | grep -o "Id: [a-zA-Z0-9_-]*" | cut -d' ' -f2)
        
        if [ -n "$FOLDER_ID" ]; then
            echo -e "${GREEN}✅ Pasta criada:${NC} $FOLDER_ID"
            
            # Upload dos arquivos
            echo "📤 Fazendo upload da Midjourney LoRA..."
            gdrive files upload --parent "$FOLDER_ID" "$MIDJOURNEY_LORA"
            
            echo "📤 Fazendo upload do dataset..."
            gdrive files upload --parent "$FOLDER_ID" "$DATASET_ZIP"
            
            echo -e "\n${GREEN}✅ Upload concluído!${NC}"
            echo -e "${YELLOW}💡 No Colab, monte o Drive e copie os arquivos:${NC}"
            echo "from google.colab import drive"
            echo "drive.mount('/content/drive')"
            echo "!cp /content/drive/MyDrive/ValentinaColab/* /content/models/"
        else
            echo -e "${RED}❌ Erro ao criar pasta no Drive${NC}"
        fi
        ;;
        
    3)
        echo -e "\n${BLUE}📤 Upload via rclone...${NC}"
        
        if ! command -v rclone &> /dev/null; then
            echo -e "${RED}❌ rclone não encontrado.${NC}"
            echo -e "${YELLOW}💡 Instale com:${NC} brew install rclone"
            echo -e "${YELLOW}💡 Configure com:${NC} rclone config"
            exit 1
        fi
        
        echo -e "${YELLOW}📋 Remotes configurados:${NC}"
        rclone listremotes
        
        echo -e "\n${YELLOW}Digite o nome do remote (ex: gdrive:):${NC}"
        read remote
        
        if [ -n "$remote" ]; then
            echo "📤 Fazendo upload para $remote..."
            rclone copy "$UPLOAD_DIR" "$remote/ValentinaColab/" --progress
            echo -e "${GREEN}✅ Upload via rclone concluído!${NC}"
        fi
        ;;
        
    4)
        echo -e "\n${BLUE}🔗 Criando links temporários...${NC}"
        
        # Verificar se transfer.sh está acessível
        echo "📤 Testando upload para transfer.sh..."
        
        echo "📤 Upload da Midjourney LoRA..."
        LORA_URL=$(curl --upload-file "$MIDJOURNEY_LORA" https://transfer.sh/midjourney_LORA.safetensors)
        
        echo "📤 Upload do dataset..."
        DATASET_URL=$(curl --upload-file "$DATASET_ZIP" https://transfer.sh/valentina_dataset.zip)
        
        echo -e "\n${GREEN}✅ Links temporários criados:${NC}"
        echo -e "${YELLOW}Midjourney LoRA:${NC} $LORA_URL"
        echo -e "${YELLOW}Dataset:${NC} $DATASET_URL"
        
        echo -e "\n${YELLOW}💡 No Colab, use:${NC}"
        echo "!wget $LORA_URL -O /content/models/midjourney_LORA.safetensors"
        echo "!wget $DATASET_URL -O /content/valentina_dataset.zip"
        
        # Salvar URLs em arquivo
        echo "# URLs temporários para Colab - $(date)" > "$UPLOAD_DIR/download_urls.txt"
        echo "# Válidos por 14 dias" >> "$UPLOAD_DIR/download_urls.txt"
        echo "" >> "$UPLOAD_DIR/download_urls.txt"
        echo "# Midjourney LoRA:" >> "$UPLOAD_DIR/download_urls.txt"
        echo "!wget $LORA_URL -O /content/models/midjourney_LORA.safetensors" >> "$UPLOAD_DIR/download_urls.txt"
        echo "" >> "$UPLOAD_DIR/download_urls.txt"
        echo "# Dataset:" >> "$UPLOAD_DIR/download_urls.txt"
        echo "!wget $DATASET_URL -O /content/valentina_dataset.zip" >> "$UPLOAD_DIR/download_urls.txt"
        
        echo -e "${GREEN}📝 URLs salvos em:${NC} $UPLOAD_DIR/download_urls.txt"
        ;;
        
    5)
        echo -e "\n${BLUE}📊 Verificando arquivos preparados...${NC}"
        
        if [ -d "$UPLOAD_DIR" ]; then
            echo -e "${GREEN}📁 Pasta encontrada:${NC} $UPLOAD_DIR"
            echo ""
            
            for file in "$UPLOAD_DIR"/*; do
                if [ -f "$file" ]; then
                    filename=$(basename "$file")
                    size=$(ls -lh "$file" | awk '{print $5}')
                    echo -e "${GREEN}✅${NC} $filename ($size)"
                fi
            done
            
            total_size=$(du -sh "$UPLOAD_DIR" | cut -f1)
            echo -e "\n${YELLOW}📊 Tamanho total:${NC} $total_size"
        else
            echo -e "${RED}❌ Pasta não encontrada.${NC} Execute a opção 1 primeiro."
        fi
        ;;
        
    *)
        echo -e "${RED}❌ Opção inválida${NC}"
        exit 1
        ;;
esac

echo -e "\n${GREEN}🎯 Script concluído!${NC}"
