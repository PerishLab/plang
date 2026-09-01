"""Generation zero host for plang. Compiles the S0 subset to LLVM IR text.

This host is temporary. tools/guard.sh keeps it confined to boot/ and refuses
to let the language depend on it. It is deleted once plang hosts itself.
"""

import subprocess
import sys

WORD = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
DIGIT = "0123456789"
PUNCT = ["->", "==", "!=", "<=", ">=", "{", "}", "(", ")", ",", ":", "=",
         "<", ">", "+", "-", "*", "/", "."]

SCALARS = {"u8": "i8", "u32": "i32", "u64": "i64", "bool": "i1"}
NUMERIC = ["u8", "u32", "u64"]
ARITH = {"+": "add", "-": "sub", "*": "mul", "/": "udiv"}
COMPARE = {"==": "eq", "!=": "ne", "<": "ult", ">": "ugt", "<=": "ule", ">=": "uge"}
LEVELS = [["==", "!=", "<", ">", "<=", ">="], ["+", "-"], ["*", "/"]]

RESERVED = ["const", "let", "return", "break", "continue"]
BOOLS = {"true": "1", "false": "0"}
PARAM_LIMIT = 4
CARRIER = "i64"


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


class Field:
    def __init__(self, name, kind, line):
        self.name = name
        self.kind = kind
        self.line = line


class Variant:
    def __init__(self, name, payload, line):
        self.name = name
        self.payload = payload
        self.line = line


class Product:
    def __init__(self, name, fields, line):
        self.name = name
        self.fields = fields
        self.line = line


class Sum:
    def __init__(self, name, variants, line):
        self.name = name
        self.variants = variants
        self.line = line


class Func:
    def __init__(self, name, params, result, body, line):
        self.name = name
        self.params = params
        self.result = result
        self.body = body
        self.line = line


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


class Arm:
    def __init__(self, name, binding, body, line):
        self.name = name
        self.binding = binding
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


class Call:
    def __init__(self, name, args, labels, line):
        self.name = name
        self.args = args
        self.labels = labels
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


class Pick:
    def __init__(self, target, field, line):
        self.target = target
        self.field = field
        self.line = line


class Parser:
    def __init__(self, path, tokens):
        self.path = path
        self.tokens = tokens
        self.at = 0

    def peek(self, ahead=0):
        return self.tokens[min(self.at + ahead, len(self.tokens) - 1)]

    def take(self):
        token = self.tokens[self.at]
        self.at += 1
        return token

    def sees(self, text, ahead=0):
        token = self.peek(ahead)
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

    def program(self):
        items = []
        while self.peek().kind != "end":
            head = self.peek()
            if head.kind != "keyword":
                raise Fault(self.path, head.line,
                            "expected a declaration, found %r" % head.text)
            if head.text == "#type":
                items.append(self.shape())
            elif head.text == "#func":
                items.append(self.func())
            else:
                raise Fault(self.path, head.line,
                            "%s is not available in this subset" % head.text)
        return items

    def shape(self):
        head = self.take()
        name = self.identifier()
        self.expect("punct", "=")
        body = self.expect("keyword")
        if body.text == "#struct":
            self.expect("punct", "{")
            fields = []
            while not self.sees("}"):
                field = self.identifier()
                self.expect("punct", ":")
                fields.append(Field(field.text, self.identifier().text, field.line))
            self.take()
            return Product(name.text, fields, head.line)
        if body.text == "#enum":
            self.expect("punct", "{")
            variants = []
            while not self.sees("}"):
                label = self.identifier()
                payload = None
                if self.sees("("):
                    self.take()
                    payload = self.identifier().text
                    self.expect("punct", ")")
                variants.append(Variant(label.text, payload, label.line))
            self.take()
            return Sum(name.text, variants, head.line)
        raise Fault(self.path, body.line,
                    "a #type is a #struct or a #enum, found %s" % body.text)

    def func(self):
        head = self.take()
        name = self.identifier().text
        self.expect("punct", "(")
        params = []
        while not self.sees(")"):
            if params:
                self.expect("punct", ",")
            field = self.identifier()
            self.expect("punct", ":")
            params.append(Field(field.text, self.identifier().text, field.line))
        self.take()
        if len(params) > PARAM_LIMIT:
            raise Fault(self.path, head.line,
                        "%s takes %s, the limit is %d"
                        % (name, plural(len(params), "parameter", "parameters"),
                           PARAM_LIMIT))
        self.expect("punct", "->")
        return Func(name, params, self.identifier().text, self.block(), head.line)

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
            kind = self.identifier().text
            self.expect("punct", "=")
            return Bind(name, kind, self.expression(), token.text == "let", token.line)
        if token.kind == "name" and token.text == "return":
            self.take()
            return Return(self.expression(), token.line)
        if token.kind == "name" and self.sees("=", 1):
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
            label = self.identifier()
            binding = None
            if self.sees("("):
                self.take()
                binding = self.identifier().text
                self.expect("punct", ")")
            self.expect("punct", "->")
            if self.sees("{"):
                body = self.block()
            else:
                body = [self.statement()]
            arms.append(Arm(label.text, binding, body, label.line))
        self.take()
        return Switch(scrutinee, arms, head.line)

    def expression(self, level=0):
        if level == len(LEVELS):
            return self.suffix()
        left = self.expression(level + 1)
        while self.peek().kind == "punct" and self.peek().text in LEVELS[level]:
            op = self.take()
            right = self.expression(level + 1)
            left = Binary(op.text, left, right, op.line)
        return left

    def suffix(self):
        node = self.primary()
        while self.sees("."):
            dot = self.take()
            node = Pick(node, self.identifier().text, dot.line)
        return node

    def primary(self):
        token = self.take()
        if token.kind == "number":
            return Number(int(token.text), token.line)
        if token.kind == "punct" and token.text == "(":
            inner = self.expression()
            self.expect("punct", ")")
            return inner
        if token.kind != "name":
            raise Fault(self.path, token.line,
                        "expected an expression, found %r" % token.text)
        if token.text in RESERVED:
            raise Fault(self.path, token.line,
                        "%s is reserved and cannot be a name" % token.text)
        if self.sees("("):
            self.take()
            args = []
            labels = []
            while not self.sees(")"):
                if args:
                    self.expect("punct", ",")
                if self.peek().kind == "name" and self.sees(":", 1):
                    labels.append(self.identifier().text)
                    self.take()
                else:
                    labels.append(None)
                args.append(self.expression())
            self.take()
            return Call(token.text, args, labels, token.line)
        return Read(token.text, token.line)


class Emitter:
    def __init__(self, path, items):
        self.path = path
        self.shapes = {}
        self.funcs = {}
        self.order = []
        for item in items:
            if isinstance(item, Func):
                if item.name in self.funcs:
                    raise Fault(path, item.line, "%s is defined twice" % item.name)
                self.funcs[item.name] = item
                self.order.append(item)
            else:
                if item.name in self.shapes or item.name in SCALARS:
                    raise Fault(path, item.line, "%s is defined twice" % item.name)
                self.shapes[item.name] = item
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

    def machine(self, kind, line):
        if kind in SCALARS:
            return SCALARS[kind]
        if kind in self.shapes:
            return "%" + kind
        raise Fault(self.path, line, "unknown type %s" % kind)

    def product(self, kind, line):
        shape = self.shapes.get(kind)
        if not isinstance(shape, Product):
            raise Fault(self.path, line, "%s is not a #struct" % kind)
        return shape

    def sum(self, kind, line):
        shape = self.shapes.get(kind)
        if not isinstance(shape, Sum):
            raise Fault(self.path, line, "%s is not a #enum" % kind)
        return shape

    def program(self):
        self.lines.append('target triple = "%s"' % triple())
        self.lines.append("")
        for name, shape in self.shapes.items():
            if isinstance(shape, Product):
                inner = ", ".join(self.machine(f.kind, f.line) for f in shape.fields)
            else:
                inner = "i32, " + CARRIER
            self.lines.append("%%%s = type { %s }" % (name, inner))
        if self.shapes:
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
        head = ", ".join("%s %%p%d" % (self.machine(p.kind, p.line), n)
                         for n, p in enumerate(func.params))
        self.lines.append("define %s @%s(%s) {"
                          % (self.machine(func.result, func.line), func.name, head))
        for n, param in enumerate(func.params):
            slot = self.bind(param.name, param.kind, False, param.line)
            self.lines.append("  store %s %%p%d, ptr %s"
                              % (self.machine(param.kind, param.line), n, slot))
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
        self.emit("  %s = alloca %s" % (slot, self.machine(kind, line)))
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
                      % (self.machine(statement.kind, statement.line), value, slot))
            return
        if isinstance(statement, Store):
            slot, kind, movable = self.lookup(statement.name, statement.line)
            if not movable:
                raise Fault(self.path, statement.line,
                            "%s is a const and cannot be reassigned"
                            % statement.name)
            value = self.expression(statement.value, kind)
            self.emit("  store %s %s, ptr %s"
                      % (self.machine(kind, statement.line), value, slot))
            return
        if isinstance(statement, Return):
            value = self.expression(statement.value, func.result)
            self.lines.append("  ret %s %s"
                              % (self.machine(func.result, statement.line), value))
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

    def arms(self, node, labels, subject):
        seen = {}
        for arm in node.arms:
            if arm.name not in labels:
                raise Fault(self.path, arm.line,
                            "%s has no variant named %s" % (subject, arm.name))
            if arm.name in seen:
                raise Fault(self.path, arm.line, "%s is matched twice" % arm.name)
            seen[arm.name] = arm
        missing = [name for name in labels if name not in seen]
        if missing:
            raise Fault(self.path, node.line,
                        "$switch on %s must cover %s"
                        % (subject, ", ".join(sorted(missing))))
        return seen

    def switch(self, func, node):
        value, kind = self.value(node.scrutinee, None)
        if kind == "bool":
            self.truth(func, node, value)
            return
        if kind not in self.shapes or not isinstance(self.shapes[kind], Sum):
            raise Fault(self.path, node.line,
                        "$switch needs a bool or a #enum, found %s" % kind)
        shape = self.shapes[kind]
        seen = self.arms(node, [v.name for v in shape.variants], kind)
        tag = self.temp()
        self.emit("  %s = extractvalue %%%s %s, 0" % (tag, kind, value))
        held = self.temp()
        self.emit("  %s = extractvalue %%%s %s, 1" % (held, kind, value))
        rest = self.mark("rest")
        table = []
        blocks = []
        for index, variant in enumerate(shape.variants):
            label = self.mark("arm")
            table.append("i32 %d, label %%%s" % (index, label))
            blocks.append((label, variant))
        stuck = self.mark("stuck")
        self.lines.append("  switch i32 %s, label %%%s [ %s ]"
                          % (tag, stuck, " ".join(table)))
        self.done = True
        self.here(stuck)
        self.lines.append("  unreachable")
        self.done = True
        landed = False
        for label, variant in blocks:
            self.here(label)
            arm = seen[variant.name]
            if arm.binding is not None:
                if variant.payload is None:
                    raise Fault(self.path, arm.line,
                                "%s carries nothing to bind" % variant.name)
                keep = dict(self.slots)
                slot = self.bind(arm.binding, variant.payload, False, arm.line)
                narrow = self.temp()
                inner = self.machine(variant.payload, arm.line)
                if inner == CARRIER:
                    self.emit("  %s = or %s %s, 0" % (narrow, CARRIER, held))
                else:
                    self.emit("  %s = trunc %s %s to %s" % (narrow, CARRIER, held, inner))
                self.emit("  store %s %s, ptr %s" % (inner, narrow, slot))
            else:
                keep = None
            for inner in arm.body:
                self.statement(func, inner)
            if keep is not None:
                self.slots = keep
            if not self.done:
                landed = True
            self.jump(rest)
        self.here(rest)
        if not landed:
            self.lines.append("  unreachable")
            self.done = True

    def truth(self, func, node, value):
        seen = self.arms(node, list(BOOLS), "bool")
        for arm in seen.values():
            if arm.binding is not None:
                raise Fault(self.path, arm.line,
                            "%s carries nothing to bind" % arm.name)
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
        if want is not None and kind != want:
            raise Fault(self.path, node.line,
                        "expected %s, found %s" % (want, kind))
        return value

    def value(self, node, want):
        if isinstance(node, Truth):
            if want not in (None, "bool"):
                raise Fault(self.path, node.line,
                            "%s is a bool, not a %s" % (node.value, want))
            return BOOLS[node.value], "bool"
        if isinstance(node, Number):
            kind = want if want is not None else "u32"
            if kind not in NUMERIC:
                raise Fault(self.path, node.line, "a number cannot be a %s" % kind)
            return str(node.value), kind
        if isinstance(node, Read):
            if node.name in self.slots:
                slot, kind, movable = self.slots[node.name]
                out = self.temp()
                self.emit("  %s = load %s, ptr %s"
                          % (out, self.machine(kind, node.line), slot))
                return out, kind
            return self.variant(node.name, None, want, node.line)
        if isinstance(node, Pick):
            target, kind = self.value(node.target, None)
            shape = self.product(kind, node.line)
            for index, field in enumerate(shape.fields):
                if field.name == node.field:
                    out = self.temp()
                    self.emit("  %s = extractvalue %%%s %s, %d"
                              % (out, kind, target, index))
                    return out, field.kind
            raise Fault(self.path, node.line,
                        "%s has no field named %s" % (kind, node.field))
        if isinstance(node, Call):
            if node.name in self.shapes:
                return self.make(node)
            if any(label is not None for label in node.labels):
                raise Fault(self.path, node.line,
                            "only a #struct takes named fields, and %s is not one"
                            % node.name)
            if node.name not in self.funcs:
                return self.variant(node.name, node.args, want, node.line)
            callee = self.funcs[node.name]
            if len(node.args) != len(callee.params):
                raise Fault(self.path, node.line,
                            "%s takes %s, %d given"
                            % (node.name,
                               plural(len(callee.params), "argument", "arguments"),
                               len(node.args)))
            given = []
            for arg, param in zip(node.args, callee.params):
                given.append("%s %s" % (self.machine(param.kind, param.line),
                                        self.expression(arg, param.kind)))
            out = self.temp()
            self.emit("  %s = call %s @%s(%s)"
                      % (out, self.machine(callee.result, node.line), node.name,
                         ", ".join(given)))
            return out, callee.result
        if isinstance(node, Binary):
            if node.op in COMPARE:
                left, kind = self.value(node.left, None)
                if kind not in NUMERIC:
                    raise Fault(self.path, node.line,
                                "%s cannot be compared" % kind)
                right = self.expression(node.right, kind)
                out = self.temp()
                self.emit("  %s = icmp %s %s %s, %s"
                          % (out, COMPARE[node.op], SCALARS[kind], left, right))
                return out, "bool"
            kind = want if want is not None else "u32"
            if kind not in NUMERIC:
                raise Fault(self.path, node.line,
                            "arithmetic does not produce a %s" % kind)
            left = self.expression(node.left, kind)
            right = self.expression(node.right, kind)
            out = self.temp()
            self.emit("  %s = %s %s %s, %s"
                      % (out, ARITH[node.op], SCALARS[kind], left, right))
            return out, kind
        raise Fault(self.path, 0, "cannot emit %r" % node)

    def make(self, node):
        shape = self.product(node.name, node.line)
        names = [f.name for f in shape.fields]
        if node.labels != names:
            shown = [label if label else "?" for label in node.labels]
            raise Fault(self.path, node.line,
                        "%s wants the fields %s in order, found %s"
                        % (node.name, ", ".join(names), ", ".join(shown) or "none"))
        value = "undef"
        for index, expr in enumerate(node.args):
            field = shape.fields[index]
            inner = self.expression(expr, field.kind)
            out = self.temp()
            self.emit("  %s = insertvalue %%%s %s, %s %s, %d"
                      % (out, node.name, value,
                         self.machine(field.kind, field.line), inner, index))
            value = out
        return value, node.name

    def variant(self, name, args, want, line):
        if want is None or want not in self.shapes:
            raise Fault(self.path, line, "%s is not bound" % name)
        shape = self.sum(want, line)
        for index, variant in enumerate(shape.variants):
            if variant.name != name:
                continue
            carried = len(args) if args is not None else 0
            wanted = 1 if variant.payload else 0
            if carried != wanted:
                raise Fault(self.path, line,
                            "%s carries %s" % (name, plural(wanted, "value", "values")))
            wide = None
            if variant.payload:
                inner = self.machine(variant.payload, line)
                carried = self.expression(args[0], variant.payload)
                wide = self.temp()
                if inner == CARRIER:
                    self.emit("  %s = or %s %s, 0" % (wide, CARRIER, carried))
                else:
                    self.emit("  %s = zext %s %s to %s"
                              % (wide, inner, carried, CARRIER))
            tagged = self.temp()
            self.emit("  %s = insertvalue %%%s undef, i32 %d, 0"
                      % (tagged, want, index))
            filled = self.temp()
            self.emit("  %s = insertvalue %%%s %s, %s %s, 1"
                      % (filled, want, tagged, CARRIER,
                         wide if wide is not None else "0"))
            return filled, want
        raise Fault(self.path, line, "%s has no variant named %s" % (want, name))


def compile(path):
    with open(path, "r") as handle:
        source = handle.read()
    items = Parser(path, lex(path, source)).program()
    if "main" not in [i.name for i in items if isinstance(i, Func)]:
        raise Fault(path, 0, "a puzzle needs a function named main")
    return Emitter(path, items).program()


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
