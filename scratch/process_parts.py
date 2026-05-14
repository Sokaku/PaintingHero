
import os
from PIL import Image

def process_image(input_path, output_prefix, target_dir):
    if not os.path.exists(input_path):
        print(f"Error: No se encuentra {input_path}")
        return
        
    img = Image.open(input_path).convert("RGBA")
    width, height = img.size
    part_width = width // 4
    
    # Eliminar fondo de cuadros (checkerboard)
    data = img.getdata()
    new_data = []
    for item in data:
        # Detectar el patrón gris (claro y oscuro)
        if (180 <= item[0] <= 215 and 180 <= item[1] <= 215 and 180 <= item[2] <= 215) or \
           (230 <= item[0] <= 255 and 230 <= item[1] <= 255 and 230 <= item[2] <= 255):
            new_data.append((0, 0, 0, 0)) # Transparente
        else:
            new_data.append(item)
    img.putdata(new_data)

    # Recortar en 4 partes
    for i in range(4):
        left = i * part_width
        right = (i + 1) * part_width
        part = img.crop((left, 0, right, height))
        
        # Redimensionar a 256x256
        part = part.resize((256, 256), Image.Resampling.LANCZOS)
        
        output_path = os.path.join(target_dir, f"{output_prefix}_{i+1}.png")
        part.save(output_path, "PNG")
        print(f"✅ Generado: {output_path}")

target = "assets/images/parts"
os.makedirs(target, exist_ok=True)

process_image("heads_sheet.png", "head", target)
process_image("torsos_sheet.png", "torso", target)
process_image("legs_sheet.png", "legs", target)
