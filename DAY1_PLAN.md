# ✅ DAY 1 — SOLO GAME PLAN (Lettuce Leaf You Be)

> You're working solo today. Goal: lock the **foundations** on both sides so everything later is fast. NOT to finish the game. By tonight you want: a tiny working game loop (skeleton) + your art style locked + first assets drawn. That's a great Day 1 for one person.

**The mindset:** Technical side = get the *skeleton* breathing (one dino, judge it, see a result). Art side = *setup + your first real asset*. Depth comes later; today is about proving both pipelines work and can't ambush you.

---

## 🎯 THE SMART ORDER (so you're never stuck)

Alternate between code and art so you don't burn out on either, and so slow bits (art drawing) overlap with thinking bits (code):

1. **Technical setup** (folders, Customer resource, GameManager) — ~1 hr
2. **Art setup** (GIMP palette + template) — ~45 min
3. **Technical: the minimal loop** (one dino, Serve/Shoo, result) — ~1.5 hr
4. **Art: café counter layout + Trisha portrait** — the rest of the day
5. **Commit to git** at the end (and ideally mid-day too)

---

# 🛠️ TECHNICAL TASKS

> Reference the TEAM_BIBLE Part 2 for the detailed how-to on each. This is the checklist + what "done" looks like.

### T1 — Project folders (5 min)
- [ ] In Godot FileSystem, create: `scenes/`, `scripts/`, `data/customers/`, `art/portraits/`, `art/food/`, `art/ui/`, `art/bg/`, `audio/`
- **Done when:** the folder structure from the bible exists.

### T2 — The Customer resource (20 min) ← unlocks everything
- [ ] Create `scripts/Customer.gd` inheriting `Resource` (code in bible §2.5)
- [ ] It has: `display_name`, `is_carnivore`, portrait slots, `dialogue_lines`
- **Done when:** you can right-click `data/customers/` → New Resource → and "Customer" shows up as a type you can create.

### T3 — Make ONE test customer (10 min)
- [ ] Create `data/customers/Trisha.tres`, fill in name = "Trisha", is_carnivore = false, type one dialogue line ("The usual please, dear.")
- [ ] Portraits can be empty for now (we test with text first)
- **Done when:** clicking Trisha.tres shows your filled-in data in the Inspector.

### T4 — The GameManager brain (20 min)
- [ ] Create `scripts/GameManager.gd` inheriting `Node` (code in bible §2.7)
- [ ] Register it as an Autoload named `Game` (Project Settings → Globals/Autoload)
- **Done when:** it's in the autoload list; no errors on running.

### T5 — The MINIMAL LOOP (the big one, ~1.5 hr) ← today's real technical win
Build the smallest thing that proves the game works. In your `Main.tscn` (or a test scene):
- [ ] Show a `Label` with the customer's name + one dialogue line
- [ ] Add two `Button`s: **Serve** and **Shoo**
- [ ] Wire them: clicking either calls `Game.judge(chose_shoo)` and shows "Correct!" or "Wrong!" in a label
- [ ] Load Trisha's data into it so it's real
- **Done when:** you run the game, see Trisha's line, click Serve → "Correct!" (she's a herbivore), click Shoo → "Wrong!". **That's the entire game in miniature.** Everything else is adding polish and content on top.

### T6 — Commit to git (5 min)
- [ ] `git add .` → `git commit -m "feat: minimal serve/shoo loop working"` → `git push`
- **Done when:** it's on GitHub.

> **If you only finish T1–T5 today, that is a COMPLETE technical Day 1.** You'll have proven the core loop runs. Don't touch plating, multiple days, or juice yet.

---

# 🎨 ART TASKS

> Reference ART_GUIDE.md for palette hex codes, specs, and the expression system.

### A1 — GIMP palette (15 min)
- [ ] Load all your final hex codes (greens, warm base, pinks, reds, blue, neutrals) as a GIMP palette
- **Done when:** you can click swatches instead of typing hex codes.

### A2 — Template .xcf (20 min)
- [ ] New file 512×512, transparent, palette loaded, layers named (`base_color`, `shadow`, `lineart`)
- [ ] Save as `portrait_template.xcf`. Use "Save a Copy" for each dino.
- **Done when:** you have a reusable portrait template file.

### A3 — Café counter layout (1.5–2 hr) ← do this before characters
- [ ] Rough out the 1280×720 café counter view (Papers Please framing): counter in foreground, space for the customer portrait in the middle, plants + green vegan sign + blue window in back
- [ ] It can be ROUGH today — blocking in shapes + colors to establish layout and where the UI zones go
- **Done when:** you have a layout that tells you where the portrait, plate, ingredients, and text box will live. This drives all your UI decisions.

### A4 — Human character / café owner (1 hr)
- [ ] Draw your player character bust: neutral expression (+ scared if time)
- [ ] Green apron, cream shirt, the little vegan pin — from your palette
- **Done when:** you have a `human_neutral.png` you like.

### A5 — Trisha portrait set (1 hr)
- [ ] Using the template: draw Trisha the Triceratops — neutral + happy
- [ ] Export `dino_trisha_neutral.png` and `dino_trisha_happy.png` (512×512, transparent)
- **Done when:** two portraits exported, same head position, only the face changes between them. **This locks your character style.**

### A6 — Start menu (save for LAST, 45 min if time)
- [ ] Rough title screen: "Lettuce Leaf You Be" logo, warm floral vibe, Start/Quit
- **Done when:** a rough title mockup exists. (Easiest task — do it only if you have energy left; better designed once your style is locked anyway.)

---

## 🌙 END-OF-DAY-1 "DONE" LOOKS LIKE:

**Technical:** ✅ minimal Serve/Shoo loop runs (one dino, judge, right/wrong result), committed to git.
**Art:** ✅ palette + template set up, café counter layout roughed, human character drawn, Trisha's two portraits done.

If you hit that, you've built the skeleton AND locked your art style solo in one day — genuinely excellent. Everything from here is adding content (more dinos, more days) and polish (plating, juice, sound) onto proven foundations.

## ⚠️ Don't do today (resist the urge):
- Plating drag-and-drop (Tier 2 — click-to-add comes first, and not even today)
- Multiple days / full campaign
- Sound, particles, screen shake
- Drawing all 5 dinos (just Trisha today — prove the style first)

## 🔀 Solo scope reality check:
If it stays just you through the jam, plan for a **smaller** final game — maybe 3–4 dinos and 2 days — and that's totally fine. The Tier system means you always have something shippable. Better a tight, finished 3-dino game than an ambitious broken one.

---

*Today = foundations. One dino you can judge, one style you can repeat. That's the whole battle won. 🥬*
