# Johann van Staal

Music composed and performed as code, using [Sonic Pi](https://sonic-pi.net).
These tracks explore what happens when the old world's dead languages meet
the dancefloor — **Crypt House**: Latin voices, bells, crows, rain and
sirens over trance, house and witch-house grooves.

Each track is a single, self-contained `.rb` file. It plays the entire
arrangement from the first spoken word to the final unresolved note and
stops by itself.

This repository contains **Fragor Noctis** — one track about how
democracies die.

## Track

- **`Fragor_Noctis.rb` — "Fragor Noctis"** ("the crash of the night") —
  Crypt House, 126 BPM, D minor, ~4:30. The piece begins before its own
  first bar: over a bare drone, a slowed voice speaks a Genesis for the
  republic — *In principio erat res publica, erat libertas* — and its
  fall in one sentence: the freer we became, the more suspicious, the
  more envious, each of us nearest to himself. Then the track tells the
  same story in music. A human melody is revealed phrase by phrase,
  understood, and stated in full while Cicero defines what is at stake:
  *Est igitur res publica res populi* — the definition and the melody
  are the same thing, and both will be destroyed. Unease creeps in as
  an A flat — the tritone against the D, the old *diabolus in musica* —
  shadows the harmony. A storm gathers, glass breaks, and Cicero's cry
  *O tempora, o mores* returns damaged, as if the recording itself had
  been hit. Over the last shard falls his coldest sentence, Plato's law
  in Latin: *Ex hac maxima libertate tyrannus gignitur* — out of this
  greatest freedom the tyrant is born — and on the downbeat a second
  musical system takes over: an industrial anti-melody that does not
  sing but executes, eight rigid eighth-notes per bar, each with one
  chromatic intrusion. Marching boots approach in four stages — distant,
  approaching, present, oppressive — their steps locked to the grid of
  the track. The human melody is corrupted, drowned, and for sixteen
  bars simply gone. Then, as the machine loses power, memory does what
  Tacitus says it does — *we would have lost memory itself along with
  our voice, if forgetting were as much in our power as staying silent* —
  and the melody returns in fragments, then in its clearest statement
  of the whole piece. It does not save anything: the collapse comes
  anyway, and only the descending skeleton A–G–F–E remains, refusing
  ever to resolve to D. But over the ruins a last original line is
  spoken: *Sed meminimus. Et dum meminimus, redire potest.* — But we
  remember. And as long as we remember, it can return. The final E
  hangs in the air like an open door.

## Requirements

- **Sonic Pi v4 or later** — free, available for macOS, Windows and Linux
  at [sonic-pi.net](https://sonic-pi.net). No other software is needed.
- The **sample files** (`*.wav`) from this repository, stored on your
  local machine in one folder.

## Setup

1. **Clone or download this repository** to your computer.

2. **Keep the track's `.wav` files together in one local folder.**
   The track loads them from disk at startup. Loading is tolerant: a
   missing file is logged as `NOCH NICHT DA` and its slot is simply
   skipped when the bar comes (`VOX FEHLT`), so the piece plays even
   with an incomplete sample set.

   > ⚠️ If you store the folder in a cloud-synced location (iCloud
   > Drive, OneDrive, Dropbox), make sure the files are *actually
   > downloaded* and not just cloud placeholders. On macOS: right-click
   > the folder → *"Keep Downloaded"*. A track that hangs silently at
   > startup is almost always a sample file that the cloud has offloaded.

3. **Set your local path.** Near the top of the file you will find:

   ```ruby
   define :pfad do |name|
     "... insert local path name here ..." + name + ".wav"
   end
   ```

   Replace the placeholder with the absolute path to your sample folder,
   **written as a single line** and **ending with a trailing `/`**. On
   startup the log prints a `PFAD-TEST:` line with the full path the
   track has built — if every file is reported missing, compare that
   line character by character with the real location of your folder.

4. **Run the track as a file — do not paste it into a buffer.**
   Sonic Pi's editor is limited to roughly 10,000 characters per buffer;
   this track is far beyond that size. Put a single line into an empty
   buffer and press *Run*:

   ```ruby
   run_file "/path/to/your/folder/Fragor_Noctis.rb"
   ```

   Press *Stop* to end playback at any time — and always press *Stop*
   before re-running, otherwise loops from the previous run keep going
   and you hear doubled material. Note that the piece starts with a
   15-bar spoken prologue before the bar counter begins: the log shows
   `TAKT: 1` only once the prologue has finished.

## Samples

```
vocal_in_principio.wav       vocal_res_populi.wav
vocal_o_tempora.wav          vocal_tyrannus.wav
vocal_memoriam.wav           vocal_meminimus.wav
effect_shop_windows.wav      effect_gathering_storm.wav
effect_marching_boots.wav    effect_craw.wav
```

Voice recordings by Johann van Staal. `effect_marching_boots.wav` was
synthesized for this release — 32 collective footfalls generated from
filtered noise, spaced exactly on the 126 BPM grid so the column marches
in step with the kick. The remaining ambience samples come from free
sample libraries; see their respective sources for license details.

## The Latin texts

All spoken samples are transcribed in **`fragor_noctis_texte.txt`**,
with translations, sources and their position in the track:

- **"In principio" — an original prologue by Johann van Staal**, spoken
  in ecclesiastical Latin over the opening drone; *In principio erat*
  deliberately echoes John 1:1, and its last clause varies Terence's
  proverbial *proximus sum egomet mihi*.
- **Cicero, *De re publica* I,39** — *Est igitur res publica res populi*,
  the most famous definition of the state ever written (bar 28, under
  the first complete statement of the melody).
- **Cicero, *In Catilinam* I,2** — *O tempora, o mores!* (bar 40, and
  again at bar 49, distorted).
- **Cicero, *De re publica* I,68** — *Ex hac maxima libertate tyrannus
  gignitur*, Cicero's Latin for Plato's analysis of how democracies tip
  over (bar 61, ending on the downbeat of AUTOCRACY).
- **Tacitus, *Agricola* 2** — *Memoriam quoque ipsam cum voce
  perdidissemus…*, written after fifteen years of tyranny under
  Domitian (bar 96, opening the MEMORY section).
- **"Sed meminimus" — an original epilogue by Johann van Staal**
  (bar 120, over the collapse).

The prologue is spoken in ecclesiastical pronunciation, the Roman
witnesses in classical pronunciation — two sound-worlds of the same
dead language, as on the previous releases.

## How the track works

The architecture is the one shared by all releases: a master clock
(`live_loop :puls`) counts bars into a shared counter, and every other
loop reads that counter to decide what to play. The prologue lives
*before* the clock: the counter simply waits fifteen bars while the
opening voice speaks, so every bar number in the file stays valid.

What is specific to this track is that it contains **two musical
systems**. The human melody — revealed in stages, withheld, fractured,
corrupted by A flat and E flat, remembered, and finally reduced to a
descending skeleton that never reaches its tonic — and the machine: a
pulse-wave anti-melody through bitcrusher and distortion, built from
rigid eighth-note cells in which every bar carries one chromatic
intrusion. The two systems overlap only in AUTOCRACY, where the human
melody fades in four steps exactly as the machine rises in four steps.
The A flat that corrupts the melody is the tritone of the home key —
the interval medieval theory called *diabolus in musica*. And the
final, unresolved E is also the tonal centre of every previous Van
Staal release: the piece ends on the home note of the whole project
without ever arriving there.

The sound of breaking glass at the FRACTURE is used deliberately and
soberly; listeners in Germany will understand what night it recalls.

## Troubleshooting

- **Every file is reported `NOCH NICHT DA`** — the path definition does
  not point at your sample folder. Compare the `PFAD-TEST:` log line
  with the real path.
- **A voice is loaded but never plays** — check the log: the track
  prints a `VOX SPIELT:` line for every vocal event. If the line
  appears but you hear nothing, Sonic Pi is serving an old cached
  version of the sample: run `sample_free_all` once in an empty buffer
  (or restart Sonic Pi), then start the track again.
- **Silence at the start** — that is the prologue: fifteen bars of
  drone and voice before the counter starts. If there is no voice
  either, see the iCloud note above.
- **Samples or melodies sound doubled** — loops from a previous run are
  still alive. Press *Stop*, then *Run*.
- **The editor refuses to accept new lines** — you have hit the ~10,000
  character buffer limit. Edit the `.rb` file in an external editor and
  use `run_file` as described above.
