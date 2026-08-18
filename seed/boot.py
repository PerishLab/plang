#!/usr/bin/env python3

import argparse
import json
import re
from pathlib import Path


MIN_MEMORY = 4 * 1024
MAX_MEMORY = 16 * 1024 * 1024
NAME = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
REGISTER = re.compile(r"^%[A-Za-z_][A-Za-z0-9_]*$")


def fail(path, line, note):
    raise SystemExit(f"{path}:{line}: {note}")


def number(path, line, text):
    try:
        value = int(text, 0)
    except ValueError:
        fail(path, line, f"invalid integer: {text}")
    if value < 0 or value >= 1 << 64:
        fail(path, line, f"integer outside u64: {text}")
    return value


def named(path, line, text):
    if not NAME.fullmatch(text):
        fail(path, line, f"invalid name: {text}")
    return text


def register(path, line, text):
    if not REGISTER.fullmatch(text):
        fail(path, line, f"invalid register: {text}")
    return text


def parse(path):
    data = {}
    funcs = []
    active = None
    memory = None
    for line, raw in enumerate(path.read_text().splitlines(), 1):
        text = raw.strip()
        if not text or text.startswith("#"):
            continue
        if text.startswith("bytes ") and active is None:
            parts = text.split(maxsplit=2)
            if len(parts) != 3:
                fail(path, line, "bytes requires a name and JSON string")
            key = named(path, line, parts[1])
            if key in data:
                fail(path, line, f"duplicate data: {key}")
            try:
                value = json.loads(parts[2])
            except json.JSONDecodeError as error:
                fail(path, line, f"invalid JSON string: {error.msg}")
            if not isinstance(value, str):
                fail(path, line, "bytes value must be a string")
            data[key] = value.encode()
            continue
        parts = text.split()
        if parts[0] == "memory" and active is None:
            if memory is not None or len(parts) != 2:
                fail(path, line, "program requires one memory declaration")
            value = number(path, line, parts[1])
            if value < MIN_MEMORY or value > MAX_MEMORY or value & (value - 1):
                fail(
                    path,
                    line,
                    f"memory must be a power of two from {MIN_MEMORY} through {MAX_MEMORY}",
                )
            memory = value
            continue
        if parts[0] == "func" and active is None:
            if len(parts) != 3:
                fail(path, line, "func requires a name and arity")
            active = {
                "name": named(path, line, parts[1]),
                "arity": number(path, line, parts[2]),
                "code": [],
                "line": line,
            }
            if active["arity"] > 8:
                fail(path, line, "func arity exceeds eight")
            continue
        if parts == ["end"] and active is not None:
            funcs.append(active)
            active = None
            continue
        if active is None:
            fail(path, line, f"unexpected form: {parts[0]}")
        active["code"].append((parts, line))
    if active is not None:
        fail(path, active["line"], f"function {active['name']} has no end")
    if memory is None:
        fail(path, 0, "missing memory declaration")
    names = [func["name"] for func in funcs]
    if len(names) != len(set(names)):
        fail(path, 0, "duplicate function")
    if names.count("main") != 1:
        fail(path, 0, "program requires one main function")
    return memory, data, funcs


def immediate(reg, value):
    words = []
    first = True
    for shift in range(0, 64, 16):
        part = (value >> shift) & 0xFFFF
        if part or first:
            op = "movz" if first else "movk"
            suffix = "" if shift == 0 else f", lsl #{shift}"
            words.append(f"    {op} {reg}, #{part}{suffix}")
            first = False
    return words


def layout(path, func):
    regs = []
    for parts, line in func["code"]:
        for token in parts[1:]:
            if token.startswith("%"):
                register(path, line, token)
                if token not in regs:
                    regs.append(token)
    if len(regs) > 30:
        fail(path, func["line"], f"function {func['name']} exceeds 30 registers")
    return {reg: (at + 1) * 8 for at, reg in enumerate(regs)}


def load(out, slots, reg, into):
    out.append(f"    ldur {into}, [x29, #-{slots[reg]}]")


def store(out, slots, reg, source):
    out.append(f"    stur {source}, [x29, #-{slots[reg]}]")


def exact(path, line, parts, count):
    if len(parts) != count:
        fail(path, line, f"{parts[0]} expects {count - 1} operands")


def target(path, line, func, label, labels):
    named(path, line, label)
    if label not in labels:
        fail(path, line, f"unknown label in {func}: {label}")
    return f"L_{func}_{label}"


def emit_func(path, data, functions, func):
    name = func["name"]
    slots = layout(path, func)
    frame = ((len(slots) * 8 + 15) // 16) * 16
    labels = set()
    for parts, line in func["code"]:
        if parts[0] == "label":
            exact(path, line, parts, 2)
            label = named(path, line, parts[1])
            if label in labels:
                fail(path, line, f"duplicate label: {label}")
            labels.add(label)
    out = [
        ".p2align 2",
        ".globl _main" if name == "main" else f".globl _pir_{name}",
        "_main:" if name == "main" else f"_pir_{name}:",
        "    stp x29, x30, [sp, #-16]!",
        "    mov x29, sp",
    ]
    if frame:
        out.append(f"    sub sp, sp, #{frame}")
    end = f"L_{name}_return"
    binary = {
        "add": "add",
        "sub": "sub",
        "mul": "mul",
        "and": "and",
        "or": "orr",
        "xor": "eor",
        "shl": "lsl",
        "shr": "lsr",
    }
    compare = {"eq": "eq", "ne": "ne", "lt": "lo", "le": "ls", "slt": "lt"}
    for at, (parts, line) in enumerate(func["code"]):
        op = parts[0]
        if op == "arg":
            exact(path, line, parts, 3)
            dst = register(path, line, parts[1])
            index = number(path, line, parts[2])
            if index >= func["arity"]:
                fail(path, line, f"argument index outside arity: {index}")
            store(out, slots, dst, f"x{index}")
        elif op == "u64":
            exact(path, line, parts, 3)
            dst = register(path, line, parts[1])
            out.extend(immediate("x9", number(path, line, parts[2])))
            store(out, slots, dst, "x9")
        elif op == "data":
            exact(path, line, parts, 4)
            ptr = register(path, line, parts[1])
            size = register(path, line, parts[2])
            key = named(path, line, parts[3])
            if key not in data:
                fail(path, line, f"unknown data: {key}")
            out.extend([f"    adrp x9, L_data_{key}@PAGE", f"    add x9, x9, L_data_{key}@PAGEOFF"])
            store(out, slots, ptr, "x9")
            out.extend(immediate("x9", len(data[key])))
            store(out, slots, size, "x9")
        elif op == "funcptr":
            exact(path, line, parts, 3)
            dst = register(path, line, parts[1])
            function = named(path, line, parts[2])
            if function not in functions:
                fail(path, line, f"unknown function: {function}")
            if function == "main":
                fail(path, line, "main cannot be used as a function value")
            out.extend(
                [
                    f"    adrp x9, _pir_{function}@PAGE",
                    f"    add x9, x9, _pir_{function}@PAGEOFF",
                ]
            )
            store(out, slots, dst, "x9")
        elif op in binary or op in compare:
            exact(path, line, parts, 4)
            dst, left, right = (register(path, line, value) for value in parts[1:])
            load(out, slots, left, "x9")
            load(out, slots, right, "x10")
            if op in binary:
                out.append(f"    {binary[op]} x11, x9, x10")
            else:
                out.extend(["    cmp x9, x10", f"    cset x11, {compare[op]}"])
            store(out, slots, dst, "x11")
        elif op in ("load8", "load64"):
            exact(path, line, parts, 4)
            dst, base, offset = (register(path, line, value) for value in parts[1:])
            load(out, slots, base, "x9")
            load(out, slots, offset, "x10")
            out.append("    add x11, x9, x10")
            out.append("    ldrb w11, [x11]" if op == "load8" else "    ldr x11, [x11]")
            store(out, slots, dst, "x11")
        elif op in ("store8", "store64"):
            exact(path, line, parts, 4)
            base, offset, value = (register(path, line, token) for token in parts[1:])
            load(out, slots, base, "x9")
            load(out, slots, offset, "x10")
            load(out, slots, value, "x11")
            out.append("    add x9, x9, x10")
            out.append("    strb w11, [x9]" if op == "store8" else "    str x11, [x9]")
        elif op == "alloc":
            exact(path, line, parts, 3)
            dst, size = (register(path, line, value) for value in parts[1:])
            load(out, slots, size, "x0")
            out.append("    bl _plang_alloc")
            store(out, slots, dst, "x0")
        elif op == "argv":
            exact(path, line, parts, 4)
            dst, base, index = (register(path, line, value) for value in parts[1:])
            load(out, slots, base, "x9")
            load(out, slots, index, "x10")
            out.append("    ldr x11, [x9, x10, lsl #3]")
            store(out, slots, dst, "x11")
        elif op in ("read", "write"):
            exact(path, line, parts, 5)
            dst, fd, buf, size = (register(path, line, value) for value in parts[1:])
            for reg, into in zip((fd, buf, size), ("x0", "x1", "x2")):
                load(out, slots, reg, into)
            out.append(f"    bl _plang_{op}")
            store(out, slots, dst, "x0")
        elif op in ("open", "close"):
            exact(path, line, parts, 3)
            dst, value = (register(path, line, token) for token in parts[1:])
            load(out, slots, value, "x0")
            out.append(f"    bl _plang_{op}")
            store(out, slots, dst, "x0")
        elif op in ("call", "invoke"):
            if len(parts) < 4:
                fail(path, line, f"{op} requires destination, function, and arity")
            dst = register(path, line, parts[1])
            callee = parts[2]
            if op == "call":
                named(path, line, callee)
                if callee not in functions:
                    fail(path, line, f"unknown function: {callee}")
            else:
                register(path, line, callee)
            arity = number(path, line, parts[3])
            args = [register(path, line, value) for value in parts[4:]]
            if arity != len(args):
                fail(path, line, f"{op} arity mismatch for {callee}")
            if op == "call" and arity != functions[callee]:
                fail(path, line, f"call arity mismatch for {callee}")
            for index, reg in enumerate(args):
                load(out, slots, reg, f"x{index}")
            if op == "call":
                out.append(f"    bl _pir_{callee}")
            else:
                load(out, slots, callee, "x9")
                out.append("    blr x9")
            store(out, slots, dst, "x0")
        elif op == "label":
            out.append(f"L_{name}_{parts[1]}:")
        elif op == "jump":
            exact(path, line, parts, 2)
            out.append(f"    b {target(path, line, name, parts[1], labels)}")
        elif op in ("zero", "nonzero"):
            exact(path, line, parts, 3)
            reg = register(path, line, parts[1])
            load(out, slots, reg, "x9")
            branch = "cbz" if op == "zero" else "cbnz"
            out.append(f"    {branch} x9, {target(path, line, name, parts[2], labels)}")
        elif op in ("out", "err"):
            exact(path, line, parts, 2)
            key = named(path, line, parts[1])
            if key not in data:
                fail(path, line, f"unknown data: {key}")
            out.extend([f"    adrp x0, L_data_{key}@PAGE", f"    add x0, x0, L_data_{key}@PAGEOFF"])
            out.extend(immediate("x1", len(data[key])))
            out.append(f"    bl _plang_{op}")
        elif op == "exit":
            exact(path, line, parts, 2)
            status = number(path, line, parts[1])
            if status > 255:
                fail(path, line, "exit status exceeds 255")
            out.extend(immediate("x0", status))
            out.append(f"    b {end}")
        elif op == "ret":
            exact(path, line, parts, 2)
            load(out, slots, register(path, line, parts[1]), "x0")
            out.append(f"    b {end}")
        else:
            fail(path, line, f"unknown instruction: {op}")
    if not func["code"] or func["code"][-1][0][0] not in ("exit", "ret"):
        fail(path, func["line"], f"function {name} must end with exit or ret")
    out.append(f"{end}:")
    if frame:
        out.append(f"    add sp, sp, #{frame}")
    out.extend(["    ldp x29, x30, [sp], #16", "    ret"])
    return out


def emit(path, memory, data, funcs):
    functions = {func["name"]: func["arity"] for func in funcs}
    out = [".section __TEXT,__text,regular,pure_instructions"]
    for func in funcs:
        out.extend(emit_func(path, data, functions, func))
    out.append(".section __TEXT,__const")
    for key, value in data.items():
        out.extend([".p2align 0", f"L_data_{key}:"])
        if value:
            out.append("    .byte " + ", ".join(str(byte) for byte in value))
    out.extend(
        [
            ".section __DATA,__data",
            ".p2align 3",
            ".globl _plang_memory_limit",
            "_plang_memory_limit:",
            f"    .quad {memory}",
            ".section __DATA,__bss",
            ".p2align 4",
            ".globl _plang_arena",
            "_plang_arena:",
            f"    .space {memory}",
        ]
    )
    return "\n".join(out) + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    memory, data, funcs = parse(args.source)
    args.output.write_text(emit(args.source, memory, data, funcs))


if __name__ == "__main__":
    main()
