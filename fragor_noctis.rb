# ============================================================
# Fragor Noctis -- Johann van Staal
# Crypt House | D minor | 126 BPM | 128 bars
#
# 0-7 INTRO | 8-15 AWAKENING | 16-31 DEMOCRACY/REVEAL
# 32-47 UNEASE | 48-63 FRACTURE | 64-79 AUTOCRACY
# 80-95 REGIME | 96-111 MEMORY | 112-127 COLLAPSE
#
# PROLOG (15 Takte vor Takt 0): "In principio erat res publica"
# ueber blossem D-Bordun -- dann erst startet die Uhr; alle
# Taktnummern bleiben unveraendert.
#
# MACHINE: Ab AUTOCRACY ersetzt eine industrielle Anti-Melodie
# zunehmend die menschliche Melodie. In REGIME uebernimmt sie
# abrupt. In MEMORY stirbt sie, waehrend die Erinnerung
# zurueckkehrt.
#
# MARCHING BOOTS: 64-95 in vier 8-Takt-Abschnitten:
# distant -> approaching -> present -> oppressive.
# Keine ueberlappenden Sample-Instanzen.
# ============================================================

set_volume! 1
set :takt, 0
set :prolog_done, nil
set_sched_ahead_time! 1
use_bpm 126
use_random_seed 17

define :pfad do |name|
  "... insert local path name here ..." + name + ".wav"
end

puts "PFAD-TEST: " + pfad("effect_shop_windows").inspect

optionale = ["effect_shop_windows", "effect_craw",
             "effect_gathering_storm", "effect_marching_boots",
             "vocal_in_principio", "vocal_res_populi", "vocal_o_tempora",
             "vocal_tyrannus", "vocal_memoriam", "vocal_meminimus"]

optionale.each do |n|
  if File.exist?(pfad(n))
    load_sample pfad(n)
  else
    puts "NOCH NICHT DA: " + n + ".wav (wird uebersprungen)"
  end
end

define :vox do |name, opts = {}|
  if File.exist?(pfad(name))
    puts "VOX SPIELT: " + name + " (Takt #{takt})"
    sample pfad(name), opts
  else
    puts "VOX FEHLT: " + name
  end
end

# ============================================================
# CLOCK -- set VOR cue, damit alle Loops denselben Takt sehen
# ============================================================

define :prolog_beats do
  60
end

live_loop :puls, auto_cue: false do
  if get(:prolog_done).nil?
    set :prolog_done, true
    sleep prolog_beats
  end
  t = tick(:takt_counter)
  set :takt, t
  cue :puls
  puts "TAKT: #{t}"
  stop if t >= 128
  sleep 4
end

# ============================================================
# PROLOG -- Genesis der Republik ueber D-Bordun
# ============================================================

in_thread do
  use_synth :dark_ambience
  with_fx :reverb, room: 1, mix: 0.7 do
    play :d2, attack: 4, sustain: prolog_beats - 12,
      release: 8, amp: 0.4
    play :a2, attack: 6, sustain: prolog_beats - 16,
      release: 8, amp: 0.2
  end
end

in_thread do
  sleep 2
  with_fx :reverb, room: 0.9, mix: 0.4 do
    vox "vocal_in_principio", rate: 0.8, amp: 0.9
  end
end

define :takt do
  get(:takt) || 0
end

# ============================================================
# MELODY -- CLEAN | 16 Beats / 4 bars
# ============================================================

define :melody_clean do |amp_level = 0.70|
  use_synth :blade
  with_fx :reverb, room: 0.85, mix: 0.42 do
    with_fx :echo, phase: 0.75, decay: 4, mix: 0.22 do
      with_fx :lpf, cutoff: 95 do
        play :a4, release: 0.65, amp: amp_level
        sleep 1
        play :f4, release: 0.45, amp: amp_level * 0.84
        sleep 0.5
        play :g4, release: 0.45, amp: amp_level * 0.88
        sleep 0.5
        play :a4, release: 0.90, amp: amp_level
        sleep 2
        play :f4, release: 0.65, amp: amp_level * 0.94
        sleep 1
        play :d4, release: 0.45, amp: amp_level * 0.80
        sleep 0.5
        play :f4, release: 0.45, amp: amp_level * 0.88
        sleep 0.5
        play :g4, release: 0.90, amp: amp_level * 0.93
        sleep 2
        play :a4, release: 0.45, amp: amp_level
        sleep 0.5
        play :c5, release: 0.45, amp: amp_level
        sleep 0.5
        play :a4, release: 0.65, amp: amp_level * 0.94
        sleep 1
        play :g4, release: 0.65, amp: amp_level * 0.89
        sleep 1
        play :f4, release: 0.65, amp: amp_level * 0.86
        sleep 1
        play :a4, release: 0.45, amp: amp_level * 0.94
        sleep 0.5
        play :g4, release: 0.45, amp: amp_level * 0.90
        sleep 0.5
        play :f4, release: 0.65, amp: amp_level * 0.86
        sleep 1
        play :e4, release: 1.80, amp: amp_level
        sleep 2
      end
    end
  end
end

# ============================================================
# MELODY REVEAL 1 -- A F G A, dann Raum
# ============================================================

define :melody_reveal_1 do
  use_synth :blade
  with_fx :reverb, room: 0.85, mix: 0.42 do
    with_fx :echo, phase: 0.75, decay: 4, mix: 0.22 do
      with_fx :lpf, cutoff: 95 do
        play :a4, release: 0.65, amp: 0.72
        sleep 1
        play :f4, release: 0.45, amp: 0.60
        sleep 0.5
        play :g4, release: 0.45, amp: 0.62
        sleep 0.5
        play :a4, release: 0.90, amp: 0.70
        sleep 2
      end
    end
  end
  sleep 12
end

# ============================================================
# MELODY REVEAL 2 -- Dm + Bb
# ============================================================

define :melody_reveal_2 do
  use_synth :blade
  with_fx :reverb, room: 0.85, mix: 0.42 do
    with_fx :echo, phase: 0.75, decay: 4, mix: 0.22 do
      with_fx :lpf, cutoff: 95 do
        play :a4, release: 0.65, amp: 0.72
        sleep 1
        play :f4, release: 0.45, amp: 0.60
        sleep 0.5
        play :g4, release: 0.45, amp: 0.62
        sleep 0.5
        play :a4, release: 0.90, amp: 0.70
        sleep 2
        play :f4, release: 0.65, amp: 0.67
        sleep 1
        play :d4, release: 0.45, amp: 0.56
        sleep 0.5
        play :f4, release: 0.45, amp: 0.62
        sleep 0.5
        play :g4, release: 0.90, amp: 0.66
        sleep 2
      end
    end
  end
  sleep 8
end

# ============================================================
# MELODY REVEAL 3 -- Dm + Bb + F; C bleibt aus
# ============================================================

define :melody_reveal_3 do
  use_synth :blade
  with_fx :reverb, room: 0.85, mix: 0.42 do
    with_fx :echo, phase: 0.75, decay: 4, mix: 0.22 do
      with_fx :lpf, cutoff: 95 do
        play :a4, release: 0.65, amp: 0.72
        sleep 1
        play :f4, release: 0.45, amp: 0.60
        sleep 0.5
        play :g4, release: 0.45, amp: 0.62
        sleep 0.5
        play :a4, release: 0.90, amp: 0.70
        sleep 2
        play :f4, release: 0.65, amp: 0.67
        sleep 1
        play :d4, release: 0.45, amp: 0.56
        sleep 0.5
        play :f4, release: 0.45, amp: 0.62
        sleep 0.5
        play :g4, release: 0.90, amp: 0.66
        sleep 2
        play :a4, release: 0.45, amp: 0.69
        sleep 0.5
        play :c5, release: 0.45, amp: 0.70
        sleep 0.5
        play :a4, release: 0.65, amp: 0.65
        sleep 1
        play :g4, release: 0.65, amp: 0.62
        sleep 1
        play :f4, release: 0.65, amp: 0.60
        sleep 1
      end
    end
  end
  sleep 4
end

# ============================================================
# FRACTURED MELODY -- Fragmente und Loecher | 16 Beats
# ============================================================

define :melody_fractured do
  use_synth :blade
  with_fx :reverb, room: 0.92, mix: 0.48 do
    with_fx :echo, phase: 0.75, decay: 4, mix: 0.25 do
      with_fx :lpf, cutoff: 90 do
        play :a4, release: 0.55, amp: 0.67
        sleep 1
        play :f4, release: 0.40, amp: 0.56
        sleep 0.5
        play :g4, release: 0.40, amp: 0.59
        sleep 0.5
        sleep 2
        play :f4, release: 0.55, amp: 0.62
        sleep 1
        play :d4, release: 0.40, amp: 0.52
        sleep 0.5
        sleep 1.5
        play :g4, release: 0.70, amp: 0.61
        sleep 1
        play :c5, release: 0.45, amp: 0.65
        sleep 0.5
        play :a4, release: 0.55, amp: 0.60
        sleep 1
        sleep 1.5
        play :f4, release: 0.60, amp: 0.57
        sleep 1
        play :e4, release: 1.80, amp: 0.70
        sleep 4
      end
    end
  end
end

# ============================================================
# CORRUPTED MELODY -- Ab und Eb kontaminieren das Original
# ============================================================

define :melody_corrupt do |amp_level = 1.0|
  use_synth :blade
  with_fx :distortion, distort: 0.22, mix: 0.27 do
    with_fx :reverb, room: 0.90, mix: 0.46 do
      with_fx :echo, phase: 0.75, decay: 4, mix: 0.25 do
        with_fx :lpf, cutoff: 88 do
          play :a4, release: 0.55, amp: 0.70 * amp_level
          sleep 1
          play :f4, release: 0.35, amp: 0.58 * amp_level
          sleep 0.5
          play :g4, release: 0.35, amp: 0.62 * amp_level
          sleep 0.5
          play :ab4, release: 0.85, amp: 0.72 * amp_level
          sleep 2
          play :f4, release: 0.55, amp: 0.66 * amp_level
          sleep 1
          play :d4, release: 0.35, amp: 0.56 * amp_level
          sleep 0.5
          play :eb4, release: 0.35, amp: 0.64 * amp_level
          sleep 0.5
          play :g4, release: 0.85, amp: 0.70 * amp_level
          sleep 2
          play :ab4, release: 0.40, amp: 0.72 * amp_level
          sleep 0.5
          play :c5, release: 0.40, amp: 0.72 * amp_level
          sleep 0.5
          play :a4, release: 0.55, amp: 0.66 * amp_level
          sleep 1
          play :g4, release: 0.55, amp: 0.63 * amp_level
          sleep 1
          play :f4, release: 0.55, amp: 0.60 * amp_level
          sleep 1
          play :ab4, release: 0.35, amp: 0.72 * amp_level
          sleep 0.5
          play :g4, release: 0.35, amp: 0.64 * amp_level
          sleep 0.5
          play :f4, release: 0.55, amp: 0.62 * amp_level
          sleep 1
          play :e4, release: 1.80, amp: 0.76 * amp_level
          sleep 2
        end
      end
    end
  end
end

# ============================================================
# MACHINE CYCLE -- industrielle Anti-Melodie | 16 Beats
# D->Eb->D | Bb->C->Bb | F->Gb->F | C->Db->C
# Sie singt nicht. Sie exekutiert.
# ============================================================

define :machine_cycle do |amp_level = 0.40, cutoff = 85|
  use_synth :pulse
  sequence = [[:d4, :eb4], [:bb3, :c4], [:f4, :gb4], [:c4, :db4]]
  with_fx :distortion, distort: 0.32, mix: 0.42 do
    with_fx :bitcrusher, bits: 6, sample_rate: 11000, mix: 0.32 do
      with_fx :reverb, room: 0.35, mix: 0.12 do
        sequence.each do |root, wrong|
          2.times do
            play root, release: 0.11, cutoff: cutoff, amp: amp_level
            sleep 0.5
            play root, release: 0.08, cutoff: cutoff - 4,
              amp: amp_level * 0.76
            sleep 0.5
            play wrong, release: 0.13, cutoff: cutoff + 5,
              amp: amp_level * 0.95
            sleep 0.5
            play root, release: 0.08, cutoff: cutoff - 2,
              amp: amp_level * 0.82
            sleep 0.5
          end
        end
      end
    end
  end
end

# ============================================================
# FINAL MELODY -- A G F E; kein D, keine Aufloesung
# ============================================================

define :melody_final do
  use_synth :blade
  with_fx :reverb, room: 1, mix: 0.65 do
    with_fx :echo, phase: 1.5, decay: 6, mix: 0.35 do
      with_fx :lpf, cutoff: 78 do
        play :a4, attack: 0.2, release: 1.5, amp: 0.52
        sleep 4
        play :g4, attack: 0.2, release: 1.5, amp: 0.46
        sleep 4
        play :f4, attack: 0.3, release: 2, amp: 0.42
        sleep 4
        play :e4, attack: 0.4, release: 5, amp: 0.60
        sleep 4
      end
    end
  end
end

# ============================================================
# CHORDS
# ============================================================

live_loop :chords, sync: :puls do
  t = takt
  stop if t >= 128
  pos = t % 4
  roots = [:d3, :bb2, :f3, :c3]
  modes = [:minor, :major, :major, :major]
  tensions = [:e4, :c4, :g4, :d4]
  root = roots[pos]
  mode = modes[pos]
  tension = tensions[pos]
  if t < 48
    use_synth :hollow
    with_fx :reverb, room: 0.95, mix: 0.55 do
      play chord(root, mode), attack: 0.5, sustain: 3.5, release: 2.5,
        cutoff: 75, amp: (t < 8 ? 0.38 : 0.46)
      play tension, attack: 1, sustain: 2, release: 3, amp: 0.15
    end
  elsif t < 64
    use_synth :hollow
    with_fx :reverb, room: 1, mix: 0.62 do
      with_fx :distortion, distort: 0.08, mix: 0.12 do
        play chord(root, mode), attack: 0.4, sustain: 3.4, release: 2.8,
          cutoff: 70, amp: 0.47
        play tension, attack: 0.8, release: 3, amp: 0.18
        play :ab3, attack: 1, release: 4, amp: 0.15 if pos == 3
      end
    end
  elsif t < 96
    use_synth :hollow
    with_fx :reverb, room: 0.90, mix: 0.48 do
      with_fx :distortion, distort: 0.18, mix: 0.22 do
        play chord(root, mode), attack: 0.25, sustain: 3.4, release: 2,
          cutoff: 65, amp: 0.51
        play :ab3, attack: 0.6, release: 3, amp: 0.21 if pos == 0 || pos == 3
      end
    end
  elsif t < 112
    use_synth :hollow
    with_fx :reverb, room: 1, mix: 0.60 do
      with_fx :distortion, distort: 0.12, mix: 0.15 do
        play chord(root, mode), attack: 0.5, sustain: 3.5, release: 3,
          cutoff: 62, amp: 0.42
        play :ab3, attack: 1, release: 4, amp: 0.19 if pos == 3
      end
    end
  else
    use_synth :dark_ambience
    amp_fade = (t < 120 ? 0.32 : (t < 124 ? 0.22 : 0.12))
    with_fx :reverb, room: 1, mix: 0.78 do
      play root, attack: 1.5, sustain: 2, release: 5,
        cutoff: 58, amp: amp_fade
    end
  end
  sleep 4
end

# ============================================================
# KICK
# ============================================================

live_loop :kick, sync: :puls do
  t = takt
  stop if t >= 128
  if t < 8
    sleep 4
  elsif t < 16
    4.times do
      sample :bd_haus, amp: 1.20
      sleep 1
    end
  elsif t < 64
    4.times do
      sample :bd_haus, amp: 1.40
      sample :bd_tek, amp: 0.16
      sleep 1
    end
  elsif t < 96
    with_fx :lpf, cutoff: 105 do
      4.times do
        sample :bd_haus, amp: 1.48
        sample :bd_tek, amp: 0.30
        sleep 1
      end
    end
  elsif t < 112
    4.times do
      sample :bd_haus, amp: 1.35
      sample :bd_tek, amp: 0.20
      sleep 1
    end
  elsif t < 120
    4.times do
      sample :bd_haus, amp: 1.05
      sleep 1
    end
  else
    sleep 4
  end
end

# ============================================================
# HATS
# ============================================================

live_loop :hats, sync: :puls do
  t = takt
  stop if t >= 128
  if t < 8
    sleep 4
  elsif t < 32
    4.times do
      sleep 0.5
      sample :drum_cymbal_closed, amp: 0.34, sustain: 0, release: 0.05
      sleep 0.5
    end
  elsif t < 96
    4.times do |i|
      sleep 0.5
      sample :drum_cymbal_closed, amp: 0.42, sustain: 0, release: 0.05
      if i == 3 && t >= 64
        sleep 0.25
        sample :drum_cymbal_closed, amp: 0.20, sustain: 0, release: 0.03
        sleep 0.25
      else
        sleep 0.5
      end
    end
  elsif t < 112
    4.times do
      sleep 0.5
      sample :drum_cymbal_closed, amp: 0.32, release: 0.05
      sleep 0.5
    end
  elsif t < 120
    2.times do
      sleep 0.5
      sample :drum_cymbal_closed, amp: 0.22
      sleep 1.5
    end
  else
    sleep 4
  end
end

# ============================================================
# BASS
# ============================================================

live_loop :bass, sync: :puls do
  t = takt
  stop if t >= 128
  pos = t % 4
  if t < 8
    sleep 4
  elsif t < 16
    use_synth :fm
    root = [:d2, :bb1, :f2, :c2][pos]
    4.times do
      play root, release: 0.20, cutoff: 68, amp: 0.57
      sleep 1
    end
  elsif t < 96
    use_synth :fm
    patterns = [
      [:d2, :d2, :a1, :d2, :c2],
      [:bb1, :bb1, :f2, :bb1, :a1],
      [:f2, :f2, :c2, :f2, :e2],
      [:c2, :c2, :g1, :c2, :ab1]
    ]
    n = patterns[pos]
    distortion = (t < 48 ? 0.12 : (t < 64 ? 0.20 : 0.30))
    with_fx :distortion, distort: distortion,
      mix: (t < 64 ? 0.22 : 0.34) do
      with_fx :lpf, cutoff: (t < 64 ? 78 : 84) do
        play n[0], release: 0.28, amp: 0.82
        sleep 1
        play n[1], release: 0.18, amp: 0.60
        sleep 0.5
        play n[2], release: 0.18, amp: 0.68
        sleep 0.5
        play n[3], release: 0.28, amp: 0.78
        sleep 1
        play n[4], release: 0.20,
          amp: (pos == 3 ? 0.76 : 0.63)
        sleep 1
      end
    end
  elsif t < 112
    use_synth :fm
    roots = [:d2, :bb1, :f2, :c2]
    with_fx :distortion, distort: 0.16, mix: 0.20 do
      4.times do
        play roots[pos], release: 0.25, cutoff: 70, amp: 0.68
        sleep 1
      end
    end
  elsif t < 120
    use_synth :fm
    roots = [:d2, :bb1, :f2, :c2]
    2.times do
      play roots[pos], release: 0.60, cutoff: 58, amp: 0.48
      sleep 2
    end
  else
    sleep 4
  end
end

# ============================================================
# CRYPT PULSE
# 80-95 bewusst abgesenkt: die MACHINE wird zum Vordergrund.
# ============================================================

live_loop :crypt_pulse, sync: :puls do
  t = takt
  stop if t >= 128
  pos = t % 4
  if t < 32
    sleep 4
  elsif t < 112
    use_synth :prophet
    pairs = [[:d3, :a3], [:bb2, :f3], [:f3, :c4], [:c3, :g3]]
    p = pairs[pos]
    amp_level =
      if t < 48
        0.50
      elsif t < 64
        0.57
      elsif t < 80
        0.64
      elsif t < 96
        0.42
      else
        0.48
      end
    cutoff = (t < 64 ? 70 : (t < 96 ? 78 : 66))
    with_fx :reverb, room: 0.70, mix: 0.28 do
      with_fx :distortion,
        distort: (t < 64 ? 0.20 : 0.30),
        mix: (t < 64 ? 0.26 : 0.34) do
        if pos != 3
          4.times do
            play p[0], release: 0.20, cutoff: cutoff, amp: amp_level
            sleep 0.5
            play p[1], release: 0.20, cutoff: cutoff,
              amp: amp_level * 0.94
            sleep 0.5
          end
        else
          3.times do
            play :c3, release: 0.20, cutoff: cutoff, amp: amp_level
            sleep 0.5
            play :g3, release: 0.20, cutoff: cutoff,
              amp: amp_level * 0.94
            sleep 0.5
          end
          play :c3, release: 0.20, cutoff: cutoff, amp: amp_level
          sleep 0.5
          play :ab3, release: 0.35, cutoff: cutoff + 5,
            amp: (t < 64 ? 0.68 : (t < 80 ? 0.82 : 0.56))
          sleep 0.5
        end
      end
    end
  elsif t < 120
    use_synth :prophet
    play [:d3, :bb2, :f3, :c3][pos],
      release: 0.25, cutoff: 56, amp: 0.27
    sleep 4
  else
    sleep 4
  end
end

# ============================================================
# GHOST
# In REGIME deutlich zurueckgenommen: weniger Spuk, mehr Ordnung.
# ============================================================

live_loop :ghost, sync: :puls do
  t = takt
  stop if t >= 128
  if t < 112
    use_synth :dark_ambience
    ghost_note = [:a6, :f6, :c7, :e6][t % 4]
    amp_level =
      if t < 16
        0.34
      elsif t < 48
        0.28
      elsif t < 80
        0.40
      elsif t < 96
        0.25
      else
        0.25
      end
    with_fx :reverb, room: 1, mix: 0.68 do
      with_fx :echo, phase: 1.5, decay: 6, mix: 0.38 do
        sleep 2.5
        play ghost_note, attack: 0.20, release: 3, amp: amp_level
        sleep 1.5
      end
    end
  else
    sleep 4
  end
end

# ============================================================
# SHADOW -- Ab-Kontamination hinter der Harmonie
# ============================================================

live_loop :shadow, sync: :puls do
  t = takt
  stop if t >= 128
  if t < 32
    sleep 4
  elsif t < 96
    if t % 4 == 3
      use_synth :dark_ambience
      with_fx :reverb, room: 1, mix: 0.72 do
        sleep 2
        play :ab3, attack: 0.8, sustain: 0.5, release: 4,
          cutoff: 72, amp: (t < 64 ? 0.28 : 0.42)
        sleep 2
      end
    else
      sleep 4
    end
  elsif t < 112
    if t % 4 == 3
      use_synth :dark_ambience
      with_fx :reverb, room: 1, mix: 0.75 do
        play :ab3, attack: 1.5, release: 5,
          cutoff: 62, amp: 0.30
      end
    end
    sleep 4
  else
    sleep 4
  end
end

# ============================================================
# SHOP WINDOWS -- FRACTURE
# ============================================================

live_loop :shop_windows, sync: :puls do
  t = takt
  stop if t >= 128
  if t == 48
    if File.exist?(pfad("effect_shop_windows"))
      with_fx :reverb, room: 0.75, mix: 0.18 do
        sample pfad("effect_shop_windows"), amp: 0.40
      end
    end
  elsif t == 56
    if File.exist?(pfad("effect_shop_windows"))
      with_fx :reverb, room: 0.95, mix: 0.40 do
        with_fx :distortion, distort: 0.15, mix: 0.20 do
          sample pfad("effect_shop_windows"),
            start: 0.38, finish: 0.72, amp: 0.50
        end
      end
    end
  end
  sleep 4
end

# ============================================================
# MAIN MELODY ARRANGEMENT
# REVEALED - UNDERSTOOD - WITHDRAWN - FRACTURED -
# CORRUPTED - DISPLACED - REMEMBERED - LOST
# ============================================================

live_loop :melody, sync: :puls do
  t = takt
  stop if t >= 128
  if t < 16
    sleep 16
  elsif t < 20
    melody_reveal_1
  elsif t < 24
    melody_reveal_2
  elsif t < 28
    melody_reveal_3
  elsif t < 32
    melody_clean 0.74
  elsif t < 36
    melody_clean 0.70
  elsif t < 40
    melody_reveal_1
  elsif t < 44
    melody_clean 0.72
  elsif t < 48
    melody_reveal_2
  elsif t < 52
    melody_fractured
  elsif t < 56
    sleep 16
  elsif t < 60
    melody_fractured
  elsif t < 64
    melody_reveal_1
  elsif t < 68
    melody_corrupt 0.95
  elsif t < 72
    melody_corrupt 0.82
  elsif t < 76
    melody_corrupt 0.66
  elsif t < 80
    melody_corrupt 0.48
  elsif t < 96
    sleep 16
  elsif t < 100
    melody_reveal_1
  elsif t < 104
    melody_reveal_2
  elsif t < 108
    melody_reveal_3
  elsif t < 112
    melody_clean 0.80
  else
    melody_final
  end
end

# ============================================================
# MACHINE
# 64-79 takeover | 80-95 established regime
# 96-107 dying | 108+ gone
# ============================================================

live_loop :machine, sync: :puls do
  t = takt
  stop if t >= 128
  if t < 64
    sleep 16
  elsif t < 68
    machine_cycle 0.12, 68
  elsif t < 72
    machine_cycle 0.20, 74
  elsif t < 76
    machine_cycle 0.34, 80
  elsif t < 80
    machine_cycle 0.48, 86
  elsif t < 84
    # REGIME: kein gradueller Uebergang mehr -- die Maschine ist da.
    machine_cycle 0.66, 94
  elsif t < 88
    machine_cycle 0.68, 97
  elsif t < 92
    machine_cycle 0.68, 100
  elsif t < 96
    machine_cycle 0.72, 102
  elsif t < 100
    machine_cycle 0.44, 82
  elsif t < 104
    machine_cycle 0.28, 72
  elsif t < 108
    machine_cycle 0.12, 60
  else
    sleep 16
  end
end

# ============================================================
# THE CROW -- Omen vor der FRACTURE
# ============================================================

live_loop :crow, sync: :puls do
  t = takt
  stop if t >= 128
  if t == 26
    if File.exist?(pfad("effect_craw"))
      with_fx :reverb, room: 0.90, mix: 0.30 do
        sample pfad("effect_craw"), amp: 0.38
      end
    end
  end
  sleep 4
end

# ============================================================
# DIE STIMMEN
# 28 Definition | 40/49 Aufschrei | 61 Gesetz
# 96 Verlust | 120 Epilog
# ============================================================

with_fx :reverb, room: 0.8, mix: 0.32 do
  live_loop :stimme, sync: :puls do
    t = takt
    stop if t >= 128
    case t
    when 28
      vox "vocal_res_populi", rate: 0.9, amp: 0.85
    when 40
      vox "vocal_o_tempora", rate: 0.9, amp: 0.9
    when 49
      with_fx :distortion, distort: 0.2, mix: 0.4 do
        vox "vocal_o_tempora", rate: 0.97, amp: 0.6, hpf: 50
      end
    when 61
      vox "vocal_tyrannus", rate: 0.9, amp: 0.9
    when 96
      vox "vocal_memoriam", rate: 0.9, amp: 0.85
    when 120
      vox "vocal_meminimus", rate: 0.9, amp: 0.8
    end
    sleep 4
  end
end

# ============================================================
# GATHERING STORM -- UNEASE kippt in FRACTURE
# ============================================================

live_loop :gathering_storm, sync: :puls do
  t = takt
  stop if t >= 128
  if t == 40
    if File.exist?(pfad("effect_gathering_storm"))
      with_fx :reverb, room: 0.85, mix: 0.20 do
        sample pfad("effect_gathering_storm"), amp: 0.50
      end
    end
  end
  sleep 4
end

# ============================================================
# MARCHING BOOTS
# 64-71 distant
# 72-79 approaching
# 80-87 present
# 88-95 oppressive
#
# effect_marching_boots.wav = 16 bars at 126 BPM.
# Each invocation uses exactly half the file = 8 bars.
# No overlapping copies.
# ============================================================

live_loop :marching_boots, sync: :puls do
  t = takt
  stop if t >= 128
  if t == 64
    if File.exist?(pfad("effect_marching_boots"))
      with_fx :lpf, cutoff: 68 do
        with_fx :reverb, room: 0.75, mix: 0.30 do
          sample pfad("effect_marching_boots"),
            start: 0.0, finish: 0.5, amp: 0.22
        end
      end
    end
  elsif t == 72
    if File.exist?(pfad("effect_marching_boots"))
      with_fx :lpf, cutoff: 84 do
        with_fx :reverb, room: 0.52, mix: 0.20 do
          sample pfad("effect_marching_boots"),
            start: 0.5, finish: 1.0, amp: 0.38
        end
      end
    end
  elsif t == 80
    if File.exist?(pfad("effect_marching_boots"))
      with_fx :lpf, cutoff: 105 do
        with_fx :reverb, room: 0.35, mix: 0.12 do
          sample pfad("effect_marching_boots"),
            start: 0.0, finish: 0.5, amp: 0.50
        end
      end
    end
  elsif t == 88
    if File.exist?(pfad("effect_marching_boots"))
      with_fx :lpf, cutoff: 110 do
        with_fx :reverb, room: 0.28, mix: 0.08 do
          sample pfad("effect_marching_boots"),
            start: 0.5, finish: 1.0, amp: 0.54
        end
      end
    end
  end
  sleep 4
end
