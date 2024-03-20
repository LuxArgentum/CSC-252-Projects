//
// Created by Matthew Song on 3/14/24.
//

#include "sim4.h"

int determine_R_Type(InstructionFields *fields, CPUControl *controlOut);

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
            return determine_R_Type(fields, controlOut);
            // I-Type Opcodes
        case 0x8:               // addi-Opcode
        case 0x9:               // addiu-Opcode
        case 0xa:               // slti-Opcode
        case 0x23:              // lw-Opcode
        case 0x2b:              // sw-Opcode
        case 0x4:               // beq-Opcode
        case 0x2:               // j-Opcode
        case 0x28:              // sb Function Hex
        case 0x05:              // bne Function Hex
        case 0x20:              // lb Function Hex
            determine_I_Type(fields, controlOut);
            break;
            // Unknown Opcode
        default:
            return 0;           // Unknown instruction
    }
    return 1;                   // Success
}

WORD getInstruction(WORD curPC, WORD *instructionMemory) {

    // Divide the PC by the size of a word (4 bytes) to get the index in the instruction memory array
    // Return the instruction at the calculated index
    return instructionMemory[curPC / 4];
}

WORD getALUinput1(CPUControl *controlIn,
                  InstructionFields *fieldsIn,
                  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33,
                  WORD oldPC) {

    return rsVal;
}

WORD getALUinput2(CPUControl *controlIn,
                  InstructionFields *fieldsIn,
                  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33,
                  WORD oldPC) {

    // If ALUsrc is 0, the second input to the ALU is the value of the rt register
    // Otherwise, it's the immediate value from the instruction
    if (controlIn->ALUsrc == 0) {
        return rtVal;
    } else {
        return fieldsIn->imm32;
    }
}

void execute_ALU(CPUControl *controlIn,
                 WORD input1, WORD input2,
                 ALUResult *aluResultOut) {

    // Initialize the result and zero fields of aluResultOut
    aluResultOut->result = 0;
    aluResultOut->zero = 0;

    // If bNegate is set, negate the second input
    if (controlIn->ALU.bNegate) {
        input2 = -input2;
    }

    // Perform the operation specified by the ALU control bits
    switch (controlIn->ALU.op) {
        case 0: // AND
            aluResultOut->result = input1 & input2;
            break;
        case 1: // OR
            aluResultOut->result = input1 | input2;
            break;
        case 2: // ADD
            aluResultOut->result = input1 + input2;
            break;
        case 3: // Less
            if (input1 + input2 < 0) {
                aluResultOut->result = 1;
            } else {
                aluResultOut->result = 0;
            }
            break;
        case 4: // XOR
            aluResultOut->result = input1 ^ input2;
            break;
        default:
            // Invalid ALU operation
            break;
    }

    // Set the zero field of aluResultOut
    if (aluResultOut->result == 0) {
        aluResultOut->zero = 1;
    }
}

void execute_MEM(CPUControl *controlIn,
                 ALUResult *aluResultIn,
                 WORD rsVal, WORD rtVal,
                 WORD *memory,
                 MemResult *resultOut) {

    // Initialize readVal to 0
    resultOut->readVal = 0;

    // Calculate the memory address from the ALU result
    int memAddress = aluResultIn->result / 4;

    // If memRead is set, read a value from memory
    if (controlIn->memRead) {
        resultOut->readVal = memory[memAddress];
    }

    // If memWrite is set, write the value of rtVal to memory
    if (controlIn->memWrite) {
        memory[memAddress] = rtVal;
    }
}

WORD getNextPC(InstructionFields *fields, CPUControl *controlIn, int aluZero,
               WORD rsVal, WORD rtVal,
               WORD oldPC) {

    // If the branch control bit is set and the ALU zero output is true, branch to the address specified by the immediate field
    if (controlIn->branch && aluZero) {
        return oldPC + 4 + (fields->imm32 << 2);
    }
        // If the jump control bit is set, jump to the address specified by the address field
    else if (controlIn->jump) {
        return (oldPC & 0xf0000000) | (fields->address << 2);
    }
        // Otherwise, just go to the next instruction in memory
    else {
        return oldPC + 4;
    }
}

void execute_updateRegs(InstructionFields *fields, CPUControl *controlIn,
                        ALUResult *aluResultIn, MemResult *memResultIn,
                        WORD *regs) {

    // Check if a register needs to be written to
    if (controlIn->regWrite) {
        // Determine the destination register
        int destReg;
        if (controlIn->regDst) {
            destReg = fields->rd;
        } else {
            destReg = fields->rt;
        }

        // If memToReg is set, write the value read from memory to the register
        // Otherwise, write the result from the ALU to the register
        if (controlIn->memToReg) {
            regs[destReg] = memResultIn->readVal;
        } else {
            regs[destReg] = aluResultIn->result;
        }
    }
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
int determine_R_Type(InstructionFields *fields, CPUControl *controlOut) {

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
            return 0;           // Unknown instruction
    }
    return 1;               // Success
}

/**
 * Determines the I-Type instruction.
 *
 * @param fields        The instruction fields.
 * @param controlOut    The CPUControl to fill out.
 */
void determine_I_Type(InstructionFields *fields, CPUControl *controlOut) {

    switch (fields->opcode) {
        // Part 1 Opcodes
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
        // Part 2 Extras
        // FIXME: WHY DON'T YOU WORK:LKHJA:OFIHDSF:LK j;l kg
        case 0x28:      // sb Function Hex
            writeControlOut(controlOut, 1, 2, 0, 0, 1, 0, 0, 0, 0, 0);
            break;
        case 0x05:      // bne Function Hex
            writeControlOut(controlOut, 0, 2, 1, 0, 0, 0, 0, 1, 1, 0);
            break;
        case 0x20:      // lb Function Hex
            writeControlOut(controlOut, 1, 2, 0, 1, 0, 1, 0, 1, 0, 0);
            break;
    }
}