# Sharemind Bytecode Reference

This document describes the bytecode format used by the Sharemind Virtual
machine.


## Bytecode Instruction Representation

The bytecode consists of 8-byte (64-bit) blocks.
Each 8-byte block represents an instruction code, or argument data.
The block size of 64 bits was chosen to be wide enough to be used for immediate
values and pointers of the underlying hardware architecture.
This is needed to implement [direct-threaded code](
https://secure.wikimedia.org/wikipedia/en/wiki/Threaded_code#Direct_threading).


### Legend for Instruction Formats

Bit notation is big-endian, e.g. `0x2d` is denoted as `00101101`.

| Symbol | Description |
|--------|-------------|
| `0`    | unset bit   |
| `1`    | set bit     |
| `.`    | undefined up to this point, might not be part of any instruction, 0 by convention |


<a name="format"></a>
### Instruction Format Base
The instruction format base specifies a base layout for all instructions.
It only uses the 2 first bytes of the 8-byte block to denote the instruction
type.
The last 6 bytes are instruction-specific.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |
|----------|----------|----------|----------|----------|----------|----------|----------|
|`NNNNNNNN`|`TTTTTTTT`|`........`|`........`|`........`|`........`|`........`|`........`|

  * `NNNNNNNN` - [namespace](#namespaces) of instruction
  * `TTTTTTTT` - namespace-specific type of instruction
  * 6 bytes of instruction subtype

An instruction may be followed by a fixed number of 8-byte blocks containing the
instruction arguments depending on the specific instruction.


<a name="dtb"></a>
### Data Type Byte Format

The data type byte defines a data type of the virtual machine.
The first 4 bits of the data type byte define the format of type and the last 3
bits define the width of its values.
The 5th bit of the data type byte is currently reserved.


#### Data Types (4 most significant bits)

| Name  | Value | Description             |
|-------|-------|-------------------------|
| uint  | 0x00  | unsigned integer        |
| int   | 0x10  | signed integer          |
| float | 0x20  | IEEE 754 floating-point |

_FUTURE fixed-point number types can be added here. For examples, see:
<http://www.open-std.org/JTC1/SC22/WG14/www/docs/n1169.pdf>._


#### Data Type width (3 least significant bits)

| Name     | Value  | Description        | In use?                          |
|----------|--------|--------------------|----------------------------------|
| variable | `0x00` | variable width     | Reserved                         |
| fixed8   | `0x01` | 1 byte (8 bits)    | Yes                              |
| fixed16  | `0x02` | 2 byte (16 bits)   | Yes                              |
| fixed32  | `0x03` | 4 byte (32 bits)   | Yes                              |
| fixed64  | `0x04` | 8 byte (64 bits)   | Yes                              |
|          | `0x05` | 16 byte (128 bits) | Reserved for IEEE 754 quadruple? |
|          | `0x06` |                    | Reserved                         |
|          | `0x07` |                    | Reserved                         |


#### Table of all currently allowed data type byte values

| Alias   | Type  | Width   | Value  |
|---------|-------|---------|--------|
| uint8   | uint  | fixed8  | `0x01` |
| uint16  | uint  | fixed16 | `0x02` |
| uint32  | uint  | fixed32 | `0x03` |
| uint64  | uint  | fixed64 | `0x04` |
| int8    | int   | fixed8  | `0x11` |
| int16   | int   | fixed16 | `0x12` |
| int32   | int   | fixed32 | `0x13` |
| int64   | int   | fixed64 | `0x14` |
| float32 | float | fixed32 | `0x23` |
| float64 | float | fixed64 | `0x24` |


<a name="olb"></a>
### Operand Location Byte Format

The operand location byte denotes where the actual data of the operand resides.

| Name      | Value  | Used by           |
|-----------|--------|-------------------|
| imm       | `0x01` | Most instructions |
| reg       | `0x02` | Most instructions |
| stack     | `0x04` | Most instructions |
| ref       | `0x08` | common.proc reference pushing instructions and common.mov |
| cref      | `0x10` | common.proc reference pushing instructions and common.mov |
| mem_imm   | `0x20` | common.proc reference pushing instructions and common.mov |
| mem_reg   | `0x40` | common.proc reference pushing instructions and common.mov |
| mem_stack | `0x80` | common.proc reference pushing instructions and common.mov |

Most instructions only use imm, reg and stack to keep the total number of
instructions reasonable.


<a name="intro_abl"></a>
## Introduction to the "arith", "bitwise" and "logical" namespaces

Instructions in the "arith", "bitwise" and "logical" [namespaces](#namespaces)
have one, two or three arguments.
Byte 1 of each instruction specifies the type of the instruction in each
namespace.
The two higher bits of byte 1 (also named the bit prefix) denote its class and
specify the number of arguments for the instruction.
The six lower bits of byte 1 specify the rest of the type for the instruction.
The class can be one of the following:

|  Value in base 2  |  Description           |  Style                |
|-------------------|------------------------|-----------------------|
|              `00` |  unary instructions:   | dest := op(dest)      |
|              `01` |  binary instructions:  | dest := op(src)       |
|              `10` |  binary instructions:  | dest := op(dest, src) |
|              `11` |  trinary instructions: | dest := op(src<sub>1</sub>, src<sub>2</sub>) |

The format of the instructions in these namespaces is the following, for one,
two and three arguments respectively:

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |  arg 2  |  arg 3  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|---------|---------|
|`NNNNNNNN`|`00TTTTTT`|DTB|OLB<sub>dest</sub>|`........`|`........`|`........`|`........`| dest |||
|`NNNNNNNN`|`01TTTTTT`|DTB|OLB<sub>dest</sub>|OLB<sub>src</sub>|`........`|`........`|`........`| dest | src ||
|`NNNNNNNN`|`10TTTTTT`|DTB|OLB<sub>dest</sub>|OLB<sub>src+</sub>|`........`|`........`|`........`| dest | src ||
|`NNNNNNNN`|`11TTTTTT`|DTB|OLB<sub>dest</sub>|OLB<sub>src1</sub>|OLB<sub>src2</sub>|`........`|`........`| dest | src<sub>1</sub> | src<sub>2</sub> |

  * `NNNNNNNN` - [namespace](#namespaces) of instruction
  * `TTTTTT` - type of instruction
  * DTB - [data type](#dlb) of all arguments
  * OLB<sub>dest</sub> - [operand location](#olb) (reg or stack) of the first
    argument (dest).
  * OLB<sub>src</sub> - [operand location](#olb) (reg or stack) of the second
    argument (src).
  * OLB<sub>src+</sub> - [operand location](#olb) (imm, reg or stack) of the
    second argument (src).
  * OLB<sub>src1</sub> - [operand location](#olb) (imm, reg or stack) of the
    second argument (src<sub>1</sub>).
  * OLB<sub>src2</sub> - [operand location](#olb) (reg or stack; or imm, if the
    OLB<sub>src1</sub> is not imm) of the third argument (src<sub>2</sub>).

The first argument (dest) specifies write-only or read-write data.
Other arguments (src, src<sub>1</sub> and src<sub>2</sub>) specify read-only
data.


<a name="fpu"></a>
### Floating point operations

Operations on floating point (float32 and float64) values are handled by the
software or hardware floating point unit (FPU).
The FPU is controlled by the virtual machines FPU state register which can be
read and set using the common.fpu.getstate and common.fpu.setstate instructions.
The bits of this 64-bit register from lowest (0) to highest (63) are used as
follows:

| Bit(s) | Description              | Value     | Value description |
|--------|--------------------------|-----------|-------------------|
| 0      | Underflow detection mode | 0x00      | Detect underflow tininess after rounding (default) |
| 0      | Underflow detection mode | 0x01      | Detect underflow tininess before rounding |
| 1-2    | Rounding mode            | 0x00 << 1 | Round to nearest even number (default) |
| 1-2    | Rounding mode            | 0x01 << 1 | Round to zero     |
| 1-2    | Rounding mode            | 0x02 << 1 | Round to down     |
| 1-2    | Rounding mode            | 0x03 << 1 | Round to up       |
| 3      | Fatal exceptions flags   | 0x01 << 3 | Crash on inexact result (default is not set) |
| 4      | Fatal exceptions flags   | 0x02 << 3 | Crash on underflow (default is not set) |
| 5      | Fatal exceptions flags   | 0x04 << 3 | Crash on overflow (default is not set) |
| 6      | Fatal exceptions flags   | 0x08 << 3 | Crash on divide by zero (default is not set) |
| 7      | Fatal exceptions flags   | 0x10 << 3 | Crash on invalid operation (default is not set) |
| 8      | Active exception flags   | 0x01 << 8 | Inexact result (default is not set) |
| 9      | Active exception flags   | 0x02 << 8 | Underflow (default is not set) |
| 10     | Active exception flags   | 0x04 << 8 | Overflow (default is not set) |
| 11     | Active exception flags   | 0x08 << 8 | Divide by zero (default is not set) |
| 12     | Active exception flags   | 0x10 << 8 | Invalid operation (default is not set) |
| 13-63  | Unused                   |           |                   |

Floating point operations may generate exceptions.
If an exception occurs and the FPU state register has the "Crash on ..." bit set
for that exception, the execution of the process terminates with that exception.
Otherwise just the active exception flag for that exception is set in the FPU
state register.
The virtual machine never clears the active exception flags.
It is the responsibility of the process to clear the active exception flags when
desired.
By default, the "Crash on ..." bits are not set and all raised exceptions are
effectively ignored (this replicates AMD64 default behaviour).


<a name="namespaces"></a>
## Global namespaces

| Name    | Value  | Description             |
|---------|--------|-------------------------|
| common  | `0x00` | common instructions     |
| arith   | `0x01` | arithmetic instructions |
| bitwise | `0x02` | bitwise instructions    |
| logical | `0x03` | logical instructions    |
| jump    | `0x04` | jump instructions       |


## The "common" Namespace (0x00)

| Instruction              | Prefix     | Description      | Implemented? |
|--------------------------|------------|------------------|--------------|
| common.nop               | `0x000000` | no operation     | Yes          |
| common.trap              | `0x000001` | trap             | Yes          |
| common.mov               | `0x0001`   | move value       | Yes          |
| common.proc.call         | `0x000200` | call a procedure from the current code segment | Yes |
| common.proc.lnkcall      | `0x000201` | call a procedure from another linked code segment | No |
| common.proc.syscall      | `0x000202` | call a system procedure | Yes |
| common.proc.return       | `0x000203` | return from the current proceure | Yes |
| common.proc.push         | `0x000204` | push a value onto the next procedure stack | Yes |
| common.proc.pushref      | `0x000205` | push a reference onto the next procedure reference stack | Yes |
| common.proc.pushrefpart  | `0x000206` | push a partial reference onto the next procedure reference stack | Yes |
| common.proc.pushcref     | `0x000207` | push a constant reference onto the next procedure constant reference stack | Yes |
| common.proc.pushcrefpart | `0x000208` | push a partial constant reference onto the next procedure constant reference stack | Yes |
| common.proc.clrstack     | `0x000209` | clears all the next procedure stacks | Yes |
| common.proc.resizestack  | `0x00020a` | resizes the current stack frame | Yes |
| common.proc.getrefsize   | `0x00020c` | gets the size of the given mutable reference in bytes | Yes |
| common.proc.getcrefsize  | `0x00020d` | gets the size of the given constant reference in bytes | Yes |
| common.mem.alloc         | `0x000300` | allocates memory | Yes          |
| common.mem.free          | `0x000301` | frees allocated memory | Yes    |
| common.mem.getmemsize    | `0x000302` | gets the size of the given memory area in bytes | Yes |
| common.mem.getnrefs      | `0x000303` | gets the number of references the given memory area has | No |
| common.mem.dup           | `0x000304` | duplicates the given memory | No |
| common.convert           | `0x0004`   | converts between values | Yes   |
| common.fpu.getstate      | `0x000500` | reads the state of the FPU | Yes |
| common.fpu.setstate      | `0x000501` | sets the state of the FPU | Yes |
| common.halt              | `0x00ff00` | ends program execution | Yes    |
| common.except            | `0x00ff01` | throws an user exception | Yes |


### common.nop (0x000000)

Does nothing, except increment the instruction pointer.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |
|----------|----------|----------|----------|----------|----------|----------|----------|
|`00000000`|`00000000`|`00000000`|`........`|`........`|`........`|`........`|`........`|

No arguments.


### common.trap (0x000001)

Generates a trap signal for the debugger.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |
|----------|----------|----------|----------|----------|----------|----------|----------|
|`00000000`|`00000000`|`00000001`|`........`|`........`|`........`|`........`|`........`|

No arguments.


### common.mov (0x0001)

Moves values from a register or a memory slot to another register or memory
slot, i.e.
```
  for (0 <= w <= W) d[w] := s[w]
```

where `W` is the number of bytes to move, `d` is the destination and `s` is the
source of the data.
If the source or destination of the data is a global register or stack register,
then the data is moved to/from the beginning of the the respective register
(i.e. affecting only the `W` first bytes, the least-significant bytes).

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |  arg 2  |  arg 3  |  arg 4  |  arg 5  | notes |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|---------|---------|---------|---------|-------|
|`00000000`|`00000001`|OLB<sub>src</sub>|`00000000`|OLB<sub>dest</sub>|`00000000`|`00000000`|`........`| src | dest | | | | `if {OLB<sub>src</sub>} ∪ {OLB<sub>dest</sub>} ⊂ { imm, reg, stack }` |
|`00000000`|`00000001`|OLB<sub>src</sub>|`00000000`|OLB<sub>dest</sub>|OLB<sub>destOffset</sub>|OLB<sub>nbytes</sub>|`........`| src | dest | destOffset | nbytes | | `if (OLB<sub>src</sub> ∈ { imm, reg, stack }) ∧ (OLB<sub>dest</sub> ∉ { imm, reg, stack })` |
|`00000000`|`00000001`|OLB<sub>src</sub>|OLB<sub>srcOffset</sub>|OLB<sub>dest</sub>|`00000000`|OLB<sub>nbytes</sub>|`........`| src | srcOffset | dest | nbytes | | `if (OLB<sub>src</sub> ∉ { imm, reg, stack }) ∧ (OLB<sub>dest</sub> ∈ { imm, reg, stack })` |
|`00000000`|`00000001`|OLB<sub>src</sub>|OLB<sub>srcOffset</sub>|OLB<sub>dest</sub>|OLB<sub>destOffset</sub>|OLB<sub>nbytes</sub>|`........`| src | srcOffset | dest | destOffset | nbytes | `if (OLB<sub>src</sub> ∉ { imm, reg, stack }) ∧ (OLB<sub>dest</sub> ∉ { imm, reg, stack })` |

  * `00000000` - namespace "common"
  * `00000001` - instruction type "move value"
  * OLB<sub>src</sub> - [operand location](#olb) for source
  * OLB<sub>dest</sub> - [operand location](#olb) for destination (reg, stack,
    ref or mem_*)
  * OLB<sub>srcOffset</sub> - [operand location](#olb) for source offset (imm,
    reg or stack)
  * OLB<sub>destOffset</sub> - [operand location](#olb) for destination offset
    (imm, reg or stack)
  * OLB<sub>nbytes</sub> - [operand location](#olb) for number of bytes to copy
    (imm, reg or stack)

Arguments:
  1. src - The source operand
  2. srcOffset - The source operand offset
  3. dest - The destination operand
  4. destOffset - The destination operand offset
  5. nbytes - The number of bytes to copy (uint64). Must be greater than 0 if
     OLB<sub>nbytes</sub> is imm.


### common.proc.call (0x000200)

Calls the given procedure from the current code segment.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |  arg 2  | notes |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|---------|-------|
|`00000000`|`00000010`|`00000000`|OLB<sub>proc</sub>|OLB<sub>ret</sub>|`........`|`........`|`........`| proc | | `if OLB<sub>ret</sub> = imm` |
|`00000000`|`00000010`|`00000000`|OLB<sub>proc</sub>|OLB<sub>ret</sub>|`........`|`........`|`........`| proc | ret | `if OLB<sub>ret</sub> ≠ imm` |

  * OLB<sub>proc</sub> - the [operand location](#olb) (imm, reg or stack) of the
    procedure address.
  * OLB<sub>ret</sub> - the [operand location](#olb) (imm, reg or stack) for the
    return value.

Arguments:
  1. A 64-bit address (index of the 64-bit block containing the first
     instruction of the called process).
  2. if the operand location for the return value is reg or stack, the index of
     the register or stack where the return value should be written.
     Otherwise, if operand location of the return value is imm, the second
     argument is omitted, i.e. the return value is discarded.


### common.proc.lnkcall (0x000201)

Calls the given procedure from the given code segment.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |  arg 2  |  arg 3  | notes |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|---------|---------|-------|
|`00000000`|`00000010`|`00000001`|OLB<sub>lunit</sub>|OLB<sub>proc</sub>|OLB<sub>ret</sub>|`........`|`........`| lunit | proc | | `if OLB<sub>ret</sub> = imm` |
|`00000000`|`00000010`|`00000001`|OLB<sub>lunit</sub>|OLB<sub>proc</sub>|OLB<sub>ret</sub>|`........`|`........`| lunit | proc | ret | `if OLB<sub>ret</sub> ≠ imm` |

  * OLB<sub>lunit</sub> - the [operand location](#olb) (imm, reg or stack) of
    the code segment index.
  * OLB<sub>proc</sub> - the [operand location](#olb) (imm, reg or stack) of the
    procedure address.
  * OLB<sub>ret</sub> - the [operand location](#olb) (imm, reg or stack) for the
    return value.

Arguments:
  1. A 64-bit index of the code segment containing the procedure to be called.
  2. A 64-bit address (index of the 64-bit block containing the first
     instruction of the called process).
  3. if the operand location for the return value is reg or stack, the index of
     the register or stack where the return value should be written.
     Otherwise, if operand location of the return value is imm, the third
     argument is omitted, i.e. the return value is discarded.


### common.proc.syscall (0x000202)

Calls the given system call.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |  arg 2  | notes |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|---------|-------|
|`00000000`|`00000010`|`00000010`|OLB<sub>proc</sub>|OLB<sub>ret</sub>|`........`|`........`|`........`| proc | | `if OLB<sub>ret</sub> = imm` |
|`00000000`|`00000010`|`00000010`|OLB<sub>proc</sub>|OLB<sub>ret</sub>|`........`|`........`|`........`| proc | ret | `if OLB<sub>ret</sub> ≠ imm` |

  * OLB<sub>proc</sub> - the [operand location](#olb) (imm, reg or stack) of the
    system call index.
  * OLB<sub>ret</sub> - the [operand location](#olb) (imm, reg or stack) for the
    return value.

Arguments:
  1. The 64-bit index of the system call to call.
  2. if the OLB<sub>ret</sub> is reg or stack, the index of the register or
     stack where the return value should be written.
     Otherwise, if OLB<sub>ret</sub> is imm, the second argument is omitted,
     i.e. the return value is discarded.


### common.proc.return (0x000203)

Frees the next procedure stack and returns from the current procedure.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|
|`00000000`|`00000010`|`00000011`|OLB<sub>retval</sub>|`........`|`........`|`........`|`........`| retval |

  * OLB<sub>retval</sub> - the [operand location](#olb) (imm, reg or stack) of
    the return value.

Arguments:
  1. a 64-bit return value. Procedures with no return values in higher-level
     languages should by convention return (uint64) 0.


### common.proc.push (0x000204)

Pushes a 64-bit value to the next procedure stack.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|
|`00000000`|`00000010`|`00000100`|OLB<sub>value</sub>|`........`|`........`|`........`|`........`| value |

  * OLB<sub>value</sub> - the [operand location](#olb) (imm, reg or stack) of
    the value to push.

Arguments:
  1. The 64-bit value to push, depending on OLB<sub>value</sub>.


### common.proc.pushref (0x000205)

Pushes a mutable reference to the next procedure stack.
The reference created references the whole of the given data.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|
|`00000000`|`00000010`|`00000101`|OLB<sub>index</sub>|`........`|`........`|`........`|`........`|  index  |

  * OLB<sub>index</sub> - the [operand location](#olb) (all except imm and cref)
    of the value to reference.

Arguments:
  1. The 64-bit unsigned register index, stack register index, memory handle
     index or mutable reference index.


### common.proc.pushrefpart (0x000206)

Pushes a partial reference to the next procedure stack.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |  arg 2  |  arg 3  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|---------|---------|
|`00000000`|`00000010`|`00000110`|OLB<sub>index</sub>|OLB<sub>offset</sub>|OLB<sub>length</sub>|`........`|`........`| index | offset | length |

  * OLB<sub>index</sub> - the [operand location](#olb) (all except imm and cref)
    of the value to reference.
  * OLB<sub>offset</sub> - the [operand location](#olb) (imm, reg or stack) of
    the offset in bytes in the value to reference.
  * OLB<sub>length</sub> - the [operand location](#olb) (imm, reg or stack) of
    the number of bytes to reference.

Arguments:
  1. The 64-bit unsigned register index, stack register index, memory handle
     index or mutable reference index.
  2. The 64-bit unsigned offset in bytes in the value to reference.
  3. The 64-bit unsigned amount of bytes to reference.


### common.proc.pushcref (0x000207)

Pushes a constant reference to the next procedure stack.
The constant reference created references the whole of the given data.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|---------|---------|
|`00000000`|`00000010`|`00000111`|OLB<sub>index</sub>|`........`|`........`|`........`|`........`| index |

  * OLB<sub>index</sub> - the [operand location](#olb) (imm, reg, stack, cref,
    ref, mem_reg, mem_stack) of the value to reference.

Arguments:
  1. The 64-bit unsigned immediate, register index, stack register index, memory
     handle index, mutable reference index or constant reference index.


### common.proc.pushcrefpart (0x000208)

Pushes a partial constant reference to the next procedure stack.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |  arg 2  |  arg 3  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|---------|---------|
|`00000000`|`00000010`|`00001000`|OLB<sub>index</sub>|OLB<sub>offset</sub>|OLB<sub>length</sub>|`........`|`........`| index | offset | length |

  * OLB<sub>index</sub> - the [operand location](#olb) of the value to
    reference.
  * OLB<sub>offset</sub> - the [operand location](#olb) (imm, reg or stack) of
    the offset in bytes in the value to reference.
  * OLB<sub>length</sub> - the [operand location](#olb) (imm, reg or stack) of
    the number of bytes to reference.

Arguments:
  1. The 64-bit unsigned immediate, register index, stack register index, memory
     handle index, mutable reference index or constant reference index.
  2. The 64-bit unsigned offset in bytes in the value to reference.
  3. The 64-bit unsigned amount of bytes to reference (64-bit value).


### common.proc.clrstack (0x000209)

Clears the next procedure stack.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |
|----------|----------|----------|----------|----------|----------|----------|----------|
|`00000000`|`00000010`|`00001001`|`........`|`........`|`........`|`........`|`........`|

No arguments.


### common.proc.resizestack (0x00020a)

Resizes the container for the current stack frame.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|
|`00000000`|`00000010`|`00001010`|`........`|`........`|`........`|`........`|`........`| nregs |

When starting a program (entering a stack frame), no global (stack) registers
are available.
Use this command to allocate registers.

Registers can also be reallocated using this instruction.
During reallocation, existing registers retain their indexes and contents.
If the number of registers to be allocated is greater than the number of
registers currently allocated, new uninitialized registers are added.
If the number of registers to be allocated is less than the number of registers
currently allocated, registers with indexes greater or equal than the number of
registers to be allocated will not be accessible after this instructions.
Note that this does not ensure secure deletion of the contents of registers
which were made inaccessible by the reallocation, since their memory might later
be reused for newly allocated uninitialized data.

Arguments:
  1. The 64-bit unsigned number of (global or stack) registers to be present
     after executing this instruction.


### common.proc.getrefsize (0x00020c)

Retrieves the size of the mutable reference in bytes.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |  arg 2  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|---------|
|`00000000`|`00000010`|`00001100`|OLB<sub>ref</sub>|OLB<sub>sizedest</sub>|`........`|`........`|`........`| ref | sizedest |

  * OLB<sub>ref</sub> - the [operand location](#olb) (imm, reg or stack) of the
    mutable reference.
  * OLB<sub>sizedest</sub> - the [operand location](#olb) (reg or stack) where
    to store the size of bytes held by the mutable reference.

Arguments:
  1. The 64-bit unsigned index of the mutable reference or the index of the
     register or stack slot where the index is held.
  2. The 64-bit unsigned index of the register or stack slot where to store the
     number of bytes held by the reference.


### common.proc.getcrefsize (0x00020d)

Retrieves the size of the constant reference in bytes.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |  arg 2  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|---------|
|`00000000`|`00000010`|`00001101`|OLB<sub>cref</sub>|OLB<sub>sizedest</sub>|`........`|`........`|`........`| cref | sizedest |

  * OLB<sub>cref</sub> - the [operand location](#olb) (imm, reg or stack) of the
    constant reference.
  * OLB<sub>sizedest</sub> - the [operand location](#olb) (reg or stack) where
    to store the size of bytes held by the constant reference.

Arguments:
  1. The 64-bit unsigned index of the constant reference or the index of the
     register or stack slot where the index is held.
  2. The 64-bit unsigned index of the register or stack slot where to store the
     number of bytes held by the reference.


### common.mem.alloc (0x000300)

Allocates dynamic memory, and retrieves a 64-bit unsigned memory handle, or 0 if
allocation fails.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |  arg 2  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|---------|
|`00000000`|`00000011`|`00000000`|OLB<sub>handleDest</sub>|OLB<sub>nbytes</sub>|`........`|`........`|`........`| handleDest | nbytes |

  * OLB<sub>handleDest</sub> - the [operand location](#olb) (reg or stack) where
    to store the memory handle.
  * OLB<sub>nbytes</sub> - the [operand location](#olb) (imm, reg or stack) of
    the number of bytes to allocate.

Arguments:
  1. The 64-bit unsigned register or stack slot index to write the retrieved
     memory handle index to.
  2. The 64-bit unsigned number of bytes to allocate (64-bit value).


### common.mem.free (0x000301)

Frees dynamic memory.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|
|`00000000`|`00000011`|`00000001`|OLB<sub>handle</sub>|`........`|`........`|`........`|`........`| handle |

  * OLB<sub>handle</sub> - the [operand location](#olb) (reg or stack) of the
    memory handle.

Arguments:
  1. The 64-bit unsigned index of the register or stack slot where to read the
     memory handle from.


### common.mem.getmemsize (0x000302)

Retrieves the size of the allocated memory in bytes.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |  arg 2  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|---------|
|`00000000`|`00000011`|`00000010`|OLB<sub>handle</sub>|OLB<sub>sizedest</sub>|`........`|`........`|`........`| handle | sizedest |

  * OLB<sub>handle</sub> - the [operand location](#olb) (imm, reg or stack) of
    the memory handle.
  * OLB<sub>sizedest</sub> - the [operand location](#olb) (reg or stack) where
    to store the size of bytes held by the memory handle.

Arguments:
  1. The 64-bit unsigned index of the register or stack slot where to read the
     memory handle from.
  2. The 64-bit unsigned index of the register or stack slot where to store the
     number of bytes to allocate.


### common.convert (0x0004)

Converts between register values.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |  arg 2  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|---------|
|`00000000`|`00000100`|DTB<sub>src</sub>|OLB<sub>src</sub>|DTB<sub>dest</sub>|OLB<sub>dest</sub>|`........`|`........`| src | dest |

  * DTB<sub>src</sub> - the [data type](#dlb) of the source value.
  * OLB<sub>src</sub> - the [operand location](#olb) (reg or stack) of the
    source value.
  * DTB<sub>dest</sub> - the [data type](#dlb) of the destination value (must be
    different from DTB<sub>src</sub>).
  * OLB<sub>dest</sub> - the [operand location](#olb) (reg or stack) of the
    destination value.

Arguments:
  1. The 64-bit unsigned index of the source register or stack slot where to
     read the value from.
  2. The 64-bit unsigned index of the destination register or stack slot where
     to store the converted value.


### common.fpu.getstate (0x000500)

Reads the state of the FPU.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|
|`00000000`|`00000101`|`00000000`|OLB<sub>dest</sub>|`........`|`........`|`........`|`........`| dest |

  * OLB<sub>dest</sub> - the [operand location](#olb) (reg or stack) where to
    write the contents of the [FPU state register](#fpu).

Arguments:
  1. The 64-bit unsigned index of the destination register or stack slot where
     to write the contents of the [FPU state register](#fpu).


### common.fpu.setstate (0x000501)

Sets the state of the FPU.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|
|`00000000`|`00000101`|`00000000`|OLB<sub>src</sub>|`........`|`........`|`........`|`........`| src |

  * OLB<sub>src</sub> - the [operand location](#olb) (reg or stack) where to
    read the contents of the [FPU state register](#fpu) from.

Arguments:
  1. The 64-bit unsigned index of the destination register or stack slot where
     to read the contents of the [FPU state register](#fpu) from.


### common.halt (0x00ff00)

Halts program execution.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|
|`00000000`|`11111111`|`00000000`|OLB<sub>retval</sub>|`........`|`........`|`........`|`........`| retval |

  * OLB<sub>retval</sub> - The [operand location](#olb) (imm, reg or stack) of
    the return value.

Arguments:
  1. The 64-bit signed return value (try to use values less than
     2<sup>32</sup>-1)


### common.except (0x00ff01)

Halts program execution with an user exception.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|
|`00000000`|`11111111`|`00000001`|`........`|`........`|`........`|`........`|`........`| errnum  |

Arguments:
  1. An user exception code.


## The "arith" Namespace (0x01)

For a short explanation on the format of this section, [see here](#intro_abl).


### Unary Instructions: d := op(d)

| Instruction | Value    | Description | Implemented? |
|-------------|----------|-------------|--------------|
| arith.uneg  | `0x0100` | d := -d     | Yes          |
| arith.uinc  | `0x0101` | d := d + 1  | Yes          |
| arith.udec  | `0x0102` | d := d - 1  | Yes          |


### Binary Instructions: d := op(s)

| Instruction | Value    | Description | Implemented? |
|-------------|----------|-------------|--------------|
| arith.bneg  | `0x0140` | d := -s     | Yes          |
| arith.binc  | `0x0141` | d := s + 1  | Yes          |
| arith.bdec  | `0x0142` | d := s - 1  | Yes          |


### Binary Instructions: d := op(d, s)

| Instruction  | Value    | Description                     | Implemented? |
|--------------|----------|---------------------------------|--------------|
| arith.badd   | `0x0180` | d := d + s                      | Yes          |
| arith.bsub   | `0x0181` | d := d - s                      | Yes          |
| arith.bsub2  | `0x0182` | d := s - d                      | Yes          |
| arith.bmul   | `0x0183` | d := d * s                      | Yes          |
| arith.bdiv   | `0x0184` | d := d / s                      | Yes          |
| arith.bdiv2  | `0x0185` | d := s / d                      | Yes          |
| arith.bmod   | `0x0186` | d := d % s                      | Yes          |
| arith.bmod2  | `0x0187` | d := s % d                      | Yes          |
| arith.bpow   | `0x0188` | d := d raised to the s-th power | No           |
| arith.bpow2  | `0x0189` | d := s raised to the d-th power | No           |
| arith.blog   | `0x018a` | d := logarithm of d to base s   | No           |
| arith.blog2  | `0x018b` | d := logarithm of s to base d   | No           |
| arith.broot  | `0x018c` | d := s-th root of d             | No           |
| arith.broot2 | `0x018d` | d := d-th root of s             | No           |


### Trinary Instructions: d := op(s1, s2)

| Instruction | Value    | Description                       | Implemented? |
|-------------|----------|-----------------------------------|--------------|
| arith.tadd  | `0x01c0` | d := s1 + s2                      | Yes          |
| arith.tsub  | `0x01c1` | d := s1 - s2                      | Yes          |
|             | `0x01c2` |                                   |  RESERVED    |
| arith.tmul  | `0x01c3` | d := s1 * s2                      | Yes          |
| arith.tdiv  | `0x01c4` | d := s1 / s2                      | Yes          |
|             | `0x01c5` |                                   |  RESERVED    |
| arith.tmod  | `0x01c6` | d := s1 % s2                      | Yes          |
|             | `0x01c7` |                                   |  RESERVED    |
| arith.tpow  | `0x01c8` | d := s1 raised to the s2-th power | No           |
|             | `0x01c9` |                                   |  RESERVED    |
| arith.tlog  | `0x01ca` | d := logarithm of s1 to base s2   | No           |
|             | `0x01cb` |                                   |  RESERVED    |
| arith.troot | `0x01cc` | d := s2-th root of s1             | No           |
|             | `0x01cd` |                                   |  RESERVED    |


## The "bitwise" Namespace (0x02)
For a short explanation on the format of this section, [see here](#intro_abl).

The instructions in the bitwise namespace only accept operands of type uint.


### Unary Instructions: d := op(d)

| Instruction   | Value    | Description | Implemented? |
|---------------|----------|-------------|--------------|
| bitwise.uinv  | `0x0200` | d := ~d     | Yes          |
|               | `0x0201` |             |  RESERVED    |
| bitwise.urtl  | `0x0202` | d := bitwise rotate left  of d by 1 bit | Yes |
| bitwise.urtr  | `0x0203` | d := bitwise rotate right of d by 1 bit | Yes |
| bitwise.ushl0 | `0x0204` | d := bitwise shift  left  of d by 1 bit, add unset (0) bit | Yes |
| bitwise.ushl1 | `0x0205` | d := bitwise shift  left  of d by 1 bit, add set   (1) bit | Yes |
| bitwise.ushr0 | `0x0206` | d := bitwise shift  right of d by 1 bit, add unset (0) bit | Yes |
| bitwise.ushr1 | `0x0207` | d := bitwise shift  right of d by 1 bit, add set   (1) bit | Yes |
| bitwise.ushl  | `0x0208` | d := bitwise shift  left  of d by 1 bit, extend last  bit  | Yes |
| bitwise.ushr  | `0x0209` | d := bitwise shift  right of d by 1 bit, extend first bit  | Yes |


### Binary Instructions: d := op(s)

| Instruction    | Value    | Description | Implemented? |
|----------------|----------|-------------|--------------|
| bitwise.binv   | `0x0240` | d := ~s     | Yes          |
|                | `0x0241` |             |  RESERVED    |
| bitwise.b1rtl  | `0x0242` | d := bitwise rotate left  of s by 1 bit | Yes |
| bitwise.b1rtr  | `0x0243` | d := bitwise rotate right of s by 1 bit | Yes |
| bitwise.b1shl0 | `0x0244` | d := bitwise shift  left  of s by 1 bit, add unset (0) bit | Yes |
| bitwise.b1shl1 | `0x0245` | d := bitwise shift  left  of s by 1 bit, add set   (1) bit | Yes |
| bitwise.b1shr0 | `0x0246` | d := bitwise shift  right of s by 1 bit, add unset (0) bit | Yes |
| bitwise.b1shr1 | `0x0247` | d := bitwise shift  right of s by 1 bit, add set   (1) bit | Yes |
| bitwise.b1shl  | `0x0248` | d := bitwise shift  left  of s by 1 bit, extend last  bit  | Yes |
| bitwise.b1shr  | `0x0249` | d := bitwise shift  right of s by 1 bit, extend first bit  | Yes |


### Binary Instructions: d := op(d, s)
| Instruction     | Value    | Description         | Implemented? |
|-----------------|----------|---------------------|--------------|
| bitwise.bb_0000 | `0x0280` | d := d AND (NOT d)  |  RESERVED    |
| bitwise.bband   | `0x0281` | d := d AND s        | Yes          |
| bitwise.bbabj   | `0x0282` | d := d AND (NOT s)  | Yes          |
| bitwise.bb_0011 | `0x0283` | d := d              |  RESERVED    |
| bitwise.bbcni   | `0x0284` | d := (NOT d) AND s  | Yes          |
| bitwise.bb_0101 | `0x0285` | d := s              |  RESERVED    |
| bitwise.bbxor   | `0x0286` | d := d XOR s        | Yes          |
| bitwise.bbor    | `0x0287` | d := d OR s         | Yes          |
| bitwise.bbbnor  | `0x0288` | d := NOT (d OR s)   | Yes          |
| bitwise.bbxnor  | `0x0289` | d := NOT (d XOR s)  | Yes          |
| bitwise.bb_1010 | `0x028a` | d := NOT s          |  RESERVED    |
| bitwise.bbci    | `0x028b` | d := d OR (NOT s)   | Yes          |
| bitwise.bb_1100 | `0x028c` | d := NOT d          |  RESERVED    |
| bitwise.bbimp   | `0x028d` | d := (NOT d) OR s   | Yes          |
| bitwise.bbnand  | `0x028e` | d := NOT (d AND s)  | Yes          |
| bitwise.bb_1111 | `0x028f` | d := d OR (NOT d)   |  RESERVED    |
| bitwise.brtl    | `0x0290` | d := bitwise rotate left  of d by s bits | Yes |
| bitwise.brtr    | `0x0291` | d := bitwise rotate right of d by s bits | Yes |
| bitwise.bshl0   | `0x0292` | d := bitwise shift  left  of d by s bits, add unset (0) bits | Yes |
| bitwise.bshl1   | `0x0293` | d := bitwise shift  left  of d by s bits, add set   (1) bits | Yes |
| bitwise.bshr0   | `0x0294` | d := bitwise shift  right of d by s bits, add unset (0) bits | Yes |
| bitwise.bshr1   | `0x0295` | d := bitwise shift  right of d by s bits, add set   (1) bits | Yes |
| bitwise.bshl    | `0x0296` | d := bitwise shift  left  of d by s bits, extend last bit    | Yes |
| bitwise.bshr    | `0x0297` | d := bitwise shift  right of d by s bits, extend first bit   | Yes |

### Trinary Instructions: d := op(s1, s2)

| Instruction     | Value    | Description          | Implemented? |
|-----------------|----------|----------------------|--------------|
| bitwise.bt_0000 | `0x02c0` | d := d AND (NOT d)   |  RESERVED    |
| bitwise.btand   | `0x02c1` | d := s1 AND s2       | Yes          |
| bitwise.btabj   | `0x02c2` | d := s1 AND (NOT s2) | Yes          |
| bitwise.bt_0011 | `0x02c3` | d := s1              |  RESERVED    |
| bitwise.btcni   | `0x02c4` | same as bitwise.tabj |  RESERVED    |
| bitwise.bt_0101 | `0x02c5` | d := s2              |  RESERVED    |
| bitwise.btxor   | `0x02c6` | d := s1 XOR s2       | Yes          |
| bitwise.btor    | `0x02c7` | d := s1 OR s2        | Yes          |
| bitwise.btbnor  | `0x02c8` | d := NOT (s1 OR s2)  | Yes          |
| bitwise.btxnor  | `0x02c9` | d := NOT (s1 XOR s2) | Yes          |
| bitwise.bt_1010 | `0x02ca` | d := NOT s2          |  RESERVED    |
| bitwise.btci    | `0x02cb` | same as bitwise.btimp with operators swapped |  RESERVED  |
| bitwise.bt_1100 | `0x02cc` | d := NOT s1          |  RESERVED    |
| bitwise.btimp   | `0x02cd` | d := s1 OR (NOT s2)  | Yes          |
| bitwise.btnand  | `0x02ce` | d := NOT (s1 AND s2) | Yes          |
| bitwise.bt_1111 | `0x02cf` | d := d OR (NOT d)    |  RESERVED    |
| bitwise.trtl    | `0x02d0` | d := bitwise rotate left  of s1 by s2 bits | Yes |
| bitwise.trtr    | `0x02d1` | d := bitwise rotate right of s1 by s2 bits | Yes |
| bitwise.tshl0   | `0x02d2` | d := bitwise shift  left  of s1 by s2 bits, add unset (0) bits | Yes |
| bitwise.tshl1   | `0x02d3` | d := bitwise shift  left  of s1 by s2 bits, add set   (1) bits | Yes |
| bitwise.tshr0   | `0x02d4` | d := bitwise shift  right of s1 by s2 bits, add unset (0) bits | Yes |
| bitwise.tshr1   | `0x02d5` | d := bitwise shift  right of s1 by s2 bits, add set   (1) bits | Yes |
| bitwise.tshl    | `0x02d6` | d := bitwise shift  left  of s1 by s2 bits, extend last  bit   | Yes |
| bitwise.tshr    | `0x02d7` | d := bitwise shift  right of s1 by s2 bits, extend first bit   | Yes |


## The "logical" Namespace (0x03)
For a short explanation on the format of this section, [see here](#intro_abl).

Note that most of the instructions only operate on uints.
The result of all these expressions is either 1 (true) or 0 (false) and is
written as an uint64 to the 64-bit register d<sub>reg</sub> previously occupied
operand d.


### Unary Instructions: d<sub>reg</sub> := op(d)

| Instruction  | Value    | Description           | Input data types | Implemented? |
|--------------|----------|-----------------------|------------------|--------------|
| logical.unot | `0x0300` | d<sub>reg</sub> := ¬d | Only uint's      | Yes          |


### Binary Instructions: d<sub>reg</sub> := op(s)

| Instruction  | Value    | Description           | Input data types | Implemented? |
|--------------|----------|-----------------------|------------------|--------------|
| logical.bnot | `0x0340` | d<sub>reg</sub> := ¬s | Only uint's      | Yes          |


### Binary Instructions: d<sub>reg</sub> := op(d, s)

| Instruction     | Value    | Description                 | Input data types | Implemented? |
|-----------------|----------|-----------------------------|------------------|--------------|
| logical.lb_0000 | `0x0380` | d<sub>reg</sub> := false    |                  | RESERVED     |
| logical.lband   | `0x0381` | d<sub>reg</sub> := d ∧ s    | Only uint's      | Yes          |
| logical.lbabj   | `0x0382` | d<sub>reg</sub> := d ∧ ¬s   | Only uint's      | Yes          |
| logical.lb_0011 | `0x0383` | d<sub>reg</sub> := d        |                  | RESERVED     |
| logical.lbcni   | `0x0384` | d<sub>reg</sub> := ¬d ∧ s   | Only uint's      | Yes          |
| logical.lb_0101 | `0x0385` | d<sub>reg</sub> := s        |                  | RESERVED     |
| logical.lbxor   | `0x0386` | d<sub>reg</sub> := d ⊻ s    | Only uint's      | Yes          |
| logical.lbor    | `0x0387` | d<sub>reg</sub> := d ∨ s    | Only uint's      | Yes          |
| logical.lbbnor  | `0x0388` | d<sub>reg</sub> := ¬(d ∨ s) | Only uint's      | Yes          |
| logical.lbxnor  | `0x0389` | d<sub>reg</sub> := ¬(d ⊻ s) | Only uint's      | Yes          |
| logical.lb_1010 | `0x038a` | d<sub>reg</sub> := ¬s       |                  | RESERVED     |
| logical.lbci    | `0x038b` | d<sub>reg</sub> := d ∨ ¬s   | Only uint's      | Yes          |
| logical.lb_1100 | `0x038c` | d<sub>reg</sub> := ¬d       |                  | RESERVED     |
| logical.lbimp   | `0x038d` | d<sub>reg</sub> := ¬d ∨ s   | Only uint's      | Yes          |
| logical.lbnand  | `0x038e` | d<sub>reg</sub> := ¬(d ∧ s) | Only uint's      | Yes          |
| logical.lb_1111 | `0x038f` | d<sub>reg</sub> := true     |                  | RESERVED     |
| logical.beq     | `0x0390` | d<sub>reg</sub> := d = s    | All types        | Yes          |
| logical.bne     | `0x0391` | d<sub>reg</sub> := d ≠ s    | All types        | Yes          |
| logical.blt     | `0x0392` | d<sub>reg</sub> := d < s    | All types        | Yes          |
| logical.ble     | `0x0393` | d<sub>reg</sub> := d ≤ s    | All types        | Yes          |
| logical.bge     | `0x0394` | d<sub>reg</sub> := d ≥ s    | All types        | Yes          |
| logical.bgt     | `0x0395` | d<sub>reg</sub> := d > s    | All types        | Yes          |


### Trinary Instructions: d<sub>reg</sub> := op(s1, s2)

| Instruction     | Value    | Description                   | Input data types | Implemented? |
|-----------------|----------|-------------------------------|------------------|--------------|
| logical.lt_0000 | `0x03c0` | d<sub>reg</sub> := false      |                  |  RESERVED    |
| logical.ltand   | `0x03c1` | d<sub>reg</sub> := s1 ∧ s2    | Only uint's      | Yes          |
| logical.ltabj   | `0x03c2` | d<sub>reg</sub> := s1 ∧ ¬s2   | Only uint's      | Yes          |
| logical.lt_0011 | `0x03c3` | d<sub>reg</sub> := s1         |                  |  RESERVED    |
| logical.ltcni   | `0x03c4` | same as logical.tabj with operators swapped |    |  RESERVED    |
| logical.lt_0101 | `0x03c5` | d<sub>reg</sub> := s2         |                  |  RESERVED    |
| logical.ltxor   | `0x03c6` | d<sub>reg</sub> := s1 ⊻ s2    | Only uint's      | Yes          |
| logical.ltor    | `0x03c7` | d<sub>reg</sub> := s1 ∨ s2    | Only uint's      | Yes          |
| logical.ltbnor  | `0x03c8` | d<sub>reg</sub> := ¬(s1 ∨ s2) | Only uint's      | Yes          |
| logical.ltxnor  | `0x03c9` | d<sub>reg</sub> := ¬(s1 ⊻ s2) | Only uint's      | Yes          |
| logical.lt_1010 | `0x03ca` | d<sub>reg</sub> := ¬s2        |                  |  RESERVED    |
| logical.ltci    | `0x03cb` | same as logical.ltimp with operators swapped |   |  RESERVED    |
| logical.lt_1100 | `0x03cc` | d<sub>reg</sub> := ¬s1        |                  |  RESERVED    |
| logical.ltimp   | `0x03cd` | d<sub>reg</sub> := ¬s1 ∨ s2   | Only uint's      | Yes          |
| logical.ltnand  | `0x03ce` | d<sub>reg</sub> := ¬(s1 ∧ s2) | Only uint's      | Yes          |
| logical.lt_1111 | `0x03cf` | d<sub>reg</sub> := true       |                  |  RESERVED    |
| logical.teq     | `0x03d0` | d<sub>reg</sub> := s1 = s2    | All types        | Yes          |
| logical.tne     | `0x03d1` | d<sub>reg</sub> := s1 ≠ s2    | All types        | Yes          |
| logical.tlt     | `0x03d2` | d<sub>reg</sub> := s1 < s2    | All types        | Yes          |
| logical.tle     | `0x03d3` | d<sub>reg</sub> := s1 ≤ s2    | All types        | Yes          |
| logical.tge     | `0x03d4` | d<sub>reg</sub> := s1 ≥ s2    | All types        | Yes          |
| logical.tgt     | `0x03d5` | d<sub>reg</sub> := s1 > s2    | All types        | Yes          |


## The "jump" Namespace (0x04)

All jumps are relative.

| Instruction | Value    | Description                          | Implemented? |
|-------------|----------|--------------------------------------|--------------|
| jump.jmp    | `0x0400` | unconditional jump                   | Yes          |
| jump.jz     | `0x0401` | jump if zero / false                 | Yes          |
| jump.jnz    | `0x0402` | jump if non-zero / true              | Yes          |
| jump.dnjz   | `0x0403` | decrease and jump if zero / false    | Yes          |
| jump.dnjnz  | `0x0404` | decrease and jump if non-zero / true | Yes          |
| jump.jeq    | `0x0405` | jump if equal                        | Yes          |
| jump.jne    | `0x0406` | jump if not equal                    | Yes          |
| jump.jge    | `0x0407` | jump if greater or equal             | Yes          |
| jump.jgt    | `0x0408` | jump if greater                      | Yes          |
| jump.jle    | `0x0409` | jump if less or equal                | Yes          |
| jump.jlt    | `0x040a` | jump if less                         | Yes          |


### jump.jmp (0x0400)

Jumps to the given relative address.

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|
|`00000100`|`00000000`|OLB<sub>target</sub>|`........`|`........`|`........`|`........`|`........`| target |

  * OLB<sub>target</sub> - [operand location](#olb) (imm, reg or stack) of jump
    target.

Arguments:
  1. relative jump target (signed 64-bit integer).


### jump.jz (0x0401), jump.jnz (0x0402)

Tests whether the second argument is zero (0 for integers or 0.0 for floating
point numbers) and jumps to the relative address provided by the first argument
if:
  * for jump.jz the second argument tested as zero
  * for jump.jnz the second argument tested as not zero

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |  arg 2  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|---------|
|`00000100`|`000000TT`|OLB<sub>target</sub>|DTB<sub>cond</sub>|OLB<sub>cond</sub>|`........`|`........`|`........`| target | cond |

  * `TT` - `01` for jump.jz and `10` for jump.jnz.
  * OLB<sub>target</sub> - [operand location](#olb) (imm, reg or stack) of jump
    target.
  * DTB<sub>cond</sub> - [data type](#dlb) of argument to test (uint8, uint16,
    uint32 or uint64; int* types are covered by the respective uint* types
    because of two's complement).
  * OLB<sub>cond</sub> - [operand location](#olb) (reg or stack) of argument to
    test.

Arguments:
  1. relative jump target (signed 64-bit integer).
  2. argument to test for being zero.


### jump.dnjz (0x0403), jump.dnjnz (0x0404)

Decreases the second argument by one and tests whether the second argument is
zero (0 for integers or 0.0 for floating point numbers) and jumps to the
relative address provided by the first argument if:
  * for jump.dnjz the first argument tested as zero
  * for jump.dnjnz the first argument tested as not zero

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |  arg 2  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|---------|
|`00000100`|`00000TTT`|OLB<sub>target</sub>|DTB<sub>cond</sub>|OLB<sub>cond</sub>|`........`|`........`|`........`| target | cond |

  * `TTT` - `011` for jump.dnjz and `100` for jump.dnjnz.
  * OLB<sub>target</sub> - [operand location](#olb) (imm, reg or stack) of jump
    target.
  * DTB<sub>cond</sub> - [data type](#dlb) of argument to test (uint8, uint16,
    uint32 or uint64; int* types are covered by the respective uint* types
    because of two's complement).
  * OLB<sub>cond</sub> - [operand location](#olb) (reg or stack) of argument to
    test.

Arguments:
  1. relative jump target (signed 64-bit integer).
  2. argument to test for being zero.


### jump.jeq (0x0405), jump.jne (0x0406), jump.jge (0x0407), jump.jgt (0x0408), jump.jle (0x0409), jump.jlt (0x040a)

Compares the second and third argument and jumps to the relative address
provided by the first argument, if:
  * for jump.je the arguments are equal
  * for jump.jne the arguments are not equal
  * for jump.jge the second argument is greater or equal than the third argument
  * for jump.jgt the second argument is greater than the third argument
  * for jump.jle the second argument is less or equal than the third argument
  * for jump.jlt the second argument is less than the third argument

|  byte 0  |  byte 1  |  byte 2  |  byte 3  |  byte 4  |  byte 5  |  byte 6  |  byte 7  |  arg 1  |  arg 2  |  arg 3  |
|----------|----------|----------|----------|----------|----------|----------|----------|---------|---------|---------|
|`00000100`|`0000TTTT`|OLB<sub>target</sub>|DTB<sub>ops</sub>|OLB<sub>op1</sub>|OLB<sub>op2</sub>|`........`|`........`| target | op<sub>1</sub> | op<sub>2</sub> |

  * `TTTT`
    * `0101` for jump.je,
    * `0110` for jump.jne,
    * `0111` for jump.jge,
    * `1000` for jump.jgt,
    * `1001` for jump.jle,
    * `1010` for jump.jlt
  * OLB<sub>target</sub> - [operand location](#olb) (imm, reg or stack) of jump
    target.
  * DTB<sub>ops</sub> - the [data type](#dlb) for the arguments.
  * OLB<sub>op1</sub> - [operand location](#olb) (imm, reg or stack) for the
    second argument.
  * OLB<sub>op2</sub> - [operand location](#olb) (reg or stack) for the third
    argument.

Arguments:
  1. relative jump target (signed 64-bit integer).
  2. first comparison operand.
  3. second comparison operand.
