# Sharemind VM bytecode instructions definitions

This repository contains the definitions and meta-data of all Sharemind virtual
machine bytecode instructions in [m4/instr.m4][1].
The m4 code is used to generate a number of C headers used by various
components of Sharemind.

See [doc/bytecode.md][2] for the bytecode reference.

## Build dependencies

  * [CMake][] 2.8.12 or later
  * [GNU m4][]


  [1]: m4/instr.m4
  [2]: doc/bytecode.md "Sharemind Bytecode Reference"
  [CMake]: http://www.cmake.org/
  [GNU m4]: https://www.gnu.org/software/m4/
