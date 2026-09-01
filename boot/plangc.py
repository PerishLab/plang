"""Generation zero host for plang. Compiles the S0 subset to LLVM IR text.

This host is temporary. tools/guard.sh keeps it confined to boot/ and refuses
to let the language depend on it. It is deleted once plang hosts itself.
"""

import subprocess
import sys

WORD = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
DIGIT = "0123456789"
PUNCT = ["->", "{", "}", "(", ")", ",", ":", "="]

TYPES = {"u8": "i8", "u32": "i32", "u64": "i64", "bool": "i1"}


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
        if c == "#":
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
    def __init__(self, name, result, body):
        self.name = name
        self.result = result
        self.body = body


class Call:
    def __init__(self, name, line):
        self.name = name
        self.line = line


class Number:
    def __init__(self, value):
        self.value = value


class Return:
    def __init__(self, value):
        self.value = value


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

    def expect(self, kind, text=None):
        token = self.take()
        if token.kind != kind or (text is not None and token.text != text):
            wanted = text if text is not None else kind
            raise Fault(self.path, token.line,
                        "expected %s, found %r" % (wanted, token.text))
        return token

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
        name = self.expect("name").text
        self.expect("punct", "(")
        self.expect("punct", ")")
        self.expect("punct", "->")
        result = self.expect("name")
        if result.text not in TYPES:
            raise Fault(self.path, result.line, "unknown type %s" % result.text)
        return Func(name, result.text, self.block())

    def block(self):
        self.expect("punct", "{")
        body = []
        while not (self.peek().kind == "punct" and self.peek().text == "}"):
            body.append(self.statement())
        self.take()
        return body

    def statement(self):
        token = self.peek()
        if token.kind == "name" and token.text == "return":
            self.take()
            return Return(self.expression())
        raise Fault(self.path, token.line, "expected a statement, found %r" % token.text)

    def expression(self):
        token = self.take()
        if token.kind == "number":
            return Number(int(token.text))
        if token.kind == "name":
            self.expect("punct", "(")
            self.expect("punct", ")")
            return Call(token.text, token.line)
        raise Fault(self.path, token.line, "expected an expression, found %r" % token.text)


class Emitter:
    def __init__(self, path, funcs):
        self.path = path
        self.funcs = {f.name: f for f in funcs}
        self.lines = []
        self.next = 0

    def temp(self):
        self.next += 1
        return "%%%d" % self.next

    def program(self):
        self.lines.append('target triple = "%s"' % triple())
        self.lines.append("")
        for func in self.funcs.values():
            self.func(func)
        return "\n".join(self.lines) + "\n"

    def func(self, func):
        self.next = 0
        self.lines.append("define %s @%s() {" % (TYPES[func.result], func.name))
        for statement in func.body:
            self.statement(func, statement)
        self.lines.append("}")
        self.lines.append("")

    def statement(self, func, statement):
        if isinstance(statement, Return):
            value = self.expression(statement.value)
            self.lines.append("  ret %s %s" % (TYPES[func.result], value))
            return
        raise Fault(self.path, 0, "cannot emit %r" % statement)

    def expression(self, node):
        if isinstance(node, Number):
            return str(node.value)
        if isinstance(node, Call):
            callee = self.funcs.get(node.name)
            if callee is None:
                raise Fault(self.path, node.line, "no such function %s" % node.name)
            slot = self.temp()
            self.lines.append("  %s = call %s @%s()"
                              % (slot, TYPES[callee.result], node.name))
            return slot
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
