import os
from PIL import Image

def flawless_victory_clean(input_path, output_prefix, target_dir):
    if not os.path.exists(input_path):
        return
        
    img = Image.open(input_path).convert("RGBA")
    width, height = img.size
    part_width = width // 4
    
    # 1. DETECTAR COLORES DEL FONDO (Muestreo de esquinas)
    # El patrón de cuadros tiene 2 colores. Muestreamos varios puntos del borde superior.
    bg_colors = []
    for x in range(0, width, 10):
        pixel = img.getpixel((x, 0))
        bg_colors.append(pixel)
    for y in range(0, 100, 10):
        pixel = img.getpixel((0, y))
        bg_colors.append(pixel)
        
    # 2. LIMPIEZA ABSOLUTA
    data = img.getdata()
    new_data = []
    for item in data:
        r, g, b, a = item
        is_bg = False
        # Comprobamos si el píxel se parece a ALGUNo de los colores del fondo muestreados
        for bg_c in bg_colors:
            if abs(r - bg_c[0]) < 15 and abs(g - bg_c[1]) < 15 and abs(b - bg_c[2]) < 15:
                is_bg = True
                break
                
        # También borramos cualquier cosa casi blanca o gris muy clara por si acaso
        if r > 180 and g > 180 and b > 180 and abs(r-g) < 10 and abs(g-b) < 10:
            is_bg = True

        if is_bg:
            new_data.append((0, 0, 0, 0))
        else:
            new_data.append(item)
    img.putdata(new_data)

    # 3. RECORTE AL MILÍMETRO
    for i in range(4):
        left = i * part_width
        right = (i + 1) * part_width
        part = img.crop((left, 0, right, height))
        
        bbox = part.getbbox()
        if bbox:
            part = part.crop(bbox)
            w, h = part.size
            # Margen mínimo arriba (2%) para que no toque
            margin = int(h * 0.02)
            size = max(w, h + margin)
            square_img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
            square_img.paste(part, ((size - w) // 2, margin))
            part = square_img

        part = part.resize((256, 256), Image.Resampling.LANCZOS)
        
        output_path = os.path.join(target_dir, f"{output_prefix}_{i+1}.png")
        part.save(output_path, "PNG")
        print(f"🎯 Héroe LIMPIO generado: {output_path}")

target = "assets/images/parts"
os.makedirs(target, exist_ok=True)
flawless_victory_clean("heads_sheet.png", "head", target)
