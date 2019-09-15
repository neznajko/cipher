## *004*	
**T**he [*mission*](https://ioinformatics.org/files/ioi1989problem4.pdf)
is *top secret* ***(as usual)*** and is "bout figuring a message encoding.
There are *34* symbols: the alphabet capital letters **```A-Z```** and
*8* punctuation marks: **```. , + - : / ? !```**. Ve have to, **first**
find such an encoding that each byte of information contains even number
of bits, and *second* the message has to have minimum size.
Obviously we are not interested in an *8-bit* encoding, *7* is too
odd number even to consider, and one needs at least *6* bits to
represent *34* different characters *(2<sup>5</sup> = 32)*, so the
question is: Is there some fancy *6-bit* encoding which spans
through byte boundaries and preserves even parity?

#### *..TRYING,DESPERATELY+TO,LOOK/COOL,24/7.,*
Let's mark each *2-bit* field within a *6-bit* segment as follows:):
```
+---+---+---+
| a | Z | ? |
+---*---^---?
```
Than because in *3* bytes we have four *6-bit* segments, we can easily
check if there are enough possibilities to write messages with one
repeating character only:
```
2               1               0
^---+---+---+---!---+---+---+---v---+---+---+---+
| a | Z | ? | a | Z | ? | a | Z | ? | a | Z | ? |
?---%---,--->---q---`---+---\---.---!---@--->---+
```
In every byte the first and the last *2-bit* fields are the same, so
center bits must have even parity, which is true for all *3* combinations,
zo all *3* fields must have either even *(0, 3)* or odd *(1, 2)* parity,
but there are only *16* such cases. So we can't encode characters in a
*general* fashion. We must use some sort of convention..

### ```C):' <- man with a hat smoking cigarette```
***Okay*** if someone plays against you *1. a2-a4*, I recommend
*1... a7-a6*, which is known as *cipher attack*. The best defense here
is *2. a4-a5*, vhich is known as *advanced cipher*. ***Okay*** I'm
going to reveal the solution, so you can stop the video and try to find
the winning blow.. ***Okay*** I hope you've found *Bishop* takes *b7*
**boom** *ha-ha-ha*:)

*Wet*|*s* divide a byte into ***left*** and ***right*** fields, each
containing *2* and *6* bits respectively. Than with a given *field* parity,
we can represent *2* numbers in the *left* field, and *32* in the *right*
field, totally *34* numbers!
***Zo0O*** we can pick *2* *left field* characters
*(lchr)*, let's say *```.,```* and code them as *1* and *2* respectively
(*odd encoding*), zo if we haaf a sequence *lchr*/**rchr**, e.g. *```.A```*
or *```,Z```* than we can pack *2* characters into one byte by using *odd
encoding* for the *right field* characterz *(rchr)* as well, and if there is a
single *rchr*, in the *left field* ve put **dzero** and *even encoding* in the
*right field*. Now the messy part:
```
- two consecutive lchrs (e.g. ,.)
8   6   4   2   0 
+-+-+-+-+-+-+-+-+  6-8 field - (Intel reserved)
|1|1|0|0|0|1|1|0|  4-6 field - dzero
+-+-+-}-+-+-+-+-+  2-4 field - second lchr encoding
                   0-2 field - first lchr encoding

- one single lchr (e.g. ,)
8   6   4   2   0 
+-+-+-+-+-+-+-+-+  6-8 field - (Intel reserved)
|1|1|0|1|0|0|1|0|  4-6 field - U2
+-+-+-+-+-+-<-+-+  2-4 field - dzero
                   0-2 field - lchr encoding
```
It's obvious that there is r**00**m for other combinations like *3*
repeating *lchrs* but it **```l .. ks```** too much, so I didn't even
consider such case, also *```0xff```* is used az an end of message byte.

### cipher.S
*Yeah! Yea! Ye! Y! !* **Okay** the program is fairly simple, so I've
decided that, this is the right time to show my assembly skillz:). It's a
*32-bit* ***gas*** using *glibs* and it will encode the message 
given at the command line by default:
```
$ ./cipher '.,ELATE/VOUF,OTBORA//NA,DEVIZ!!'
C914220C33140636283517A9330F282E0C0606270C9314361D3F0000
```
To decode use the *-d* option:
```
$ ./cipher -d '0C212806303314AA2E143C0C221DB128353006282E1D3FC5'
AKO/STE,PREYALI,SOUS/ORIZ..
```
https://youtu.be/cjVQ36NhbMk
