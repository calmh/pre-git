#!/usr/bin/env python2.2
# $Id: go.py,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

from copy import *
import time, string, sys

EMPTY = 0
WHITE = 2
BLACK = 1
MAXDEPTH = 5

class Board:
    def __init__(self, size):
        self.board = [ [EMPTY]*size for n in range(size) ]
        self.neighbors = [ [0]*size for n in range(size) ]
        self.tmpBoard = None
        self.prisoners = {BLACK:0, WHITE:0}
        self.moveHistory = []
        self.tmpMoves = []
        self.size = size

    def freedoms(self, x, y):
        if self.board[y][x] == EMPTY:
            return None
        self.tmpBoard = deepcopy(self.board)
        color = self.tmpBoard[y][x]
        return self.__freedoms(x, y, color)

    def __freedoms(self, x, y, color):
        free = 0
        if self.tmpBoard[y][x] == color:
            self.tmpBoard[y][x] += 1
            for (xo,yo) in [(1,0), (0,1), (-1,0), (0,-1)]:
                nx = x + xo
                ny = y + yo
                if nx < 0 or nx >= self.size or ny < 0 or ny >= self.size: continue
                if self.tmpBoard[ny][nx] == EMPTY:
                    free += 1
                    self.tmpBoard[ny][nx] = EMPTY + 10
                elif self.tmpBoard[ny][nx] == color:
                    free += self.__freedoms(nx, ny, color)
        return free        

    def kill(self, x, y):
        color = self.board[y][x]
        self.tmpBoard = deepcopy(self.board)
        k = self.__kill(x, y, color)
        self.board = deepcopy(self.tmpBoard)
        return k
    
    def __kill(self, x, y, color):
        kills = 0
        if self.tmpBoard[y][x] == color:
            kills += 1
            self.tmpBoard[y][x] = EMPTY
            self.tmpMoves.append((-1, color, x, y))
            for (xo,yo) in [(1,0), (0,1), (-1,0), (0,-1)]:
                nx = x + xo
                ny = y + yo
                if nx < 0 or nx >= self.size or ny < 0 or ny >= self.size: continue
                self.neighbors[ny][nx] -= 1
                kills += self.__kill(nx, ny, color)
        return kills

    def move(self, move, color):
        self.set(move.x, move.y, color)

    def set(self, x, y, color):
        assert self.board[y][x] == EMPTY, "Illegal move"
        self.tmpMoves = [(1, color, x, y)]
        self.board[y][x] = color;
        for (xo,yo) in [(1,0), (0,1), (-1,0), (0,-1)]:
            nx = x + xo
            ny = y + yo
            if nx < 0 or nx >= self.size or ny < 0 or ny >= self.size: continue
            self.neighbors[ny][nx] += 1
            c = self.board[ny][nx]
            if c != color and c != EMPTY:
                f = self.freedoms(nx, ny)
                if f == 0:
                    p = self.kill(nx, ny)
                    self.tmpMoves.append((0, color, p))
                    self.prisoners[color] += p
        self.moveHistory.append(self.tmpMoves)

    def undo(self):
        move = self.moveHistory.pop()
        for event in move:
            type = event[0]
            if type == 1: # add
                x, y = event[2], event[3]
                self.board[y][x] = EMPTY
                for (xo,yo) in [(1,0), (0,1), (-1,0), (0,-1)]:
                    nx = x + xo
                    ny = y + yo
                    if nx < 0 or nx >= self.size or ny < 0 or ny >= self.size: continue
                    self.neighbors[ny][nx] -= 1
            elif type == -1: # remove
                x, y = event[2], event[3]
                self.board[y][x] = event[1]
                for (xo,yo) in [(1,0), (0,1), (-1,0), (0,-1)]:
                    nx = x + xo
                    ny = y + yo
                    if nx < 0 or nx >= self.size or ny < 0 or ny >= self.size: continue
                    self.neighbors[ny][nx] += 1
            elif type == 0: # prisoners
                self.prisoners[event[1]] -= event[2]

    def eval(self):
        value = 0
#        self.tmpBoard = deepcopy(self.board)

#        blackf = lambda c : c == BLACK
#        whitef = lambda c : c == WHITE
#        for line in self.tmpBoard:
#            l = filter(None, line)
#            black = len(filter(blackf, l))
#            white = len(filter(whitef, l))
#            value += 100 * black - 100 * white

        value += 1000 * self.prisoners[BLACK] - 1000 * self.prisoners[WHITE]
        return value

    def movelist(self, color):
        moves = []
        for x in range(self.size):
            for y in range(self.size):
                if self.board[y][x] == EMPTY and self.neighbors[y][x] != 0:
                    moves.append(Move(x, y))
        return moves
                

    def __str__(self):
        tstr = "   "
        for n in range(self.size):
            tstr += string.letters[26+n] + " "
        tstr += "\n"
        y = 1
        for line in self.board:
            tstr += str(y) + "  "
            y += 1
            for point in line:
                tstr += ["· ", "X ", "O "][point]
            tstr += "\n"
        tstr += "Prisoners: %d B, %d W\n"%(self.prisoners[BLACK], self.prisoners[WHITE])
        return tstr

class Move:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __repr__(self):
        return string.letters[string.letters.index("A") + self.x] + str(self.y + 1)

class AI:
    def __init__(self, board):
        self.board = board

    def makeMove(self, color):
        self.searchDepth = 0
        self.counter = 0
        val, moves = self.minimaxValue(color)
        print val, moves
        move = moves[0]
        self.board.move(move, color)

    def minimaxValue(self, color):
        #        self.counter += 1
        #        if not self.counter % 10000:
        #            sys.stdout.write("+")
        #            sys.stdout.flush()
        #        elif not self.counter % 1000:
        #            sys.stdout.write("·")
        #            sys.stdout.flush()
        if self.searchDepth == 1:
            sys.stdout.write("·")
            sys.stdout.flush()
        ncolor = [None, WHITE, BLACK][color]
        if self.searchDepth == MAXDEPTH:
            return (self.board.eval(), [])
        else:
            self.searchDepth += 1
            moves = self.board.movelist(color)
            gradedMoves = []
            for move in moves:
                self.board.move(move, color)
                val, moves = self.minimaxValue(ncolor)
                gradedMoves.append((val, [move] + moves))
                self.board.undo()
            gradedMoves.sort()
            if color == BLACK: # maximize
                gradedMoves.reverse()
            val, moves = gradedMoves[0]
            self.searchDepth -= 1
            return (val, moves)

class UI:
    copyright = "* LuserGo v0.01\n  Copyright (C) 2002 Jakob Borg\n"
    def __init__(self):
        self.board = Board(9)
#        self.board.move(Move(2, 2), BLACK)
#        self.board.move(Move(6, 6), BLACK)
#        self.board.move(Move(2, 6), WHITE)
#        self.board.move(Move(6, 2), WHITE)
        self.ai = AI(self.board)

    def readMove(self):
        move = raw_input("Your move: ")
        move = move.upper()
        x, y = string.letters.index(move[0])-string.letters.index("A"), eval(move[1:]) - 1
        return Move(x, y)

    def start(self):
        print self.copyright
        color = BLACK
        pcolor = None
        while pcolor != BLACK and pcolor != WHITE:
            pcolor = raw_input("Choose black or white [B/W]: ")
            try:
                pcolor = {"B":BLACK, "b":BLACK, "W":WHITE, "w":WHITE}[pcolor]
            except:
                pcolor = None
        if pcolor == WHITE:
            self.board.move(Move(2,2), BLACK)
            color = WHITE
        while 1:
            print self.board
            if color == pcolor:
                move = self.readMove()
                self.board.move(move, color)
            else:
                print "Thinking ",
                self.ai.makeMove(color)
                print " OK"
            color = [None, WHITE, BLACK][color]

def main():
    ui = UI()
    ui.start()
    
if __name__ == "__main__":
    main()
