//
// Created by Matthew Song on 3/14/24.
//

#include "sim4.h"

void determine_R_Type(InstructionFields *fields, CPUControl *controlOut);

void determine_I_Type(InstructionFields *fields, CPUControl *controlOut);

/**
 * Extracts the fields from the given instruction.
 *
 * @param instruction   The instruction to extract fields from.
 * @param fieldsOut     Where instruction fields are stored.
 */
void extract_instructionFields(WORD instruction, InstructionFields *fieldsOut) {

    fieldsOut->opcode = (instruction >> 26) & 0x3f;
    fieldsOut->rs = (instruction >> 21) & 0x1f;
    fieldsOut->rt = (instruction >> 16) & 0x1f;
    fieldsOut->rd = (instruction >> 11) & 0x1f;
    fieldsOut->shamt = (instruction >> 6) & 0x1f;
    fieldsOut->funct = instruction & 0x3f;
    fieldsOut->imm16 = instruction & 0xffff;
    fieldsOut->imm32 = signExtend16to32(fieldsOut->imm16);
    fieldsOut->address = instruction & 0x3ffffff;
}

/**
 * Fills out the CPUControl based on the instruction fields.
 *
 * @param fields        The instruction fields.
 * @param controlOut    The CPUControl to fill out.
 * @return              Returns 1 if the instruction is recognized, and 0 if the opcode or function is not recognized.
 */
int fill_CPUControl(InstructionFields *fields, CPUControl *controlOut) {

    // Finding instructions based on the opcode
    switch (fields->opcode) {

        case 0:                 // R-Type-Opcode
            determine_R_Type(fields, controlOut);
            break;
        // I-Type Opcodes
        case 0x8:               // addi-Opcode
        case 0x9:               // addiu-Opcode
        case 0xa:               // slti-Opcode
        case 0x23:              // lw-Opcode
        case 0x2b:              // sw-Opcode
        case 0x4:               // beq-Opcode
        case 0x2:               // j-Opcode
            determine_I_Type(fields, controlOut);
            break;
        // Unknown Opcode
        default:
            return 0;           // Unknown instruction
    }
    return 1;                   // Success
}

/**
 * Writes the control output.
 *
 * @param controlOut
 * @param ALUsrc
 * @param ALUop
 * @param bNegate
 * @param memRead
 * @param memWrite
 * @param memToReg
 * @param regDst
 * @param regWrite
 * @param branch
 * @param jump
 */
void
writeControlOut(CPUControl *controlOut, int ALUsrc, int ALUop, int bNegate, int memRead, int memWrite, int memToReg,
                int regDst, int regWrite, int branch, int jump) {

    controlOut->ALUsrc = ALUsrc;
    controlOut->ALU.op = ALUop;
    controlOut->ALU.bNegate = bNegate;
    controlOut->memRead = memRead;
    controlOut->memWrite = memWrite;
    controlOut->memToReg = memToReg;
    controlOut->regDst = regDst;
    controlOut->regWrite = regWrite;
    controlOut->branch = branch;
    controlOut->jump = jump;
}

/**
 * Determines the R-Type instruction.
 *
 * @param fields        The instruction fields.
 * @param controlOut    The CPUControl to fill out.
 */
void determine_R_Type(InstructionFields *fields, CPUControl *controlOut) {

    switch (fields->funct) {

        case 0x20:      // add Function Hex
        case 0x21:      // addu Function Hex
            writeControlOut(controlOut, 0, 2, 0, 0, 0, 0, 1, 1, 0, 0);
            break;
        case 0x22:      // sub Function Hex
        case 0x23:      // subu Function Hex
            writeControlOut(controlOut, 0, 2, 1, 0, 0, 0, 1, 1, 0, 0);
            break;
        case 0x24:      // and Function Hex
            writeControlOut(controlOut, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0);
            break;
        case 0x25:      // or Function Hex
            writeControlOut(controlOut, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0);
            break;
        case 0x26:      // xor Function Hex
            writeControlOut(controlOut, 0, 4, 0, 0, 0, 0, 1, 1, 0, 0);
            break;
        case 0x2a:      // slt Function Hex
            writeControlOut(controlOut, 0, 3, 1, 0, 0, 0, 1, 1, 0, 0);
            break;
        default:
            break;

    }
}
/**
 * Determines the I-Type instruction.
 *
 * @param fields        The instruction fields.
 * @param controlOut    The CPUControl to fill out.
 */
void determine_I_Type(InstructionFields *fields, CPUControl *controlOut) {

    switch (fields->opcode) {
        case 0x8:       // addi-Opcode
        case 0x9:       // addiu-Opcode
            writeControlOut(controlOut, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0);
            break;
        case 0x0a:       // slti-Opcode
            writeControlOut(controlOut, 1, 3, 1, 0, 0, 0, 0, 1, 0, 0);
            break;
        case 0x23:      // lw-Opcode
            writeControlOut(controlOut, 1, 2, 0, 1, 0, 1, 0, 1, 0, 0);
            break;
        case 0x2b:      // sw-Opcode
            writeControlOut(controlOut, 1, 2, 0, 0, 1, 0, 0, 0, 0, 0);
            break;
        case 0x4:       // beq-Opcode
            writeControlOut(controlOut, 0, 2, 1, 0, 0, 0, 0, 0, 1, 0);
            break;
        case 0x2:       // j-Opcode
            writeControlOut(controlOut, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
            break;
    }
}