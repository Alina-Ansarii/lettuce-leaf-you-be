# 👋 WELCOME TO THE TEAM — Lettuce Leaf You Be

> Hey! You're joining a Pakistan Game Jam project. This doc gets you from zero to "able to help" as fast as possible. Read the whole thing once, then keep it handy.

---

## 🎮 What the game is

**Lettuce Leaf You Be** — a cozy pixel-art game where you run a **strictly vegan café** for dinosaurs. Customers walk up and talk; you have to read the clues and decide: is this a genuine **herbivore** (serve them a plate of plants/bugs), or a **carnivore in disguise** pretending to be vegan (spot it and **shoo it away** before it causes trouble)? Cozy on the surface, quietly sinister underneath — goofy but with a creeping edge.

**Made in:** Godot 4.7 (GDScript). **Runs in:** web browser (it's a browser jam). **Art style:** gritty, muted pixel art (Papers Please vibe).

**Deadline:** Sunday Aug 16, 9:00 PM PKT.

---

## 🚀 Getting set up (do this first)

You need three things: Godot, Git, and the repo.

### 1. Install Godot 4.7
- Go to **godotengine.org** → download **Godot 4.7, the STANDARD version** (NOT the .NET/C# one — we use GDScript).
- It's a single .exe, no installer. Just run it.

### 2. Install Git (if you don't have it)
- **git-scm.com** → download → run installer → click Next through all defaults.
- (Optional but easier: **GitHub Desktop** from desktop.github.com if you prefer clicking over command line.)

### 3. Get the project
- First, ask the project owner (**Amer / GitHub: Alina-Ansarii**) to **add you as a collaborator** on the repo (they do: repo → Settings → Collaborators → add your GitHub username). Accept the email invite.
- Then open a terminal where you want the project and run:
  ```
  git clone https://github.com/Alina-Ansarii/lettuce-leaf-you-be.git
  ```
  (⚠️ the username has **two i's** — Alina-Ansari**i**.)
- Open Godot → **Import** → navigate into the cloned folder → pick **`project.godot`** → Import & Edit.

You're in! Press **F5** to run the game and see the current state.

---

## 🧭 How the project is organized

```
game-jam/
├── project.godot          ← Godot config (don't hand-edit)
├── scenes/                ← game screens (.tscn) + their scripts
│   ├── Main.tscn          ← THE main game screen
│   └── Main.gd            ← its logic
├── scripts/               ← shared code
│   ├── Customer.gd        ← the "customer" data type
│   └── GameManager.gd     ← the game brain (autoloaded as `Game`)
├── data/customers/        ← customer data files (.tres) — one per dino
├── art/
│   ├── bg/                ← café background
│   ├── portraits/         ← dino portraits (+ xcf/ = editable GIMP source)
│   ├── food/  ui/         ← food icons + UI art
├── audio/                 ← sounds (empty so far)
└── docs/                  ← ALL guides live here — READ THESE:
    ├── HANDOFF.md         ← current project state + what's next
    ├── TEAM_BIBLE.md      ← full design + Godot + Git guide (the big one)
    ├── ART_GUIDE.md       ← palette + art specs
    ├── PIXEL_ART_GUIDE.md ← pixel-art workflow
    └── ART_REFERENCE_PROMPTS.md ← visual reference prompts
```

**Golden rule:** `.png` files are used by the game; `.xcf` files (in `portraits/xcf/`) are the editable GIMP sources. Never point Godot at a `.xcf`.

**Start by reading `docs/HANDOFF.md`** — it has the exact current state and the to-do list.

---

## ✅ What's done so far (FULL detail)

### Infrastructure
- **Godot 4.7 project** set up, runs, and **exports to web (HTML5)** — this was tested end-to-end on Day 1 (a "hello" build was uploaded to itch and confirmed running in a browser). The scary "does it even export?" risk is already dead.
- **Live on itch.io:** alina-ansari.itch.io/lettuce-leaf-you-be (currently a draft).
- **GitHub repo** created and everything pushed: github.com/Alina-Ansarii/lettuce-leaf-you-be.
- **Pixel-crisp rendering** configured: `Default Texture Filter = Nearest` (so scaled-up pixel art stays sharp, not blurry).
- Web export uses **GL Compatibility** renderer automatically (set up for browser builds).

### The working game loop (this is DONE and TESTED)
A customer appears with a name + a line of dialogue. Two buttons: **Serve** and **Shoo**. You click one; the game checks whether your choice matches whether the customer is secretly a carnivore, shows **CORRECT** or **WRONG**, and updates **score** (+10 correct) and **lives** (−1 wrong). This full loop runs and works — it's the skeleton everything else builds on.

**The clever bit:** the whole judgment is one line — you're correct when `player_chose_shoo == customer.is_carnivore`. Shoo a carnivore = right. Serve a herbivore = right. Serve a carnivore or shoo a herbivore = wrong.

### The code (exact current contents)

**`scripts/Customer.gd`** — the customer data type (a Resource):
```gdscript
class_name Customer
extends Resource

@export var display_name: String = "Dino"
@export var is_carnivore: bool = false
@export_multiline var dialogue_line: String = "..."
```
Each customer is a `.tres` file made from this — editable in the Inspector, no code needed to add one. **To extend** (add wanted-ingredients, portrait textures, etc.), add `@export` lines here.

**`scripts/GameManager.gd`** — the brain, autoloaded globally as `Game`:
```gdscript
extends Node

var score:= 0
var lives:= 3

func judge(customer: Customer, player_chose_shoo: bool) -> bool:
	var correct := (player_chose_shoo == customer.is_carnivore)
	if correct:
		score += 10
	else:
		lives -= 1
	return correct
```
Reachable from any script as `Game.score`, `Game.judge(...)`, etc. **This is where the multi-customer / day-flow logic should be added** (a customer list + advance function).

**`scenes/Main.gd`** — the screen controller. On start it shows the current customer's name + dialogue and connects the Serve/Shoo buttons; on click it calls `Game.judge()` and shows CORRECT/WRONG. Currently it hard-loads one customer (`Trisha.tres`) via `preload`. **Needs:** replace the single hard-coded customer with a list from GameManager, and add portrait + plating logic.

**`data/customers/Trisha.tres`** — one real customer: name "Trisha", `is_carnivore = false`, a dialogue line. Making more dinos = right-click `data/customers/` → New Resource → Customer → fill in the Inspector.

### The scene — `Main.tscn` node tree (current)
```
Control                     ← root, has Main.gd, fills screen
├── Background (TextureRect)   ← cafe-blocked-out.png, full-rect
├── Portrait   (TextureRect)   ← trisha-neutral, scaled 2×, upper-center
├── NameLabel  (Label)         ← customer name    ⚠️ still stacked top-left
├── DialogueLabel (Label)      ← dialogue line    ⚠️ still stacked top-left
├── ServeButton (Button)       ← "Serve"          ⚠️ still stacked top-left
├── ShooButton  (Button)       ← "Shoo"           ⚠️ still stacked top-left
└── ResultLabel (Label)        ← CORRECT/WRONG     ⚠️ still stacked top-left
```
⚠️ The labels + buttons **work** (clickable) but are **piled in the top-left corner** at default positions. **First UI job = lay them out**: dialogue near the portrait, plate + ingredient buttons + Serve/Shoo on the counter (bottom third).

### The art done
- **Café background** (`art/bg/cafe-blocked-out.png`) — pixel blockout of the empty room: counter, wall, menu board, window, plants. The upper-center is deliberately **left clear** (that's where the portrait sits) and the counter is left clear (for buttons).
- **Trisha the Triceratops** — first dino, **two expressions** (`trisha-neutral-png.png`, `trisha-happy-png.png`), hand-drawn in GIMP, transparent PNGs. Same head position in both so they swap cleanly. Editable GIMP sources are in `art/portraits/xcf/`.
- A resized café reference mockup (`art/bg/reference-cafe-1280x720.png`) — for tracing/layout, NOT used in the game.

### Design decisions locked
- **Core concept:** vegan café; the *one rule* is "herbivores only" → the whole game is deduce genuine-herbivore vs disguised-carnivore, then serve or shoo. This single binary keeps scope tight.
- **Art style:** gritty/muted pixel art (Papers Please look), NOT cutesy — matches the goofy-but-sinister tone.
- **Structure:** day-by-day café shifts (each day = a few customers + a story beat; escalating). Always shippable — can stop at any number of days.
- **Cast planned (5 dinos):** 3 herbivores (Trisha ✅ done, Steg, Bronte) + 2 disguised carnivores (Ray the Velociraptor, and a second predator — Compy the Compsognathus was cut for being too raptor-like; being replaced by a **Pterodactyl** for a distinct silhouette).
- **Undertale-style dialogue** planned: typewriter text reveal + a "blip" sound per character.
- **Portrait expressions as clues:** carnivores' portraits flash to a "hungry" tell (a red-eye glint) — spotting it is part of the deduction.

## 🔜 What still needs doing

**Build in tiers — finish Tier 1 before Tier 2, etc. Always keep it shippable.**

**TIER 1 — make it a complete playable game:**
- Lay out the UI properly (dialogue box, plate, ingredient buttons, Serve/Shoo — currently stacked in a corner).
- Multiple customers + a day-by-day flow (currently just one customer). Add a customer list + advance logic in GameManager.
- Add 2–4 more customer `.tres` files (mix of herbivores + a disguised carnivore).
- Dialogue system (Undertale-style typewriter text + blip sound).
- Plating — **click-to-add first** (click ingredient buttons → food icon appears on the plate; Serve confirms). Drag-and-drop is a later upgrade, don't start with it.
- Title + win/lose screens.

**TIER 2 — depth & content:**
- Portrait expression swaps (happy on correct serve; hungry/caught for carnivores) — including the "hungry tell" flash as a clue.
- More dinos, a running mystery, a score/lives display.

**TIER 3 — juice & polish:**
- Sound (café ambience, text blips, serve/shoo/day-end stings).
- Screen shake, particles, tween pop-ins.
- The itch.io page (credits + "how we used the theme/limitation" blurb).

## 💡 Small mechanics we're considering (pick a few, don't do all)

Ranked by value-for-effort. A game with **3 mechanics done well beats 8 half-working** — pick 2–4 and nail them.

**Cheap + high payoff:**
- **Order matching** ⭐ — each herbivore wants a *specific dish* ("I'd like a fern salad"); you must plate the right ingredients. Makes plating actually matter. *(Compare plate contents to a `wanted_ingredients` list on the Customer.)*
- **Patience/suspicion timer** — a draining bar per customer; too slow → they leave annoyed / get suspicious. One Timer + ProgressBar. Adds tension.
- **Tips + a daily goal** — correct serves give coins; each day has a quota ("earn 50"). Adds progression. Pure variables + a label.
- **Streak/combo bonus** — consecutive correct calls build a multiplier. One counter.

**Medium effort, great flavor:**
- **"Look closer" inspect action** — a button to examine the customer for an extra clue before deciding. Very Papers Please; makes deduction active.
- **Different wrong-answer consequences** — serving a carnivore doesn't just fail; it eats another customer / you lose a life with a scare. Makes mistakes memorable.
- **Regulars** — repeat customers who tip more / warn you about a wolf.

**Cheap juice:**
- **Expression-tell reveal** — carnivore portrait briefly flashes "hungry" (red eye); you must catch it.
- **Limited shoos** — can only shoo so many times/day, so wrongly shooing a herbivore costs you.
- **End-of-day summary** — a little report card ("Served 6, shooed 2 wolves, earned 40 tips").

**Recommended priority:** order-matching → patience timer → tips+goal → expression-tell. Those four turn the skeleton into a real game without ballooning scope.

---

## 🙋 Where YOU can help

**If you're coding:** good self-contained tasks that won't collide with others — the **dialogue box** (`DialogueBox.tscn` + typewriter reveal), the **title/win/lose screens**, the **plating logic**, or the **end-of-day summary screen**. Tell Amer which one you're taking so two people don't edit the same file.

**If you're doing art:** we need more **dino portraits** (see `docs/ART_REFERENCE_PROMPTS.md` for the style + character list), **6 food icons** (fern, bamboo, cactus, beet, mushroom, flower), and **UI frames**. Match the existing **Trisha** for style — use her as a reference. Palette hex codes are in `docs/ART_GUIDE.md`. **No AI-generated art** (jam rule) — hand-drawn or CC0-with-credit only.

**If you're writing:** we need **customer dialogue** — each dino's lines + the clues that hint whether they're a secret carnivore. This is easy to parallelize; just add to a shared doc.

---

## 🔧 How to work without breaking things (IMPORTANT — read this)

We share code through Git. Follow this rhythm every time:

**Before you start working:**
```
git pull
```
(grabs everyone's latest changes — ALWAYS do this first)

**After finishing a chunk of work:**
```
git add .
git commit -m "feat: describe what you did"
git push
```
(commit types: `feat:` new feature, `fix:` bug fix, `art:` art, `docs:` docs, `chore:` housekeeping)

**The one rule that prevents disasters:** ⚠️ **Never edit the same scene (`.tscn`) file as someone else at the same time.** Scene files don't merge cleanly. Coordinate in chat: "I've got Main.tscn for the next hour." This is why the game is split into separate scenes — so we each work in different files.

**If Git yells at you** (merge conflict, "please commit before you merge", etc.): don't panic, don't force anything — ask Amer, or check the Git section in `docs/TEAM_BIBLE.md` which has fixes for the common errors.

---

## 🎨 Quick style reference (so your work matches)

**Palette (hex):** greens `#A7BD40` `#667436` `#C6C954`, warm wood/tan `#CFBD8C` `#FFEC8E`, outlines `#292E16`, pink accents `#D9828D`, deep red `#8B263E` / `#42010F` (⚠️ blood-red is MENACE ONLY — carnivore eyes), window-blue `#5C95E0`, off-white `#FFFDF7`.

**Art style:** gritty, muted, low-fi pixel art — Papers Please, not cutesy. Full detail in `docs/ART_GUIDE.md` + `docs/ART_REFERENCE_PROMPTS.md`.

**Rules to not lose points:** browser build must work, credit all team members + assets on the itch page, no AI-generated content, team max 3 people.

---

## 📞 Stuck?

- Read `docs/HANDOFF.md` (state) and `docs/TEAM_BIBLE.md` (the full guide — it explains Godot, GDScript, and Git for beginners).
- Ask Amer.
- Press **F5** to test, and read the **Output** panel at the bottom of Godot for error messages (they name the file + line).

Welcome aboard — let's make the weirdest café in the Cretaceous. 🥬🦖
