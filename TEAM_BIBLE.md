# 🥬🦖 LETTUCE LEAF YOU BE — THE TEAM BIBLE
### *The complete design + technical guide for our Pakistan Game Jam entry*

> **This is the one document the whole team works from.** Part 1 is the game design (what we're making and why). Part 2 is the technical guide (how to actually build it in Godot, written for total beginners). Part 3 is the GitHub workflow (how the three of us share code without breaking each other's work). Read Part 1 fully. Keep Parts 2 & 3 open while you work.

**Jam:** Pakistan Game Jam 2026 · **Engine:** Godot 4.7.1 (standard/GDScript build) · **Deadline:** Sun Aug 16, 9:00 PM PKT
**Theme:** Dinosaurs · **Optional prompt:** Everyday · **Limitation:** No animations · **Must run in browser**
**Live build:** alina-ansari.itch.io/lettuce-leaf-you-be · **Repo:** github.com/Alina-Ansarii/lettuce-leaf-you-be

---

# 📖 PART 1 — THE GAME

## The pitch

You run **Lettuce Leaf You Be**, a strictly-vegan roadside café in a world full of dinosaurs. Herbivores line up for a nice plate of plants and bugs. But some customers aren't what they claim: **carnivores in disguise**, sweet-talking their way in, pretending to be vegan — while secretly sizing you (and your other customers) up as lunch.

Every customer walks up, says something, and — because dinosaurs are rude and never state their order outright — **you have to judge them.** Read their face and their words:
- **Genuine herbivore?** → Build them a plate (plants / bugs / beetles), serve it, they rate it and leave happy.
- **Carnivore in disguise?** → Spot the tells and **shoo them away** before they cause trouble.

Cozy on the surface, quietly sinister underneath. Goofy first — a T-Rex loudly insisting he's "just here for the ambiance" — but with a real creeping edge.

## Why this design wins votes

| Voting category | How we hit it |
|---|---|
| **Theme (dinosaurs)** | The entire cast is dinosaurs. |
| **Theme (everyday prompt)** | Running a café is the everyday grind. |
| **Limitation (no animation)** | Static Undertale-style portraits are a *style*, not a handicap. |
| **Creativity** | Deduction + hidden-identity ("is this vegan legit?") is a fresh spin. |
| **Fun** | Reading the wolves is a real, tense little puzzle. |
| **Presentation** | Hand-drawn portraits + good writing + juice (sound, shake, particles). |

## The core loop (what happens each customer)

1. **Day starts** — title card: "Day 1 — Lettuce Leaf You Be."
2. A **dinosaur walks up** — its portrait appears, name shown.
3. It **talks** — drops clues in its words + its portrait expression. It never states an order.
4. **You judge:** genuine herbivore, or disguised carnivore?
   - **Herbivore →** open the plate, add ingredients (plants/bugs/beetles), hit **Serve**. It rates the plate (cosmetic for now), leaves happy.
   - **Carnivore →** hit **Shoo!** If you're right, crisis averted. If you're wrong (you shoo a real herbivore, or serve a real carnivore), bad outcome.
5. **Next customer.** After all customers, the **day ends** → results → next day.

**One rule runs the whole game:** the café is vegan. Serve the herbivores, expose the wolves.

## The art direction (this is what makes it feasible)

We copy **Undertale's visual language**: static character **portraits** beside a **text box**. Nothing animates — ever. Each speaking dino has a small set of **still expressions** (neutral, happy, "hungry" = the mask slipping). Swapping between two still images is *not* animation, it's just showing a different picture — 100% legal under the limitation, and it's the charm.

**The expression is a gameplay clue.** The "vegan" raptor's neutral portrait has a too-wide smile; when it thinks you're distracted, its portrait swaps to *hungry* (narrowed eyes, a glint of teeth). Sharp players catch the tell.

**Art division:**
- **Player 3** draws the **hero art** in GIMP: the café background, the UI frames, food icons, and the **named story dinos** with their expression sets.
- **CC0 free assets** fill the long tail (filler customers, extra icons, particles, fonts). Credit everything.
- Rule of thumb: if a dino has dialogue and clues, Player 3 draws it. If it's set dressing, use a free asset.

> ⚠️ **No AI-generated art or audio** — jam rule. All hand-drawn or CC0-with-credit.

## Starting cast (5 dinos: 3 herbivores + 2 disguised carnivores)

| Dino | True nature | Portrait expressions | Clue idea |
|---|---|---|---|
| **Trisha** the Triceratops | Herbivore (tutorial regular) | neutral, happy | Warm, orders "the usual," clearly harmless. |
| **Steg** the Stegosaurus | Herbivore | neutral, happy | Slow, sweet, obsessed with ferns. |
| **Bronte** the Brontosaurus | Herbivore | neutral, happy | Big, gentle, enormous appetite for greens. |
| **Ray** the Velociraptor | **Carnivore in disguise** | neutral (sweet), hungry (mask slips), caught | "I'm SO not a meat person!" … eyes your arm. |
| **Compy** the Compsognathus | **Carnivore in disguise** | neutral, hungry, caught | Tiny, twitchy, suspiciously interested in the other customers. |

## Structure & scope — day-by-day shifts

The game is a series of **days**. Each day = a few customers + a story beat. Difficulty escalates: Day 1 friendly regulars (tutorial), mid-game the first disguised predator, finale a big-bad. **This is the safest possible structure** because every day is content on top of *one* loop you build once — you can stop at any number of days and still have a complete game.

**Build in this order. Finish each tier before starting the next.**

- **TIER 1 (shippable):** one café screen, dialogue box, 5 dinos, click-to-add plating, Serve/Shoo judging, 3 days with a beginning/twist/end, title + win/lose screens, **exported to browser.** ← target: end of Day 2.
- **TIER 2 (medium-scale feel):** more dinos + days, expression-swap tells, a running mystery, a score/lives meter.
- **TIER 3 (juice):** sound, screen shake, particles, tween pop-ins, the itch.io page.

---

# 🛠️ PART 2 — THE TECHNICAL GUIDE (for beginners)

> This part assumes you've never really used Godot or written GDScript. It goes slow. If you already know a bit, skim to the section you need.

## 2.0 — What Godot even is (the mental model)

Godot is a **game engine**: a program for building games. Three ideas explain 90% of it:

1. **Everything is a Node.** A node is a single building block that does one thing: a `Label` shows text, a `Button` is clickable, a `TextureRect` shows an image, a `Sprite2D` shows a 2D picture, an `AudioStreamPlayer` plays sound. You build a game by combining nodes.

2. **Nodes form a tree, and a tree is a Scene.** You nest nodes inside each other (a `Control` with a `Label` and two `Button`s inside it). Save that tree as a **Scene** (a `.tscn` file). A scene is a reusable chunk — a customer, a menu, the whole café. Scenes can contain other scenes.

3. **Scripts give nodes behavior.** You attach a **script** (a `.gd` file, written in GDScript) to a node to make it *do* things — respond to clicks, change text, keep score. The node is the body; the script is the brain.

That's it. Our whole game is: scenes made of nodes, with scripts telling them what to do.

## 2.1 — GDScript in 5 minutes (the only syntax you need)

GDScript looks like Python. Here's essentially everything we'll use:

```gdscript
extends Control              # this script controls a Control node

# ---- VARIABLES (store data) ----
var score := 0               # a number. ':=' means "figure out the type for me"
var cafe_name := "Lettuce Leaf You Be"   # text (a String)
var is_open := true          # true/false (a bool)
var foods := ["fern", "beetle", "leaf"]  # a list (an Array)

# ---- FUNCTIONS (do things) ----
func serve_customer(name: String) -> void:   # 'func' defines an action
    print("Serving ", name)                  # print shows text in the Output panel
    score += 10                              # add 10 to score

# ---- SPECIAL FUNCTIONS Godot calls automatically ----
func _ready() -> void:       # runs ONCE when this node enters the game
    print("Café is open!")

func _process(delta) -> void:  # runs EVERY frame (~60x/sec). We rarely need this.
    pass                       # 'pass' means "do nothing"

# ---- IF / ELSE (make decisions) ----
func check(is_carnivore: bool) -> void:
    if is_carnivore:
        print("Shoo it away!")
    else:
        print("Serve it a plate.")

# ---- LOOPS (repeat) ----
func list_all() -> void:
    for food in foods:       # do this once per item in the list
        print(food)
```

**Rules that trip up beginners:**
- **Indentation matters** (use Tab). Code inside a function/if/loop must be indented. Wrong indentation = errors.
- **No semicolons, no curly braces `{}`.** Blocks are defined by indentation, like Python.
- `#` starts a comment (a note to humans; Godot ignores it).
- Names are case-sensitive: `Score` and `score` are different.

That's genuinely most of it. You'll pick up the rest by doing.

## 2.2 — Touring the editor (where things are)

- **Top-center tabs:** `2D`, `3D`, `Script`, `AssetLib`. We live in **2D** (building screens) and **Script** (writing code).
- **Left — Scene panel:** the node tree of the scene you're editing. The **+** button (top-left of it) adds a child node.
- **Left — FileSystem panel (below Scene):** all your project's files, rooted at `res://` (that's the project folder).
- **Center — Viewport:** the canvas where you see/arrange your 2D screen.
- **Right — Inspector:** every property of the currently-selected node (text, color, position, and — for our custom Customer — its data). **Player 3 will use the Inspector constantly** to fill in dino data.
- **Bottom — Output/Debugger:** where `print()` messages and error messages show up. When something breaks, **read the Output panel** — the error usually tells you the file and line number.
- **Top-right — Play ▶ (F5)** runs the game. **F6** runs just the current scene.

## 2.3 — The project & file structure (agree on this, don't fight it)

This structure is what lets 3 people work without colliding. Create these folders in the FileSystem panel (right-click `res://` → New Folder):

```
res://
  scenes/          ← all .tscn scene files
    Main.tscn          (top-level game flow)   [Player 1 owns]
    Cafe.tscn          (the café screen)        [Player 1 / 2]
    DialogueBox.tscn   (portrait + text + next) [Player 2]
    PlatingArea.tscn   (plate + ingredient shelf)[Player 1]
    TitleScreen.tscn   [Player 2]
    ResultScreen.tscn  [Player 2]
  scripts/         ← all .gd script files
    GameManager.gd     (the "brain" autoload)
    Customer.gd        (the customer data definition)
  data/
    customers/       ← Trisha.tres, Ray.tres … [Player 3 fills these]
  art/
    portraits/  food/  ui/  bg/    [Player 3]
  audio/           [Player 2]
```

**The golden rule for 3 people:** *never have two people editing the same `.tscn` or `.gd` file at the same time.* Scene files don't merge cleanly. Because the game is split into separate scenes, each person works in different files. Coordinate in chat: "I'm editing Cafe.tscn for the next hour."

## 2.4 — Building a scene, step by step (concrete walkthrough)

Let's build the **DialogueBox** scene as a worked example. This is the pattern for every scene.

1. **Scene → New Scene.**
2. Under "Create Root Node," click **User Interface** (makes a `Control` root — right for UI).
3. Rename the root: double-click `Control` in the Scene panel → type `DialogueBox`.
4. **Add the portrait:** select `DialogueBox`, click **+**, search **TextureRect**, Create. Rename it `Portrait`. (A TextureRect shows an image.)
5. **Add the text:** select `DialogueBox` again, **+**, search **Label** (or **RichTextLabel** for fancier text), Create. Rename it `DialogueText`.
6. **Add a button:** select `DialogueBox`, **+**, search **Button**, Create. Rename it `NextButton`. In the Inspector, set its **Text** to "Next".
7. **Position them** in the viewport by dragging, or set anchors (Godot's layout system — for now, dragging is fine).
8. **Save (Ctrl+S)** as `res://scenes/DialogueBox.tscn`.

You now have a reusable dialogue box. To give it behavior, attach a script (next section).

## 2.5 — Attaching a script & the Customer data resource

### The Customer resource (build this FIRST — it unlocks all content)

A **Resource** is a custom data container you can save as a file and edit in the Inspector. We make one for customers so that **adding a new dino = making a file + drawing a face, with zero new code.**

1. In FileSystem, right-click `res://scripts/` → **New Script**.
2. Name it `Customer.gd`. For "Inherits," type **Resource**. Create.
3. Replace its contents with:

```gdscript
class_name Customer
extends Resource

# @export makes a variable editable in the Inspector as a fill-in field.
@export var display_name: String = "Dino"
@export var is_carnivore: bool = false          # THE key flag: true = disguised wolf

@export_group("Portraits")
@export var portrait_neutral: Texture2D
@export var portrait_happy: Texture2D
@export var portrait_hungry: Texture2D          # the "mask slips" tell

@export_group("Dialogue")
@export_multiline var dialogue_lines: Array[String] = []   # what it says, line by line
```

- `class_name Customer` registers "Customer" as a type Godot knows everywhere.
- Each `@export` becomes a labeled box in the Inspector.

### Making a customer data file (Player 3's job, no coding)

1. In FileSystem, right-click `res://data/customers/` → **New Resource**.
2. In the search box, type **Customer**, pick it, Create. Save as `Trisha.tres`.
3. Click `Trisha.tres` — the **Inspector** now shows all the fields: Display Name, Is Carnivore, the three portrait slots, Dialogue Lines.
4. Fill them in: type the name, leave "Is Carnivore" unchecked (Trisha's a real herbivore), **drag portrait images from FileSystem into the portrait slots**, and type her dialogue lines.
5. Repeat for each dino. For Ray, **check "Is Carnivore"** and fill the `portrait_hungry` slot.

**This is the magic:** once the Customer resource exists, growing the game to 10, 20, 30 dinos is just making more `.tres` files. That's how "medium-scale" stays safe.

## 2.6 — The dialogue box script (hand-rolled, ~beginner-friendly)

We decided to hand-roll dialogue (simpler than learning a plugin for our needs). Attach this to the `DialogueBox` scene root (select root → in Scene panel, click the "Attach Script" icon, or right-click → Attach Script):

```gdscript
extends Control

# @onready grabs a child node when the scene loads. The $ path points to it.
@onready var portrait: TextureRect = $Portrait
@onready var dialogue_text: Label = $DialogueText
@onready var next_button: Button = $NextButton

var lines: Array[String] = []
var current_line := 0

# A signal is how this node announces "I'm done" without knowing who's listening.
signal dialogue_finished

func _ready() -> void:
    # Connect the button's 'pressed' signal to our advance() function.
    next_button.pressed.connect(advance)

func start(customer: Customer) -> void:
    portrait.texture = customer.portrait_neutral
    lines = customer.dialogue_lines
    current_line = 0
    _show_line()

func _show_line() -> void:
    dialogue_text.text = lines[current_line]

func advance() -> void:
    current_line += 1
    if current_line >= lines.size():
        dialogue_finished.emit()      # tell the café we're done talking
    else:
        _show_line()
```

**The one concept to really understand here is `signal`.** The dialogue box doesn't know anything about the café. When it finishes, it just *shouts* `dialogue_finished`. The café *listens* for that shout and reacts (shows the Serve/Shoo buttons). This keeps scenes independent — which is exactly what lets 3 people work in separate files without tangling.

## 2.7 — The GameManager (the brain / autoload)

An **autoload** is a script Godot loads once and keeps alive for the whole game, reachable from anywhere by name. Perfect for "what day is it, who's the current customer, what's the score."

1. Create `res://scripts/GameManager.gd`, inheriting **Node**:

```gdscript
extends Node

var day := 1
var lives := 3
var score := 0

var day_customers: Array[Customer] = []   # the customers for the current day
var current_index := 0

func start_day(customers: Array[Customer]) -> void:
    day_customers = customers
    current_index = 0

func get_current_customer() -> Customer:
    return day_customers[current_index]

func next_customer() -> bool:
    current_index += 1
    return current_index < day_customers.size()   # false = day is over

# Returns true if the player judged correctly.
func judge(player_chose_shoo: bool) -> bool:
    var c := get_current_customer()
    var correct := (player_chose_shoo == c.is_carnivore)
    if correct:
        score += 10
    else:
        lives -= 1
    return correct
```

2. **Register it as an autoload:** Project → Project Settings → **Globals/Autoload** tab → click the folder icon → pick `GameManager.gd` → set Node Name to `Game` → Add.
3. Now **any script** can call `Game.next_customer()` or read `Game.score`. That's how the title screen, café, and result screen all share one brain.

## 2.8 — The plating mechanic (start simple)

**Tier 1 version (click-to-add — build this first):**
- In your `PlatingArea` scene, make a row of ingredient `Button`s (Plant, Bug, Beetle…) and an empty `Plate` area (a `Control` or `TextureRect`).
- When an ingredient button is pressed, spawn its icon onto the plate. Rough idea:

```gdscript
extends Control

@onready var plate := $Plate
var plate_contents: Array[String] = []

func add_ingredient(ingredient_name: String, icon: Texture2D) -> void:
    plate_contents.append(ingredient_name)
    var sprite := TextureRect.new()          # make a new image node
    sprite.texture = icon
    plate.add_child(sprite)                   # put it on the plate
    # (position it randomly or in a grid slot)

func clear_plate() -> void:
    plate_contents.clear()
    for child in plate.get_children():
        child.queue_free()                    # remove the icons
```

- A **Serve** button confirms the plate. For Tier 1, *any* herbivore plate is accepted; the rating is cosmetic.

**Tier 2 upgrade (drag-and-drop):** Godot has built-in drag-and-drop via `_get_drag_data()`, `_can_drop_data()`, `_drop_data()`. Only do this once the click version works end-to-end. Never let plating polish block the core loop.

## 2.9 — Motion without animation (our juice toolkit — all legal)

The limitation bans *animation*, not *movement*. These are all transform math and 100% allowed:

- **Tweens** — smoothly change a value over time. Slide a portrait in, fade text, pop a plate:
  ```gdscript
  var t := create_tween()
  t.tween_property(portrait, "position", Vector2(100, 200), 0.3)  # slide over 0.3s
  ```
- **Squash/stretch via scale** — on a good serve, briefly scale the plate to (1.2, 0.8) and back. Feels great, zero frames.
- **Screen shake** — nudge the camera randomly for a few frames on a scary moment.
- **Particles** — `GPUParticles2D` for steam off food, sparkles on a perfect serve.
- **Colour flash, sound stings, UI pop.** Cheap, huge presentation payoff.

## 2.10 — Running, testing, and the web export

- **Test constantly:** press **F5** to run the whole game, **F6** to run just the open scene. Read the **Output** panel for `print()`s and errors.
- **Web export (already working — keep using it):**
  1. Project → Export → the **Web** preset is already set up.
  2. Export Path is `build/index.html`. Click **Export Project**.
  3. In File Explorer, go **inside** the `build` folder, select all files (Ctrl+A), right-click → **Compress to ZIP** (Windows built-in). `index.html` must be at the top level of the zip.
  4. On itch.io: edit the game → upload the new zip → keep "This file will be played in the browser" checked → Save.
- **Re-export & re-test in the browser often** (every major milestone), not just at the end. Browser builds sometimes behave differently from the editor (audio, file paths) — catch it early.

## 2.11 — When something breaks (beginner debugging)

- **Read the Output/Debugger panel.** Godot errors usually name the **file and line**. Go there first.
- **"Nonexistent function / null instance"** usually = a `$NodePath` doesn't match the actual node name in the Scene panel. Check spelling/case.
- **`print()` everything.** Not sure if a function runs? `print("got here")`. Not sure a value? `print("score is ", score)`.
- **One change at a time.** Make a change, run, verify. Don't stack five changes then wonder which broke it.
- **Stuck >15 min?** Ask a teammate or paste the exact error somewhere for help. Don't grind alone.

---

# 🌿 PART 3 — GITHUB (how the 3 of us share code)

> Git is how three people work on the same project without emailing zip files around. It tracks every change and merges everyone's work. It feels weird for a day, then it's second nature. Follow the recipes below exactly.

## 3.0 — The mental model

- **The repo on GitHub** (github.com/Alina-Ansarii/lettuce-leaf-you-be) is the **single source of truth** — the "official" copy in the cloud.
- **Each person has a clone** (a full copy) on their own computer.
- You **pull** to download everyone's latest changes, and **push** to upload yours. The cycle is: pull → work → commit → push.

## 3.1 — One-time setup

**Everyone needs git installed.** Player 1 already has it (v2.35). Players 2 & 3: download from **git-scm.com**, run the installer, click Next through all defaults.

**First-time identity (each person, once):** open a terminal and run (with your own name/email):
```
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

**Player 1 (repo owner): add teammates.** On the repo page → **Settings → Collaborators → Add people** → enter Player 2's and Player 3's GitHub usernames. They accept the email invite.

## 3.2 — Players 2 & 3: clone the repo (get your copy)

1. Open a terminal in the folder where you want the project (e.g. Desktop). Tip: open the folder in File Explorer, click the address bar, type `cmd`, Enter.
2. Run:
```
git clone https://github.com/Alina-Ansarii/lettuce-leaf-you-be.git
```
3. This creates a `lettuce-leaf-you-be` folder with everything in it.
4. Open Godot → Project Manager → **Import** → navigate into that folder → pick `project.godot` → Import & Edit.

You now have the project and are connected to the shared repo.

## 3.3 — The daily rhythm (memorize this)

**⭐ Before you start working each session — PULL:**
```
git pull
```
This grabs everyone's latest changes. **Always pull before you start.** Skipping this is the #1 cause of conflicts.

**⭐ After finishing a chunk of work — ADD, COMMIT, PUSH:**
```
git add .
git commit -m "Add Trisha's portrait and dialogue"
git push
```
- `git add .` — stages all your changes.
- `git commit -m "..."` — saves a labeled snapshot locally (see commit style below).
- `git push` — uploads it to GitHub so teammates can pull it.

That's the whole loop: **pull → work → add → commit → push.** Do it several times a day, in small chunks. Small frequent commits are much safer than one giant commit at midnight.

## 3.4 — Commit message style (conventional commits)

Good commit messages make history readable. Use this simple convention — a **type**, then a short description in the imperative ("add", not "added"):

```
feat: add plating click-to-add mechanic
fix: correct portrait not showing for Ray
art: add Trisha neutral + happy portraits
docs: update README with build steps
chore: ignore build folder in git
refactor: move judging logic into GameManager
```

**Types you'll use:**
- `feat:` — a new feature ("feat: add Shoo button")
- `fix:` — a bug fix ("fix: day doesn't advance after last customer")
- `art:` — art assets ("art: add café background")
- `docs:` — documentation
- `chore:` — housekeeping (gitignore, file moves)
- `refactor:` — restructuring code without changing behavior

Keep the description under ~50 characters, present tense, describing *what the commit does*. Example full command:
```
git commit -m "feat: add carnivore detection with hungry portrait tell"
```

## 3.5 — The rules that prevent 90% of git pain

1. **PULL before you start. PUSH when you pause.** Always.
2. **Never let two people edit the same file at once.** Especially `.tscn` scene files — they don't merge cleanly. Coordinate in chat: "I've got Cafe.tscn." This is *why* we split the game into separate scenes.
3. **Commit small and often.** A commit per feature/asset, not one per day.
4. **Communicate.** A 10-second "pushing changes to GameManager, pull in a sec" message saves hours.

## 3.6 — When git complains (common fixes)

- **"Please commit your changes or stash them before you merge" (on pull):** you have uncommitted work. Commit it first (`git add .` → `git commit -m "..."`), then `git pull` again.
- **"Merge conflict":** two people changed the same lines. Git marks the spots in the file with `<<<<<<<`, `=======`, `>>>>>>>`. Open the file, decide which version to keep, delete the marker lines, save, then `git add .` → `git commit` → `git push`. **If it's a `.tscn` scene file and the conflict looks scary, don't guess** — ask the teammate who made the other change and resolve it together. (Avoid this entirely by rule #2.)
- **"Repository not found":** wrong URL — double-check the username spelling (ours is `Alina-Ansarii`, two i's).
- **"rejected — non-fast-forward" (on push):** someone pushed before you. Run `git pull` first, resolve anything, then `git push`.

## 3.7 — Optional cleanup: ignore the build folder

Right now the `build/` export files are committed to the repo (harmless, just bulky). To keep exports out of git going forward, open `.gitignore` in the project, add a line:
```
build/
```
Then:
```
git rm -r --cached build
git add .
git commit -m "chore: stop tracking build folder"
git push
```
Optional — skip it if you're busy. It doesn't affect the game.

---

# ✅ PART 4 — CHECKLISTS & TIMELINE

## Submission checklist (don't lose easy points)

- [ ] Game **runs in the browser** (tested on the actual itch page, not just the editor).
- [ ] **All 3 team members credited** on the itch page (Player 1, 2, 3 by name).
- [ ] **Every asset credited** with source + license (CC0 packs, fonts, SFX).
- [ ] **No AI-generated content** anywhere (art, audio).
- [ ] Game **published after** the jam start (Aug 13) — ✅.
- [ ] **One submission** per team.
- [ ] A short **"how we used the theme + limitation"** blurb on the page (voters read it — free Theme points).
- [ ] **Submit early** (Sat night / Sun morning) with a working build, then keep polishing.
- [ ] **⚠️ Confirm the team is exactly 3 people** (jam max). Sort this before anything else.

## The 3-day timeline

**Day 1 — Thursday (today) — Foundations ✅ mostly DONE:**
- [x] Godot installed, project created, "hello dinos" runs.
- [x] Web export working, live on itch.
- [x] GitHub repo created and pushed.
- [ ] Add Players 2 & 3 as collaborators; they clone + import.
- [ ] Player 1: build the `Customer.gd` resource + `GameManager` autoload + the day/customer state skeleton (grey boxes fine).
- [ ] Player 3: palette + portrait size decided; draw Trisha (neutral + happy); rough café background.
- [ ] Player 2: build the `DialogueBox` scene + script; get one portrait + text + Next button working.

**Day 2 — Friday — The full loop (TIER 1):**
- [ ] Player 1: wire judging (Serve/Shoo → compare `is_carnivore`), click-to-add plating, chain 3 days of customer data.
- [ ] Player 2: real UI layout, win/lose + title screens, re-export & re-test in browser.
- [ ] Player 3: draw Steg + Bronte + food icons + plate; write all 5 customers' dialogue.
- [ ] **Goal: a complete, playable, ugly-but-shippable game by end of day.**

**Day 3 — Saturday — Content, wolves, juice (TIER 2 + 3):**
- [ ] Player 3: draw Ray + Compy (neutral/hungry/caught); subtle "hungry" tells.
- [ ] Player 1: expression-swap clue system + shoo-away outcomes; add customers if ahead.
- [ ] Player 2: sound, screen shake, particles, tween pop-ins; build the itch page (credits + blurb).
- [ ] All: writing sprint. **Submit Saturday night** with a full build, then keep polishing.

**Sunday (until 9 PM) — Buffer & submit:**
- [ ] Fix playtest issues, add extra days if wanted, re-submit improved build.
- [ ] Final browser test in incognito. **Nothing risky after ~7 PM.**

## The daily git commands, one more time (tape this to your monitor)

```
# starting work:
git pull

# saving work (repeat often):
git add .
git commit -m "feat: describe what you did"
git push
```

---

*One rule: the café is vegan. Everything else is just spotting who's lying about it. 🥬🔪🦖*


