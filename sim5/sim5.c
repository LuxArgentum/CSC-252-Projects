#include <stdbool.h>
#include "sim5.h"

int determine_R_Type(InstructionFields *fieldsIn, ID_EX *new_idex);

int determine_I_Type(InstructionFields *fieldsIn, ID_EX *new_idex);

void
writeControlOutExtra(ID_EX *new_idex, int ALUsrc, int ALUop, int bNegate, int memRead, int memWrite,
                     int memToReg,
                     int regDst, int regWrite, int extra1, int extra2, int extra3);

void clearRegisters(ID_EX *in);

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

int IDtoIF_get_stall(InstructionFields *fields, ID_EX *old_idex, EX_MEM *old_exmem) {
    /*
     Check if stall is needed
     Stall = return 1
     No stall = return 0
    
     The parameters are the Fields of the current instruction, plus the ID/EX
     and EX/MEM pipeline registers, for the two instructions ahead. This
     function must not modify any of these in - simply query to determine
     if a stall is required.
     If a stall is required, then the IF phase will also stall; that is, you will see
     this instruction repeated on the next clock cycle.
     If you don’t recognize the opcode or funct (meaning that this is an invalid
     instruction), return 0 from this function.
     */

    bool check1 = fields->rs == old_exmem->writeReg && old_exmem->regWrite && old_exmem->memRead;
    bool check2 = fields->rt == old_exmem->writeReg && old_exmem->regWrite && old_exmem->memRead;

    if (check1 || check2) {
        return 1;  // Stall is needed
    }
    return 0;  // No stall is needed
}

int IDtoIF_get_branchControl(InstructionFields *fields, WORD rsVal, WORD rtVal) {
    /*
     * In this project, my code will ask your code whether a stall is required. You must detect the conditions listed
     * below, and request a stall if they occur. (Your stall detection code always runs as part of ID.)My code will
     * handle the IF phase; if you ask for a stall, then I will stall the IF as well. However, it will be your
     * responsibility to make sure that the control bits (in the ID/EX pipeline register) are all set to zero.
     *
     * You must detect the following conditions:
     *
     * LW Data Hazard
     * We’ve discussed this in class: one instruction loads a value from memory into a register, and the very next
     * instruction wants to use that value in the ALU. Stall the 2nd instruction, to insert an empty space between
     * them. This check must be precise. This means that you must look at the opcode, and figure out exactly which
     * registers you are actually reading. Only stall if a real hazard exists. (For instance, ADDI should not stall
     * if the “hazard” only affects the rt register, since ADDI uses rt as a write register, not a read register.)
     *
     * SW Data Register Hazard
     * This hazard occurs when a SW instruction plans to write a register to memory, but the data register that it
     * plans to write is being modified by an instruction still in the pipeline. There are two versions of this. If
     * the instruction that writes to the register is immediately before the SW, then you are required to solve this
     * with forwarding. However, if the instruction that writes to the register is 2 clock cycles ahead, then you
     * can’t solve the problem with forwarding (unless we add even more complexity to the processor), so in that case
     * you must stall.2 Bonus question: Why don’t you need to stall if there is a write which is 3 clock cycles
     * ahead???
     * */

    /*
    This asks the ID phase if the current instruction (in ID) needs to perform
    a branch/jump. The parameters are the Fields for this instruction, along
    with the rsVal and rtVal for this instruction.

    If you return 0, then the PC will advance as normal. (If you ask for a
    stall, then you must also return this branchControl value.)

    If you return 1, then the PC will jump to the (relative) branch destination
    - see calc branchAddr().

    If you return 2, then the PC will jump to the (absolute) jump destination
    - see calc jumpAddr().

    If you return 3, then the PC will jump to rsVal. (You will not need to use
    this feature unless you decide to add support for JR, just for fun.)

    If you don’t recognize the opcode or funct (meaning that this is an invalid
    instruction), return 0 from this function.
    */

    // Check if the opcode indicates a branch or jump instruction
    switch (fields->opcode) {
        case 0x4:  // beq opcode
            // If rsVal is equal to rtVal, return 1 to indicate a branch to the relative destination
            if (rsVal == rtVal) {
                return 1;
            }
            break;
        case 0x5:  // bne opcode
            // If rsVal is not equal to rtVal, return 1 to indicate a branch to the relative destination
            if (rsVal != rtVal) {
                return 1;
            }
            break;
        case 0x2:  // j opcode
            // Return 2 to indicate a jump to the absolute destination
            return 2;
        default:
            // If the opcode is not recognized, return 0 to indicate no change in control flow
            return 0;
    }

    // If none of the above conditions are met, return 0 to indicate no change in control flow
    return 0;
}

WORD calc_branchAddr(WORD pcPlus4, InstructionFields *fields) {

    /*
     * This asks you to calculate the address that you would jump to if you perform a conditional branch (BEQ,BNE).
     * This function should model a simple branch adder in hardware - and thus, it will calculate this value on every
     * clock cycle, and for every instruction - even if there is no possible way that it might be used. Essentially,
     * this is one of 4 inputs to a MUX - where the MUX is controlled by the branchControl value above. (My code in
     * the IF phase will implement this MUX.)
     * */

    // Calculate the branch address by adding the sign-extended, left-shifted immediate value to the incremented PC value
    return pcPlus4 + (fields->imm32 << 2);
}

WORD calc_jumpAddr(WORD pcPlus4, InstructionFields *fields) {
    /*
     * "This asks you to calculate the address that you would jump to if you perform an unconditional branch (J4). As
     * with calc branchAddr(), this must calculate this value on every clock cycle, and for every instruction - even
     * if there is no possible way that it might be used."
     * */

    // Calculate the jump address by concatenating the upper 4 bits of the incremented PC value with the left-shifted
    // address field from the instruction
    return (WORD) ((pcPlus4 & 0xf0000000) | (fields->address << 2));
}

int execute_ID(int IDstall, InstructionFields *fieldsIn, WORD pcPlus4, WORD rsVal, WORD rtVal, ID_EX *new_idex) {
    /*
     * This function implements the core of the ID phase. Its first parameter is the stall setting (exactly what you
     * returned from IDtoIF get stall()). The next is the Fields for this instruction, followed by the rsVal and rtVal;
     * last is a pointer to the (new) ID/EX pipeline register. Decode the opcode and funct, and set all of the in of
     * the ID EX struct. (I don’t define how you might use the extra* in.) As in Sim 4, you will return 1 if you
     * recognize the opcode/funct; return 0 if it is an invalid instruction.
     * */

    if (IDstall) {
        writeControlOutExtra(new_idex, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        return 1;
    }

    new_idex->rs = fieldsIn->rs;
    new_idex->rt = fieldsIn->rt;
    new_idex->rd = fieldsIn->rd;

    new_idex->rsVal = rsVal;
    new_idex->rtVal = rtVal;

//     Finding instructions based on the opcode
    switch (fieldsIn->opcode) {
        case 0:                 // R-Type-Opcode
            if (!determine_R_Type(fieldsIn, new_idex)) {
                return 0;       // Unknown instruction
            }
            break;
            // I-Type Opcodes
        case 0x8:               // addi-Opcode
        case 0x9:               // addiu-Opcode
        case 0xa:               // slti-Opcode
        case 0x23:              // lw-Opcode
        case 0x2b:              // sw-Opcode
        case 0x4:               // beq-Opcode
        case 0x2:               // j-Opcode
        case 0x05:              // bne Function Hex
        case 0xc:               // andi-Opcode
        case 0x0d:              // ori-Opcode
        case 0x0f:              // lui-Opcode
            if (!determine_I_Type(fieldsIn, new_idex)) {
                return 0;       // Unknown instruction
            }
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
 * @param new_idex
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
writeControlOut(ID_EX *new_idex, int ALUsrc, int ALUop, int bNegate, int memRead, int memWrite, int memToReg,
                int regDst, int regWrite) {

    writeControlOutExtra(new_idex, ALUsrc, ALUop, bNegate, memRead, memWrite, memToReg, regDst, regWrite, 0, 0, 0);
}

void
writeControlOutExtra(ID_EX *new_idex, int ALUsrc, int ALUop, int bNegate, int memRead, int memWrite, int memToReg,
                     int regDst, int regWrite, int extra1, int extra2, int extra3) {

    new_idex->ALUsrc = ALUsrc;
    new_idex->ALU.op = ALUop;
    new_idex->ALU.bNegate = bNegate;
    new_idex->memRead = memRead;
    new_idex->memWrite = memWrite;
    new_idex->memToReg = memToReg;
    new_idex->regDst = regDst;
    new_idex->regWrite = regWrite;
    new_idex->extra1 = extra1;
    new_idex->extra2 = extra2;
    new_idex->extra3 = extra3;
}

/**
 * Determines the R-Type instruction.
 *
 * @param fieldsIn        The instruction fieldsIn.
 * @param new_idex    The CPUControl to fill out.
 */
int determine_R_Type(InstructionFields *fieldsIn, ID_EX *new_idex) {

    /* FIXME:
     * Set ALUsrc=2 to indicate zero-extended imm16
     * Set ALU.op=4 to select the XOR operation in the ALU
     * Set ALU.op=5 if the operation is a NOP
     * */

    switch (fieldsIn->funct) {
        case 0:         // sll Function Hex
            // TODO: Test this
            writeControlOutExtra(new_idex, 3, 7, 0, 0, 0, 0, 1, 1, 0, 0, fieldsIn->shamt);
            break;
        case 0x20:      // add Function Hex
        case 0x21:      // addu Function Hex
            writeControlOut(new_idex, 0, 2, 0, 0, 0, 0, 1, 1);
            break;
        case 0x22:      // sub Function Hex
        case 0x23:      // subu Function Hex
            writeControlOut(new_idex, 0, 2, 1, 0, 0, 0, 1, 1);
            break;
        case 0x24:      // and Function Hex
            writeControlOut(new_idex, 0, 0, 0, 0, 0, 0, 1, 1);
            break;
        case 0x25:      // or Function Hex
            writeControlOut(new_idex, 0, 1, 0, 0, 0, 0, 1, 1);
            break;
        case 0x26:      // xor Function Hex
            writeControlOut(new_idex, 0, 4, 0, 0, 0, 0, 1, 1);
            break;
        case 0x27:      // nor Function Hex
            // TODO: Test this
            writeControlOut(new_idex, 0, 0, 0, 0, 0, 0, 0, 0);
            break;
        case 0x2a:      // slt Function Hex
            writeControlOut(new_idex, 0, 3, 1, 0, 0, 0, 1, 1);
            break;
        case 0x18:      // mult Function Hex
            writeControlOut(new_idex, 0, 6, 0, 0, 0, 0, 1, 1);
        default:
            return 0;           // Unknown instruction
    }
    return 1;               // Success
}

/**
 * Determines the I-Type instruction.
 *
 * @param fieldsIn        The instruction fieldsIn.
 * @param new_idex    The CPUControl to fill out.
 */
int determine_I_Type(InstructionFields *fieldsIn, ID_EX *new_idex) {

    /* FIXME:
     * Set ALUsrc=2 to indicate zero-extended imm16
     * Set ALU.op=4 to select the XOR operation in the ALU
     * Set ALU.op=5 if the operation is a NOP
     * */

    switch (fieldsIn->opcode) {
        // Part 1 Opcodes
        case 0x8:       // addi-Opcode
        case 0x9:       // addiu-Opcode
            writeControlOut(new_idex, 1, 2, 0, 0, 0, 0, 0, 1);
            break;
        case 0x0a:       // slti-Opcode
            writeControlOut(new_idex, 1, 3, 1, 0, 0, 0, 0, 1);
            break;
        case 0x23:      // lw-Opcode
            writeControlOut(new_idex, 1, 2, 0, 1, 0, 1, 0, 1);
            break;
        case 0x2b:      // sw-Opcode
            writeControlOut(new_idex, 1, 2, 0, 0, 1, 0, 0, 0);
            break;
        case 0x4:       // beq-Opcode
        case 0x2:       // j-Opcode
        case 0x5:       // bne-Opcode
            writeControlOut(new_idex, 0, 0, 0, 0, 0, 0, 0, 0);
            clearRegisters(new_idex);
            break;
        case 0xc:       // andi-Opcode
            writeControlOutExtra(new_idex, 2, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0);
            break;
        case 0x0d:       // ori-Opcode
            // FIXME:
            writeControlOutExtra(new_idex, 2, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0);
            break;
        case 0x0f:       // lui-Opcode
            // FIXME:
            writeControlOutExtra(new_idex, 1, 5, 0, 0, 0, 0, 0, 1, 1, 0, 0);
            break;
        case 0x0:       // nop-Opcode
            // FIXME:
            writeControlOutExtra(new_idex, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0);
            break;
        default:
            return 0;           // Unknown instruction
    }
    return 1;               // Success
}

void clearRegisters(ID_EX *in) {
    in->rs = 0;
    in->rt = 0;
    in->rd = 0;
    in->rsVal = 0;
    in->rtVal = 0;
}

WORD EX_getALUinput1(ID_EX *in, EX_MEM *old_exMem, MEM_WB *old_memWb) {
    // Check if the instruction in the ID stage is dependent on the instruction in the EX or MEM stage
    bool check1 = in->rs == old_exMem->writeReg && old_exMem->regWrite;
    bool check2 = in->rt == old_exMem->writeReg && old_exMem->regWrite;
    bool check3 = in->rs == old_memWb->writeReg && old_memWb->regWrite;
    bool check4 = in->rt == old_memWb->writeReg && old_memWb->regWrite;

    if (in->ALUsrc == 2) {
        if (check2) {
            return old_exMem->aluResult;
        }
        if (check4) {
            return old_memWb->memResult;
        }
        return in->rtVal;
    }
    if (check1) {
        return old_exMem->aluResult;
    }
    if (check3) {
        return old_memWb->memResult;
    }
    return in->rsVal;
}

WORD EX_getALUinput2(ID_EX *in, EX_MEM *old_exMem, MEM_WB *old_memWb) {
    // Check if the instruction in the ID stage is dependent on the instruction in the EX or MEM stage
    bool check2 = in->rt == old_exMem->writeReg && old_exMem->regWrite;
    bool check4 = in->rt == old_memWb->writeReg && old_memWb->regWrite;

    // If ALUsrc is 0, the second input to the ALU is the value of the rt register
    // Otherwise, it's the immediate value from the instruction
    if (in->ALUsrc == 0) {
        if (check2) {
            return old_exMem->aluResult;
        }
        if (check4) {
            return old_memWb->memResult;
        }
        return in->rtVal;
    } else if (in->ALUsrc == 1) {
        return in->imm32;
    } else if (in->ALUsrc == 2) {
        return (WORD) in->imm16;  // Zero-extend the 16-bit immediate to 32 bits.
    } else if (in->ALUsrc == 3) {
        return in->extra3;
    }
    return -1;
}

void execute_EX(ID_EX *in, WORD input1, WORD input2, EX_MEM *new_exMem) {
    // Initialize the result and zero in of aluResultOut
    new_exMem->aluResult = 0;
//    new_exMem->zero = 0;

    // If bNegate is set, negate the second input
    if (in->ALU.bNegate) {
        input2 = -input2;
    }

    // Perform the operation specified by the ALU control bits
    switch (in->ALU.op) {
        case 0: // AND
            new_exMem->aluResult = input1 & input2;
            break;
        case 1: // OR
            new_exMem->aluResult = input1 | input2;
            break;
        case 2: // ADD
            new_exMem->aluResult = input1 + input2;
            break;
        case 3: // Less
            if (input1 + input2 < 0) {
                new_exMem->aluResult = 1;
            } else {
                new_exMem->aluResult = 0;
            }
            break;
        case 4: // XOR
            new_exMem->aluResult = input1 ^ input2;
            break;
        case 5: // NOP TODO: Check if NOP works
            new_exMem->aluResult = 0;
            break;
        case 6: // Mult
            new_exMem->aluResult = input1 * input2;
            break;
        case 7: // Shift Left Logical TODO: Check that SLL works
            new_exMem->aluResult = input1 << input2;
            break;
        default:
            // Invalid ALU operation
            break;
    }

//    // Set the zero field of aluResultOut
//    if (new_exMem->aluResult == 0) {
//        new_exMem->zero = 1;
//    }
}

void execute_MEM(EX_MEM *in, MEM_WB *old_memWb, WORD *mem, MEM_WB *new_memwb) {

    // Initialize readVal to 0
    new_memwb->memResult = 0;

    // Calculate the memory address from the ALU result
    int memAddress = in->aluResult / 4;

    // If memRead is set, read a value from memory
    if (in->memRead) {
        new_memwb->memResult = mem[memAddress];
    }

    // If memWrite is set, write the value of rtVal to memory
    if (in->memWrite) {
        mem[memAddress] = in->rtVal;
    }
}

void execute_WB(MEM_WB *in, WORD *regs) {
    // Check if a register needs to be written to
    if (in->regWrite) {
        // Determine the destination register
        int destReg = in->writeReg;

        // If memToReg is set, write the value read from memory to the register
        // Otherwise, write the result from the ALU to the register
        if (in->memToReg) {
            regs[destReg] = in->memResult;
        } else {
            regs[destReg] = in->aluResult;
        }
    }
}

///**
// * Fills out the CPUControl based on the instruction in.
// *
// * @param in        The instruction in.
// * @param controlOut    The CPUControl to fill out.
// * @return              Returns 1 if the instruction is recognized, and 0 if the opcode or function is not recognized.
// */
//int fill_CPUControl(InstructionFields *in, CPUControl *controlOut) {
//
//    // Finding instructions based on the opcode
//    switch (in->opcode) {
//
//        case 0:                 // R-Type-Opcode
//            return determine_R_Type(in, controlOut);
//            // I-Type Opcodes
//        case 0x8:               // addi-Opcode
//        case 0x9:               // addiu-Opcode
//        case 0xa:               // slti-Opcode
//        case 0x23:              // lw-Opcode
//        case 0x2b:              // sw-Opcode
//        case 0x4:               // beq-Opcode
//        case 0x2:               // j-Opcode
//        case 0x05:              // bne Function Hex
//        case 0xc:               // andi-Opcode
//            determine_I_Type(in, controlOut);
//            break;
//            // Unknown Opcode
//        default:
//            return 0;           // Unknown instruction
//    }
//    return 1;                   // Success
//}

//WORD getInstruction(WORD curPC, WORD *instructionMemory) {
//
//    // Divide the PC by the size of a word (4 bytes) to get the index in the instruction memory array
//    // Return the instruction at the calculated index
//    return instructionMemory[curPC / 4];
//}

//WORD getALUinput1(CPUControl *controlIn,
//                  InstructionFields *fieldsIn,
//                  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33,
//                  WORD oldPC) {
//
//    if (controlIn->ALUsrc == 2) {
//        return rtVal;
//    }
//    return rsVal;
//}

//WORD getALUinput2(CPUControl *controlIn,
//                  InstructionFields *fieldsIn,
//                  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33,
//                  WORD oldPC) {
//
//    // If ALUsrc is 0, the second input to the ALU is the value of the rt register
//    // Otherwise, it's the immediate value from the instruction
//    if (controlIn->ALUsrc == 0) {
//        return rtVal;
//    } else if (controlIn->extra1 == 1) {
//        return (WORD) fieldsIn->imm16;  // Zero-extend the 16-bit immediate to 32 bits.
//    } else if (controlIn->ALUsrc == 2) {
//        return fieldsIn->shamt;
//    } else {
//        return fieldsIn->imm32;
//    }
//}

//void execute_ALU(CPUControl *controlIn,
//                 WORD input1, WORD input2,
//                 ALUResult *aluResultOut) {
//
//    // Initialize the result and zero in of aluResultOut
//    aluResultOut->result = 0;
//    aluResultOut->zero = 0;
//
//    // If bNegate is set, negate the second input
//    if (controlIn->ALU.bNegate) {
//        input2 = -input2;
//    }
//
//    // Perform the operation specified by the ALU control bits
//    switch (controlIn->ALU.op) {
//        case 0: // AND
//            aluResultOut->result = input1 & input2;
//            break;
//        case 1: // OR
//            aluResultOut->result = input1 | input2;
//            break;
//        case 2: // ADD
//            aluResultOut->result = input1 + input2;
//            break;
//        case 3: // Less
//            if (input1 + input2 < 0) {
//                aluResultOut->result = 1;
//            } else {
//                aluResultOut->result = 0;
//            }
//            break;
//        case 4: // XOR
//            aluResultOut->result = input1 ^ input2;
//            break;
//        case 5: // Shift left
//            aluResultOut->result = input1 << input2;
//            break;
//        default:
//            // Invalid ALU operation
//            break;
//    }
//
//    // Set the zero field of aluResultOut
//    if (aluResultOut->result == 0) {
//        aluResultOut->zero = 1;
//    }
//}

//void execute_MEM(CPUControl *controlIn,
//                 ALUResult *aluResultIn,
//                 WORD rsVal, WORD rtVal,
//                 WORD *memory,
//                 MemResult *resultOut) {
//
//    // Initialize readVal to 0
//    resultOut->readVal = 0;
//
//    // Calculate the memory address from the ALU result
//    int memAddress = aluResultIn->result / 4;
//
//    // If memRead is set, read a value from memory
//    if (controlIn->memRead) {
//        resultOut->readVal = memory[memAddress];
//    }
//
//    // If memWrite is set, write the value of rtVal to memory
//    if (controlIn->memWrite) {
//        memory[memAddress] = rtVal;
//    }
//}

//WORD getNextPC(InstructionFields *in, CPUControl *controlIn, int aluZero,
//               WORD rsVal, WORD rtVal,
//               WORD oldPC) {
//
//    // If the branch control bit is set and the ALU zero output is true, branch to the address specified by the immediate field
//    if (controlIn->branch && aluZero) {
//        return oldPC + 4 + (in->imm32 << 2);
//    }
//    if (controlIn->extra2 == 1 && !aluZero) {
//        return oldPC + 4 + (in->imm32 << 2);
//    }
//// If the jump control bit is set, jump to the address specified by the address field
//    else if (controlIn->jump) {
//        return (oldPC & 0xf0000000) | (in->address << 2);
//    }
//// Otherwise, just go to the next instruction in memory
//    else {
//        return oldPC + 4;
//    }
//}

//void execute_updateRegs(InstructionFields *in, CPUControl *controlIn,
//                        ALUResult *aluResultIn, MemResult *memResultIn,
//                        WORD *regs) {
//
//    // Check if a register needs to be written to
//    if (controlIn->regWrite) {
//        // Determine the destination register
//        int destReg;
//        if (controlIn->regDst) {
//            destReg = in->rd;
//        } else {
//            destReg = in->rt;
//        }
//
//        // If memToReg is set, write the value read from memory to the register
//        // Otherwise, write the result from the ALU to the register
//        if (controlIn->memToReg) {
//            regs[destReg] = memResultIn->readVal;
//        } else {
//            regs[destReg] = aluResultIn->result;
//        }
//    }
//}