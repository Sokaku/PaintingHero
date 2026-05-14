
import os
from PIL import Image, ImageOps

def process_image(input_path, output_prefix, target_dir):
    if not os.path.exists(input_path):
        return
        
    img = Image.open(input_path).convert("RGBA")
    width, height = img.size
    part_width = width // 4
    
    # Algoritmo de transparencia mejorado
    data = img.getdata()
    new_data = []
    # Definimos los rangos de gris del checkerboard de forma más amplia
    for item in data:
        # Si el píxel es un gris del checkerboard (típicamente r=g=b)
        r, g, b, a = item
        if (abs(r-g) < 5 and abs(g-b) < 5 and r > 150): 
            new_data.append((0, 0, 0, 0))
        else:
            new_data.append(item)
    img.putdata(new_data)

    # Recortar en 4 partes manteniendo el aspecto original (352x768)
    for i in range(4):
        left = i * part_width
        right = (i + 1) * part_width
        part = img.crop((left, 0, right, height))
        
        # Opcional: Recortar bordes vacíos automáticamente para que encajen mejor
        # (Esto ayuda a que no haya "espacio" invisible arriba y abajo)
        
        output_path = os.path.join(target_dir, f"{output_prefix}_{i+1}.png")
        # Guardamos a tamaño original o proporcional para NO achatar
        part.save(output_path, "PNG")
        print(f"✅ Re-generado con aspecto original: {output_path}")

target = "assets/images/parts"
os.makedirs(target, exist_ok=True)

process_image("heads_sheet.png", "head", target)
process_image("torsos_sheet.png", "torso", target)
process_image("legs_sheet.png", "legs", target)
