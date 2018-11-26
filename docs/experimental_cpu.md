This document describes the changes I have made along the way toward re-implementing the CPU in the Mega65 project.   It includes some of the design decisions/rationale/etc.

## Background

Many *many* years ago (circa 2003 or so) I first got the chance to play around with FGPAs and Verilog using a Spartan-3 board made by XESS.  Two of the things I partially implemented (but never really finished) were a 6502 CPU core and a decent chunk of the C64's VIC-II chip.   I got the CPU to (barely) execute some simple instruction sequences.  I actually got the VIC-II to do quite a bit, like support all of the basic text and bitmap modes, including sprites.  I even managed to (sorta) make it cycle accurate with the original, sharing the memory bus with the CPU on alternate cycles.  Later on I got a Spartan-6 and goofed around a bit more, but not much later my wife and I started a family (i.e. kids) and it all got put on the back burner.

Somewhere along the way I heard about the Mega65 project, but I wasn't really in much of a position to do anything with it and thus didn't pay much attention.  Then maybe around 2016 or so I sorta got back into FPGAs and picked up a NexysVideo board.  The first thing I did was work on getting DVI/HDMI output to work on the Artix-7, generating just a simple test pattern.  It was a fun little project, but didn't go much further than that.

Sometime I think in late 2017 I rediscovered the Mega65 project and decided to take a look again.   The C65 has always had a special place in my heart since knew some of the engineers that worked on the project back at Commodore when I'd worked there in the early 90's.  I even managed to score a couple of C65s before I left Commodore.  I've never done much with them though, since there are some things about them that make them a bit of a pain to deal with these days.

Anyway, I was happy to see how far along the project had come, and decided to see if there was anything I could do to help.  The first thing I had to do was get the existing codebase working on my NexysVideo board, which gave me a chance to become more familiar with the codebase.

After making things work on the NexysVideo, I helped get the project working on Vivado, since ISE was just way too painful.  Unfortunately, ISE had been inferring certain things from the VHDL that it probably shouldn't have, but the Mega65 codebase really had come to depend on that inference.  Fixing things to work with Vivado required doing a lot of surgery to both the GS4510 and VIC-IV code bases.

In the back of my mind I kept thinking back to my old 6502 implementation, wondering if I could maybe just redo the whole thing with that.  Then reality set in.  The GS4510 feature set was a long way from a 6502, and I'd never really finished my 6502 anyway.

However, once I got things working with Vivado, I set out to get my 6502 working again.  After many many months of effort and a complete change to the way the whole thing was structured (largely around how the microcode was implemented), I finally had a decent 6502 implementation.  I then set out to add the 65C02 stuff, thinking it'd be a good stepping stone to a 65CE02 and perhaps later the 4510.

In the meantime though I didn't really have anything interesting I could do with it.   But, last summer while on vacation (yes, I write Verilog and 6502 assembly code for "fun" on my vacation), I set about to redo the Mega65 UART monitor using my 6502 core, a bit of extra helper logic, and a chunk of 6502 assembly.  Of course I did all this in secret mostly because I didn't want to promise anything to the Mega65 project maintainers I couldn't actually deliver, and partially because I didn't know how they'd react.

The good news was, aside from the fact I'd used Verilog instead of VHDL (much to Paul's dismay, I fear), I think it was pretty well received, and in the meantime it has allowed the monitor to gain some pretty significant and useful features.   And it's way smaller, to boot, using about 25% of the FPGA resources of the original monitor.

However, what I really had my sights set on was replacing the main CPU core itself, for a number of reasons.  Partly because I thought it'd be an interesting challenge, but partly because I felt like the GS4510 code was written in too "functional" of a coding style that was leading to a very large implementation in the FPGA.   It certainly works and is clearly synthesizable, but IMHO it also uses way more resources in the FPGA than it needs to.

That being said, I need to give proper credit to Paul Gardner-Stephen and everyone else because had I not had the existing "reference" design to work with (so that I could have something functional from day one), I probably never would have gotten started.  It would have just been too daunting to go from ground zero to a fully functional C65 clone.  

The truth is, I've had a *ton* of fun getting the chance to play around in this codebase for a while now, and it's really allowed me to hone my Verilog and VHDL skills as a hobbyist.

So, my next "secret" project was to tackle replacing the GS4510.  I have no allusions that the Mega65 folks will adopt my core at all, and I really have done it largely because it was just something interesting to do.

That being said, I do hope that perhaps some of the other architectural changes to Mega65 overall might be interesting enough to consider at some point, even if only in spirit.  Unfortunately, my codebase has had to deviate from the mainline development effort significantly in ways that don't make it easy to just "drop in" at this point, but I hope to close the gap over time as I can find the time.

## 65CE02

Before I could really do anything, I had to tackle getting a proper 65CE02 core up and running.  I started trying to do this as a modification to my 65C02, but I very quickly determined that the 65C02 datapath was really nothing like the one the 65CE02 used.  So, I had to basically start all over again.  After a number of false starts, I finally sat down with OmniGraffle and tried to plan things out as best I could, again trying to pay homage to the original 65CE02 based on what very little documentation exists.   I also discovered a [web site](http://www.pastraiser.com) where someone had reverse engineered decent chunks of the 65CE02 CPU, which also helped immensely when I got stuck on how some of the microcode handled certain instructions.  I can't really claim to be any kind of Verilog or CPU design expert, but I figured the guys that did the originals knew what they were doing. ;)

Once I had the basic data path up and running I was able to then do the same work I'd done for the 65(C)02 core and started implementing the microcode instruction by instruction again, making heavy use of Klaus Dormann's existing functional tests.

Eventually I had to move on an start implementing the new instructions that were specific to the 'E'.   For that, I basically ported the shell of Klaus' tests to a different macro assembler, since I needed something that would support the 65CE02/4510 instruction set.

## 4510

The last bit of extended functionality that I had to add to get a proper
4510 implementation was support for the mapper unit.  The GS4510 supports the memory mapper directly, but I had a hunch that the 4510's mapper was actually done mostly external to the 65CE02 core in the 4510.  

My reasoning here was that when CSG did the 4510 microcontroller, they probably wanted to change the existing 65CE02 layout as much as possible.   At most they might have added a few new signals coming out of the microcode PLA in support of the MAP instruction.  So, I also wound up implementing the first version of the mapper as a totally separate thing outside the CPU core itself by snooping the data bus and watching for the core to fetch the MAP instruction (as well as the NOP/EOM instruction).  The core itself implemented the MAP instruction by simply placing the A, X, Y and Z register values on the data lines over the course of four clock cycles. The external mapper logic would then just run a little state machine that would snag those values and use them to update the mapper registers.  

Over time I eventually found it better (in light of the required GS4510 hypervisor support needed for Mega65) to eliminate the external state machine and just have some dedicated signals running out of the CPU core to the mapper unit to tell it when to perform mapper register updates.

## Mega65 Rework

Once I was happy with my 4510 CPU core, I had to shift my focus for a few months toward getting the Mega65 design to a place where it was even remotely possible to drop in a more-or-less "stock" 4510 CPU.

My basic roadmap was going to be to try to iteratively change the Mega65 hardware in baby steps, marching slowly towards a design where all that remained within the GS4510 was the execution core, the memory mapper, and the hypervisor support.   It seemed like almost everything else could have been done externally in a more modular fasion, so I figured this was maybe just potential goodness anyway.  Even if nothing else ever came from all of this, the methodology I used to get to that point will always be in the git repo.

## Address resolver

One of the first things I did was take the chunk of VHDL that was used to generate the 28-bit system address from the CPU core 16-bit address and pull that out into a separate module.   For the most part this was pretty straightforward since the code was already pretty self contained an a VHDL procedure.  But, I figured long term this logic would still be needed for my CPU core, so having it live on its own seemed like a good thing.

## 20 bit physical address space

Given that the existing Mega65 system memory map used a 28-bit physical address and I only had support for the standard 20-bit address space, one of the things I had to tackle was reworking Mega65 to go back to a 20-bit address space.

I actually did this in two stages.  The first was to go from a 28-bit to 24-bit address space, since there wasn't a lot that really relied on having the full address space available.   For the most part I was just able to lop off the top four bits and everything pretty much kept working.

However, dropping all the way back down to 20 bits was more of a challenge because of how the physical addresses of many of the I/O devices had been changed to have an additional two bits in the address.

These two extra bits basically were used to represent whether the VIC-IV was running in VIC-II, VIC-III or VIC-IV mode.  But for what I needed to do, I had to remove that support and go back to standard C64/C65 I/O addresses.   What I did instead of having these two extra address bits was instead plumb through the VIC-IV mode bits directly to the devices that needed to know what mode the machine was in.  For the most part, this was the VIC itself (which already knew) and all of the "new" C65 hardware devices that didn't exist on the C64 that would need to be hidden if the VIC-IV was in VIC-II mode.

One of my other motivations for going back to the smaller physical address space was also to save some resources all throughout address decode logic that was spread all over the design.   Fewer address lines having to be routed through the design should result in fewer resources, which ultimately results in the critital data paths having fewer LUTs.  I do think it would be pretty trivial to expand the address space back to 24 bits without too much difficulty.  Personally though I think anything beyond that is really overkill though given how hard it is given the existing mapper to even make use of 1MB.

## More CPU simplification

The next step I took was to to remove a bunch of additional GS4510 features that didn't actually seem to be used at all yet.  This included the FPU, support for 32-bit operands and some of the flat 32-bit addressing support, the zero page cache, virtual memory page tables, etc.   The Kickstart code didn't seem to use any of this stuff, so I just removed it.

## Bus interface rework

Next, I started working on trying to pull all of the external device selection logic out of the CPU core, or at least as much as I could.
My reasoning here was that the original C65 didn't need to have a bunch of dedicated special busses coming out of the CPU, and the CPU core itself didn't know *anything* about what external hardware it was talking to. In fact, the 4510 in the C65 had to be told via external logic when it was supposed to be accessing the built-in I/O devices, for example.  All of the logic for device selection was done somewhere else.   

The existing Mega65 bus design also had this requirement that the various busses would drive an alternate address when not in use so that devices wouldn't accidentally think they were active, particularly for I/O registers with side effects.  IMHO, this was best solved via dedicated chip select signals like what was done on the real hardware.  By doing it this way, all I/O devices would nominally be able to look at a single unified address bus rather than needing special dedicated ones.

Another thing I wanted to solve was where wait states were generated.  Again, it bothered me that the CPU core had to have explicit built-in knowledge of which devices needed how many wait states.   Again, I figured this should be done externally by the I/O devices themselves (if needed), or at the very least some kind of bus interface controller should handle it.   This was why the original 6502/65C02/65CE02 CPUs had a Ready signal in the first place, to solve exactly this problem.

The other thing I came to realize along the way was that trying to mix and match asynchronous and synchronous devices[^2] was a really bad idea.  It made timing closure really hard, and made the bus signaling even more tweaky than it already was.  So, I modified all of the I/O devices to use registered outputs rather than combinatorial.

Eventually by mid-September I had reworked and refactored the code enough to where I was able to finally pull most of the bus interface logic out of the CPU core entirely and into an external bus interface module.  It wasn't perfect, but it at least let me begin to tease things apart.

At this point certain devices like the hypervisor control logic, DMAgic and CPU port stuff were still part of the CPU core, but almost everything else had been modularized.

## More bus rework and notes on timing

Once I had an external bus interface module, I started reworking how many of the different devices were connected.   I kept trying to simplify things over time, eventually getting to the point where everything that was hooked up to the same shared address bus. Well, almost.

I say almost because at this point (and still to this day) there are really two different "system" address busses.   The first one is that one that is driven combinatorially from the CPU, and thus is available before the next clock edge.  The second is the registered version that is only driven after the next clock.

It turns out that for things like the block RAMs, we can generally meet timing using the combinatorial versions, and this is what lets the Mega65 have essentially zero wait state access to memory.   However, for almost everything else (i.e. I/O devices), there just isn't enough time for all of the I/O device and register decoding to happen in the same clock cycle.  Thus, almost everything but RAM/ROM winds up with a single wait state.   However, that wait state is really only "visible" when the CPU is at full clock speed.   It's invisible when the CPU is at 1Mhz or 3.5Mhz.

## DMAgic

By early October I was pretty happy with how the bus interface had turned out, and I started plotting out how I was going to handle DMAgic.  In the real C65 DMAgic is another chip that sits on the same system bus basically right next to the CPU, but in Mega65 it is part of the GS4510 core.   Given that the GS4510 was also what was doing most of the address generation and decoding (and needed translations), it made some sense that it really had to be done this way.   But for my goal of wanting to replace the CPU core, I was going to have to do something more like the original.

I started out by again trimming what I felt was unneeded functionality from the existing DMAAgic implementation.   I removed a number of features (like fractional byte increments), unneeded high address bits that I hadn't ever gotten rid of, etc.   I also took a stab at reducing the FPGA resource requirements for the DMA list loading by using a small state machine rather than having a bunch of routing chained through all of the registers.

Somewhere in this timeframe I also finally split the CPU address resolver off into its own component entirely.  I did this because DMAgic wasn't going to need to use it, and my plan was for my DMAgic to have a direct interface to the bus interface as it would be generating C65 system addresses (and/or I/O enables) directly.

One of the other problems I had been trying to figure out how to deal with along the way was the GS4510 support for flat 32-bit indirect addressing.   I had tried coming up with various ways to fit that into my CPU design, but there really wasn't any good way to do it.  It was just not a good fit for the way the CPU worked.  I was either going to have to double the size of the microcode (which I was maybe going to need to do at some point anyway for proper NMOS 6502 suppport), or I was going to have to do something equally bad.

However, after starting the DMAgic implementation it occurred to me that maybe DMAgic itself could handle this.  The idea was that because DMAgic had direct access to the "flat" machine address space, it would be pretty trivial to have it do an access on behalf of the CPU.  In fact, the existing Kickstart code has existing subroutines to do exactly this by using DMA lists to read arbitrary addresses.   But, the overhead of doing that is really high, and having to modify DMA lists on the fly just to read an arbitary byte in memory is really a pain.

But, another approach might be to have a dedicated set of DMAgic registers that the CPU can use to read/write system memory by first programming in an address, and then doing another read (or write) to a data register that then performs a one byte DMA access.   This is very much like what the new monitor does when it wants to access memory on the C65 side.  By doing it this way, it'd let me eliminate the requirement that the CPU have direct support for 32-bit flat addressing, which was being used in quite a few places in the kickstart code.

So, this is basically what I did.  But, along the way I realized I could do something even more useful.   I could have both a base address register and an index register that could optionally auto-increment after each access.  Also, if the index register wraps around while incrementing, the base address register increments by 256.   I did it this way so that if you're just modifying the index register directly you can do so without having to worry about page crossing boundaries, and you can always just reset the index back to zero.

The new registers are defined like this:

```
dmagic_pio_base_addr   $d710-$d712   ; 20-bit base address
dmagic_pio_index       $d713         ; 8-bit index
dmagic_pio_data        $d714
dmagic_pio_data_inc    $d715
```

The nice thing about doing it this way is that these registers don't have to be re-fetched from memory, unlike an indirect 32-bit flat address pointer.   This wound up making the DOS sector copy loop both simpler and faster, as well as no longer neeing any special CPU support.  This felt to me like a more natural way to give the CPU easy access to a bigger address space without requiring fundamental changes to the instructions set architecture.  It's also easy to expand to either support larger addresses (24-bit would be trival), or additional base/index registers if desired.  In many ways it's almost like giving the CPU more address registers.  And you could even redirect the CPU's base page to the DMAgic register bank, and then you'd only need a 3-cycle zero page instruction plus a 2 or 3 cycle I/O access to reach anywhere in memory.

Once I had all of this working, I was able to eliminate the special 32-bit flat addressing support from the GS4510 core since it was no longer needed, thus eliminating the last thing at the instruction set level preventing me from being able to use a different CPU core.

Getting back to the new DMAgic implementation, the other thing I had to implement to get all of this to work was a new bus arbiter module.  Because both the CPU and DMAgic would be able to drive the bus interface module independently, I had to have a module sitting in between them all making the decisions about which device would get the bus next.  Of course, further complicating things was the fact that the very first thing I was trying to implement meant that I'd also have to support DMAgic being able to take over the bus from the CPU when it was in the middle of an I/O bus cycle!   It turned out not to be hard to do this, though.  DMAgic knows when it is doing a bus access on behalf of the CPU, and thus was able to provide a special request signal to the arbiter that tells it what needs to happen in that special case.

Now that I had this working, it was time to finish the rest of the DMAgic implementation.   It was all pretty straightforward and winds up running a state machine not all that dissimilar to what GS4510 did.   The trickiest bits were mostly in driving the bus interface signals exactly right during each state so that I could perform a read and write on each cycle.

Interestingly, one "defect" that still remains is that DMAgic currently always runs at full CPU clock speed and doesn't honor the 3.5Mhz C65 CPU clock timing mode when it probably should.  This would be pretty straightforward to fix, I just haven't gotten around to it yet.

One fun thing I did during the new DMAgic bringup was to hook up a switch on the FPGA board so I could change the implementations on the fly. That way I could boot with the GS4510 version enabled, and then switch to the new one and run a test to see if the new one was working.  It was very useful.

Eventually I was happy with the new implementation and then decided that it really was too monolithic of a design, so I rewrote it in Verilog (Sorry, Paul), and just recently SystemVerilog.  IMHO one of the problems I have with VHDL is that doing properly modular designs is so painful because it's just so verbose to do so.  This is something that SystemVerilog is *really* good at, as it turns out.

Now that the new implementation was working, I was able to remove all of the DMAgic stuff from GS4510.

## UART Monitor

Now it was time to pull the monitor support out into a separate bus master alongside the CPU and DMAgic.   This was fairly straightforward, although in the name of expediency I let things regress a bit when I first did this.  I left intact the ability to dump memory and such, but I temporarily lost the ability to monitor CPU state, perform tracing/single stepping, and a few other things in the short term.

Once nice side effect of having the UART monitor have its own memory interface is that it should make it easier (perhaps with more help from the bus arbiter module) to have the monitor "lock out" the CPU from performing any memory accesses.

## Speed Emulation

The next thing I decided to tackle was the slow CPU speed emulation stuff.  Because my CPU core already executed all instructions in the same number of clock cycles as a real 65CE02, I figured I wasn't going to need anything as complex as what GS4510 was having to do here, so I drastically simplified the logic down to the point where I really only had the "ready" signal feeding into the CPU core like I was going to have with mine.

I also wound up implementing a way to flip a switch on the FPGA board to emulate half-speed mode.  I did this because it helped shake out various bugs in the bus ready logic that kept creeping up every now and then.  I'd find cases where things would work right at full speed most of the time, but sometimes with slower speeds things would be a bit goofy.   More on this later, I suspect.

## Hypervisor

Throughout this entire process, dealing with the hypervisor stuff was what I was dreading the most.  For months I'd been thinking of how I was going to make this work (if at all).

I think my initial thought was that I'd just rip out all the hypervisor stuff from Kickstart and "deal with it later", but over time it became clear that this really wasn't viable unless I wanted to hardcode all of the ROMs into the FPGA bitstream.  That might have been ok for an experiment, but probably not ok for anyone else (assuming anyone but me would ever get to see any of this anyway).

So, my first attempt (along the lines of the mapper support) was to try to come up with some tricky way to do this all with a combination of external logic and some additional software support.  I figured if I was going to snoop the CPU bus looking for MAP/EOM sequences, I could also do other tricks like interpose the bus entirely and then feed the CPU alternate instruction sequences or something to fake a hypervisor trap.  Then I could have a small trampoline routine that would save off the rest of the CPU state to hypervisor registers (where Kickstart was expecting them to be), and then do something similar upon exit.  I kinda got this working, but it was really tweaky and fragile and just seemed like I was forcing myself not to touch the CPU core for no particular good reason.

Another aborted attempt involved trying to find some way to do what I needed via special hidden microcode sequences, using empty space in other instructions.  But, that just made a mess out of the timing logic and also never quite worked right.

I then took a step back and really started to think about what the CPU was missing from it's instruction set to turn this into more of a software problem.  At the end of the day, a hypervisor trap really just needs to be able to save and restore the CPU state without losing information.   

CPU interrupts would almost work here, except for a couple of annoying problems:

* The state of the E bit isn't restored by an RTI
* There's no guarantee the stack is always in a good state to allow an interrupt

Fixing the first problem would be easy, since it'd be pretty trivial to have RTI restore the E bit if we're executing an RTI from hypervisor mode.  It'd only take a few new control signals for that.  But the stack pointer was a major problem.

Eventually I started to think back to supervisor mode in the 68000.  What made that possible was that the dedicated SSP register that was not accessible to user mode, and thus could always be guaranteed to be in a good state.

So I thought, why not just add another stack pointer?  It turned out that it wasn't even all that big of a change to the data path in the CPU because I just had to have the hypervisor mode be known to the CPU data path and thus control which stack pointer was to be used.

However, that posed another problem.... how would I access the user stack pointer from hypervisor mode?  I hated the idea of plumbing dedicated read/write access to internal CPU registers, but I also absolutely needed to be able to save/restore the user stack pointer in software.

Well, I cheated.  What I did was make the executive decision that in hypervisor mode we don't really need the stack to be able to operate in both 8-bit and 16-bit mode on the fly.   We can just pick one or the other.  The only reason it's switchable in the 65CE02 is for backwards compatibility with software that wouldn't work right if the stack didn't wrap by default.  But in hypervisor mode we can just pick a mode and stick with it.  For now it stays in 8-bit mode because that's what the current hypervisor mode did, but it's a single line of code change in the CPU to make hypervisor mode always use 16-bit mode.

I took this route because I could now (ab)use the E bit (and CLE/SEE) instructions to control switching between the user stack registers and the hypervisor stack registers.  And with that little trick, I could now perform a complete hypervisor entry totally in software, with only a little bit of extra external hardware support, and some CPU support for a HYP interrupt that's separate from IRQ and NMI.

I also had to deal with the 4510 mapper registers in a similar way.   So, in this case I also upgraded the mapper to have dual mapper register files as well.  The MAP/EOM instructions only modify the "current" set of mapper registers, but the hypervisor controller also provides direct read/write to the user mapper registers.

In my hypervisor controller, the main bit of functionality has been reduced to just having a set of registers to control the trampoline entry point for hypervisor traps, and another set of registers that records where the "real" hypervisor entry was supposed to be.  Upon hypervisor entry, the CPU first jumps to the trampoline routine that saves all CPU and other machine state, then sets up the proper state for the trap routine and does an indirect jump through the hypervisor registers that have the trap address in them.   The trampoline address is currently programmable, but defaults to using $8200 (which winds up mapped to $f8200).

Note: In retrospect the performance overhead of always hitting the trampoline entry point first might be too high.  I did it mostly for quick compatibility with the existing trap entry points.  But another approach might be to just use a vectored hypervisor interrupt, and let the traps themselves decide how much CPU state they need to save and restore.

## New CPU Core

So with this new hypervisor design in hand, it was time to take the final plunge and try dropping in my 4510 core.   This took probably about a solid four days of wiring everything together and getting the machine to boot up again.

Not surprisingly, changing out the CPU core exposed a number of issues in the bus interface that got exposed by the fact that my CPU core is totally evil and has combinatorial paths all the way from the data input signals to address and data output signals since that's the only way (with the current 1:1 ratio of CPU clock cycle to bus clock cycle) to have single cycle execution while also being able to talk to synchronous devices like the block rams.  I wound up having to fix all kinds of various things I didn't run into with the GS4510 core since it always takes at least one more cycle to latch the data input.

Another issue I ran into along the way was that much of the Kickstart code that used DMAgic assumed that it ran serially with the CPU, but that's not 100% true any more.  There are some dead cycles present when DMAgic isn't using the bus that the CPU gets to use, and in some cases the Kickstart code was changing I/O mappings immediately after triggering a DMA operation, which was leading to DMAgic stepping over the wrong device's memory.  My approach here was to implement the DMAgic "busy" bit that existed in the original, and have the Kickstart code poll that for completion.

Annoyingly, once I got to where I'd boot past Kickstart and land in C65 mode, things were no longer stable.  I eventually tracked this down to a bug in the interrupt handling logic in the new CPU in the presence of wait states that I hadn't tripped across in all my previous unit testing.  Once I fixed that, things immediately were stable and I could even run Bouldermark!

The most disappointing thing though was that I had to drop the clock speed down to the 30Mhz range to make timing.  I knew that the combinatorial path from input to output might be an issue, but I hadn't quite internalized just how bad it was going to be in practice.  This was a case where the GS4510 was better in the sense that it buffered the input data and mine didn't and thus could run at a higher clock speed.

I was eventually able to claw back timing closure somewhat and can now run with a 33.3Mhz CPU clock.  I reworked the mapper to use distributed RAMs for the offset/enable lookups to save a new nanoseconds along the critical timing path.  The downside though was that shaving off those few nanoseconds in the mapper meant that updating the mapper registers now takes 16 clock cycles after the MAP instruction executes because I can only update one entry per cycle due to how LUTs work when used as a RAM.  So, to make sure that the CPU doesn't try to perform a mapped access before that completes, I had to plumb a busy signal from the mapper to the bus ready logic to make sure that the CPU gets held off until the mapper finishes.   In 3.5Mhz mode the extra cycles are likely to be barely noticeable because the extra 16 clocks happen at the full CPU speed.

However, the 33.3Mhz clock speed versus 40Mhz wasn't necessarily bad news.  While the clock speed is lower, the new CPU core can actually execute things in fewer cycles than GS4510 can, which more than makes up the difference.  I get a Bouldermark score of 35,865, which almost 40% faster than the approximately 25,649 GS4510 gets at 40Mhz, at a 16% slower clock speed.

Also, my other goal of having a smaller CPU core in terms of FPGA resources also panned out.  By the time I got GS4510 down to mostly just the execution core, hypervisor and cpuport stuff, it was still well north of 3000 cells in the FPGA.  Mine clocks in around 1200 or so if you add in the the hypervisor module and cpu port.  It's hard to do a direct comparison with the current "stock" design because so much of the other functionality has been torn out or modularized into other components.  But, last I looked the stock GS4510 was over 8000 cells.  Tallying up my new versions of everything (including DMAgic and other other pieces that are now modular) comes up to around 2300 or so[^3].

## Big Scary Merge of Doom

Of course, while I was doing all of this from my evil lair, the rest of the Mega65 project was moving forward too.  It wasn't going to be reasonable to show up and say "hey, look, new CPU core!", even if it was only an experiment if my code was basically stuck with how things were in July.

So, I now had to attempt to merge as much of the current tree back into mine as I could.   I really wanted all of the recent video stability fixes and the new monitor stuff, but I knew that anything that touched the CPU core was going to be very problematic since I'd basically ripped it all to shreds compared to the other branches.

Amazingly, I was able to do the raw merge in about a day, doing it in stages based on the different milestone branches in the main Mega65 tree.  As I exepected, the CPU changes around the secure mode stuff were the most problematic, although the CIA I/O stall stuff also had to be completely redone in a different way.   In my case I wound up plumbing ready signals directly from the CIAs rather than have the CPU know why its being stalled.   The CIAs now always add some wait states after any register write to let the I/O port values "settle", which is what makes the keyboard work right in full speed mode again.

As for the new secure mode stuff, I basically punted.  This will require me to figure out how to fit this into the new CPU/hypervisor architecture, and I don't fully have my head wrapped around how it's supposed to work.  So, all the fancy new Matrix mode stuff is pretty much broken at the moment, although you can still use the monitor from the serial port.

## Future Plans

I don't yet know what (if anything) is going to become of my changes.  As I said, I somewhat did it for my own personal amusement, but I also thought that it might demonstrate some alternate ways of breaking down some of the technical problems the Mega65 team has been trying to solve.

One thing I think still really needs to be addressed is how the bus protocol works between the CPU and all the other devices.  The combinatorial feedback paths in the current design are very long, and also make the logic a lot more complicated than I think it should be.

An idea I've been mulling around in my head would be to switch the CPU core to run at a higher clock frequency, but break the bus accesses down into multiple cycles, perhaps similar to how the 68000 worked.  By doing so I believe the bus arbitration protocol could be made easier to work with since each memory access could be thought of as an indivisible operation.  As things are now, the crazy pipelining stuff that has to deal with overlapping memory accesses is really confusing and very easy to get wrong in some subtle ways that are hard to debug.

The basic breakdown of the logic time currently looks like this:


Path                                    | Routing Delay
:---------------------------------------|-------------:
BRAM clock edge to CPU input routing		|          8ns
CPU input to mapper RAM                 |          6ns
mapper ram to address resolver LUT      |        3.4ns
address resolver to RAM                 |        8.8ns

Total cycle time is ~26.2ns, or ~38Mhz.

Rearranging the data to break things down between the CPU paths and the memory paths:

Path                                    | Routing Delay
:---------------------------------------|-------------:
CPU + mapper                            |        9.4ns
Adress resolver + BRAM routing          |       16.8ns

The real bottleneck here is the memory access time.  In theory this could be broken down into something like 3 10ns clock periods using a 100Mhz clock and would have an effective speed of 33.3Mhz pretty much like I have today, but then all of the input to output paths could be eliminated. On the other hand, the idea of a 3:1 ratio makes me twitch.   4:1 would be better in some ways since the bus could support two 2-cycle accesses, and something else could alternate with the CPU (like DMAgic, VIC, etc.).   But then we might only have a logical CPU clock speed of 25Mhz.   It might be possible to push this to 28Mhz though, which at least would be a nice logical pixel clock speed and a good multiple of the various clocks used in the original C65.

Other TBD items:

* Restore all the expected monitor functionality somehow so things like breakpoints/tracing/etc. work.
* Fix the 6502 speed emulation.  This involves adding logic somewhere to detect all of the instructions that need extra cycles added.  Branches are tricky though since it depends on taken versus not for 100% accuracy, and page crossings also come into play.  Another option might be to have optional states in the microcode that only get used in 6502 compatibility mode.   The absolute worst case scenario might be to have a full on second copy of the microcode sequences that adhere more closely to the 6502 versions, which would also let me consider supporting the "undefined" 6502 opcodes to some extent.
* Document how the current bus interface works.
* Fix DMAgic's timing to honor the CPU speed.
* Figure out the secure mode stuff and get matrix mode all happy again
* Figure out if I want to rework the bus/cpu clocking architecture
* Figure out if any of this is remotely interesting to anyone but me. :)
* Document the existing data path in the CPU.  It no longer matches what my original OmniGraffle document shows because I wound up adding some dedicated ALU units for some address calculations in order to shorten the critical paths.
* Consider if there's any reasonable way to do the new stuff in VHDL.  My old VHDL DMAgic is in the git repo and could be updated to match the new SystemVerilog version without too much effort.  It'll just be a lot more verbose.  The CPU microcode has no solution I can think of that doesn't involve external tooling.  No preprocessor and ternary operator really hurts VHDL here. :(

[^1]: Well, everything but the undefined opcodes, anyway.

[^2]: By this I mean devices that require a clock edge to register their outputs versus those that would drive their output only via combinatorial signals.

[^3]: It's a little tricky to extract this information from Vivado because you have to force the synthesis tools to not perform cross-module optimizations, which causes all of the totals to get messed up since the architectural boundaries no longer line up with the original code.