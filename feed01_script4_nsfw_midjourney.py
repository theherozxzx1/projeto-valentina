#!/usr/bin/env python3
"""
Script 4: NSFW Checkpoint + Midjourney LoRA
Primeira imagem do feed da Valentina Moreau
Gera 4 variações usando checkpoint NSFW + LoRA Midjourney
"""

import subprocess
import time
import os

def main():
    print("🎨 SCRIPT 4: NSFW CHECKPOINT + MIDJOURNEY LORA")
    print("=" * 50)
    print("Gerando primeira imagem do feed da Valentina Moreau")
    print("Modelo: NSFW Master FLUX + Midjourney LoRA")
    print("Variações: 4")
    print("=" * 50)
    
    # Prompt detalhado baseado nas características da Valentina
    prompt = """A stunning 23-year-old woman named Valentina Moreau wearing an elegant off-shoulder cream silk blouse, hyperrealistic portrait photography. Oval face with delicately defined jawline and prominent cheekbones, large almond-shaped deep brown expressive eyes with long dark lashes, perfectly arched eyebrows, full plump lips with pronounced cupid's bow in natural pink tone, straight proportional nose with slightly tapered tip. Flawless sun-kissed golden-olive skin with healthy glow and velvety texture. Rich dark brown hair with subtle chocolate and mahogany highlights, long flowing past shoulders with voluminous natural waves cascading down, dense and shiny hair. Curvy and toned silhouette, natural proportions, confident posture. Direct confident gaze with touch of mystery and intelligence, subtle enigmatic smile. Professional photography, soft natural lighting, high detail, 8k resolution, photorealistic, Instagram-worthy, glamorous yet sophisticated aesthetic."""
    
    # Seeds para variações consistentes
    seeds = [42, 12345, 98765, 55555]
    
    # Parâmetros otimizados para checkpoint + LoRA
    steps = 8  # Muito reduzido devido ao Hyper-FLUX + LoRA
    guidance = 6.0  # Reduzido para equilibrar checkpoint + LoRA
    width = 768
    height = 1024
    lora_scale = 0.7  # Menor que no script 2 pois o checkpoint já tem LoRAs
    
    # Modelo HuggingFace Hub
    model_id = "John6666/nsfw-master-flux-lora-merged-with-flux1-dev-fp16-v10-fp8-flux"
    lora_path = "/Users/andre/Projeto-Valentina/Models/midjourney_LORA.safetensors"
    
    # Criar diretório de saída se não existir
    output_dir = "/Users/andre/Projeto-Valentina/FeedValentina/Feed01_NSFW_MidjourneyLoRA"
    os.makedirs(output_dir, exist_ok=True)
    
    start_time = time.time()
    
    for i, seed in enumerate(seeds, 1):
        print(f"\n🖼️  Gerando variação {i}/4 (seed: {seed})")
        
        output_path = f"{output_dir}/valentina_feed01_nsfw_midjourney_var{i:02d}_seed{seed}.png"
        
        cmd = [
            "python", "-m", "mflux.generate",
            "--model", model_id,
            "--base-model", "dev",
            "--prompt", prompt,
            "--steps", str(steps),
            "--guidance", str(guidance),
            "--width", str(width),
            "--height", str(height),
            "--seed", str(seed),
            "--lora-paths", lora_path,
            "--lora-scales", str(lora_scale),
            "--quantize", "8",
            "--output", output_path,
            "--low-ram"
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, cwd="/Users/andre/Projeto-Valentina/mflux")
            
            if result.returncode == 0:
                print(f"✅ Variação {i} gerada com sucesso!")
                print(f"📁 Salva em: {output_path}")
            else:
                print(f"❌ Erro na variação {i}:")
                print(f"Stdout: {result.stdout}")
                print(f"Stderr: {result.stderr}")
                
        except Exception as e:
            print(f"❌ Exceção na variação {i}: {str(e)}")
    
    end_time = time.time()
    total_time = end_time - start_time
    
    print(f"\n🎯 SCRIPT 4 CONCLUÍDO!")
    print(f"⏱️  Tempo total: {total_time:.2f} segundos")
    print(f"📂 Diretório: {output_dir}")
    print(f"🎨 Modelo: NSFW Master FLUX + Midjourney LoRA")
    print(f"⚙️  Parâmetros: {steps} steps, guidance {guidance}, LoRA scale {lora_scale}")

if __name__ == "__main__":
    main()
