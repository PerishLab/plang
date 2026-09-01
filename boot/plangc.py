"""Generation zero host for plang. Compiles the S0 subset to LLVM IR text.

This host is temporary. tools/guard.sh keeps it confined to boot/ and refuses
to let the language depend on it. It is deleted once plang hosts itself.
"""

import subprocess
import sys

WORD = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
DIGIT = "0123456789"
PUNCT = ["->", "==", "!=", "<=", ">=", "{", "}", "(", ")", ",", ":", "=",
         "<", ">", "+", "-", "*", "/"]

TYPES = {"u8": "i8", "u32": "i32", "u64": "i64", "bool": "i1"}
NUMERIC = ["u8", "u32", "u64"]
ARITH = {"+": "add", "-": "sub", "*": "mul", "/": "udiv"}
COMPARE = {"==": "eq", "!=": "ne", "<": "ult", ">": "ugt", "<=": "ule", ">=": "uge"}
LEVELS = [["==", "!=", "<", ">", "<=", ">="], ["+", "-"], ["*", "/"]]

RESERVED = ["const", "let", "return", "break", "continue"]
BOOLS = {"true": "1", "false": "0"}
PARAM_LIMIT = 4


def plural(count, one, many):
    return "%d %s" % (count, one if count == 1 else many)


def triple():
    """The toolchain owns the target triple. An emitter that invents one is
    overridden with a warning, and one that omits it is overridden the same
    way, so ask."""
    out = subprocess.check_output(["clang", "-print-target-triple"])
    return out.decode().strip()


class Fault(Exception):
    def __init__(self, path, line, message):
        if line:
            super().__init__("%s:%d: %s" % (path, line, message))
        else:
            super().__init__("%s: %s" % (path, message))


class Token:
    def __init__(self, kind, text, line):
        self.kind = kind
        self.text = text
        self.line = line

    def __repr__(self):
        return "%s(%s)" % (self.kind, self.text)


def lex(path, source):
    tokens = []
    line = 1
    i = 0
    while i < len(source):
        c = source[i]
        if c == "\n":
            line += 1
            i += 1
            continue
        if c in " \t\r":
            i += 1
            continue
        if c == "#" or c == "$":
            j = i + 1
            while j < len(source) and source[j] in WORD:
                j += 1
            if j == i + 1:
                raise Fault(path, line, "a sigil must be followed by a word")
            tokens.append(Token("keyword", source[i:j], line))
            i = j
            continue
        if c in WORD:
            j = i
            while j < len(source) and (source[j] in WORD or source[j] in DIGIT):
                j += 1
            word = source[i:j]
            if j < len(source) and source[j] == "_":
                raise Fault(path, line, "identifiers are single words: %s_" % word)
            tokens.append(Token("name", word, line))
            i = j
            continue
        if c in DIGIT:
            j = i
            while j < len(source) and source[j] in DIGIT:
                j += 1
            tokens.append(Token("number", source[i:j], line))
            i = j
            continue
        if c == "_":
            raise Fault(path, line, "an identifier may not carry an underscore")
        hit = None
        for p in PUNCT:
            if source.startswith(p, i):
                hit = p
                break
        if hit is None:
            raise Fault(path, line, "stray character %r" % c)
        tokens.append(Token("punct", hit, line))
        i += len(hit)
    tokens.append(Token("end", "", line))
    return tokens


class Func:
    def __init__(self, name, params, result, body, line):
        self.name = name
        self.params = params
        self.result = result
        self.body = body
        self.line = line


class Param:
    def __init__(self, name, kind):
        self.name = name
        self.kind = kind


class Bind:
    def __init__(self, name, kind, value, movable, line):
        self.name = name
        self.kind = kind
        self.value = value
        self.movable = movable
        self.line = line


class Store:
    def __init__(self, name, value, line):
        self.name = name
        self.value = value
        self.line = line


class Return:
    def __init__(self, value, line):
        self.value = value
        self.line = line


class Call:
    def __init__(self, name, args, line):
        self.name = name
        self.args = args
        self.line = line


class Binary:
    def __init__(self, op, left, right, line):
        self.op = op
        self.left = left
        self.right = right
        self.line = line


class Number:
    def __init__(self, value, line):
        self.value = value
        self.line = line


class Read:
    def __init__(self, name, line):
        self.name = name
        self.line = line


class Truth:
    def __init__(self, value, line):
        self.value = value
        self.line = line


class Arm:
    def __init__(self, name, body, line):
        self.name = name
        self.body = body
        self.line = line


class Switch:
    def __init__(self, scrutinee, arms, line):
        self.scrutinee = scrutinee
        self.arms = arms
        self.line = line


class Loop:
    def __init__(self, body, line):
        self.body = body
        self.line = line


class Leave:
    def __init__(self, again, line):
        self.again = again
        self.line = line


class Parser:
    def __init__(self, path, tokens):
        self.path = path
        self.tokens = tokens
        self.at = 0

    def peek(self):
        return self.tokens[self.at]

    def take(self):
        token = self.tokens[self.at]
        self.at += 1
        return token

    def sees(self, text):
        token = self.peek()
        return token.kind in ("punct", "name") and token.text == text

    def expect(self, kind, text=None):
        token = self.take()
        if token.kind != kind or (text is not None and token.text != text):
            wanted = text if text is not None else kind
            raise Fault(self.path, token.line,
                        "expected %s, found %r" % (wanted, token.text))
        return token

    def identifier(self):
        token = self.expect("name")
        if token.text in RESERVED:
            raise Fault(self.path, token.line,
                        "%s is reserved and cannot be a name" % token.text)
        return token

    def kind(self):
        token = self.expect("name")
        if token.text not in TYPES:
            raise Fault(self.path, token.line, "unknown type %s" % token.text)
        return token.text

    def program(self):
        items = []
        while self.peek().kind != "end":
            items.append(self.func())
        return items

    def func(self):
        head = self.expect("keyword")
        if head.text != "#func":
            raise Fault(self.path, head.line,
                        "only #func is available in this subset, found %s" % head.text)
        name = self.identifier().text
        self.expect("punct", "(")
        params = []
        while not self.sees(")"):
            if params:
                self.expect("punct", ",")
            field = self.identifier().text
            self.expect("punct", ":")
            params.append(Param(field, self.kind()))
        self.take()
        if len(params) > PARAM_LIMIT:
            raise Fault(self.path, head.line,
                        "%s takes %s, the limit is %d"
                        % (name, plural(len(params), "parameter", "parameters"),
                           PARAM_LIMIT))
        self.expect("punct", "->")
        return Func(name, params, self.kind(), self.block(), head.line)

    def block(self):
        self.expect("punct", "{")
        body = []
        while not self.sees("}"):
            body.append(self.statement())
        self.take()
        return body

    def statement(self):
        token = self.peek()
        if token.kind == "keyword" and token.text == "$switch":
            return self.switch()
        if token.kind == "keyword" and token.text == "$loop":
            self.take()
            return Loop(self.block(), token.line)
        if token.kind == "keyword":
            raise Fault(self.path, token.line,
                        "%s is not available in this subset" % token.text)
        if token.kind == "name" and token.text in ("break", "continue"):
            self.take()
            return Leave(token.text == "continue", token.line)
        if token.kind == "name" and token.text in ("const", "let"):
            self.take()
            name = self.identifier().text
            self.expect("punct", ":")
            kind = self.kind()
            self.expect("punct", "=")
            return Bind(name, kind, self.expression(), token.text == "let", token.line)
        if token.kind == "name" and token.text == "return":
            self.take()
            return Return(self.expression(), token.line)
        if token.kind == "name" and self.tokens[self.at + 1].text == "=":
            name = self.identifier().text
            self.take()
            return Store(name, self.expression(), token.line)
        raise Fault(self.path, token.line,
                    "expected a statement, found %r" % token.text)

    def switch(self):
        head = self.take()
        scrutinee = self.expression()
        self.expect("punct", "{")
        arms = []
        while not self.sees("}"):
            label = self.expect("name")
            self.expect("punct", "->")
            if self.sees("{"):
                body = self.block()
            else:
                body = [self.statement()]
            arms.append(Arm(label.text, body, label.line))
        self.take()
        return Switch(scrutinee, arms, head.line)

    def expression(self, level=0):
        if level == len(LEVELS):
            return self.primary()
        left = self.expression(level + 1)
        while self.peek().kind == "punct" and self.peek().text in LEVELS[level]:
            op = self.take()
            right = self.expression(level + 1)
            left = Binary(op.text, left, right, op.line)
        return left

    def primary(self):
        token = self.take()
        if token.kind == "number":
            return Number(int(token.text), token.line)
        if token.kind == "punct" and token.text == "(":
            inner = self.expression()
            self.expect("punct", ")")
            return inner
        if token.kind == "name" and token.text in BOOLS and not self.sees("("):
            return Truth(token.text, token.line)
        if token.kind == "name":
            if token.text in RESERVED:
                raise Fault(self.path, token.line,
                            "%s is reserved and cannot be a name" % token.text)
            if not self.sees("("):
                return Read(token.text, token.line)
            self.take()
            args = []
            while not self.sees(")"):
                if args:
                    self.expect("punct", ",")
                args.append(self.expression())
            self.take()
            return Call(token.text, args, token.line)
        raise Fault(self.path, token.line,
                    "expected an expression, found %r" % token.text)


class Emitter:
    def __init__(self, path, funcs):
        self.path = path
        self.order = funcs
        self.funcs = {}
        for func in funcs:
            if func.name in self.funcs:
                raise Fault(path, func.line, "%s is defined twice" % func.name)
            self.funcs[func.name] = func
        self.lines = []
        self.slots = {}
        self.next = 0
        self.marks = 0
        self.done = False
        self.loops = []

    def temp(self):
        self.next += 1
        return "%%%d" % self.next

    def mark(self, tag):
        self.marks += 1
        return "%s%d" % (tag, self.marks)

    def here(self, label):
        self.lines.append("%s:" % label)
        self.done = False

    def jump(self, label):
        if not self.done:
            self.lines.append("  br label %%%s" % label)
            self.done = True

    def emit(self, text):
        if self.done:
            return
        self.lines.append(text)

    def program(self):
        self.lines.append('target triple = "%s"' % triple())
        self.lines.append("")
        for func in self.order:
            self.func(func)
        return "\n".join(self.lines) + "\n"

    def func(self, func):
        self.next = 0
        self.marks = 0
        self.slots = {}
        self.done = False
        self.loops = []
        head = ", ".join("%s %%p%d" % (TYPES[p.kind], n)
                         for n, p in enumerate(func.params))
        self.lines.append("define %s @%s(%s) {"
                          % (TYPES[func.result], func.name, head))
        for n, param in enumerate(func.params):
            slot = self.bind(param.name, param.kind, False, func.line)
            self.lines.append("  store %s %%p%d, ptr %s"
                              % (TYPES[param.kind], n, slot))
        for statement in func.body:
            self.statement(func, statement)
        if not self.done:
            raise Fault(self.path, func.line,
                        "%s can reach its end without returning" % func.name)
        self.lines.append("}")
        self.lines.append("")

    def bind(self, name, kind, movable, line):
        if name in self.slots:
            raise Fault(self.path, line, "%s is already bound" % name)
        slot = "%s" + str(len(self.slots))
        self.lines.append("  %s = alloca %s" % (slot, TYPES[kind]))
        self.slots[name] = (slot, kind, movable)
        return slot

    def lookup(self, name, line):
        if name not in self.slots:
            raise Fault(self.path, line, "%s is not bound" % name)
        return self.slots[name]

    def statement(self, func, statement):
        if isinstance(statement, Bind):
            value = self.expression(statement.value, statement.kind)
            slot = self.bind(statement.name, statement.kind,
                             statement.movable, statement.line)
            self.emit("  store %s %s, ptr %s"
                      % (TYPES[statement.kind], value, slot))
            return
        if isinstance(statement, Store):
            slot, kind, movable = self.lookup(statement.name, statement.line)
            if not movable:
                raise Fault(self.path, statement.line,
                            "%s is a const and cannot be reassigned"
                            % statement.name)
            value = self.expression(statement.value, kind)
            self.emit("  store %s %s, ptr %s" % (TYPES[kind], value, slot))
            return
        if isinstance(statement, Return):
            value = self.expression(statement.value, func.result)
            self.lines.append("  ret %s %s" % (TYPES[func.result], value))
            self.done = True
            return
        if isinstance(statement, Switch):
            self.switch(func, statement)
            return
        if isinstance(statement, Loop):
            self.loop(func, statement)
            return
        if isinstance(statement, Leave):
            if not self.loops:
                word = "continue" if statement.again else "break"
                raise Fault(self.path, statement.line,
                            "%s is only meaningful inside a $loop" % word)
            frame = self.loops[-1]
            if not statement.again and not self.done:
                frame[2] = True
            self.jump(frame[0] if statement.again else frame[1])
            return
        raise Fault(self.path, 0, "cannot emit %r" % statement)

    def switch(self, func, node):
        value = self.expression(node.scrutinee, "bool")
        seen = {}
        for arm in node.arms:
            if arm.name not in BOOLS:
                raise Fault(self.path, arm.line,
                            "bool has no variant named %s" % arm.name)
            if arm.name in seen:
                raise Fault(self.path, arm.line,
                            "%s is matched twice" % arm.name)
            seen[arm.name] = arm
        missing = [name for name in BOOLS if name not in seen]
        if missing:
            raise Fault(self.path, node.line,
                        "$switch on bool must cover %s" % ", ".join(sorted(missing)))
        yes = self.mark("yes")
        no = self.mark("no")
        rest = self.mark("rest")
        self.lines.append("  br i1 %s, label %%%s, label %%%s" % (value, yes, no))
        self.done = True
        landed = False
        for name, label in (("true", yes), ("false", no)):
            self.here(label)
            for inner in seen[name].body:
                self.statement(func, inner)
            if not self.done:
                landed = True
            self.jump(rest)
        self.here(rest)
        if not landed:
            self.lines.append("  unreachable")
            self.done = True

    def loop(self, func, node):
        head = self.mark("head")
        end = self.mark("end")
        self.jump(head)
        self.here(head)
        frame = [head, end, False]
        self.loops.append(frame)
        for inner in node.body:
            self.statement(func, inner)
        self.jump(head)
        self.loops.pop()
        self.here(end)
        if not frame[2]:
            self.lines.append("  unreachable")
            self.done = True

    def expression(self, node, want):
        value, kind = self.value(node, want)
        if kind != want:
            raise Fault(self.path, node.line,
                        "expected %s, found %s" % (want, kind))
        return value

    def value(self, node, want):
        if isinstance(node, Truth):
            if want != "bool":
                raise Fault(self.path, node.line,
                            "%s is a bool, not a %s" % (node.value, want))
            return BOOLS[node.value], "bool"
        if isinstance(node, Number):
            if want not in NUMERIC:
                raise Fault(self.path, node.line,
                            "a number cannot be a %s" % want)
            return str(node.value), want
        if isinstance(node, Read):
            slot, kind, movable = self.lookup(node.name, node.line)
            out = self.temp()
            self.emit("  %s = load %s, ptr %s" % (out, TYPES[kind], slot))
            return out, kind
        if isinstance(node, Call):
            callee = self.funcs.get(node.name)
            if callee is None:
                raise Fault(self.path, node.line, "no such function %s" % node.name)
            if len(node.args) != len(callee.params):
                raise Fault(self.path, node.line,
                            "%s takes %s, %d given"
                            % (node.name,
                               plural(len(callee.params), "argument", "arguments"),
                               len(node.args)))
            given = []
            for arg, param in zip(node.args, callee.params):
                given.append("%s %s" % (TYPES[param.kind],
                                        self.expression(arg, param.kind)))
            out = self.temp()
            self.emit("  %s = call %s @%s(%s)"
                              % (out, TYPES[callee.result], node.name,
                                 ", ".join(given)))
            return out, callee.result
        if isinstance(node, Binary):
            if node.op in COMPARE:
                inner = "u32" if want == "bool" else want
                left, kind = self.value(node.left, inner)
                right = self.expression(node.right, kind)
                out = self.temp()
                self.emit("  %s = icmp %s %s %s, %s"
                                  % (out, COMPARE[node.op], TYPES[kind], left, right))
                return out, "bool"
            if want not in NUMERIC:
                raise Fault(self.path, node.line,
                            "arithmetic does not produce a %s" % want)
            left = self.expression(node.left, want)
            right = self.expression(node.right, want)
            out = self.temp()
            self.emit("  %s = %s %s %s, %s"
                              % (out, ARITH[node.op], TYPES[want], left, right))
            return out, want
        raise Fault(self.path, 0, "cannot emit %r" % node)


def compile(path):
    with open(path, "r") as handle:
        source = handle.read()
    funcs = Parser(path, lex(path, source)).program()
    if "main" not in [f.name for f in funcs]:
        raise Fault(path, 0, "a puzzle needs a function named main")
    return Emitter(path, funcs).program()


def main(argv):
    if len(argv) < 2:
        sys.stderr.write("usage: plangc.py SOURCE [-o BINARY]\n")
        return 2
    source = argv[1]
    binary = None
    if len(argv) == 4 and argv[2] == "-o":
        binary = argv[3]
    try:
        text = compile(source)
    except Fault as fault:
        sys.stderr.write("%s\n" % fault)
        return 1
    if binary is None:
        sys.stdout.write(text)
        return 0
    listing = binary + ".ll"
    with open(listing, "w") as handle:
        handle.write(text)
    return subprocess.call(["clang", "-O0", "-o", binary, listing])


if __name__ == "__main__":
    sys.exit(main(sys.argv))
