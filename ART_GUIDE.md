# 🎨 LETTUCE LEAF YOU BE — ART STYLE GUIDE & ASSET TRACKER
### *Day-1 solo art bible — specs, palette, style rules, and everything to draw*

> You have a tablet and some GIMP experience, so hand-drawn linework is the plan. This doc gives you (1) the exact specs so everything fits together, (2) a locked palette with hex codes, (3) style rules so it looks intentional, and (4) a checklist of every asset. Work top to bottom today.

---

## 1. THE SPECS (decide once, never think about it again)

| Thing | Value | Why |
|---|---|---|
| **Game resolution** | 1280 × 720 (16:9) | Standard, itch-friendly, matches your build. |
| **Portrait canvas** | 512 × 512 px, transparent PNG | Square = easy to slot in UI; crisp when scaled down. |
| **Food/ingredient icons** | 128 × 128 px, transparent PNG | Small, uniform, readable on a plate. |
| **Plate** | ~400 × 300 px, transparent PNG | Big enough to drop several icons on. |
| **Café background** | 1280 × 720 px | Fills the whole screen behind everything. |
| **Export format** | PNG with alpha (transparency) | Godot loves PNGs; transparency lets portraits sit on any background. |
| **File naming** | `dino_trisha_neutral.png`, `dino_ray_hungry.png`, `food_fern.png` | Lowercase, underscores, descriptive. Consistency saves headaches. |

**Golden rule:** every portrait is the *same* 512×512 canvas with the face in the *same* spot, so when Godot swaps neutral→happy→hungry, nothing jumps around. Draw all expressions of one dino by duplicating layers in the same file.

---

## 2. THE PALETTE (lush floral vegan café + a jewel-toned menace)

A tight palette is the #1 thing that makes indie art look deliberate instead of amateur. This palette is **warm-dominant** (greens, yellows, pinks, reds), so the single **blue** and the deep **red** become powerful because they're rare. Use **these and mostly these**. Load them as a GIMP palette (see §5).

**GREENS — your world (café, plants, calm):**
- `#C6C954` — **Bamboo**, bright yellow-green — the "vegan" signature pop (signage, brand accents)
- `#A7BD40` — **Android Green** — leafy mid-green (main foliage, plants)
- `#667436` — **Cypress** — deep olive (plant shadows, darker leaves)
- `#292E16` — **Darkest Forest** — near-black green (deepest shadows AND your outline color)

**WARM BASE — café light & surfaces:**
- `#FFEC8E` — **Ylang Ylang** — soft warm yellow (light, highlights, cream surfaces)
- `#CFBD8C` — **Dry Leaf** — sandy tan (wood, counters, neutral warmth)

**PINKS — cute accents ONLY (flowers, highlights, little charming details):**
- `#D9828D` — **Chrysanthemum** — friendly rose-pink (flowers, beetle-shell highlights, cheerful sparkle)
- `#D17484` — **Tulip Bloom** — warmer pink (variation for the above)
> Pink is your *sprinkle* — decorative touches that bring the world to life. It is NOT a main surface color and NOT the danger color. Keep it to small joyful details.

**DEEP RED — THE MENACE (use VERY sparingly):**
- `#8B263E` — **Crushed Rose** — deep berry-red (dramatic UI, rich accents, "caught" backgrounds)
- `#42010F` — **Rhinoceros Beetle**, near-black blood red — ⚠️ **THE danger color.** Carnivore eyes, the snarl, the warning flash. Almost never appears in calm moments.

**BLUE — the opposing accent = the SKY / world outside:**
- `#5C95E0` — **United Nations Blue** — cool bright blue. Used for the **window / sky beyond the café**. Warm cozy interior vs cool outside world. This is your one cool note against everything warm — it does real emotional work, so don't spread it around inside the café.

**NEUTRALS (linework + text):**
- `#292E16` — Darkest Forest doubles as your **warm near-black outline** (keeps everything cohesive — no pure black)
- `#FFFDF7` — off-white (highlights, text on dark)

**The two-tier red rule (your tone in color form):** friendly **pinks** = charm and cuteness; deep **Rhinoceros Beetle red** = menace. When a "vegan" raptor's eye flashes that near-black blood-red against your soft pinks and bright greens, it reads as genuinely wrong. That contrast IS the game's goofy-but-sinister tone.

> Tip: keep the dinos themselves in your greens, tans, and soft pinks so the deep red *pops* the instant it appears in an eye.

### What colors should the CAFÉ be?

Think of the café as **warm, leafy, and inviting — a cozy plant-filled interior with a cool sky outside.** Build it from your warm base + greens, and let pink + blue do accent work:

- **Walls / interior:** `#CFBD8C` **Dry Leaf** (sandy tan) as the main wall/surface, with `#FFEC8E` **Ylang Ylang** where light hits (near windows, lamps). This makes the room feel warm and lit.
- **Wood — counter, tables, shelves:** `#CFBD8C` for lit wood, shadowed with `#667436`/`#292E16`. (You can push the wood browner if you want; tan reads as light pine.)
- **Plants everywhere (this is a VEGAN café — lean in):** `#A7BD40` **Android Green** leaves, shadowed with `#667436` **Cypress**. Hanging plants, potted ferns, a leafy trim. Plants are your theme *and* your decoration.
- **The vegan branding / signage / menu board:** `#C6C954` **Bamboo** — the bright pop that says "fresh & green." Use it for the café's logo, the menu sign, an apron.
- **Cute accents:** little `#D9828D` **Chrysanthemum** pink flowers in pots / on tables / on the counter. Sprinkle, don't flood.
- **The window & sky outside:** `#5C95E0` **United Nations Blue** — a window showing a cool blue sky/outside. This is the ONE cool element; it frames the warm interior and makes it feel cozy by contrast.
- **Outlines & deep shadow:** `#292E16` **Darkest Forest** throughout, for cohesion.

**The formula:** *warm tan room + lots of green plants + a bright green vegan sign + tiny pink flowers + one cool blue window.* That's a café that's unmistakably a lush vegan spot, cozy and pretty — and it makes the deep-red menace land harder because the room around it is so warm and safe-feeling.

> Deliberately DON'T put the deep red (`#42010F`) in the café decor. The room should feel 100% safe. The red only enters through a *customer's eyes* — that's the whole scare.

---

## 3. STYLE RULES (so all your art matches)

1. **Chunky, consistent outlines.** Use `#2E2A26` (warm near-black), a **medium-thick line** at a consistent brush size. Undertale-ish: bold, readable, a little wobbly-organic is charming. Pick a line weight and keep it the same across every asset.
2. **Flat color + one shadow.** Fill with a flat base color, then add **one** darker shade for shadow (using the "deep" version of that hue from the palette). Don't over-render — flat + one shadow reads as clean *style*, and it's fast. This is the whole reason the no-animation limit doesn't hurt you.
3. **Big, simple, expressive faces.** Portraits are the whole game. Eyes and mouth do the acting. Make them large and clear. Personality > anatomical accuracy — these are cute cartoon dinos.
4. **Same face position across expressions.** Draw the neutral face, then for happy/hungry duplicate the layer and only change what moves (eyes, mouth, brows). Keeps swaps seamless.
5. **Limited palette per character.** Each dino = 2–3 colors + outline + shadow. Restraint looks professional.
6. **Readable at small sizes.** Your 512px portrait may display at ~300px. Squint at it — if the expression still reads, you're good.

---

## 4. THE EXPRESSION SYSTEM (your secret weapon)

Each speaking dino needs a small set of still faces. **You don't draw a new head each time — you swap features on the same head.**

**Herbivores** (Trisha, Steg, Bronte) need just **2**:
- **neutral** — calm, pleasant.
- **happy** — served correctly: eyes closed/curved up, big smile, maybe a little sparkle.

**Disguised carnivores** (Ray, Compy) need **3** — this is where the game lives:
- **neutral (sweet)** — the disguise. *Slightly* too-wide smile, a bit stiff. Should look *almost* innocent — the fun is that it's subtle.
- **hungry (mask slips)** — the tell. Narrowed eyes, a glint of teeth, a tiny touch of `#C0392B` in the eye. Drops for a moment when it thinks you're not looking.
- **caught** — you shooed it: shocked/annoyed/snarling, full red-eye, teeth bared. The payoff.

**How to make the "hungry tell" fair:** it should be *catchable but not obvious*. A player paying attention notices the eyes narrow and a fang appear; a distracted one misses it. Draw it as the same face with: eyes → half-lidded, add 1–2 visible teeth, brows → slight downward tilt, a speck of red. That's it. Subtlety is the craft here.

---

## 5. GIMP WORKFLOW (your art assembly line)

Set this up once, reuse forever:

1. **New file:** 512×512, **Fill with: Transparency.**
2. **Load the palette:** Windows → Dockable Dialogs → Palettes → (right-click) Import/New palette → add the hex codes from §2. Now you click swatches instead of hunting colors.
3. **Set up layers** (Layers panel), bottom to top:
   - `base_color` (flat fills)
   - `shadow` (the one darker shade, set layer mode to Multiply if you like)
   - `lineart` (your outlines, on top)
   - Keep the background transparent (no background layer).
4. **Draw:** sketch rough on a temp layer → clean `lineart` → flat `base_color` → `shadow`. Delete the sketch layer.
5. **Save the working file** as `.xcf` (GIMP's format — keeps layers) e.g. `trisha.xcf`.
6. **For each expression:** duplicate the lineart+color layers, tweak the face, toggle visibility to see just that expression.
7. **Export each expression:** File → **Export As** → `dino_trisha_neutral.png` (PNG, keep transparency). Repeat per expression.
8. **This `.xcf`-per-dino, PNG-per-expression** system means every dino is one editable file that spits out its face variants. That's your pipeline.

> Make ONE template `.xcf` (canvas + palette + named empty layers), then **File → Save a Copy** for each new dino. Never rebuild the setup.

---

## 6. THE ASSET TRACKER ✅ (tick these off)

### Priority order for a solo Day 1: do §A specs, then Trisha, then the café bg. Everything else is Day 2–3.

**A. Setup (do first, ~1 hr)**
- [ ] Decide + save palette in GIMP
- [ ] Build the template `.xcf` (512×512, palette, named layers)
- [ ] Pin 5–6 style references (Undertale portraits + CC0 dino art)

**B. Portraits — HERBIVORES (2 expressions each)**
- [ ] `dino_trisha_neutral` (Triceratops — tutorial, do FIRST)
- [ ] `dino_trisha_happy`
- [ ] `dino_steg_neutral` (Stegosaurus)
- [ ] `dino_steg_happy`
- [ ] `dino_bronte_neutral` (Brontosaurus)
- [ ] `dino_bronte_happy`

**C. Portraits — DISGUISED CARNIVORES (3 expressions each)**
- [ ] `dino_ray_neutral` (Velociraptor — sweet disguise)
- [ ] `dino_ray_hungry` (the tell)
- [ ] `dino_ray_caught`
- [ ] `dino_compy_neutral` (Compsognathus)
- [ ] `dino_compy_hungry`
- [ ] `dino_compy_caught`

**D. Food icons (128×128) — draw OR grab CC0**
- [ ] `food_fern`
- [ ] `food_leaf`
- [ ] `food_beetle`
- [ ] `food_bug`
- [ ] `food_berry`
- [ ] (optional) `food_mushroom`, `food_flower`

**E. Café & UI**
- [ ] `plate_empty` (~400×300)
- [ ] `bg_cafe` (1280×720 — your showcase piece)
- [ ] UI: text box frame
- [ ] UI: ingredient shelf/panel
- [ ] UI: buttons (Serve, Shoo, Next) — or restyle a CC0 UI kit
- [ ] UI: star-rating widget (5 stars, filled + empty)
- [ ] UI: day-title card / result card frame
- [ ] Title screen logo/art ("Lettuce Leaf You Be")

**F. Optional / juice (only if ahead)**
- [ ] Player character portrait (you, the owner) — neutral + scared
- [ ] Filler background customers (CC0)
- [ ] Particle bits (steam, sparkle) — often CC0

---

## 7. TODAY'S REALISTIC SOLO GOAL

Don't try to draw everything. **Today = specs + palette + template + Trisha (neutral & happy) + a rough café background.** If Trisha comes out looking good and *feeling* like the game, you've locked your style — and every asset after her gets faster because the hard decisions are done. That's a great, complete Day 1 for one person.

> Reminder: **no AI-generated art** (jam rule). Everything hand-drawn by you, or CC0 with credit. Keep a running list of any CC0 asset + its source for the credits page.

---

*Cozy creams, leafy greens, and one drop of red for the ones who lie about being vegan. 🥬👁️*
