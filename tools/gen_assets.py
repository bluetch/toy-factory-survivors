#!/usr/bin/env python3
import os, struct, zlib


def write_png_rgba(path, w, h, pixels):
    # pixels: bytes length w*h*4, row-major, top-down
    def chunk(tag, data):
        return struct.pack("!I", len(data)) + tag + data + struct.pack("!I", zlib.crc32(tag + data) & 0xFFFFFFFF)

    raw = bytearray()
    stride = w * 4
    for y in range(h):
        raw.append(0)  # filter type 0
        raw.extend(pixels[y * stride : (y + 1) * stride])

    ihdr = struct.pack("!IIBBBBB", w, h, 8, 6, 0, 0, 0)  # 8-bit, RGBA
    idat = zlib.compress(bytes(raw), 9)

    sig = b"\x89PNG\r\n\x1a\n"
    data = sig + chunk(b"IHDR", ihdr) + chunk(b"IDAT", idat) + chunk(b"IEND", b"")
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "wb") as f:
        f.write(data)


def rgba(hexstr, a=255):
    hexstr = hexstr.lstrip("#")
    r = int(hexstr[0:2], 16)
    g = int(hexstr[2:4], 16)
    b = int(hexstr[4:6], 16)
    return (r, g, b, a)


def img(w, h, fill=(0, 0, 0, 0)):
    return bytearray(list(fill) * (w * h))


def set_px(p, w, x, y, c):
    if x < 0 or y < 0:
        return
    if x >= w:
        return
    i = (y * w + x) * 4
    p[i : i + 4] = bytes(c)


def rect(p, w, x0, y0, ww, hh, c):
    for y in range(y0, y0 + hh):
        for x in range(x0, x0 + ww):
            set_px(p, w, x, y, c)


def outline(p, w, x0, y0, ww, hh, c):
    for x in range(x0, x0 + ww):
        set_px(p, w, x, y0, c)
        set_px(p, w, x, y0 + hh - 1, c)
    for y in range(y0, y0 + hh):
        set_px(p, w, x0, y, c)
        set_px(p, w, x0 + ww - 1, y, c)


def sprite_bot(body, ink):
    w = h = 16
    p = img(w, h)
    rect(p, w, 4, 4, 8, 9, body)
    outline(p, w, 4, 4, 8, 9, ink)
    rect(p, w, 6, 6, 2, 2, rgba("E5E7EB"))
    rect(p, w, 10, 6, 1, 2, rgba("E5E7EB"))
    rect(p, w, 5, 13, 3, 2, tuple(max(0, int(v * 0.75)) for v in body[:3]) + (255,))
    rect(p, w, 9, 13, 3, 2, tuple(max(0, int(v * 0.75)) for v in body[:3]) + (255,))
    return w, h, p


def sprite_mouse(body, ink):
    w = h = 16
    p = img(w, h)
    rect(p, w, 5, 7, 6, 5, body)
    outline(p, w, 5, 7, 6, 5, ink)
    rect(p, w, 3, 6, 3, 3, body)
    outline(p, w, 3, 6, 3, 3, ink)
    rect(p, w, 10, 6, 3, 3, body)
    outline(p, w, 10, 6, 3, 3, ink)
    rect(p, w, 11, 11, 3, 1, ink)
    return w, h, p


def sprite_ragdoll(cloth, ink):
    w = h = 16
    p = img(w, h)
    rect(p, w, 6, 4, 4, 4, rgba("F5D0C5"))
    outline(p, w, 6, 4, 4, 4, ink)
    rect(p, w, 5, 8, 6, 6, cloth)
    outline(p, w, 5, 8, 6, 6, ink)
    rect(p, w, 4, 9, 1, 4, tuple(max(0, int(v * 0.85)) for v in cloth[:3]) + (255,))
    rect(p, w, 11, 9, 1, 4, tuple(max(0, int(v * 0.85)) for v in cloth[:3]) + (255,))
    return w, h, p


def sprite_duck(body, ink):
    w = h = 16
    p = img(w, h)
    rect(p, w, 4, 7, 8, 6, body)
    outline(p, w, 4, 7, 8, 6, ink)
    rect(p, w, 9, 5, 4, 4, body)
    outline(p, w, 9, 5, 4, 4, ink)
    rect(p, w, 12, 8, 2, 1, rgba("FB7185"))
    return w, h, p


def sprite_box(body, ink):
    w = h = 16
    p = img(w, h)
    rect(p, w, 4, 5, 8, 8, body)
    outline(p, w, 4, 5, 8, 8, ink)
    rect(p, w, 6, 7, 4, 4, tuple(max(0, int(v * 0.8)) for v in body[:3]) + (255,))
    outline(p, w, 6, 7, 4, 4, ink)
    rect(p, w, 7, 8, 2, 2, rgba("E5E7EB"))
    return w, h, p


def sprite_bullet():
    w = h = 16
    p = img(w, h)
    y = rgba("FBBF24")
    rect(p, w, 7, 3, 2, 10, y)
    rect(p, w, 6, 5, 4, 6, rgba("FCD34D"))
    return w, h, p


def sprite_gem():
    w = h = 16
    p = img(w, h)
    c = rgba("60A5FA")
    rect(p, w, 7, 3, 2, 2, rgba("93C5FD"))
    rect(p, w, 6, 5, 4, 7, c)
    rect(p, w, 7, 12, 2, 1, rgba("2563EB"))
    outline(p, w, 6, 5, 4, 7, rgba("1D4ED8"))
    return w, h, p


def ui_stripes():
    w = h = 32
    p = img(w, h, rgba("000000", 0))
    y = rgba("FBBF24", 255)
    k = rgba("111827", 255)
    for yy in range(h):
        for xx in range(w):
            # diagonal pattern
            v = (xx + yy) // 4
            set_px(p, w, xx, yy, y if (v & 1) == 0 else k)
    return w, h, p


def ui_metal_panel():
    w = h = 48
    p = img(w, h, rgba("111827", 255))
    # inner
    rect(p, w, 2, 2, w - 4, h - 4, rgba("1F2A44", 255))
    # rivets
    r = rgba("9CA3AF", 255)
    for (x, y) in [(6, 6), (w - 7, 6), (6, h - 7), (w - 7, h - 7)]:
        rect(p, w, x - 1, y - 1, 3, 3, r)
        rect(p, w, x, y, 1, 1, rgba("E5E7EB", 255))
    # scanline highlight
    for yy in range(4, h - 4, 6):
        rect(p, w, 3, yy, w - 6, 1, rgba("93C5FD", 30))
    return w, h, p


def main():
    root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    sp = os.path.join(root, "assets", "sprites")
    ui = os.path.join(root, "assets", "ui")
    ink = rgba("111827")
    write_png_rgba(os.path.join(sp, "player.png"), *sprite_bot(rgba("34D399"), ink))
    write_png_rgba(os.path.join(sp, "enemy_tin_soldier.png"), *sprite_bot(rgba("EF4444"), ink))
    write_png_rgba(os.path.join(sp, "enemy_windup_mouse.png"), *sprite_mouse(rgba("A78BFA"), ink))
    write_png_rgba(os.path.join(sp, "enemy_rag_doll.png"), *sprite_ragdoll(rgba("F472B6"), ink))
    write_png_rgba(os.path.join(sp, "enemy_robo_duck.png"), *sprite_duck(rgba("F59E0B"), ink))
    write_png_rgba(os.path.join(sp, "enemy_jackbox.png"), *sprite_box(rgba("22C55E"), ink))
    write_png_rgba(os.path.join(sp, "bullet.png"), *sprite_bullet())
    write_png_rgba(os.path.join(sp, "gem.png"), *sprite_gem())
    write_png_rgba(os.path.join(ui, "hazard_stripes.png"), *ui_stripes())
    write_png_rgba(os.path.join(ui, "metal_panel.png"), *ui_metal_panel())
    print("Generated sprites/ui assets.")


if __name__ == "__main__":
    main()

