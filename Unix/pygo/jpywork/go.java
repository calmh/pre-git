import org.python.core.*;

public class go extends java.lang.Object {
    static String[] jpy$mainProperties = new String[] {"python.modules.builtin", "exceptions:org.python.core.exceptions"};
    static String[] jpy$proxyProperties = new String[] {"python.modules.builtin", "exceptions:org.python.core.exceptions", "python.options.showJavaExceptions", "true"};
    static String[] jpy$packages = new String[] {"org.python.core", null};
    
    public static class _PyInner extends PyFunctionTable implements PyRunnable {
        private static PyObject i$0;
        private static PyObject i$1;
        private static PyObject i$2;
        private static PyObject i$3;
        private static PyObject i$4;
        private static PyObject s$5;
        private static PyObject i$6;
        private static PyObject s$7;
        private static PyObject i$8;
        private static PyObject s$9;
        private static PyObject s$10;
        private static PyObject s$11;
        private static PyObject s$12;
        private static PyObject s$13;
        private static PyObject s$14;
        private static PyObject s$15;
        private static PyObject s$16;
        private static PyObject s$17;
        private static PyObject s$18;
        private static PyObject i$19;
        private static PyObject s$20;
        private static PyObject s$21;
        private static PyObject s$22;
        private static PyObject s$23;
        private static PyObject s$24;
        private static PyObject s$25;
        private static PyObject s$26;
        private static PyObject s$27;
        private static PyObject s$28;
        private static PyObject s$29;
        private static PyFunctionTable funcTable;
        private static PyCode c$0___init__;
        private static PyCode c$1_freedoms;
        private static PyCode c$2__Board__freedoms;
        private static PyCode c$3_kill;
        private static PyCode c$4__Board__kill;
        private static PyCode c$5_move;
        private static PyCode c$6_set;
        private static PyCode c$7_undo;
        private static PyCode c$8_eval;
        private static PyCode c$9_movelist;
        private static PyCode c$10___str__;
        private static PyCode c$11_Board;
        private static PyCode c$12___init__;
        private static PyCode c$13___repr__;
        private static PyCode c$14_Move;
        private static PyCode c$15___init__;
        private static PyCode c$16_makeMove;
        private static PyCode c$17_minimaxValue;
        private static PyCode c$18_AI;
        private static PyCode c$19___init__;
        private static PyCode c$20_readMove;
        private static PyCode c$21_start;
        private static PyCode c$22_UI;
        private static PyCode c$23_main;
        private static PyCode c$24_main;
        private static void initConstants() {
            i$0 = Py.newInteger(0);
            i$1 = Py.newInteger(2);
            i$2 = Py.newInteger(1);
            i$3 = Py.newInteger(3);
            i$4 = Py.newInteger(10);
            s$5 = Py.newString("Illegal move");
            i$6 = Py.newInteger(1000);
            s$7 = Py.newString("   ");
            i$8 = Py.newInteger(26);
            s$9 = Py.newString(" ");
            s$10 = Py.newString("\012");
            s$11 = Py.newString("  ");
            s$12 = Py.newString("\267 ");
            s$13 = Py.newString("X ");
            s$14 = Py.newString("O ");
            s$15 = Py.newString("Prisoners: %d B, %d W\012");
            s$16 = Py.newString("A");
            s$17 = Py.newString("\267");
            s$18 = Py.newString("* LuserGo v0.01\012  Copyright (C) 2002 Jakob Borg\012");
            i$19 = Py.newInteger(9);
            s$20 = Py.newString("Your move: ");
            s$21 = Py.newString("Choose black or white [B/W]: ");
            s$22 = Py.newString("B");
            s$23 = Py.newString("b");
            s$24 = Py.newString("W");
            s$25 = Py.newString("w");
            s$26 = Py.newString("Thinking ");
            s$27 = Py.newString(" OK");
            s$28 = Py.newString("__main__");
            s$29 = Py.newString("/usr/home/jb/devel/pygo/go.py");
            funcTable = new _PyInner();
            c$0___init__ = Py.newCode(2, new String[] {"self", "size", "n"}, "/usr/home/jb/devel/pygo/go.py", "__init__", false, false, funcTable, 2, null, null, 0, 1);
            c$1_freedoms = Py.newCode(3, new String[] {"self", "x", "y", "color"}, "/usr/home/jb/devel/pygo/go.py", "freedoms", false, false, funcTable, 3, null, null, 0, 1);
            c$2__Board__freedoms = Py.newCode(4, new String[] {"self", "x", "y", "color", "yo", "xo", "ny", "nx", "free"}, "/usr/home/jb/devel/pygo/go.py", "_Board__freedoms", false, false, funcTable, 4, null, null, 0, 1);
            c$3_kill = Py.newCode(3, new String[] {"self", "x", "y", "k", "color"}, "/usr/home/jb/devel/pygo/go.py", "kill", false, false, funcTable, 5, null, null, 0, 1);
            c$4__Board__kill = Py.newCode(4, new String[] {"self", "x", "y", "color", "yo", "kills", "xo", "ny", "nx"}, "/usr/home/jb/devel/pygo/go.py", "_Board__kill", false, false, funcTable, 6, null, null, 0, 1);
            c$5_move = Py.newCode(3, new String[] {"self", "move", "color"}, "/usr/home/jb/devel/pygo/go.py", "move", false, false, funcTable, 7, null, null, 0, 1);
            c$6_set = Py.newCode(4, new String[] {"self", "x", "y", "color", "yo", "p", "xo", "ny", "nx", "f", "c"}, "/usr/home/jb/devel/pygo/go.py", "set", false, false, funcTable, 8, null, null, 0, 1);
            c$7_undo = Py.newCode(1, new String[] {"self", "yo", "event", "move", "xo", "ny", "nx", "type", "y", "x"}, "/usr/home/jb/devel/pygo/go.py", "undo", false, false, funcTable, 9, null, null, 0, 1);
            c$8_eval = Py.newCode(1, new String[] {"self", "value"}, "/usr/home/jb/devel/pygo/go.py", "eval", false, false, funcTable, 10, null, null, 0, 1);
            c$9_movelist = Py.newCode(2, new String[] {"self", "color", "x", "moves", "y"}, "/usr/home/jb/devel/pygo/go.py", "movelist", false, false, funcTable, 11, null, null, 0, 1);
            c$10___str__ = Py.newCode(1, new String[] {"self", "n", "tstr", "y", "point", "line"}, "/usr/home/jb/devel/pygo/go.py", "__str__", false, false, funcTable, 12, null, null, 0, 1);
            c$11_Board = Py.newCode(0, new String[] {}, "/usr/home/jb/devel/pygo/go.py", "Board", false, false, funcTable, 13, null, null, 0, 0);
            c$12___init__ = Py.newCode(3, new String[] {"self", "x", "y"}, "/usr/home/jb/devel/pygo/go.py", "__init__", false, false, funcTable, 14, null, null, 0, 1);
            c$13___repr__ = Py.newCode(1, new String[] {"self"}, "/usr/home/jb/devel/pygo/go.py", "__repr__", false, false, funcTable, 15, null, null, 0, 1);
            c$14_Move = Py.newCode(0, new String[] {}, "/usr/home/jb/devel/pygo/go.py", "Move", false, false, funcTable, 16, null, null, 0, 0);
            c$15___init__ = Py.newCode(2, new String[] {"self", "board"}, "/usr/home/jb/devel/pygo/go.py", "__init__", false, false, funcTable, 17, null, null, 0, 1);
            c$16_makeMove = Py.newCode(2, new String[] {"self", "color", "move", "moves", "val"}, "/usr/home/jb/devel/pygo/go.py", "makeMove", false, false, funcTable, 18, null, null, 0, 1);
            c$17_minimaxValue = Py.newCode(2, new String[] {"self", "color", "moves", "ncolor", "val", "move", "gradedMoves"}, "/usr/home/jb/devel/pygo/go.py", "minimaxValue", false, false, funcTable, 19, null, null, 0, 1);
            c$18_AI = Py.newCode(0, new String[] {}, "/usr/home/jb/devel/pygo/go.py", "AI", false, false, funcTable, 20, null, null, 0, 0);
            c$19___init__ = Py.newCode(1, new String[] {"self"}, "/usr/home/jb/devel/pygo/go.py", "__init__", false, false, funcTable, 21, null, null, 0, 1);
            c$20_readMove = Py.newCode(1, new String[] {"self", "x", "move", "y"}, "/usr/home/jb/devel/pygo/go.py", "readMove", false, false, funcTable, 22, null, null, 0, 1);
            c$21_start = Py.newCode(1, new String[] {"self", "move", "color", "pcolor"}, "/usr/home/jb/devel/pygo/go.py", "start", false, false, funcTable, 23, null, null, 0, 1);
            c$22_UI = Py.newCode(0, new String[] {}, "/usr/home/jb/devel/pygo/go.py", "UI", false, false, funcTable, 24, null, null, 0, 0);
            c$23_main = Py.newCode(0, new String[] {"ui"}, "/usr/home/jb/devel/pygo/go.py", "main", false, false, funcTable, 25, null, null, 0, 1);
            c$24_main = Py.newCode(0, new String[] {}, "/usr/home/jb/devel/pygo/go.py", "main", false, false, funcTable, 26, null, null, 0, 0);
        }
        
        
        public PyCode getMain() {
            if (c$24_main == null) _PyInner.initConstants();
            return c$24_main;
        }
        
        public PyObject call_function(int index, PyFrame frame) {
            switch (index){
                case 0:
                return _PyInner.__listcomprehension$1(frame);
                case 1:
                return _PyInner.__listcomprehension$2(frame);
                case 2:
                return _PyInner.__init__$3(frame);
                case 3:
                return _PyInner.freedoms$4(frame);
                case 4:
                return _PyInner._Board__freedoms$5(frame);
                case 5:
                return _PyInner.kill$6(frame);
                case 6:
                return _PyInner._Board__kill$7(frame);
                case 7:
                return _PyInner.move$8(frame);
                case 8:
                return _PyInner.set$9(frame);
                case 9:
                return _PyInner.undo$10(frame);
                case 10:
                return _PyInner.eval$11(frame);
                case 11:
                return _PyInner.movelist$12(frame);
                case 12:
                return _PyInner.__str__$13(frame);
                case 13:
                return _PyInner.Board$14(frame);
                case 14:
                return _PyInner.__init__$15(frame);
                case 15:
                return _PyInner.__repr__$16(frame);
                case 16:
                return _PyInner.Move$17(frame);
                case 17:
                return _PyInner.__init__$18(frame);
                case 18:
                return _PyInner.makeMove$19(frame);
                case 19:
                return _PyInner.minimaxValue$20(frame);
                case 20:
                return _PyInner.AI$21(frame);
                case 21:
                return _PyInner.__init__$22(frame);
                case 22:
                return _PyInner.readMove$23(frame);
                case 23:
                return _PyInner.start$24(frame);
                case 24:
                return _PyInner.UI$25(frame);
                case 25:
                return _PyInner.main$26(frame);
                case 26:
                return _PyInner.main$27(frame);
                default:
                return null;
            }
        }
        
        private static PyObject __listcomprehension$1(PyFrame frame) {
            // Temporary Variables
            int t$0$int;
            PyObject t$0$PyObject, t$1$PyObject, t$2$PyObject, t$3$PyObject;
            
            t$0$PyObject = new PyList(new PyObject[] {});
            t$1$PyObject = t$0$PyObject.__getattr__("append");
            t$0$int = 0;
            t$3$PyObject = frame.getglobal("range").__call__(frame.getlocal(1));
            while ((t$2$PyObject = t$3$PyObject.__finditem__(t$0$int++)) != null) {
                frame.setlocal(2, t$2$PyObject);
                t$1$PyObject.__call__(new PyList(new PyObject[] {frame.getglobal("EMPTY")})._mul(frame.getlocal(1)));
            }
            return t$0$PyObject;
        }
        
        private static PyObject __listcomprehension$2(PyFrame frame) {
            // Temporary Variables
            int t$0$int;
            PyObject t$0$PyObject, t$1$PyObject, t$2$PyObject, t$3$PyObject;
            
            t$0$PyObject = new PyList(new PyObject[] {});
            t$1$PyObject = t$0$PyObject.__getattr__("append");
            t$0$int = 0;
            t$3$PyObject = frame.getglobal("range").__call__(frame.getlocal(1));
            while ((t$2$PyObject = t$3$PyObject.__finditem__(t$0$int++)) != null) {
                frame.setlocal(2, t$2$PyObject);
                t$1$PyObject.__call__(new PyList(new PyObject[] {i$0})._mul(frame.getlocal(1)));
            }
            return t$0$PyObject;
        }
        
        private static PyObject __init__$3(PyFrame frame) {
            frame.getlocal(0).__setattr__("board", __listcomprehension$1(frame));
            frame.getlocal(0).__setattr__("neighbors", __listcomprehension$2(frame));
            frame.getlocal(0).__setattr__("tmpBoard", frame.getglobal("None"));
            frame.getlocal(0).__setattr__("prisoners", new PyDictionary(new PyObject[] {frame.getglobal("BLACK"), i$0, frame.getglobal("WHITE"), i$0}));
            frame.getlocal(0).__setattr__("moveHistory", new PyList(new PyObject[] {}));
            frame.getlocal(0).__setattr__("tmpMoves", new PyList(new PyObject[] {}));
            frame.getlocal(0).__setattr__("size", frame.getlocal(1));
            return Py.None;
        }
        
        private static PyObject freedoms$4(PyFrame frame) {
            if (frame.getlocal(0).__getattr__("board").__getitem__(frame.getlocal(2)).__getitem__(frame.getlocal(1))._eq(frame.getglobal("EMPTY")).__nonzero__()) {
                return frame.getglobal("None");
            }
            frame.getlocal(0).__setattr__("tmpBoard", frame.getglobal("deepcopy").__call__(frame.getlocal(0).__getattr__("board")));
            frame.setlocal(3, frame.getlocal(0).__getattr__("tmpBoard").__getitem__(frame.getlocal(2)).__getitem__(frame.getlocal(1)));
            return frame.getlocal(0).invoke("_Board__freedoms", new PyObject[] {frame.getlocal(1), frame.getlocal(2), frame.getlocal(3)});
        }
        
        private static PyObject _Board__freedoms$5(PyFrame frame) {
            // Temporary Variables
            int t$0$int;
            PyObject[] t$0$PyObject__;
            PyObject t$0$PyObject, t$1$PyObject, t$2$PyObject, t$3$PyObject, t$4$PyObject, t$5$PyObject, t$6$PyObject, t$7$PyObject;
            
            // Code
            frame.setlocal(8, i$0);
            if (frame.getlocal(0).__getattr__("tmpBoard").__getitem__(frame.getlocal(2)).__getitem__(frame.getlocal(1))._eq(frame.getlocal(3)).__nonzero__()) {
                t$0$PyObject = i$2;
                t$1$PyObject = frame.getlocal(0);
                t$2$PyObject = t$1$PyObject.__getattr__("tmpBoard");
                t$3$PyObject = frame.getlocal(2);
                t$4$PyObject = t$2$PyObject.__getitem__(t$3$PyObject);
                t$5$PyObject = frame.getlocal(1);
                t$4$PyObject.__setitem__(t$5$PyObject, t$4$PyObject.__getitem__(t$5$PyObject).__iadd__(t$0$PyObject));
                t$0$int = 0;
                t$4$PyObject = new PyList(new PyObject[] {new PyTuple(new PyObject[] {i$2, i$0}), new PyTuple(new PyObject[] {i$0, i$2}), new PyTuple(new PyObject[] {i$2.__neg__(), i$0}), new PyTuple(new PyObject[] {i$0, i$2.__neg__()})});
                while ((t$0$PyObject = t$4$PyObject.__finditem__(t$0$int++)) != null) {
                    t$0$PyObject__ = org.python.core.Py.unpackSequence(t$0$PyObject, 2);
                    frame.setlocal(5, t$0$PyObject__[0]);
                    frame.setlocal(4, t$0$PyObject__[1]);
                    frame.setlocal(7, frame.getlocal(1)._add(frame.getlocal(5)));
                    frame.setlocal(6, frame.getlocal(2)._add(frame.getlocal(4)));
                    if (((t$5$PyObject = ((t$6$PyObject = ((t$7$PyObject = frame.getlocal(7)._lt(i$0)).__nonzero__() ? t$7$PyObject : frame.getlocal(7)._ge(frame.getlocal(0).__getattr__("size")))).__nonzero__() ? t$6$PyObject : frame.getlocal(6)._lt(i$0))).__nonzero__() ? t$5$PyObject : frame.getlocal(6)._ge(frame.getlocal(0).__getattr__("size"))).__nonzero__()) {
                        continue;
                    }
                    if (frame.getlocal(0).__getattr__("tmpBoard").__getitem__(frame.getlocal(6)).__getitem__(frame.getlocal(7))._eq(frame.getglobal("EMPTY")).__nonzero__()) {
                        t$5$PyObject = i$2;
                        frame.setlocal(8, frame.getlocal(8).__iadd__(t$5$PyObject));
                        frame.getlocal(0).__getattr__("tmpBoard").__getitem__(frame.getlocal(6)).__setitem__(frame.getlocal(7), frame.getglobal("EMPTY")._add(i$4));
                    }
                    else if (frame.getlocal(0).__getattr__("tmpBoard").__getitem__(frame.getlocal(6)).__getitem__(frame.getlocal(7))._eq(frame.getlocal(3)).__nonzero__()) {
                        t$5$PyObject = frame.getlocal(0).invoke("_Board__freedoms", new PyObject[] {frame.getlocal(7), frame.getlocal(6), frame.getlocal(3)});
                        frame.setlocal(8, frame.getlocal(8).__iadd__(t$5$PyObject));
                    }
                }
            }
            return frame.getlocal(8);
        }
        
        private static PyObject kill$6(PyFrame frame) {
            frame.setlocal(4, frame.getlocal(0).__getattr__("board").__getitem__(frame.getlocal(2)).__getitem__(frame.getlocal(1)));
            frame.getlocal(0).__setattr__("tmpBoard", frame.getglobal("deepcopy").__call__(frame.getlocal(0).__getattr__("board")));
            frame.setlocal(3, frame.getlocal(0).invoke("_Board__kill", new PyObject[] {frame.getlocal(1), frame.getlocal(2), frame.getlocal(4)}));
            frame.getlocal(0).__setattr__("board", frame.getglobal("deepcopy").__call__(frame.getlocal(0).__getattr__("tmpBoard")));
            return frame.getlocal(3);
        }
        
        private static PyObject _Board__kill$7(PyFrame frame) {
            // Temporary Variables
            int t$0$int;
            PyObject[] t$0$PyObject__;
            PyObject t$0$PyObject, t$1$PyObject, t$2$PyObject, t$3$PyObject, t$4$PyObject, t$5$PyObject, t$6$PyObject, t$7$PyObject;
            
            // Code
            frame.setlocal(5, i$0);
            if (frame.getlocal(0).__getattr__("tmpBoard").__getitem__(frame.getlocal(2)).__getitem__(frame.getlocal(1))._eq(frame.getlocal(3)).__nonzero__()) {
                t$0$PyObject = i$2;
                frame.setlocal(5, frame.getlocal(5).__iadd__(t$0$PyObject));
                frame.getlocal(0).__getattr__("tmpBoard").__getitem__(frame.getlocal(2)).__setitem__(frame.getlocal(1), frame.getglobal("EMPTY"));
                frame.getlocal(0).__getattr__("tmpMoves").invoke("append", new PyTuple(new PyObject[] {i$2.__neg__(), frame.getlocal(3), frame.getlocal(1), frame.getlocal(2)}));
                t$0$int = 0;
                t$1$PyObject = new PyList(new PyObject[] {new PyTuple(new PyObject[] {i$2, i$0}), new PyTuple(new PyObject[] {i$0, i$2}), new PyTuple(new PyObject[] {i$2.__neg__(), i$0}), new PyTuple(new PyObject[] {i$0, i$2.__neg__()})});
                while ((t$0$PyObject = t$1$PyObject.__finditem__(t$0$int++)) != null) {
                    t$0$PyObject__ = org.python.core.Py.unpackSequence(t$0$PyObject, 2);
                    frame.setlocal(6, t$0$PyObject__[0]);
                    frame.setlocal(4, t$0$PyObject__[1]);
                    frame.setlocal(8, frame.getlocal(1)._add(frame.getlocal(6)));
                    frame.setlocal(7, frame.getlocal(2)._add(frame.getlocal(4)));
                    if (((t$2$PyObject = ((t$3$PyObject = ((t$4$PyObject = frame.getlocal(8)._lt(i$0)).__nonzero__() ? t$4$PyObject : frame.getlocal(8)._ge(frame.getlocal(0).__getattr__("size")))).__nonzero__() ? t$3$PyObject : frame.getlocal(7)._lt(i$0))).__nonzero__() ? t$2$PyObject : frame.getlocal(7)._ge(frame.getlocal(0).__getattr__("size"))).__nonzero__()) {
                        continue;
                    }
                    t$2$PyObject = i$2;
                    t$3$PyObject = frame.getlocal(0);
                    t$4$PyObject = t$3$PyObject.__getattr__("neighbors");
                    t$5$PyObject = frame.getlocal(7);
                    t$6$PyObject = t$4$PyObject.__getitem__(t$5$PyObject);
                    t$7$PyObject = frame.getlocal(8);
                    t$6$PyObject.__setitem__(t$7$PyObject, t$6$PyObject.__getitem__(t$7$PyObject).__isub__(t$2$PyObject));
                    t$2$PyObject = frame.getlocal(0).invoke("_Board__kill", new PyObject[] {frame.getlocal(8), frame.getlocal(7), frame.getlocal(3)});
                    frame.setlocal(5, frame.getlocal(5).__iadd__(t$2$PyObject));
                }
            }
            return frame.getlocal(5);
        }
        
        private static PyObject move$8(PyFrame frame) {
            frame.getlocal(0).invoke("set", new PyObject[] {frame.getlocal(1).__getattr__("x"), frame.getlocal(1).__getattr__("y"), frame.getlocal(2)});
            return Py.None;
        }
        
        private static PyObject set$9(PyFrame frame) {
            // Temporary Variables
            int t$0$int;
            PyObject[] t$0$PyObject__;
            PyObject t$0$PyObject, t$1$PyObject, t$2$PyObject, t$3$PyObject, t$4$PyObject, t$5$PyObject, t$6$PyObject, t$7$PyObject, t$8$PyObject;
            
            // Code
            if (frame.getglobal("__debug__").__nonzero__()) Py.assert(frame.getlocal(0).__getattr__("board").__getitem__(frame.getlocal(2)).__getitem__(frame.getlocal(1))._eq(frame.getglobal("EMPTY")), s$5);
            frame.getlocal(0).__setattr__("tmpMoves", new PyList(new PyObject[] {new PyTuple(new PyObject[] {i$2, frame.getlocal(3), frame.getlocal(1), frame.getlocal(2)})}));
            frame.getlocal(0).__getattr__("board").__getitem__(frame.getlocal(2)).__setitem__(frame.getlocal(1), frame.getlocal(3));
            t$0$int = 0;
            t$1$PyObject = new PyList(new PyObject[] {new PyTuple(new PyObject[] {i$2, i$0}), new PyTuple(new PyObject[] {i$0, i$2}), new PyTuple(new PyObject[] {i$2.__neg__(), i$0}), new PyTuple(new PyObject[] {i$0, i$2.__neg__()})});
            while ((t$0$PyObject = t$1$PyObject.__finditem__(t$0$int++)) != null) {
                t$0$PyObject__ = org.python.core.Py.unpackSequence(t$0$PyObject, 2);
                frame.setlocal(6, t$0$PyObject__[0]);
                frame.setlocal(4, t$0$PyObject__[1]);
                frame.setlocal(8, frame.getlocal(1)._add(frame.getlocal(6)));
                frame.setlocal(7, frame.getlocal(2)._add(frame.getlocal(4)));
                if (((t$2$PyObject = ((t$3$PyObject = ((t$4$PyObject = frame.getlocal(8)._lt(i$0)).__nonzero__() ? t$4$PyObject : frame.getlocal(8)._ge(frame.getlocal(0).__getattr__("size")))).__nonzero__() ? t$3$PyObject : frame.getlocal(7)._lt(i$0))).__nonzero__() ? t$2$PyObject : frame.getlocal(7)._ge(frame.getlocal(0).__getattr__("size"))).__nonzero__()) {
                    continue;
                }
                t$2$PyObject = i$2;
                t$3$PyObject = frame.getlocal(0);
                t$4$PyObject = t$3$PyObject.__getattr__("neighbors");
                t$5$PyObject = frame.getlocal(7);
                t$6$PyObject = t$4$PyObject.__getitem__(t$5$PyObject);
                t$7$PyObject = frame.getlocal(8);
                t$6$PyObject.__setitem__(t$7$PyObject, t$6$PyObject.__getitem__(t$7$PyObject).__iadd__(t$2$PyObject));
                frame.setlocal(10, frame.getlocal(0).__getattr__("board").__getitem__(frame.getlocal(7)).__getitem__(frame.getlocal(8)));
                if (((t$2$PyObject = frame.getlocal(10)._ne(frame.getlocal(3))).__nonzero__() ? frame.getlocal(10)._ne(frame.getglobal("EMPTY")) : t$2$PyObject).__nonzero__()) {
                    frame.setlocal(9, frame.getlocal(0).invoke("freedoms", frame.getlocal(8), frame.getlocal(7)));
                    if (frame.getlocal(9)._eq(i$0).__nonzero__()) {
                        frame.setlocal(5, frame.getlocal(0).invoke("kill", frame.getlocal(8), frame.getlocal(7)));
                        frame.getlocal(0).__getattr__("tmpMoves").invoke("append", new PyTuple(new PyObject[] {i$0, frame.getlocal(3), frame.getlocal(5)}));
                        t$2$PyObject = frame.getlocal(5);
                        t$6$PyObject = frame.getlocal(0);
                        t$7$PyObject = t$6$PyObject.__getattr__("prisoners");
                        t$8$PyObject = frame.getlocal(3);
                        t$7$PyObject.__setitem__(t$8$PyObject, t$7$PyObject.__getitem__(t$8$PyObject).__iadd__(t$2$PyObject));
                    }
                }
            }
            frame.getlocal(0).__getattr__("moveHistory").invoke("append", frame.getlocal(0).__getattr__("tmpMoves"));
            return Py.None;
        }
        
        private static PyObject undo$10(PyFrame frame) {
            // Temporary Variables
            int t$0$int, t$1$int, t$2$int;
            PyObject[] t$0$PyObject__;
            PyObject t$0$PyObject, t$1$PyObject, t$2$PyObject, t$3$PyObject, t$4$PyObject, t$5$PyObject, t$6$PyObject, t$7$PyObject, t$8$PyObject, t$9$PyObject, t$10$PyObject, t$11$PyObject, t$12$PyObject, t$13$PyObject, t$14$PyObject, t$15$PyObject, t$16$PyObject, t$17$PyObject;
            
            // Code
            frame.setlocal(3, frame.getlocal(0).__getattr__("moveHistory").invoke("pop"));
            t$0$int = 0;
            t$1$PyObject = frame.getlocal(3);
            while ((t$0$PyObject = t$1$PyObject.__finditem__(t$0$int++)) != null) {
                frame.setlocal(2, t$0$PyObject);
                frame.setlocal(7, frame.getlocal(2).__getitem__(i$0));
                if (frame.getlocal(7)._eq(i$2).__nonzero__()) {
                    t$0$PyObject__ = org.python.core.Py.unpackSequence(new PyTuple(new PyObject[] {frame.getlocal(2).__getitem__(i$1), frame.getlocal(2).__getitem__(i$3)}), 2);
                    frame.setlocal(9, t$0$PyObject__[0]);
                    frame.setlocal(8, t$0$PyObject__[1]);
                    frame.getlocal(0).__getattr__("board").__getitem__(frame.getlocal(8)).__setitem__(frame.getlocal(9), frame.getglobal("EMPTY"));
                    t$1$int = 0;
                    t$3$PyObject = new PyList(new PyObject[] {new PyTuple(new PyObject[] {i$2, i$0}), new PyTuple(new PyObject[] {i$0, i$2}), new PyTuple(new PyObject[] {i$2.__neg__(), i$0}), new PyTuple(new PyObject[] {i$0, i$2.__neg__()})});
                    while ((t$2$PyObject = t$3$PyObject.__finditem__(t$1$int++)) != null) {
                        t$0$PyObject__ = org.python.core.Py.unpackSequence(t$2$PyObject, 2);
                        frame.setlocal(4, t$0$PyObject__[0]);
                        frame.setlocal(1, t$0$PyObject__[1]);
                        frame.setlocal(6, frame.getlocal(9)._add(frame.getlocal(4)));
                        frame.setlocal(5, frame.getlocal(8)._add(frame.getlocal(1)));
                        if (((t$4$PyObject = ((t$5$PyObject = ((t$6$PyObject = frame.getlocal(6)._lt(i$0)).__nonzero__() ? t$6$PyObject : frame.getlocal(6)._ge(frame.getlocal(0).__getattr__("size")))).__nonzero__() ? t$5$PyObject : frame.getlocal(5)._lt(i$0))).__nonzero__() ? t$4$PyObject : frame.getlocal(5)._ge(frame.getlocal(0).__getattr__("size"))).__nonzero__()) {
                            continue;
                        }
                        t$4$PyObject = i$2;
                        t$5$PyObject = frame.getlocal(0);
                        t$6$PyObject = t$5$PyObject.__getattr__("neighbors");
                        t$7$PyObject = frame.getlocal(5);
                        t$8$PyObject = t$6$PyObject.__getitem__(t$7$PyObject);
                        t$9$PyObject = frame.getlocal(6);
                        t$8$PyObject.__setitem__(t$9$PyObject, t$8$PyObject.__getitem__(t$9$PyObject).__isub__(t$4$PyObject));
                    }
                }
                else if (frame.getlocal(7)._eq(i$2.__neg__()).__nonzero__()) {
                    t$0$PyObject__ = org.python.core.Py.unpackSequence(new PyTuple(new PyObject[] {frame.getlocal(2).__getitem__(i$1), frame.getlocal(2).__getitem__(i$3)}), 2);
                    frame.setlocal(9, t$0$PyObject__[0]);
                    frame.setlocal(8, t$0$PyObject__[1]);
                    frame.getlocal(0).__getattr__("board").__getitem__(frame.getlocal(8)).__setitem__(frame.getlocal(9), frame.getlocal(2).__getitem__(i$2));
                    t$2$int = 0;
                    t$8$PyObject = new PyList(new PyObject[] {new PyTuple(new PyObject[] {i$2, i$0}), new PyTuple(new PyObject[] {i$0, i$2}), new PyTuple(new PyObject[] {i$2.__neg__(), i$0}), new PyTuple(new PyObject[] {i$0, i$2.__neg__()})});
                    while ((t$4$PyObject = t$8$PyObject.__finditem__(t$2$int++)) != null) {
                        t$0$PyObject__ = org.python.core.Py.unpackSequence(t$4$PyObject, 2);
                        frame.setlocal(4, t$0$PyObject__[0]);
                        frame.setlocal(1, t$0$PyObject__[1]);
                        frame.setlocal(6, frame.getlocal(9)._add(frame.getlocal(4)));
                        frame.setlocal(5, frame.getlocal(8)._add(frame.getlocal(1)));
                        if (((t$9$PyObject = ((t$10$PyObject = ((t$11$PyObject = frame.getlocal(6)._lt(i$0)).__nonzero__() ? t$11$PyObject : frame.getlocal(6)._ge(frame.getlocal(0).__getattr__("size")))).__nonzero__() ? t$10$PyObject : frame.getlocal(5)._lt(i$0))).__nonzero__() ? t$9$PyObject : frame.getlocal(5)._ge(frame.getlocal(0).__getattr__("size"))).__nonzero__()) {
                            continue;
                        }
                        t$9$PyObject = i$2;
                        t$10$PyObject = frame.getlocal(0);
                        t$11$PyObject = t$10$PyObject.__getattr__("neighbors");
                        t$12$PyObject = frame.getlocal(5);
                        t$13$PyObject = t$11$PyObject.__getitem__(t$12$PyObject);
                        t$14$PyObject = frame.getlocal(6);
                        t$13$PyObject.__setitem__(t$14$PyObject, t$13$PyObject.__getitem__(t$14$PyObject).__iadd__(t$9$PyObject));
                    }
                }
                else if (frame.getlocal(7)._eq(i$0).__nonzero__()) {
                    t$9$PyObject = frame.getlocal(2).__getitem__(i$1);
                    t$13$PyObject = frame.getlocal(2);
                    t$14$PyObject = i$2;
                    t$15$PyObject = frame.getlocal(0);
                    t$16$PyObject = t$15$PyObject.__getattr__("prisoners");
                    t$17$PyObject = t$13$PyObject.__getitem__(t$14$PyObject);
                    t$16$PyObject.__setitem__(t$17$PyObject, t$16$PyObject.__getitem__(t$17$PyObject).__isub__(t$9$PyObject));
                }
            }
            return Py.None;
        }
        
        private static PyObject eval$11(PyFrame frame) {
            // Temporary Variables
            PyObject t$0$PyObject;
            
            // Code
            frame.setlocal(1, i$0);
            t$0$PyObject = i$6._mul(frame.getlocal(0).__getattr__("prisoners").__getitem__(frame.getglobal("BLACK")))._sub(i$6._mul(frame.getlocal(0).__getattr__("prisoners").__getitem__(frame.getglobal("WHITE"))));
            frame.setlocal(1, frame.getlocal(1).__iadd__(t$0$PyObject));
            return frame.getlocal(1);
        }
        
        private static PyObject movelist$12(PyFrame frame) {
            // Temporary Variables
            int t$0$int, t$1$int;
            PyObject t$0$PyObject, t$1$PyObject, t$2$PyObject, t$3$PyObject, t$4$PyObject;
            
            // Code
            frame.setlocal(3, new PyList(new PyObject[] {}));
            t$0$int = 0;
            t$1$PyObject = frame.getglobal("range").__call__(frame.getlocal(0).__getattr__("size"));
            while ((t$0$PyObject = t$1$PyObject.__finditem__(t$0$int++)) != null) {
                frame.setlocal(2, t$0$PyObject);
                t$1$int = 0;
                t$3$PyObject = frame.getglobal("range").__call__(frame.getlocal(0).__getattr__("size"));
                while ((t$2$PyObject = t$3$PyObject.__finditem__(t$1$int++)) != null) {
                    frame.setlocal(4, t$2$PyObject);
                    if (((t$4$PyObject = frame.getlocal(0).__getattr__("board").__getitem__(frame.getlocal(4)).__getitem__(frame.getlocal(2))._eq(frame.getglobal("EMPTY"))).__nonzero__() ? frame.getlocal(0).__getattr__("neighbors").__getitem__(frame.getlocal(4)).__getitem__(frame.getlocal(2))._ne(i$0) : t$4$PyObject).__nonzero__()) {
                        frame.getlocal(3).invoke("append", frame.getglobal("Move").__call__(frame.getlocal(2), frame.getlocal(4)));
                    }
                }
            }
            return frame.getlocal(3);
        }
        
        private static PyObject __str__$13(PyFrame frame) {
            // Temporary Variables
            int t$0$int, t$1$int, t$2$int;
            PyObject t$0$PyObject, t$1$PyObject, t$2$PyObject, t$3$PyObject, t$4$PyObject, t$5$PyObject, t$6$PyObject;
            
            // Code
            frame.setlocal(2, s$7);
            t$0$int = 0;
            t$1$PyObject = frame.getglobal("range").__call__(frame.getlocal(0).__getattr__("size"));
            while ((t$0$PyObject = t$1$PyObject.__finditem__(t$0$int++)) != null) {
                frame.setlocal(1, t$0$PyObject);
                t$2$PyObject = frame.getglobal("string").__getattr__("letters").__getitem__(i$8._add(frame.getlocal(1)))._add(s$9);
                frame.setlocal(2, frame.getlocal(2).__iadd__(t$2$PyObject));
            }
            t$2$PyObject = s$10;
            frame.setlocal(2, frame.getlocal(2).__iadd__(t$2$PyObject));
            frame.setlocal(3, i$2);
            t$1$int = 0;
            t$3$PyObject = frame.getlocal(0).__getattr__("board");
            while ((t$2$PyObject = t$3$PyObject.__finditem__(t$1$int++)) != null) {
                frame.setlocal(5, t$2$PyObject);
                t$4$PyObject = frame.getglobal("str").__call__(frame.getlocal(3))._add(s$11);
                frame.setlocal(2, frame.getlocal(2).__iadd__(t$4$PyObject));
                t$4$PyObject = i$2;
                frame.setlocal(3, frame.getlocal(3).__iadd__(t$4$PyObject));
                t$2$int = 0;
                t$5$PyObject = frame.getlocal(5);
                while ((t$4$PyObject = t$5$PyObject.__finditem__(t$2$int++)) != null) {
                    frame.setlocal(4, t$4$PyObject);
                    t$6$PyObject = new PyList(new PyObject[] {s$12, s$13, s$14}).__getitem__(frame.getlocal(4));
                    frame.setlocal(2, frame.getlocal(2).__iadd__(t$6$PyObject));
                }
                t$6$PyObject = s$10;
                frame.setlocal(2, frame.getlocal(2).__iadd__(t$6$PyObject));
            }
            t$6$PyObject = s$15._mod(new PyTuple(new PyObject[] {frame.getlocal(0).__getattr__("prisoners").__getitem__(frame.getglobal("BLACK")), frame.getlocal(0).__getattr__("prisoners").__getitem__(frame.getglobal("WHITE"))}));
            frame.setlocal(2, frame.getlocal(2).__iadd__(t$6$PyObject));
            return frame.getlocal(2);
        }
        
        private static PyObject Board$14(PyFrame frame) {
            frame.setlocal("__init__", new PyFunction(frame.f_globals, new PyObject[] {}, c$0___init__));
            frame.setlocal("freedoms", new PyFunction(frame.f_globals, new PyObject[] {}, c$1_freedoms));
            frame.setlocal("_Board__freedoms", new PyFunction(frame.f_globals, new PyObject[] {}, c$2__Board__freedoms));
            frame.setlocal("kill", new PyFunction(frame.f_globals, new PyObject[] {}, c$3_kill));
            frame.setlocal("_Board__kill", new PyFunction(frame.f_globals, new PyObject[] {}, c$4__Board__kill));
            frame.setlocal("move", new PyFunction(frame.f_globals, new PyObject[] {}, c$5_move));
            frame.setlocal("set", new PyFunction(frame.f_globals, new PyObject[] {}, c$6_set));
            frame.setlocal("undo", new PyFunction(frame.f_globals, new PyObject[] {}, c$7_undo));
            frame.setlocal("eval", new PyFunction(frame.f_globals, new PyObject[] {}, c$8_eval));
            frame.setlocal("movelist", new PyFunction(frame.f_globals, new PyObject[] {}, c$9_movelist));
            frame.setlocal("__str__", new PyFunction(frame.f_globals, new PyObject[] {}, c$10___str__));
            return frame.getf_locals();
        }
        
        private static PyObject __init__$15(PyFrame frame) {
            frame.getlocal(0).__setattr__("x", frame.getlocal(1));
            frame.getlocal(0).__setattr__("y", frame.getlocal(2));
            return Py.None;
        }
        
        private static PyObject __repr__$16(PyFrame frame) {
            return frame.getglobal("string").__getattr__("letters").__getitem__(frame.getglobal("string").__getattr__("letters").__getattr__("index").__call__(s$16)._add(frame.getlocal(0).__getattr__("x")))._add(frame.getglobal("str").__call__(frame.getlocal(0).__getattr__("y")._add(i$2)));
        }
        
        private static PyObject Move$17(PyFrame frame) {
            frame.setlocal("__init__", new PyFunction(frame.f_globals, new PyObject[] {}, c$12___init__));
            frame.setlocal("__repr__", new PyFunction(frame.f_globals, new PyObject[] {}, c$13___repr__));
            return frame.getf_locals();
        }
        
        private static PyObject __init__$18(PyFrame frame) {
            frame.getlocal(0).__setattr__("board", frame.getlocal(1));
            return Py.None;
        }
        
        private static PyObject makeMove$19(PyFrame frame) {
            // Temporary Variables
            PyObject[] t$0$PyObject__;
            
            // Code
            frame.getlocal(0).__setattr__("searchDepth", i$0);
            frame.getlocal(0).__setattr__("counter", i$0);
            t$0$PyObject__ = org.python.core.Py.unpackSequence(frame.getlocal(0).invoke("minimaxValue", frame.getlocal(1)), 2);
            frame.setlocal(4, t$0$PyObject__[0]);
            frame.setlocal(3, t$0$PyObject__[1]);
            Py.printComma(frame.getlocal(4));
            Py.println(frame.getlocal(3));
            frame.setlocal(2, frame.getlocal(3).__getitem__(i$0));
            frame.getlocal(0).__getattr__("board").invoke("move", frame.getlocal(2), frame.getlocal(1));
            return Py.None;
        }
        
        private static PyObject minimaxValue$20(PyFrame frame) {
            // Temporary Variables
            int t$0$int;
            PyObject[] t$0$PyObject__;
            PyObject t$0$PyObject, t$1$PyObject, t$2$PyObject, t$3$PyObject;
            
            // Code
            if (frame.getlocal(0).__getattr__("searchDepth")._eq(i$2).__nonzero__()) {
                frame.getglobal("sys").__getattr__("stdout").__getattr__("write").__call__(s$17);
                frame.getglobal("sys").__getattr__("stdout").__getattr__("flush").__call__();
            }
            frame.setlocal(3, new PyList(new PyObject[] {frame.getglobal("None"), frame.getglobal("WHITE"), frame.getglobal("BLACK")}).__getitem__(frame.getlocal(1)));
            if (frame.getlocal(0).__getattr__("searchDepth")._eq(frame.getglobal("MAXDEPTH")).__nonzero__()) {
                return new PyTuple(new PyObject[] {frame.getlocal(0).__getattr__("board").invoke("eval"), new PyList(new PyObject[] {})});
            }
            else {
                t$0$PyObject = i$2;
                t$1$PyObject = frame.getlocal(0);
                t$1$PyObject.__setattr__("searchDepth", t$1$PyObject.__getattr__("searchDepth").__iadd__(t$0$PyObject));
                frame.setlocal(2, frame.getlocal(0).__getattr__("board").invoke("movelist", frame.getlocal(1)));
                frame.setlocal(6, new PyList(new PyObject[] {}));
                t$0$int = 0;
                t$1$PyObject = frame.getlocal(2);
                while ((t$0$PyObject = t$1$PyObject.__finditem__(t$0$int++)) != null) {
                    frame.setlocal(5, t$0$PyObject);
                    frame.getlocal(0).__getattr__("board").invoke("move", frame.getlocal(5), frame.getlocal(1));
                    t$0$PyObject__ = org.python.core.Py.unpackSequence(frame.getlocal(0).invoke("minimaxValue", frame.getlocal(3)), 2);
                    frame.setlocal(4, t$0$PyObject__[0]);
                    frame.setlocal(2, t$0$PyObject__[1]);
                    frame.getlocal(6).invoke("append", new PyTuple(new PyObject[] {frame.getlocal(4), new PyList(new PyObject[] {frame.getlocal(5)})._add(frame.getlocal(2))}));
                    frame.getlocal(0).__getattr__("board").invoke("undo");
                }
                frame.getlocal(6).invoke("sort");
                if (frame.getlocal(1)._eq(frame.getglobal("BLACK")).__nonzero__()) {
                    frame.getlocal(6).invoke("reverse");
                }
                t$0$PyObject__ = org.python.core.Py.unpackSequence(frame.getlocal(6).__getitem__(i$0), 2);
                frame.setlocal(4, t$0$PyObject__[0]);
                frame.setlocal(2, t$0$PyObject__[1]);
                t$2$PyObject = i$2;
                t$3$PyObject = frame.getlocal(0);
                t$3$PyObject.__setattr__("searchDepth", t$3$PyObject.__getattr__("searchDepth").__isub__(t$2$PyObject));
                return new PyTuple(new PyObject[] {frame.getlocal(4), frame.getlocal(2)});
            }
        }
        
        private static PyObject AI$21(PyFrame frame) {
            frame.setlocal("__init__", new PyFunction(frame.f_globals, new PyObject[] {}, c$15___init__));
            frame.setlocal("makeMove", new PyFunction(frame.f_globals, new PyObject[] {}, c$16_makeMove));
            frame.setlocal("minimaxValue", new PyFunction(frame.f_globals, new PyObject[] {}, c$17_minimaxValue));
            return frame.getf_locals();
        }
        
        private static PyObject __init__$22(PyFrame frame) {
            frame.getlocal(0).__setattr__("board", frame.getglobal("Board").__call__(i$19));
            frame.getlocal(0).__setattr__("ai", frame.getglobal("AI").__call__(frame.getlocal(0).__getattr__("board")));
            return Py.None;
        }
        
        private static PyObject readMove$23(PyFrame frame) {
            // Temporary Variables
            PyObject[] t$0$PyObject__;
            
            // Code
            frame.setlocal(2, frame.getglobal("raw_input").__call__(s$20));
            frame.setlocal(2, frame.getlocal(2).invoke("upper"));
            t$0$PyObject__ = org.python.core.Py.unpackSequence(new PyTuple(new PyObject[] {frame.getglobal("string").__getattr__("letters").__getattr__("index").__call__(frame.getlocal(2).__getitem__(i$0))._sub(frame.getglobal("string").__getattr__("letters").__getattr__("index").__call__(s$16)), frame.getglobal("eval").__call__(frame.getlocal(2).__getslice__(i$2, null, null))._sub(i$2)}), 2);
            frame.setlocal(1, t$0$PyObject__[0]);
            frame.setlocal(3, t$0$PyObject__[1]);
            return frame.getglobal("Move").__call__(frame.getlocal(1), frame.getlocal(3));
        }
        
        private static PyObject start$24(PyFrame frame) {
            // Temporary Variables
            PyException t$0$PyException;
            PyObject t$0$PyObject;
            
            // Code
            Py.println(frame.getlocal(0).__getattr__("copyright"));
            frame.setlocal(2, frame.getglobal("BLACK"));
            frame.setlocal(3, frame.getglobal("None"));
            while (((t$0$PyObject = frame.getlocal(3)._ne(frame.getglobal("BLACK"))).__nonzero__() ? frame.getlocal(3)._ne(frame.getglobal("WHITE")) : t$0$PyObject).__nonzero__()) {
                frame.setlocal(3, frame.getglobal("raw_input").__call__(s$21));
                try {
                    frame.setlocal(3, new PyDictionary(new PyObject[] {s$22, frame.getglobal("BLACK"), s$23, frame.getglobal("BLACK"), s$24, frame.getglobal("WHITE"), s$25, frame.getglobal("WHITE")}).__getitem__(frame.getlocal(3)));
                }
                catch (Throwable x$0) {
                    t$0$PyException = Py.setException(x$0, frame);
                    frame.setlocal(3, frame.getglobal("None"));
                }
            }
            if (frame.getlocal(3)._eq(frame.getglobal("WHITE")).__nonzero__()) {
                frame.getlocal(0).__getattr__("board").invoke("move", frame.getglobal("Move").__call__(i$1, i$1), frame.getglobal("BLACK"));
                frame.setlocal(2, frame.getglobal("WHITE"));
            }
            while (i$2.__nonzero__()) {
                Py.println(frame.getlocal(0).__getattr__("board"));
                if (frame.getlocal(2)._eq(frame.getlocal(3)).__nonzero__()) {
                    frame.setlocal(1, frame.getlocal(0).invoke("readMove"));
                    frame.getlocal(0).__getattr__("board").invoke("move", frame.getlocal(1), frame.getlocal(2));
                }
                else {
                    Py.printComma(s$26);
                    frame.getlocal(0).__getattr__("ai").invoke("makeMove", frame.getlocal(2));
                    Py.println(s$27);
                }
                frame.setlocal(2, new PyList(new PyObject[] {frame.getglobal("None"), frame.getglobal("WHITE"), frame.getglobal("BLACK")}).__getitem__(frame.getlocal(2)));
            }
            return Py.None;
        }
        
        private static PyObject UI$25(PyFrame frame) {
            frame.setlocal("copyright", s$18);
            frame.setlocal("__init__", new PyFunction(frame.f_globals, new PyObject[] {}, c$19___init__));
            frame.setlocal("readMove", new PyFunction(frame.f_globals, new PyObject[] {}, c$20_readMove));
            frame.setlocal("start", new PyFunction(frame.f_globals, new PyObject[] {}, c$21_start));
            return frame.getf_locals();
        }
        
        private static PyObject main$26(PyFrame frame) {
            frame.setlocal(0, frame.getglobal("UI").__call__());
            frame.getlocal(0).invoke("start");
            return Py.None;
        }
        
        private static PyObject main$27(PyFrame frame) {
            frame.setglobal("__file__", s$29);
            
            org.python.core.imp.importAll("copy", frame);
            frame.setlocal("time", org.python.core.imp.importOne("time", frame));
            frame.setlocal("string", org.python.core.imp.importOne("string", frame));
            frame.setlocal("sys", org.python.core.imp.importOne("sys", frame));
            frame.setlocal("EMPTY", i$0);
            frame.setlocal("WHITE", i$1);
            frame.setlocal("BLACK", i$2);
            frame.setlocal("MAXDEPTH", i$3);
            frame.setlocal("Board", Py.makeClass("Board", new PyObject[] {}, c$11_Board, null));
            frame.setlocal("Move", Py.makeClass("Move", new PyObject[] {}, c$14_Move, null));
            frame.setlocal("AI", Py.makeClass("AI", new PyObject[] {}, c$18_AI, null));
            frame.setlocal("UI", Py.makeClass("UI", new PyObject[] {}, c$22_UI, null));
            frame.setlocal("main", new PyFunction(frame.f_globals, new PyObject[] {}, c$23_main));
            if (frame.getname("__name__")._eq(s$28).__nonzero__()) {
                frame.getname("main").__call__();
            }
            return Py.None;
        }
        
    }
    public static void moduleDictInit(PyObject dict) {
        dict.__setitem__("__name__", new PyString("go"));
        Py.runCode(new _PyInner().getMain(), dict, dict);
    }
    
    public static void main(String[] args) throws java.lang.Exception {
        String[] newargs = new String[args.length+1];
        newargs[0] = "go";
        System.arraycopy(args, 0, newargs, 1, args.length);
        Py.runMain(go._PyInner.class, newargs, go.jpy$packages, go.jpy$mainProperties, "", new String[] {"repr", "string", "go", "copy"});
    }
    
}
