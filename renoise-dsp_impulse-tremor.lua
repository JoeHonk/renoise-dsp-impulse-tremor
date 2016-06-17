--[[============================================================================
impulse_tremor.lua

This is a script to be pasted into Renoise as a Formula Device

Its functionality is quite simple, and unlike Impulse Tracker, may be applied
to any Renoise DSP parameter.

nnXY : X ticks at 100% / Y ticks at 0%
============================================================================]]--
function tremor(value)
  -- While stopped or nn00, init values and set amplitude to 100%
  -- x ticks is initialized to -1, because the values aren't applied intil after the first tick is processed.
  if PLAYING == 0 or value == 0 then
      xtc=-1
      ytc=0
      amp=1
      return amp
  end
  --Update the X/Y values at first tick of each beat.
  if TICK == 0 then
    -- Translate the 0-1 decimal value into separate hex X/Y values.
    Y = (((value)*256)%16)-1
    X = (((value*256)-Y)/16)-1
    -- Impulse compatability; tick values of 0 are considered 1
    -- nn00 overrides this as a new feature to reset/disable tremor at the beat
    if X==0 then
      X=1
    end
    if Y==0 then
      Y=1
    end
    -- If we aren't on the first beat of playback, and the X or Y value changes, reset tremor state
    if xtc~=-1 and xtmp~=X and ytmp~=Y then
      xtc=0
      ytc=0
      amp=0
      xtmp=X
      ytmp=Y
    end
  end
  -- Set amplitide to 100% until X ticks are counted
  if xtc<X then
    xtc=xtc+1
    amp=1
    else
    -- Set amplitide to 0% until Y ticks are counted
    amp=0
    if ytc<Y-1 then
      ytc=ytc+1
      amp=0
    else
    xtc=0
    ytc=0
    end
  end
  return amp
end