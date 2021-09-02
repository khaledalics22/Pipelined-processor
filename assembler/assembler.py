import sys

ram = [0] * 1048576

instructions = {
    "MOV": {
        'code': '0000',
        'operands': '2'
    },
    "ADD": {
        'code': '0001',
        'operands': '2'
    },
    "SUB": {
        'code': '0010',
        'operands': '2'
    },
    "AND": {
        'code': '0011',
        'operands': '2'
    },
    "OR": {
        'code': '0100',
        'operands': '2'
    },
    "IADD": {
        'code': '0101',
        'operands': '2'
    },
    "SHL": {
        'code': '0110',
        'operands': '2'
    },
    "SHR": {
        'code': '0111',
        'operands': '2'
    },
    "CLR": {
        'code': '0000',
        'operands': '1'
    },
    "NOT": {
        'code': '0001',
        'operands': '1'
    },
    "INC": {
        'code': '0010',
        'operands': '1'
    },
    "DEC": {
        'code': '0011',
        'operands': '1'
    },
    "NEG": {
        'code': '0100',
        'operands': '1'
    },
    "OUT": {
        'code': '0101',
        'operands': '1'
    },
    "IN": {
        'code': '0110',
        'operands': '1'
    },
    "RLC": {
        'code': '0111',
        'operands': '1'
    },
    "RRC": {
        'code': '1000',
        'operands': '1'
    },
    "NOP": {
        'code': '0000',
        'operands': '0'
    },
    "SETC": {
        'code': '0001',
        'operands': '0'
    },
    "CLRC": {
        'code': '0010',
        'operands': '0'
    },
    "PUSH": {
        'code': '0000',
        'operands': '3'
    },
    "POP": {
        'code': '0001',
        'operands': '3'
    },
    "LDM": {
        'code': '0010',
        'operands': '3'
    },
    "LDD": {
        'code': '0011',
        'operands': '3'
    },
    "STD": {
        'code': '0100',
        'operands': '3'
    }
}

registers = {
    "R0": "000",
    "R1": "001",
    "R2": "010",
    "R3": "011",
    "R4": "100",
    "R5": "101",
    "R6": "110",
    "R7": "111"
}


def encode_hex(operand, fill):
    # code = ''
    # operand = int(operand)
    # if operand < 0:
    #     code = bin(operand % (1 << 16))[2:]
    # else:
    #     code = '0'*(16-len(bin(operand)[2:])) + bin(operand)[2:]

    return bin(int(operand, 16))[2:].zfill(fill)


def cleanup(testcase):
    lines = []
    org_location = False
    location = 0
    inst_address = 0
    # Deletes all the comments, empty lines, and ORG instructions
    for line in testcase:
        if (line == "\n"):
            continue
        if (line[0] == "#"):
            continue
        if (line[0] == "."):
            location = int(line.split("#")[0].rstrip().split(" ")[1], 16)
            org_location = True
            continue
        if (org_location):
            org_location = False
            if (line.rstrip("\n").isnumeric()):
                address = encode_hex(line.rstrip("\n"), 32)
                ram[location] = address[0:16]
                ram[location + 1] = address[16:32]
                location = location + 2
                continue
            else:
                inst_address = location
        lines.append(' '.join(line.split("#")[0].rstrip().upper().split()))

    return lines, inst_address


def process_nooperand(instruction):
    return "000" + instructions[instruction]['code'] + '0' * 9


def process_oneoperand(instruction):
    code = "010"
    inst, reg = instruction.split(" ")
    code += instructions[inst]['code']
    code += "000"  # To be determined
    code += registers[reg]
    code += "000"
    return code


def process_twooperand(instruction):
    code = "100"
    inst, regs = instruction.split(" ")
    reg1, reg2 = regs.split(",")
    opcode = instructions[inst]["code"]
    code += opcode

    if opcode <= "0100":
        code += registers[reg1] + registers[reg2]
        code += "000"
        return code, ""

    if opcode == "0110" or opcode == "0111":
        code += registers[reg1] + bin(int(reg2, 16))[2:].zfill(5) + "0"
        return code, ""

    reg2 = encode_hex(reg2, 16)
    if opcode == "0101":
        code += "000" + registers[reg1] + reg2 + "000"
        return code[:16], code[16:]


def process_memory(instruction):
    code = "001"
    inst, regs = instruction.split(" ")
    opcode = instructions[inst]["code"]
    code += opcode

    if opcode == "0000" or opcode == "0001":
        code += "000" + registers[regs] + "000"
        return code, ""

    reg1, reg2 = regs.split(",")

    if opcode == "0010":
        code += "000" + registers[reg1] + encode_hex(reg2, 16) + "000"

    if opcode == "0011" or opcode == "0100":
        code += registers[reg2.split("(")[1][:-1]] + \
            registers[reg1] + encode_hex(reg2.split("(")[0],16) + "000"

    return code[:16], code[16:]


testcase_filename = "Memory.asm"
if (len(sys.argv) >= 2):
    testcase_filename = sys.argv[1]

testcase = open(testcase_filename)
lines, inst_address = cleanup(testcase)

for line in lines:
    inst = line.split(" ")[0]
    if inst in instructions:
        if instructions[inst]["operands"] == "0":
            code = process_nooperand(line)
            ram[inst_address] = code
        if instructions[inst]["operands"] == "1":
            code = process_oneoperand(line)
            ram[inst_address] = code
        if instructions[inst]["operands"] == "2":
            first_word, second_word = process_twooperand(line)
            ram[inst_address] = first_word
            if second_word != "":
                inst_address = inst_address + 1
                ram[inst_address] = second_word
        if instructions[inst]["operands"] == "3":
            first_word, second_word = process_memory(line)
            ram[inst_address] = first_word
            if second_word != "":
                inst_address = inst_address + 1
                ram[inst_address] = second_word
        inst_address = inst_address + 1

output_ram = open(testcase_filename.split(".")[0] + ".mem", "+w")

output_ram.write(
    "// memory data file (do not edit the following line - required for mem load use)\n// instance=/instruction_memory/ram\n// format=mti addressradix=h dataradix=b version=1.0 wordsperline=1\n"
)

fmt = "%3s"
for i, word in enumerate(ram):
    line_number = fmt % (hex(i)[2:])
    if word == 0:
        output_ram.write(line_number + ": 0000000000000000\n")
    else:
        output_ram.write(line_number + ": " + word + "\n")
# print(ram)
