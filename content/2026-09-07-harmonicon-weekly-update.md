+++
title = "Harmonicon Weekly Update: any harp, any file"
date = 2026-09-07
description = "A week on Harmonicon, in which a property test finds a bug that has nothing to do with the property test, a bass line lies about being a harmonica, and my build directory reaches 300 gigabytes."

[taxonomies]
tags=["rust", "bevy", "music", "harmonica", "gamedev"]
categories=["harmonicon"]
+++

This is a weekly update, which means I did a week of things and now I'm going
to tell you about them, and I should say up front that most of the week went on
two problems that sound small when you write them down. You had to own the
exact harmonica a chart was written for. And the chart had to be in my file
format, the one I invented, the one nobody else has ever written anything in.

## The one harmonica you own

Here's the thing about harmonicas. A diatonic is built in one key. Not tuned to
one key, *built* in it, the reeds are physically cut for it, and if the chart
says C and the harp in your pocket says G then you can't play that chart. Not
badly, not with effort. You sit there and nothing you do produces the note.

And people learning have one harmonica. One. Whichever one turned up. So the
situation where you open my game, pick a song, and discover it wasn't written
for the only instrument you own isn't an edge case, it's Tuesday.

There are two honest answers to this and they go in opposite directions. You
keep the tab and let the music move: same holes, same breath, different key.
Or you keep the music and let the tab move: same tune, different holes. Both
are defensible, I couldn't pick, so I built both and put them on a little
screen that turns up after you choose a song.

That screen also tells you the damage. Something like "5 need a bend · 2 need
an overblow · 9 can't be played". The nine is the number I built the screen
for. If swapping your harp in quietly eats a fifth of the melody, I'd rather
say it out loud and let you decide than hand you a chart with holes in it and
let you assume you're the problem.

## The test that went looking for one thing

The remapping code has a property test on it. It walks twelve source keys
against twelve target keys, both harmonica families, every hole, both breath
directions, in both of those modes I just described, and for every single
combination it checks that anything the code calls playable is a pitch that
harmonica can physically produce.

That check is the entire reason the test exists. If it fails, my game is
sitting there listening for a note you cannot make, and then marking you down
for not making it, and you'd have no way of knowing which of you was broken.

It told me I was wrong three times, and each time the code was right, which is
why I wrote a test instead of trusting myself. A G harp is pitched *below* C,
not above, so G4 sits on hole 4 and not hole 1. A#4 isn't on an F harp at all,
and I had to go find a Bb before I could test the case I actually wanted. And
transposing a chart onto its own harmonica isn't the no-op I'd assumed, because
hole 3 blow and hole 2 draw are both G4 on a C harp, so resolving by pitch
alone was quietly rewriting one into the other and telling me it had done
nothing.

But that's not the interesting part.

The interesting part is that the same test, which I wrote to check
transposition, sat down and told me about a bug that has nothing to do with
transposition at all. The set of notes my scorer will accept from your
microphone was built out of blow reeds, draw reeds and bends. Not overblows.
Not overdraws. On a C harp, seven of the eight over-pitches simply were not in
that set, which means any chart asking for an overblow could never be scored.
Ever. Not once. And nothing on screen would have told you why.

Nobody hit it because none of the charts I ship use one. It was going to sit
there until somebody wrote something advanced, and then it was going to look
like a microphone problem, and they'd have spent an evening buying a better
microphone.

Later in the week I found the same kind of thing pointing the other way. My
table of how far each hole bends had every hole capped at a semitone and a
half, which is just wrong. A bend pulls a reed toward the other reed in the
same hole, so how far you can go is however much room is between them. Three
full semitones on hole 3, which is the note you buy a harmonica in order to
play. Nothing at all on holes 5 and 7. The table says that now, and there's a
test comparing it against the physical layout, because two descriptions of one
physical fact will come apart eventually and I'd rather find out from CI.

## Somebody else's files

Harmonicon reads Guitar Pro now, gp3 through gp7, and MuseScore, and MusicXML,
and MIDI. Drop one in a song folder and it gets found and converted and played.

Parsing them was the easy half. The hard half is that a tab file is a whole
band. Bass, comp, melody, usually drums, and I have to work out which of those
you meant. So every track gets converted on its own and fitted to its own
harmonica, because the right harp for a melody is almost never the right harp
for a bass line, and then you get a list telling you what you'd actually be
able to play. "Track 1: 6 notes, 0% playable. Track 2: 100%."

If a track is called Harmonica it wins automatically, and I learned two
exceptions to that by breaking things. A bass line called Harmonica handed me a
chart with no playable notes in it at all, so being named right no longer beats
being playable. And drum tracks now report zero notes on purpose, because their
frets are drum kit indices, and if you read those as pitches you get a part that
looks entirely reasonable, wins the picker, and then plays nothing whatsoever
resembling the song.

The word "harp" on its own is deliberately not in my list of names to look for.
It matches an orchestral harp. A harp part converted to harmonica is precisely
the unplayable soup the list exists to prevent, and the arithmetic isn't close:
missing a track called Harp costs you one click, matching a real one costs you
a chart nobody alive can play.

All seven of them sit behind one trait in a new crate, so the next format is a
module and a match arm. It cost more than I wanted. That crate went from 5
dependencies to 94, almost all of it zip and everything zip drags along behind
it. I wrote the tradeoff down and slept on it before deciding, which I mention
because I nearly didn't, and the thing that decided it was that zip is what
MuseScore and the newer Guitar Pro containers genuinely need, so it buys three
formats rather than propping up one.

## Which of my detectors can hear a chord

Chord scoring has been in there for ages. It wants every pitch of the chord
present at the same time, which is a reasonable thing to want. What I had never
once checked is whether the pitch detectors can actually deliver it.

So I measured, on a real chord out of a real chart. FFT, which is the default,
hears both notes. NMF hears both notes. YIN, pYIN and MPM hear neither.

And the three that fail don't fail quietly. pYIN and MPM both report an F4,
confidently, a note which is not in the signal, which simply happens to sit
between the two notes that are. So it isn't a chord going unscored. It's a
wrong note strolling into the scorer with its hands in its pockets.

None of which was visible from inside the game. Choosing pYIN in the options
made every chord in every chart unhittable and told you nothing. The picker
says "pYIN, single notes only" now, and if the song you loaded has chords your
detector can't hear, a banner says so.

While I was in there: unplugging your microphone in the middle of a song used
to leave the game convinced it was still connected. Your notes just stopped
scoring, forever, silently. Which is the exact failure I'd built a warning
overlay for the week before, reachable by the more likely route the entire
time, and I'd like it on the record that I found this myself before anybody
else did.

## Three hundred gigabytes

Now this next part isn't about the game at all and you can skip it, except that
it ate two days, so.

My build directory had reached 300 gigabytes.

Two separate reasons, both boring, both mine. A debug binary was 2.41 GB, of
which about ninety percent was debug information for dependencies I have never
once stepped into. And cargo doesn't delete the old ones. So there were
ninety-nine files of over a gigabyte each, sitting there, going back to August,
every one of them a complete binary from some build I'd long since stopped
caring about.

A few profile settings and a sweep later a debug binary is 287 MB, and a clean
build plus the entire test suite leaves the whole tree at 7.1 GB.

While I was in the mood I also found the version number written in four
different places that disagreed with each other, which meant the version the
game showed you in Help / About was one that no release has ever actually
carried. One script bumps all four now, and CI fails in about three seconds if
the tag and the manifest disagree, rather than after four platform builds have
finished uploading.

So: you can play a chart on the harmonica you own, or on the one it was written
for, and either way it'll tell you what that's going to cost you before you
start. And you can hand it a Guitar Pro file, and it'll work out which part of
the band you meant.

1306 tests passing. Still 0.0.x, still early, still on
[GitHub](https://github.com/tcanabrava/harmonicon).
