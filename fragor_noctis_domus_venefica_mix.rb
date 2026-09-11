# ============================================================
# Fragor Noctis (Domus Venefica Mix) -- Johann van Staal
# Witch House | D minor | 74 BPM | 128 bars
#
# 0-15 RITUAL | 16-31 AWAKENING | 32-47 APPARITION
# 48-63 FRACTURE | 64-79 POSSESSION | 80-95 MACHINE
# 96-111 MEMORY | 112-127 VOID
#
# Das Original erzaehlte den Zusammenbruch eines Systems.
# Der Remix beginnt, als waeren wir in seinen Ruinen erwacht:
# Die Melodie wird falsch erinnert, die Stimmen sind auf
# Ritualgeschwindigkeit verlangsamt, Glas und Stiefel sind
# keine Ereignisse mehr, sondern Perkussion.
# ============================================================

set_volume! 1
set :takt, 0
set_sched_ahead_time! 1
use_bpm 74
use_random_seed 23

define :pfad do |name|
  "... insert local path here ..." + name + ".wav"
end

puts "PFAD-TEST: " + pfad("vocal_in_principio").inspect

optionale = ["effect_shop_windows", "effect_gathering_storm",
             "effect_ominous_drone", "effect_marching_boots",
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
# HARMONIC DRONE -- Dm Dm Bb Bb F F C C; jeder Akkord
# ueberlebt zwei Takte.
# ============================================================

live_loop :drone, sync: :puls do
  t = takt
  stop if t >= 128
  roots = [:d2, :d2, :bb1, :bb1, :f2, :f2, :c2, :c2]
  modes = [:minor, :minor, :major, :major,
           :major, :major, :major, :major]
  pos = (t / 2) % 8
  use_synth :dark_ambience
  amp_level = (t < 16 ? 0.30 : (t < 96 ? 0.42 : 0.30))
  with_fx :reverb, room: 1, mix: 0.78 do
    with_fx :lpf, cutoff: (t < 64 ? 62 : 55) do
      play chord(roots[pos], modes[pos]),
        attack: 2, sustain: 5, release: 5, amp: amp_level
    end
  end
  sleep 4
end

# ============================================================
# SUB -- lange, fast bewegungslose Toene statt Bassline
# ============================================================

live_loop :sub, sync: :puls do
  t = takt
  stop if t >= 128
  if t < 16 || t >= 120
    sleep 4
  else
    roots = [:d1, :d1, :bb0, :bb0, :f1, :f1, :c1, :c1]
    root = roots[(t / 2) % 8]
    use_synth :subpulse
    with_fx :lpf, cutoff: (t < 64 ? 55 : 62) do
      play root, attack: 0.08, sustain: 3.4, release: 1.5,
        amp: (t < 80 ? 0.72 : 0.88)
    end
    sleep 4
  end
end

# ============================================================
# HALF-TIME DRUMS -- Kick auf der 1, grosse Snare auf der 3
# ============================================================

live_loop :drums, sync: :puls do
  t = takt
  stop if t >= 128
  if t < 16 || t >= 112
    sleep 4
  else
    kick_amp  = (t < 32 ? 1.10 : 1.38)
    snare_amp = (t < 32 ? 0.62 : 0.86)
    with_fx :distortion, distort: 0.10, mix: 0.16 do
      sample :bd_haus, rate: 0.78, amp: kick_amp
    end
    sleep 2
    with_fx :reverb, room: 0.85, mix: 0.42 do
      with_fx :distortion, distort: 0.18, mix: 0.22 do
        sample :sn_dolf, rate: 0.72, amp: snare_amp
      end
    end
    sleep 2
  end
end

# ============================================================
# HATS -- erst sparsam, spaeter nervoese Double-Time-Fragmente
# ============================================================

live_loop :hats, sync: :puls do
  t = takt
  stop if t >= 128
  if t < 24 || t >= 112
    sleep 4
  elsif t < 48
    4.times do
      sleep 0.5
      sample :drum_cymbal_closed, rate: 0.65, amp: 0.16, release: 0.04
      sleep 0.5
    end
  elsif t < 96
    8.times do |i|
      sample :drum_cymbal_closed,
        rate: (i % 3 == 0 ? 0.55 : 0.72),
        amp: (i % 4 == 3 ? 0.24 : 0.13),
        release: 0.03
      sleep 0.5
    end
  else
    4.times do
      sleep 0.5
      sample :drum_cymbal_closed, rate: 0.55, amp: 0.11, release: 0.04
      sleep 0.5
    end
  end
end

# ============================================================
# GHOST MELODY -- die Fragor-Noctis-Melodie, falsch erinnert
# ============================================================

live_loop :ghost_melody, sync: :puls do
  t = takt
  stop if t >= 128
  if t < 24
    sleep 16
  elsif t < 32
    use_synth :blade
    with_fx :reverb, room: 1, mix: 0.78 do
      with_fx :echo, phase: 1.5, decay: 8, mix: 0.45 do
        play :a4, attack: 0.3, release: 3, amp: 0.38
        sleep 4
        play :f4, attack: 0.4, release: 4, amp: 0.30
        sleep 4
        play :g4, attack: 0.4, release: 4, amp: 0.32
        sleep 4
        play :a4, attack: 0.5, release: 5, amp: 0.36
        sleep 4
      end
    end
  elsif t < 48
    use_synth :blade
    with_fx :reverb, room: 1, mix: 0.72 do
      with_fx :echo, phase: 1.5, decay: 7, mix: 0.38 do
        with_fx :lpf, cutoff: 78 do
          play :a4, release: 2.5, amp: 0.44
          sleep 2
          play :f4, release: 2, amp: 0.34
          sleep 2
          play :g4, release: 2, amp: 0.36
          sleep 2
          play :a4, release: 3, amp: 0.42
          sleep 4
          play :e4, release: 5, amp: 0.40
          sleep 6
        end
      end
    end
  elsif t < 64
    use_synth :blade
    with_fx :reverb, room: 1, mix: 0.82 do
      with_fx :distortion, distort: 0.18, mix: 0.25 do
        play :a4, release: 3, amp: 0.34
        sleep 8
        play :f4, release: 4, amp: 0.28
        sleep 4
        play :e4, release: 6, amp: 0.38
        sleep 4
      end
    end
  elsif t < 96
    sleep 16
  elsif t < 112
    use_synth :blade
    with_fx :reverb, room: 1, mix: 0.80 do
      with_fx :echo, phase: 1.5, decay: 8, mix: 0.46 do
        play :a4, release: 4, amp: 0.40
        sleep 4
        play :g4, release: 4, amp: 0.34
        sleep 4
        play :f4, release: 4, amp: 0.32
        sleep 4
        play :e4, release: 7, amp: 0.44
        sleep 4
      end
    end
  else
    sleep 16
  end
end

# ============================================================
# MACHINE -- sie marschiert nicht mehr. Sie lauert.
# ============================================================

live_loop :machine, sync: :puls do
  t = takt
  stop if t >= 128
  if t < 64
    sleep 4
  elsif t < 96
    roots = [:d2, :bb1, :f2, :c2]
    wrong = [:eb2, :c2, :gb2, :db2]
    pos = t % 4
    amp_level = (t < 72 ? 0.24 : (t < 80 ? 0.38 : 0.58))
    use_synth :pulse
    with_fx :distortion, distort: 0.45, mix: 0.48 do
      with_fx :bitcrusher, bits: 5, sample_rate: 9000, mix: 0.38 do
        with_fx :reverb, room: 0.72, mix: 0.32 do
          play roots[pos], attack: 0.15, sustain: 1.4,
            release: 2.5, cutoff: 62, amp: amp_level
          sleep 2
          play wrong[pos], attack: 0.2, sustain: 0.5,
            release: 2.5, cutoff: 68, amp: amp_level * 0.72
          sleep 2
        end
      end
    end
  elsif t < 104
    use_synth :pulse
    with_fx :bitcrusher, bits: 4, sample_rate: 7000, mix: 0.45 do
      play :d2, attack: 0.3, release: 4, cutoff: 48, amp: 0.22
    end
    sleep 4
  else
    sleep 4
  end
end

# ============================================================
# RITUAL VOCALS -- Tonhoehe und Raum machen aus Sprache Textur
# ============================================================

with_fx :reverb, room: 1, mix: 0.6 do
  live_loop :stimme, sync: :puls do
    t = takt
    stop if t >= 128
    case t
    when 2
      with_fx :echo, phase: 1.5, decay: 8, mix: 0.32 do
        vox "vocal_in_principio", rate: 0.58, amp: 0.72
      end
    when 30
      vox "vocal_res_populi", rate: 0.68, amp: 0.60
    when 46
      with_fx :distortion, distort: 0.18, mix: 0.25 do
        vox "vocal_o_tempora", rate: 0.60, amp: 0.68
      end
    when 78
      with_fx :distortion, distort: 0.30, mix: 0.36 do
        vox "vocal_tyrannus", rate: 0.52, amp: 0.72
      end
    when 98
      vox "vocal_memoriam", rate: 0.62, amp: 0.58
    when 116
      vox "vocal_meminimus", rate: 0.55, amp: 0.52
    end
    sleep 4
  end
end

# ============================================================
# REVERSED O TEMPORA -- eine spektrale Erinnerung an das
# Original; negative rate spielt das Sample rueckwaerts.
# ============================================================

live_loop :o_tempora_reverse, sync: :puls do
  t = takt
  stop if t >= 128
  if t == 44
    with_fx :reverb, room: 1, mix: 0.78 do
      with_fx :echo, phase: 1.5, decay: 8, mix: 0.38 do
        vox "vocal_o_tempora", rate: -0.55, amp: 0.42
      end
    end
  elsif t == 62
    with_fx :reverb, room: 1, mix: 0.82 do
      with_fx :distortion, distort: 0.18, mix: 0.24 do
        vox "vocal_o_tempora", rate: -0.42, amp: 0.50
      end
    end
  elsif t == 94
    with_fx :reverb, room: 1, mix: 0.88 do
      vox "vocal_o_tempora", rate: -0.35, amp: 0.34
    end
  end
  sleep 4
end

# ============================================================
# STORM -- fast unterschwellig: Auch Ruinen haben Wetter.
# ============================================================

live_loop :storm, sync: :puls do
  t = takt
  stop if t >= 128
  if t == 40
    with_fx :lpf, cutoff: 65 do
      with_fx :reverb, room: 1, mix: 0.55 do
        vox "effect_gathering_storm", rate: 0.72, amp: 0.28
      end
    end
  end
  sleep 4
end

# ============================================================
# GLASS -- keine woertliche Schaufenster-Sequenz mehr:
# Die Scherben sind Perkussion geworden.
# ============================================================

live_loop :glass, sync: :puls do
  t = takt
  stop if t >= 128
  if t >= 48 && t < 64
    start_pos = [0.12, 0.38, 0.56, 0.71][t % 4]
    with_fx :reverb, room: 0.92, mix: 0.48 do
      with_fx :distortion, distort: 0.12, mix: 0.18 do
        vox "effect_shop_windows",
          start: start_pos, finish: start_pos + 0.07,
          rate: (t.even? ? 0.52 : -0.48), amp: 0.30
      end
    end
  end
  sleep 4
end

# ============================================================
# BOOTS -- der Marsch ist tiefe Industrie-Perkussion geworden.
# ============================================================

live_loop :boots, sync: :puls do
  t = takt
  stop if t >= 128
  if t >= 64 && t < 96
    start_pos = [0.02, 0.27, 0.52, 0.77][t % 4]
    with_fx :lpf, cutoff: (t < 80 ? 58 : 72) do
      with_fx :distortion, distort: 0.18, mix: 0.24 do
        vox "effect_marching_boots",
          start: start_pos, finish: start_pos + 0.035,
          rate: 0.62, amp: (t < 80 ? 0.30 : 0.44)
      end
    end
  end
  sleep 4
end

# ============================================================
# OMINOUS DRONE -- Ritualgesang am Anfang; ferne Wiederkehr
# in MEMORY.
# ============================================================

live_loop :ominous_drone, sync: :puls do
  t = takt
  stop if t >= 128
  if t == 4
    with_fx :lpf, cutoff: 72 do
      with_fx :reverb, room: 1, mix: 0.62 do
        vox "effect_ominous_drone", rate: 0.82, amp: 0.42
      end
    end
  elsif t == 100
    with_fx :lpf, cutoff: 58 do
      with_fx :reverb, room: 1, mix: 0.82 do
        vox "effect_ominous_drone", start: 0.30, rate: 0.66, amp: 0.24
      end
    end
  end
  sleep 4
end

# ============================================================
# VOID -- alles verschwindet ausser dem unaufgeloesten E
# und dem Rest der Ruine.
# ============================================================

live_loop :void, sync: :puls do
  t = takt
  stop if t >= 128
  if t == 112
    use_synth :dark_ambience
    with_fx :reverb, room: 1, mix: 0.90 do
      play :d2, attack: 4, sustain: 20, release: 12,
        cutoff: 48, amp: 0.24
    end
  elsif t == 124
    use_synth :blade
    with_fx :reverb, room: 1, mix: 0.88 do
      with_fx :echo, phase: 2, decay: 10, mix: 0.48 do
        play :e4, attack: 1.5, release: 10, cutoff: 65, amp: 0.42
      end
    end
  end
  sleep 4
end
