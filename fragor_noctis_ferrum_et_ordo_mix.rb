# ============================================================
# Fragor Noctis (Ferrum et Ordo) -- Johann van Staal
# Martial Industrial / Crypt House | D minor | 122 BPM | 128 Takte
#
# 0-15 MOBILISATIO | 16-31 MARCH | 32-47 INDUSTRIA
# 48-63 FRACTURE | 64-79 MECHANISATIO | 80-95 REGIME
# 96-111 EXHAUSTION | 112-127 SILENTIUM
#
# Das Original erzaehlt den Zusammenbruch von innen; dieser
# Remix zeigt die Maschine, die ihn vollstreckt: Befehle statt
# Zeugen, Marschtrommel statt Melodie. Die Ordnung siegt --
# und zerrt sich in EXHAUSTION selbst auseinander; die
# Befehle laufen rueckwaerts, und das letzte Wort behaelt
# "meminimus". Kein D, keine Aufloesung.
# ============================================================

set_volume! 1
set :takt, 0
set_sched_ahead_time! 1
use_bpm 122
use_random_seed 31

define :pfad do |name|
  "... insert local path here ..." + name + ".wav"
end

puts "PFAD-TEST: " + pfad("vocal_ferrum_et_ordo").inspect

optionale = ["effect_ominous_drone", "effect_marching_boots",
             "effect_shop_windows", "effect_metal_slam",
             "effect_machine_press", "effect_chain_drag",
             "effect_metal_scrape",
             "vocal_o_tempora", "vocal_tyrannus", "vocal_meminimus",
             "vocal_obedite", "vocal_procedite", "vocal_in_ordinem",
             "vocal_ferrum_et_ordo"]

optionale.each do |n|
  if File.exist?(pfad(n))
    load_sample pfad(n)
    puts "GELADEN: " + n + ".wav"
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

live_loop :puls, auto_cue: false do
  t = tick(:takt_counter)
  set :takt, t
  cue :puls
  puts "TAKT: #{t}"
  stop if t >= 128
  sleep 4
end

define :takt do
  get(:takt) || 0
end

# ============================================================
# FRAGOR-DNA -- reduzierte Fassungen der Original-Melodie
# ============================================================

define :fragor_fragment do |amp_level = 0.38|
  use_synth :hollow
  with_fx :reverb, room: 0.96, mix: 0.48 do
    with_fx :lpf, cutoff: 56 do
      play :a3, attack: 0.70, sustain: 1.0, release: 3.2, amp: amp_level
      sleep 2.5
      play :f3, attack: 0.60, sustain: 0.5, release: 2.6,
        amp: amp_level * 0.68
      sleep 1.5
    end
  end
end

define :fragor_corrupt do |amp_level = 0.40|
  use_synth :hollow
  with_fx :distortion, distort: 0.12, mix: 0.14 do
    with_fx :reverb, room: 0.97, mix: 0.50 do
      with_fx :lpf, cutoff: 54 do
        play :a3, attack: 0.60, sustain: 0.7, release: 2.8, amp: amp_level
        sleep 1.5
        play :f3, attack: 0.50, sustain: 0.4, release: 2.0,
          amp: amp_level * 0.64
        sleep 1.0
        play :ab3, attack: 0.35, sustain: 0.25, release: 2.4,
          amp: amp_level * 0.72
        sleep 1.5
      end
    end
  end
end

# ============================================================
# MOBILISATIO -- OMINOUS DRONE (nur der Anfang)
# ============================================================

live_loop :ominous_drone, sync: :puls do
  t = takt
  stop if t >= 128
  if t == 1
    with_fx :lpf, cutoff: 68 do
      with_fx :reverb, room: 0.94, mix: 0.44 do
        vox "effect_ominous_drone", rate: 0.82, amp: 0.52
      end
    end
  end
  sleep 4
end

# ============================================================
# MOBILISATIO -- FERNE MASCHINERIE
# ============================================================

live_loop :low_machine, sync: :puls do
  t = takt
  stop if t >= 128
  if t < 8
    with_fx :lpf, cutoff: 38 do
      with_fx :distortion, distort: 0.32, mix: 0.18 do
        sample :bd_tek, rate: 0.18, amp: 0.42
      end
    end
    sleep 4
  elsif t < 16
    with_fx :lpf, cutoff: 44 do
      with_fx :distortion, distort: 0.38, mix: 0.24 do
        sample :bd_tek, rate: 0.16, amp: 0.50
      end
    end
    sleep 2.75
    with_fx :lpf, cutoff: 48 do
      sample :elec_blip2, rate: 0.07, amp: 0.22
    end
    sleep 1.25
  else
    sleep 4
  end
end

# ============================================================
# INDUSTRIAL KICK -- pro Sektion eine eigene rhythmische
# Grammatik; FRACTURE I ist der echte Drop.
# ============================================================

live_loop :industrial_kick, sync: :puls do
  t = takt
  stop if t >= 128
  if t < 16
    sleep 4
  elsif t < 24
    # MARCH I
    with_fx :distortion, distort: 0.08, mix: 0.14 do
      sample :bd_tek, rate: 0.84, amp: 1.42
      sleep 2
      sample :bd_tek, rate: 0.80, amp: 1.05
      sleep 2
    end
  elsif t < 32
    # MARCH II
    with_fx :distortion, distort: 0.10, mix: 0.16 do
      sample :bd_tek, rate: 0.84, amp: 1.48
      sleep 1.5
      sample :bd_haus, rate: 0.74, amp: 0.62
      sleep 0.5
      sample :bd_tek, rate: 0.82, amp: 1.18
      sleep 2
    end
  elsif t < 40
    # INDUSTRIA I
    with_fx :distortion, distort: 0.14, mix: 0.20 do
      sample :bd_tek, rate: 0.82, amp: 1.52
      sleep 1.5
      sample :bd_haus, rate: 0.72, amp: 0.68
      sleep 0.5
      sample :bd_tek, rate: 0.80, amp: 1.30
      sleep 1
      sample :bd_haus, rate: 0.70, amp: 0.54
      sleep 1
    end
  elsif t < 48
    # INDUSTRIA II
    with_fx :distortion, distort: 0.17, mix: 0.22 do
      sample :bd_tek, rate: 0.80, amp: 1.58
      sleep 1
      sample :bd_haus, rate: 0.70, amp: 0.62
      sleep 1.5
      sample :bd_tek, rate: 0.78, amp: 1.34
      sleep 1
      sample :bd_haus, rate: 0.68, amp: 0.58
      sleep 0.5
    end
  elsif t < 56
    # FRACTURE I -- der Drop
    sleep 4
  elsif t < 64
    # FRACTURE II -- der Rueckschlag
    with_fx :distortion, distort: 0.24, mix: 0.28 do
      sample :bd_tek, rate: 0.78, amp: 1.70
      sleep 1
      sample :bd_tek, rate: 0.76, amp: 1.18
      sleep 1.5
      sample :bd_haus, rate: 0.68, amp: 0.72
      sleep 0.5
      sample :bd_tek, rate: 0.76, amp: 1.40
      sleep 1
    end
  elsif t < 72
    # MECHANISATIO I
    with_fx :distortion, distort: 0.28, mix: 0.30 do
      sample :bd_tek, rate: 0.76, amp: 1.62
      sleep 2
      sample :bd_tek, rate: 0.74, amp: 1.42
      sleep 1
      sample :bd_haus, rate: 0.66, amp: 0.64
      sleep 1
    end
  elsif t < 80
    # MECHANISATIO II
    with_fx :distortion, distort: 0.32, mix: 0.34 do
      sample :bd_tek, rate: 0.75, amp: 1.68
      sleep 1
      sample :bd_haus, rate: 0.66, amp: 0.58
      sleep 0.5
      sample :bd_tek, rate: 0.74, amp: 1.32
      sleep 1
      sample :bd_haus, rate: 0.64, amp: 0.60
      sleep 0.5
      sample :bd_tek, rate: 0.73, amp: 1.28
      sleep 1
    end
  elsif t < 96
    # REGIME -- einfacher, absolut, starr
    with_fx :distortion, distort: 0.38, mix: 0.38 do
      4.times do
        sample :bd_tek, rate: 0.72, amp: (t < 88 ? 1.48 : 1.68)
        sleep 1
      end
    end
  elsif t < 104
    # EXHAUSTION I
    with_fx :distortion, distort: 0.25, mix: 0.28 do
      sample :bd_tek, rate: 0.70, amp: 1.22
      sleep 2
      sample :bd_tek, rate: 0.64, amp: 0.82
      sleep 2
    end
  elsif t < 112
    # EXHAUSTION II -- der Rhythmus versagt
    if t.even?
      sample :bd_tek, rate: 0.58, amp: 0.78
    end
    sleep 4
  else
    sleep 4
  end
end

# ============================================================
# MARCHING BOOTS -- 122/126 re-pitcht die Kolonne exakt aufs
# neue Raster; nur MARCH und eine spaete Wiederkehr.
# ============================================================

live_loop :marching_boots, sync: :puls do
  t = takt
  stop if t >= 128
  boots_rate = 122.0 / 126.0
  if t == 16
    with_fx :lpf, cutoff: 58 do
      with_fx :reverb, room: 0.78, mix: 0.30 do
        vox "effect_marching_boots",
          start: 0.0, finish: 0.5, rate: boots_rate, amp: 0.24
      end
    end
  elsif t == 24
    with_fx :lpf, cutoff: 78 do
      with_fx :reverb, room: 0.55, mix: 0.20 do
        vox "effect_marching_boots",
          start: 0.5, finish: 1.0, rate: boots_rate, amp: 0.38
      end
    end
  elsif t == 72
    with_fx :lpf, cutoff: 92 do
      with_fx :distortion, distort: 0.18, mix: 0.20 do
        vox "effect_marching_boots",
          start: 0.5, finish: 1.0, rate: boots_rate, amp: 0.36
      end
    end
  end
  sleep 4
end

# ============================================================
# MARSCHTROMMEL -- Ruffs, Wirbel vor Sektionswechseln,
# im REGIME starr, in EXHAUSTION zerfallend.
# ============================================================

live_loop :marschtrommel, sync: :puls do
  t = takt
  stop if t >= 128
  if t >= 24 && t < 48
    if [31, 39, 47].include?(t)
      # Wirbel in den naechsten Achter hinein
      with_fx :reverb, room: 0.45, mix: 0.12 do
        16.times do |i|
          sample :sn_dolf, rate: 1.25, amp: 0.08 + (i * 0.018), lpf: 102
          sleep 0.25
        end
      end
    else
      # Ruff: zwei Vorschlaege, dann der Schlag auf 2 bzw. 4
      2.times do
        sleep 0.65
        sample :sn_dolf, rate: 1.42, amp: 0.09, lpf: 92
        sleep 0.12
        sample :sn_dolf, rate: 1.38, amp: 0.12, lpf: 96
        sleep 0.13
        sample :sn_dolf, rate: 1.20, amp: 0.40, lpf: 106
        sleep 1.10
      end
    end
  elsif t >= 56 && t < 80
    if [63, 71, 79].include?(t)
      with_fx :distortion, distort: 0.10, mix: 0.12 do
        8.times do |i|
          sample :sn_dolf, rate: 1.18, amp: 0.16 + (i * 0.025), lpf: 108
          sleep 0.5
        end
      end
    else
      with_fx :distortion, distort: 0.12, mix: 0.14 do
        sample :sn_dolf, rate: 1.18, amp: 0.48, lpf: 108
        sleep 1
        sample :sn_dolf, rate: 1.32, amp: 0.18, lpf: 100
        sleep 0.5
        sample :sn_dolf, rate: 1.18, amp: 0.44, lpf: 108
        sleep 1.5
        sample :sn_dolf, rate: 1.12, amp: 0.50, lpf: 110
        sleep 1
      end
    end
  elsif t >= 80 && t < 96
    with_fx :distortion, distort: 0.20, mix: 0.20 do
      4.times do
        sample :sn_dolf, rate: 1.05, amp: (t < 88 ? 0.42 : 0.50), lpf: 112
        sleep 1
      end
    end
  elsif t >= 96 && t < 104
    with_fx :reverb, room: 0.52, mix: 0.18 do
      sample :sn_dolf, rate: 0.95, amp: 0.34, lpf: 94
      sleep 1.75
      sample :sn_dolf, rate: 0.82, amp: 0.20, lpf: 82
      sleep 2.25
    end
  elsif t >= 104 && t < 112
    if t.even?
      with_fx :reverb, room: 0.76, mix: 0.30 do
        sample :sn_dolf, rate: 0.70, amp: 0.24, lpf: 76
      end
    end
    sleep 4
  else
    sleep 4
  end
end

# ============================================================
# INDUSTRIAL FOLEY -- die generierten WAVs als Bauteile:
# scrape kuendigt an, slam bricht, press wird Rhythmus,
# chain zerrt die Mechanik auseinander.
# ============================================================

live_loop :industrial_foley, sync: :puls do
  t = takt
  stop if t >= 128
  if t == 46
    with_fx :reverb, room: 0.72, mix: 0.24 do
      with_fx :lpf, cutoff: 105 do
        vox "effect_metal_scrape", rate: 0.78, amp: 0.34
      end
    end
  elsif t == 48
    # FRACTURE -- der strukturelle Bruch selbst
    with_fx :reverb, room: 0.82, mix: 0.30 do
      with_fx :distortion, distort: 0.16, mix: 0.18 do
        vox "effect_metal_slam", rate: 0.82, amp: 0.92
      end
    end
  elsif t == 56
    with_fx :distortion, distort: 0.24, mix: 0.26 do
      vox "effect_metal_slam", rate: 0.92, amp: 1.00
    end
  elsif [64, 68].include?(t)
    with_fx :lpf, cutoff: 90 do
      with_fx :distortion, distort: 0.14, mix: 0.16 do
        vox "effect_machine_press", rate: 0.82, amp: 0.38
      end
    end
  elsif t == 78
    with_fx :distortion, distort: 0.18, mix: 0.20 do
      vox "effect_metal_scrape", rate: 0.88, amp: 0.38
    end
  elsif t >= 80 && t < 96 && t.even?
    # REGIME: die Presse wird Teil des Rhythmus
    with_fx :distortion, distort: (t < 88 ? 0.20 : 0.28),
                         mix: (t < 88 ? 0.22 : 0.30) do
      with_fx :lpf, cutoff: (t < 88 ? 96 : 110) do
        vox "effect_machine_press",
          start: 0.50, finish: 1.0,
          rate: (t < 88 ? 0.90 : 0.96),
          amp: (t < 88 ? 0.44 : 0.54)
      end
    end
  elsif [89, 93].include?(t)
    with_fx :distortion, distort: 0.28, mix: 0.30 do
      vox "effect_metal_slam", rate: 0.76, amp: 0.72
    end
  elsif t == 95
    with_fx :reverb, room: 0.88, mix: 0.38 do
      vox "effect_metal_scrape", rate: 0.62, amp: 0.42
    end
  elsif [97, 101].include?(t)
    with_fx :lpf, cutoff: 86 do
      with_fx :reverb, room: 0.74, mix: 0.28 do
        vox "effect_chain_drag", rate: 0.82, amp: 0.34
      end
    end
  elsif [105, 109].include?(t)
    with_fx :lpf, cutoff: 72 do
      with_fx :reverb, room: 0.90, mix: 0.44 do
        vox "effect_chain_drag", rate: 0.66, amp: 0.30
      end
    end
  end
  sleep 4
end

# ============================================================
# REST-METALL -- bewusst sparsam: Die Industrial-WAVs machen
# die physische Arbeit.
# ============================================================

live_loop :metal, sync: :puls do
  t = takt
  stop if t >= 128
  if t < 32
    sleep 4
  elsif t < 40
    with_fx :distortion, distort: 0.24, mix: 0.24 do
      sample :elec_blip2, rate: 0.22, amp: 0.46
      sleep 2
      sample :drum_cymbal_closed, rate: 0.16, amp: 0.28
      sleep 2
    end
  elsif t < 48
    with_fx :distortion, distort: 0.30, mix: 0.30 do
      sample :elec_blip2, rate: 0.18, amp: 0.52
      sleep 3
      sample :drum_cymbal_closed, rate: 0.14, amp: 0.30
      sleep 1
    end
  elsif t < 56
    sleep 4
  elsif t < 64
    with_fx :distortion, distort: 0.38, mix: 0.36 do
      sample :elec_blip2, rate: 0.16, amp: 0.52
      sleep 2.5
      sample :elec_blip2, rate: 0.13, amp: 0.38
      sleep 1.5
    end
  elsif t < 80
    with_fx :distortion, distort: 0.40, mix: 0.38 do
      sample :elec_blip2, rate: 0.15, amp: 0.44
      sleep 3
      sample :drum_cymbal_closed, rate: 0.12, amp: 0.24
      sleep 1
    end
  else
    # REGIME: Presse uebernimmt; EXHAUSTION: Kette uebernimmt
    sleep 4
  end
end

# ============================================================
# MECHANICAL TICKS -- nur in ausgewaehlten Sektionen
# ============================================================

live_loop :mechanical_tick, sync: :puls do
  t = takt
  stop if t >= 128
  if t >= 32 && t < 40
    8.times do |i|
      sample :elec_tick,
        rate: (i.even? ? 0.72 : 0.56),
        amp: (i % 4 == 0 ? 0.26 : 0.10)
      sleep 0.5
    end
  elsif t >= 72 && t < 80
    8.times do |i|
      if [0, 3, 4, 7].include?(i)
        sample :elec_tick, rate: 0.60, amp: 0.20
      end
      sleep 0.5
    end
  elsif t >= 88 && t < 96
    16.times do |i|
      if i % 3 != 1
        sample :elec_tick,
          rate: (i.even? ? 0.52 : 0.68),
          amp: (i % 4 == 0 ? 0.24 : 0.09)
      end
      sleep 0.25
    end
  else
    sleep 4
  end
end

# ============================================================
# FRAGOR-MELODIE -- 24-31 erkennbar | 40-47 kontaminiert |
# 48-55 isolierte Reste | 64-71 letzter menschlicher Rest
# ============================================================

live_loop :fragor_melody, sync: :puls do
  t = takt
  stop if t >= 128
  if t >= 24 && t < 32
    if [24, 28].include?(t)
      fragor_fragment 0.36
    else
      sleep 4
    end
  elsif t >= 40 && t < 48
    if [40, 44].include?(t)
      fragor_corrupt 0.38
    else
      sleep 4
    end
  elsif t >= 48 && t < 56
    use_synth :hollow
    with_fx :reverb, room: 0.98, mix: 0.62 do
      with_fx :lpf, cutoff: 52 do
        if t == 48
          play :a3, attack: 0.7, sustain: 1.4, release: 4, amp: 0.36
        elsif t == 51
          play :f3, attack: 0.6, sustain: 0.8, release: 4, amp: 0.30
        elsif t == 54
          play :e3, attack: 0.7, sustain: 1.4, release: 5, amp: 0.38
        end
      end
    end
    sleep 4
  elsif t >= 64 && t < 72
    if [64, 68].include?(t)
      fragor_corrupt 0.30
    else
      sleep 4
    end
  else
    sleep 4
  end
end

# ============================================================
# MACHINE MOTIF -- D->Eb->D | Bb->C->Bb | F->Gb->F | C->Db->C;
# erscheint erst, nachdem die menschliche Melodie zerbrochen ist.
# ============================================================

live_loop :machine_motif, sync: :puls do
  t = takt
  stop if t >= 128
  roots = [:d2, :bb1, :f2, :c2]
  wrong = [:eb2, :c2, :gb2, :db2]
  pos = t % 4
  if t < 56
    sleep 4
  elsif t < 64
    use_synth :pulse
    with_fx :distortion, distort: 0.28, mix: 0.30 do
      with_fx :lpf, cutoff: 68 do
        play roots[pos], release: 0.8, amp: 0.30
        sleep 2
        play wrong[pos], release: 0.5, amp: 0.20
        sleep 1
        play roots[pos], release: 0.8, amp: 0.28
        sleep 1
      end
    end
  elsif t < 80
    use_synth :pulse
    with_fx :distortion, distort: 0.40, mix: 0.42 do
      with_fx :bitcrusher, bits: 7, sample_rate: 12000, mix: 0.24 do
        with_fx :lpf, cutoff: 74 do
          play roots[pos], release: 0.7, amp: 0.42
          sleep 1.5
          play wrong[pos], release: 0.45, amp: 0.30
          sleep 0.5
          play roots[pos], release: 0.7, amp: 0.40
          sleep 2
        end
      end
    end
  elsif t < 96
    use_synth :pulse
    with_fx :distortion, distort: 0.52, mix: 0.50 do
      with_fx :bitcrusher, bits: 6, sample_rate: 9000, mix: 0.34 do
        with_fx :lpf, cutoff: 80 do
          play roots[pos], release: 0.55, amp: 0.54
          sleep 1
          play wrong[pos], release: 0.45, amp: 0.40
          sleep 1
          play roots[pos], release: 0.55, amp: 0.52
          sleep 1
          play roots[pos], release: 0.40, amp: 0.36
          sleep 1
        end
      end
    end
  elsif t < 104
    use_synth :pulse
    with_fx :bitcrusher, bits: 5, sample_rate: 7000, mix: 0.42 do
      with_fx :lpf, cutoff: 52 do
        play roots[pos], release: 2.5, amp: 0.28
      end
    end
    sleep 4
  elsif t < 112
    if t.even?
      use_synth :pulse
      with_fx :lpf, cutoff: 44 do
        play :d2, release: 3, amp: 0.18
      end
    end
    sleep 4
  else
    sleep 4
  end
end

# ============================================================
# GLASS -- nur FRACTURE
# ============================================================

live_loop :glass, sync: :puls do
  t = takt
  stop if t >= 128
  if t >= 48 && t < 56
    p = [0.10, 0.32, 0.54, 0.73][t % 4]
    with_fx :reverb, room: 0.88, mix: 0.38 do
      with_fx :distortion, distort: 0.12, mix: 0.15 do
        vox "effect_shop_windows",
          start: p, finish: [p + 0.10, 0.98].min,
          rate: 0.72, amp: 0.48
      end
    end
  end
  sleep 4
end

# ============================================================
# DIE BEFEHLE -- 24 PROCEDITE | 40 IN ORDINEM | 56 OBEDITE |
# 72 TYRANNUS | 88 FERRUM ET ORDO (dreistimmig geschichtet)
# ============================================================

live_loop :befehle, sync: :puls do
  t = takt
  stop if t >= 128
  case t
  when 24
    with_fx :compressor, threshold: 0.25, slope_above: 0.5 do
      with_fx :reverb, room: 0.55, mix: 0.16 do
        vox "vocal_procedite", rate: 0.9, amp: 1.45
      end
    end
  when 40
    with_fx :compressor, threshold: 0.25, slope_above: 0.5 do
      with_fx :distortion, distort: 0.10, mix: 0.12 do
        vox "vocal_in_ordinem", rate: 0.96, amp: 1.50
      end
    end
  when 56
    with_fx :compressor, threshold: 0.25, slope_above: 0.5 do
      with_fx :distortion, distort: 0.18, mix: 0.20 do
        vox "vocal_obedite", rate: 0.92, amp: 1.60
      end
    end
  when 72
    with_fx :compressor, threshold: 0.25, slope_above: 0.5 do
      with_fx :distortion, distort: 0.22, mix: 0.24 do
        vox "vocal_tyrannus", rate: 0.88, amp: 1.55
      end
    end
  when 88
    with_fx :compressor, threshold: 0.22, slope_above: 0.45 do
      # Hauptstimme -- verstaendlich und frontal
      with_fx :distortion, distort: 0.18, mix: 0.20 do
        vox "vocal_ferrum_et_ordo", rate: 0.92, amp: 1.35, pan: 0
      end
      # tiefe Schattenstimme
      with_fx :distortion, distort: 0.38, mix: 0.42 do
        with_fx :lpf, cutoff: 72 do
          vox "vocal_ferrum_et_ordo", rate: 0.72, amp: 0.58, pan: -0.18
        end
      end
      # Maschinenstimme
      with_fx :bitcrusher, bits: 7, sample_rate: 10500, mix: 0.38 do
        vox "vocal_ferrum_et_ordo", rate: 0.86, amp: 0.42, pan: 0.18
      end
    end
  when 92
    # Reprise: tiefer, mechanischer
    with_fx :distortion, distort: 0.42, mix: 0.42 do
      with_fx :bitcrusher, bits: 7, sample_rate: 11000, mix: 0.26 do
        vox "vocal_ferrum_et_ordo", rate: 0.72, amp: 1.35
      end
    end
  end
  sleep 4
end

# ============================================================
# GEBROCHENE BEFEHLE -- EXHAUSTION: die Befehle laufen
# rueckwaerts; die Maschine gehorcht sich selbst nicht mehr.
# ============================================================

live_loop :gebrochene_befehle, sync: :puls do
  t = takt
  stop if t >= 128
  if t == 100
    with_fx :reverb, room: 0.90, mix: 0.48 do
      vox "vocal_obedite", rate: -0.62, amp: 0.72
    end
  elsif t == 106
    with_fx :reverb, room: 0.96, mix: 0.60 do
      vox "vocal_in_ordinem", rate: -0.48, amp: 0.58
    end
  end
  sleep 4
end

# ============================================================
# MEMINIMUS -- das letzte Wort behaelt die Erinnerung.
# ============================================================

live_loop :memory, sync: :puls do
  t = takt
  stop if t >= 128
  if t == 120
    with_fx :reverb, room: 1, mix: 0.72 do
      with_fx :echo, phase: 1.5, decay: 7, mix: 0.26 do
        vox "vocal_meminimus", rate: 0.86, amp: 0.92
      end
    end
  end
  sleep 4
end

# ============================================================
# DAS LETZTE E -- das D kommt nie.
# ============================================================

live_loop :final_e, sync: :puls do
  t = takt
  stop if t >= 128
  if t == 124
    use_synth :hollow
    with_fx :reverb, room: 1, mix: 0.74 do
      with_fx :lpf, cutoff: 54 do
        play :e3, attack: 1.2, sustain: 2, release: 10, amp: 0.42
      end
    end
  end
  sleep 4
end
