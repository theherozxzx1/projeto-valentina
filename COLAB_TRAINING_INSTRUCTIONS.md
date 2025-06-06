# 📋 Instruções para Treinamento LoRA Valentina no Google Colab

## 🎯 Objetivo
Treinar uma LoRA de alta qualidade para a identidade facial da Valentina usando FLUX no Google Colab, compatível com mflux no MacBook.

## ✨ Melhorias na Versão Atual
- **Configurações otimizadas** para máxima qualidade
- **Parâmetros dinâmicos** baseados na GPU disponível  
- **Validação automática** durante o treinamento
- **Notebook limpo** sem células duplicadas
- **Monitoramento avançado** de progresso
- **Dataset generator premium** para imagens de referência superiores

## 📋 Pré-requisitos

1. **Conta Google Colab Pro** (recomendado para GPU melhor)
2. **Conta Hugging Face** com token de acesso
3. **Arquivos preparados**:
   - `valentina_dataset.zip` (7 imagens de referência) OU dataset premium gerado
   - `midjourney_LORA.safetensors` (LoRA de estilo)

## 🎨 OPCIONAL: Gerar Dataset Premium no Colab

**RECOMENDADO:** Antes do treinamento, gere um dataset de qualidade superior:

### 1. Execute o Dataset Generator
- Abra `valentina_dataset_generator_colab.ipynb` no Google Colab
- **Vantagens**: 40-50 inference steps vs 8 no MacBook
- **Resultado**: 6 imagens em resolução 1024x1024 com qualidade premium
- **Tempo**: ~10-15 minutos

### 2. Benefícios do Dataset Premium
- **Melhor qualidade facial**: Detalhes superiores devido aos steps extras
- **Maior diversidade**: 6 variações de pose, ângulo e iluminação
- **Estilo cinematográfico**: Midjourney LoRA aplicada para qualidade profissional
- **Melhor treinamento**: Dataset superior resulta em LoRA mais precisa

## 🚀 Passo a Passo

### ETAPA 1: Gerar Dataset Premium (OPCIONAL mas RECOMENDADO)
- Abra `valentina_dataset_generator_colab.ipynb`
- Execute todas as células em ordem
- Faça upload da `midjourney_LORA.safetensors`
- Aguarde 10-15 minutos para gerar 6 imagens premium
- Baixe o `valentina_hq_dataset.zip` gerado

### ETAPA 2: Treinamento da LoRA

#### 1. Abrir o Notebook no Colab
- Faça upload do arquivo `valentina_colab_facial_lora_trainer_flux.ipynb` para o Google Colab
- Ou abra diretamente pelo GitHub

#### 2. Configurar Runtime
- Vá em **Runtime > Change runtime type**
- Selecione **GPU** (T4, V100 ou A100)
- Marque **High-RAM** se disponível

#### 3. Executar Células em Ordem

#### Célula 1: Configurações
- Define todos os parâmetros de treinamento
- Otimizado para máxima qualidade

#### Célula 2: Instalação de Dependências
- Instala PyTorch, Diffusers e bibliotecas necessárias
- Aguarde 2-3 minutos

#### Célula 3: Autenticação Hugging Face
- Faça login com seu token HF
- Necessário para baixar o checkpoint NSFW

#### Célula 4: Verificação de GPU
- Detecta automaticamente sua GPU
- Ajusta parâmetros para melhor performance

#### Célula 5: Estrutura de Diretórios
- Cria pastas organizadas para o treinamento

#### Célula 6: Upload dos Dados
- **IMPORTANTE**: Faça upload dos arquivos:
  - `valentina_hq_dataset.zip` (se gerado) OU `valentina_dataset.zip` (original)
  - `midjourney_LORA.safetensors`
- As imagens serão processadas automaticamente

#### Célula 7: Preparação do Modelo
- Carrega o checkpoint NSFW
- Aplica a Midjourney LoRA como base
- Cria modelo intermediário para treinamento

#### Célula 8: Treinamento
- **TEMPO**: 30-60 minutos dependendo da GPU
- Monitore o progresso nas saídas
- Salva checkpoints automaticamente

#### Célula 9: Resultados e Download
- Empacota a LoRA treinada
- Cria documentação completa
- Download automático do arquivo ZIP

## ⚙️ Configurações Otimizadas

### Parâmetros de Qualidade:
- **LoRA Rank**: 128 (alta qualidade facial)
- **Learning Rate**: 8e-5 (preserva características)
- **Steps**: 1000 (~142 por imagem do dataset original, ~167 para dataset premium)
- **Resolution**: 1024x1024

### Dataset Premium vs Original:
- **Original**: 7 imagens em 8 steps (MacBook)
- **Premium**: 6 imagens em 40-50 steps (Colab GPU)
- **Resultado**: Melhor qualidade facial e diversidade

### Trigger Word:
- **Uso**: `a photo of vltna woman`
- **Exemplo**: `a photo of vltna woman, professional portrait, elegant lighting`

## 🎯 Uso da LoRA Treinada

### No seu MacBook com mflux:

```bash
mflux-generate \
  --model "/Users/andre/.cache/huggingface/hub/models--John6666--nsfw-master-flux-lora-merged-with-flux1-dev-fp16-v10-fp8-flux" \
  --lora "/Users/andre/Projeto-Valentina/Models/valentina_facial_lora.safetensors" \
  --lora-scale 0.8 \
  --prompt "a photo of vltna woman, elegant dress, studio lighting" \
  --output "/Users/andre/Projeto-Valentina/Generated/" \
  --width 1024 \
  --height 1024 \
  --num-inference-steps 30 \
  --guidance 7.5
```

### Com Midjourney LoRA combinada:

```bash
mflux-generate \
  --model "/Users/andre/.cache/huggingface/hub/models--John6666--nsfw-master-flux-lora-merged-with-flux1-dev-fp16-v10-fp8-flux" \
  --lora "/Users/andre/Projeto-Valentina/Models/midjourney_LORA.safetensors" \
  --lora "/Users/andre/Projeto-Valentina/Models/valentina_facial_lora.safetensors" \
  --lora-scale 0.6 \
  --lora-scale 0.8 \
  --prompt "a photo of vltna woman, professional portrait, cinematic lighting" \
  --output "/Users/andre/Projeto-Valentina/Generated/" \
  --width 1024 \
  --height 1024
```

## 🔧 Resolução de Problemas

### GPU Insuficiente:
- Reduza `TRAIN_BATCH_SIZE` para 1
- Ative `USE_CPU_OFFLOAD = True`
- Use `MIXED_PRECISION = "fp16"`

### Erro de Memória:
- Reduza `RESOLUTION` para 768
- Diminua `LORA_RANK` para 64
- Ative `GRADIENT_CHECKPOINTING`

### Download Lento:
- Use Colab Pro para internet mais rápida
- Considere dividir o treinamento em múltiplas sessões

## 📊 Expectativas de Qualidade

- **Tempo de Treinamento**: 30-60 minutos
- **Tamanho da LoRA**: ~250MB
- **Qualidade**: Alta fidelidade facial
- **Compatibilidade**: mflux, ComfyUI, A1111

## 🎨 Prompts Recomendados

### Retratos Profissionais:
- `a photo of vltna woman, professional headshot, studio lighting`
- `vltna woman, elegant portrait, soft lighting, high quality`

### Estilos Artísticos:
- `a photo of vltna woman, renaissance painting style`
- `vltna woman, cyberpunk aesthetic, neon lighting`

### Cenários:
- `vltna woman walking in a garden, natural lighting`
- `a photo of vltna woman at a coffee shop, candid moment`

## 📝 Notas Importantes

1. **Dataset Premium**: Use o `valentina_dataset_generator_colab.ipynb` para melhor qualidade
2. **Sempre use o trigger word** `vltna woman` para ativar a LoRA
3. **Peso recomendado**: 0.7-1.0 dependendo da força desejada
4. **Compatível** com todos os modelos FLUX.1-dev
5. **Mantenha backup** da LoRA treinada
6. **Teste diferentes pesos** para encontrar o ideal para cada uso

## 📋 Arquivos do Projeto

### Notebooks Disponíveis:
- `valentina_dataset_generator_colab.ipynb` - Gera dataset premium (OPCIONAL)
- `valentina_colab_facial_lora_trainer_flux.ipynb` - Treina a LoRA facial

### Fluxo Recomendado:
1. **Gerar dataset premium** (10-15 min)
2. **Treinar LoRA** com dataset premium (30-60 min)
3. **Usar LoRA** no MacBook com mflux

---

🎉 **Sucesso!** Agora você tem uma LoRA de alta qualidade da Valentina para usar localmente no seu MacBook!
