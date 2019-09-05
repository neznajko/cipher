## Top Secret
***Okay*** this time the mission is to figure an encoding. There are *34*
symbols: the alphabet capital letters *A-Z* and *8* punctuation
symbols ***. , + - : / ? !*** In the [*assignment*](https://ioinformatics.org/files/ioi1989problem4.pdf)
ve have ***first*** to find such encoding that each byte of information
contains even number of bits, and *second* the encoded message has to
have minimum size.

Ve need at least *6* bits to represent *34* different characters
*(2<sup>5</sup> = 32)*, obviously we are not interested in an *8-bit*
encoding, *7* is too odd number even to consider, so the question is:
**C**an we find some fancy *6-bit* encoding which spans through byte
boundaries and preserves the even parity? Actually it can be proven that
it's impossible!

#### *..TRYING,DESPERATELY+TO,LOOK/COOL,24/7.COM.,*
Let's mark each *2-bit* field within a *6-bit* segment as follows:):
```
+---+---+---+
| a | Z | ? |
+---*---^---?
```
Than BEK**oo**Z in *3* bytes ve hafe four *6-bit* segments, ve can easily
check if there are enough possibilities to write messages with one
repeating character only:
```
2               1               0
^---+---+---+---!---+---+---+---v---+---+---+---+
| a | Z | ? | a | Z | ? | a | Z | ? | a | Z | ? |
?---%---,--->---q---`---+---\---.---!---@--->---+
```
In every byte at the flanks we have repetitions, so center fields must
haav even number of set bits, vhich is true for all *3* combinations, zo
all *3* fields must hafe  either even *(0, 2)* or odd *(1, 3)* values, but
there are only *16* such cases. So we can't encode characters in a
***general*** fashion. We  musta use some sort of convention..

### ```C):' <- man with a hat smoking cigarette```
***Okay*** if someone plays against you *1. a2-a4*, I recommend
*1... a7-a6*, which is know as *cipher attack*. The best defense here
is *2. a4-a5*, vhich is known as *advanced cipher*. ***Okay*** I'm
going to reveal the solution, so you can stop the video and try to find
the winning blow.. ***Okay*** I hope you found *Bishop* captures *b7*
**boom** *ha-ha-ha*:)

***Okay*** ve divide a byte into *left* and *right* fields, consisting of
*2* and *6* bits respectively. In the *right field* ve can haaf
*64* numbers: *32* vith odd and *32* vith even parity, in the *left field*
ve haav the same scenario but with only *2 plus 2* numbers. Did you
notice already that *32 + 2 = 34* equals the number of symbols ve hafe to
code:). ***Z.o0O*** we can pick *2* characters let's say *.,* and code
them as *1* and *2* respectively, this will be *left field characterz*,
zo if ve haaf a sequence *.A* or *,Z* ve can pack *2* characters
into one byte by using the *odd* encoding for the
*right field characterz*. For single *rchrs* in the *lfld* ve put
**dzero** and the *even* encoding in ze *rfld*. This looks nice and clean,
now the messy paat:
```
- two repeating lchrs (e.g. ,.)
8   6   4   2   0 
+-+-+-+-+-+-+-+-+  6-8 field - 3 (Inter leserved)
|1|1|0|0|0|1|1|0|  4-6 field - dzero
+-+-+-}-+-+-+-+-+  2-4 field - second lchr encoding
                   0-2 field - first lchr encoding

- one single lchr (e.g. ,)
8   6   4   2   0 
+-+-+-+-+-+-+-+-+  6-8 field - 3 (Intel reserved)
|1|1|0|1|0|0|1|0|  4-6 field - U2
+-+-+-+-+-+-<-+-+  2-4 field - dzero
                   0-2 field - lchr encoding
```
It's obvious that there is R**oo**M for other combinations like *3* repeating
*left chrz* but it L**oo**KS too much, so I didn't consider such scenarios,
also *0xff* is used az an end of message byte.

### cipher.S
*Yeah! Yea! Ye! Y! **Okay*** I've decided nobody understand nothing so the program is
written in *gnu assembly*, joking, actually was worrying that I'm going to
fòrget how to write in assembly, by the way *phyton* comes from *Monty Phyton* not
from snake, anyway.. It's a *32-bit* gas using *glibs* and by default it will encode:
```
./cipher '.,ELATE/VOUF,OTBORA//NA,DEVIZ!!'
C914220C33140636283517A9330F282E0C0606270C9314361D3F0000
```
To decode use *-d* option:
```
$ ./cipher -d '0C212806303314AA2E143C0C221DB128353006282E1D3FC5'
AKO/STE,PREYALI,SOUS/ORIZ..
```
And basically that's it.

https://youtu.be/qFLhGq0060w
