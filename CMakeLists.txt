cmake_minimum_required(VERSION 3.27)
project(CSC_252_Projects C)

set(CMAKE_C_STANDARD 11)

include_directories(sim4)

add_executable(CSC_252_Projects
        sim4/sim4.c
        sim4/test_extraInst_ANDI.c
        sim4/extra_testcases/test_extraInst_BNE.c
        sim4/extra_testcases/test_extraInst_DIV_MFHI.c
        sim4/extra_testcases/test_extraInst_DIV_MFLO.c
        sim4/extra_testcases/test_extraInst_LB.c
        sim4/extra_testcases/test_extraInst_LUI.c
        sim4/extra_testcases/test_extraInst_MUL.c
        sim4/extra_testcases/test_extraInst_MULT_MFHI.c
        sim4/extra_testcases/test_extraInst_MULT_MFLO.c
        sim4/test_extraInst_NOR.c
        sim4/extra_testcases/test_extraInst_ORI.c
        sim4/extra_testcases/test_extraInst_SB.c
        sim4/extra_testcases/test_extraInst_SLL.c
        sim4/extra_testcases/test_extraInst_SLLV.c
        sim4/extra_testcases/test_extraInst_SLTI.c
        sim4/extra_testcases/test_extraInst_SRA.c
        sim4/extra_testcases/test_extraInst_SRAV.c
        sim4/extra_testcases/test_extraInst_SRL.c
        sim4/extra_testcases/test_extraInst_SRLV.c
        sim4/extra_testcases/test_extraInst_XORI.c
        sim4/sim4.h
        sim4/sim4_test_commonCode.c
        sim4/sim4_test_commonCode.h
        sim4/test_01_getInstruction.c
        sim4/test_02_executeControl1.c
        sim4/test_03_executeControl2.c
        sim4/test_04_aluInputs.c
        sim4/test_05_execALU.c
        sim4/test_06_execMEM.c
        sim4/test_07_fullInstructions.c
        sim4/test_07_fullInstructions_-_disabled_opcode_field_1.c
        sim4/test_07_fullInstructions_-_disabled_opcode_field_2.c
        sim4/test_07_fullInstructions_-_disabled_opcode_field_3.c
        sim4/test_08_checkUpper4BitsOnJump.c
        sim4/test_09_singleInstruction.c
        sim4/test_10_syscalls.c
        sim4/test_11_multipleInstructions1.c
        sim4/test_12_multipleInstructions1-noDebug.c
        sim4/test_13_invalidInstructions.c
        sim4/test_20_ADD_SUB_ADDI.c
        sim4/test_21_AND_OR_XOR.c
        sim4/test_22_SLT_SLTI.c
        sim4/ignored_testcases/test_milestone1_02_executeControl1.c
        sim4/ignored_testcases/test_milestone1_03_executeControl2.c)
