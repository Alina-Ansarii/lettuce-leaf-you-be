# 🎨 PIXEL ART SETUP — Lettuce Leaf You Be

> You're switching from painterly to **pixel art** — the style you already know from your Stardew work. This plays to your strength, fits the no-animation limit, is 100% jam-legal, and is faster for a solo dev. Papers Please (your own reference) is pixel art. This is the right call.

## Tool: start with Piskel (free, browser, now)

- **piskelapp.com** → "Create Sprite" → you're drawing in 10 seconds. No install. Export as PNG.
- GIMP is NOT built for pixel art (no proper pixel grid, clunky pencil) — that's why today hurt. A dedicated tool fixes all of it.
- Later, if you love it: **Aseprite** (~$20, Steam, industry standard) or **LibreSprite** (free Aseprite fork, libresprite.github.io). But don't stall on the choice — **Piskel today.**

## The golden rule: DRAW SMALL, SCALE UP

You do NOT draw at 1280×720. You draw tiny — where every pixel counts, like Stardew — then Godot scales it up crisp. This is the whole secret to easy pixel art.

| Asset | Draw at this size | Notes |
|---|---|---|
| **Café background** | **320 × 180** | Exactly 1/4 of 1280×720, same 16:9 shape. Scales up ×4 perfectly. |
| **Dino portraits** | **96 × 96** or **128 × 128** | Chunky, readable. Pick one size, use for ALL dinos. |
| **Food icons** | **32 × 32** | Tiny, simple. |
| **Plate** | **64 × 48** | Small. |

> At 320×180 your café is small enough that you're placing chunky pixels by hand — the comfortable, precise, grid-based workflow you already know. No steady-hand line-drawing needed.

## Keep pixels CRISP in Godot (one important setting)

When you scale a pixel image up, you must turn OFF smoothing or it goes blurry. In Godot:
- Click your imported PNG in the FileSystem → **Import** tab (top-right, next to Scene) → set **Filter** to **Nearest** (or turn "Filter" off) → click **Reimport**.
- Or set it project-wide: Project Settings → Rendering → Textures → **Default Texture Filter → Nearest**.
- This makes pixels stay sharp and blocky when scaled up, instead of a blurry mess.

## Your palette still applies

Load your same hex codes as a palette in Piskel/Aseprite (both support custom palettes). Same rules:
- Greens for the world, warm tans for café, pink for cute accents, **deep red ONLY for carnivore eyes/menace**, blue for the sky.
- Pixel art *loves* limited palettes — your tight palette will look great.

## The café layout is the SAME — just at 320×180

Your zone plan doesn't change, it just scales down (÷4):

```
320×180 canvas:
- Café background fills the top ~65% (menu board, plants, window)
- Leave the PORTRAIT ZONE clear: ~110×110 px, upper-center (around x:105–215, y:15–115)
- Counter/workspace = bottom ~35% (y:117–180) — leave clear for plate + buttons
```

Same as before: paint the **empty room**. Portrait, plate, buttons, dialogue box are all Godot nodes layered on top later — you don't draw them into the background.

## Your reference still works

Open your `reference-cafe-1280x720.png` in a second window (or import it into Piskel scaled to 320×180) as a guide to copy positions and colors from. Trace the zones, sample the colors, but draw in your own chunky pixel style.

## Today's realistic pixel goal

1. Get Piskel open, palette loaded.
2. Draw the **café background at 320×180** (empty room — menu board, plants, window, counter). Leave portrait + counter zones clear.
3. Draw **Trisha at 96×96 or 128×128** (neutral + happy) if you have energy.

That's a great, achievable Day 1 in a style you actually enjoy. The stress you felt was the wrong-tool/wrong-style mismatch — not your ability. Pixel art is your home turf.

---

*Small canvas, chunky pixels, crisp scale-up. Back on home turf. 🥬*
