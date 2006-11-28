input metauml;
input metauml_skin_rational;

beginfig(1);
  Class.Glyph("Glyph")
    ("+speed:int=0",
     "+direction:int=3",
     "+x:int=0",
     "+y:int=0",
     "+dx:int=0",
     "+dy:int=0",
     "+vx:int=1",
     "+vy:int=0")
    ("+Glyph()",
     "+doTurn()",
     "+move()",
     "+reset()",
     "+setStartPosition()",
     "+update()");
  Class.View("View")
    ("+bufferGraphics:Graphics",
     "+bufferImage:Image")
    ("+View()",
     "+clearBuffer()",
     "+paintBuffer()",
     "+run()");
  Class.Pacman("Pacman")
    ("-eviltime:long")
    ("+Pacman()",
     "+doTurn()",
     "+paint()",
     "+isEvil():bool",
     "+reset()",
     "+setStartPosition()",
     "+update()");
  Class.Ghost("Ghost")
    ("-scared:bool")
    ("+Ghost()",
     "+doTurn()",
     "+isScared():bool",
     "+paint()",
     "+update()");
  Class.Keyboard("Keyboard")
    ("-direction:int=0")
    ("+getNextMove():int",
     "+keyPressed()",
     "+keyReleased()",
     "+keyTyped()");
  Class.PacmanView("PacmanView")
    ("-images:Image[][]")
    ("+PacmanView()",
     "+paint()");
  Class.GhostView("GhostView")
    ("-images:Image[][]")
    ("+GhostView()",
     "+paint()");
  Class.RandomStrategy("RandomStrategy")
    ()
    ("+getNextMove():int");
  Class.World("World")
    ("-screenData:short[][]",
     "-pacman:Pacman")
    ("+World()",
     "+canMove():bool",
     "+canMoveDown():bool",
     "+canMoveLeft():bool",
     "+canMoveRight():bool",
     "+canMoveUp():bool",
     "+eatFood()",
     "+eatVitamin()",
     "+foodOn():bool",
     "+isEmpty():bool",
     "+paint()",
     "+reset()",
     "+vitaminOn():bool");
  Class.Game("Game")
    ("-level:int",
     "-lives:int",
     "-state:State")
    ("+Game()",
     "+addGhost()",
     "+doGameOver()",
     "+doPlaying()",
     "+gameInit()",
     "+ghostBumpsPacman()",
     "+paint()",
     "+play()",
     "+proceed()",
     "+pacmanKilled()",
     "+reset()",
     "+roundInit()",
     "+roundOver()",
     "+roundStart()");
  Class.Main("Main")
    ()
    ("+Main()",
     "+main()");
  Class.Panel("Panel")()();
  Class.Frame("Frame")()();

  Glyph.nw = (0, 0);

  % Center Pacman and Ghost below Glyph, align their tops.
  centered_allign_top(Pacman, Ghost)(60, below(Glyph.s, 60));

  % Put Ghost next to Game, and Game next to View.
  leftToRight(60)(Ghost, Game, View);
  
  % Put World above Game
  World.s = Game.n + (0, 60);

  % Align Main with bottom of World and right hand side of View.
  same.bottom(World, Main);
  same.right(View, Main);

  % Put frame above Main.
  Frame.s = Main.n + (0, 60);

  % Align Panel with bottom of Glyph and middle of View.
  same.bottom(Glyph, Panel);
  same.midx(Panel, View);

  % Align RandomStrategy with middle of Ghost, but stay below Game.
  RandomStrategy.left = Ghost.midx;
  RandomStrategy.top = Game.bottom - 30;
  GhostView.ne = RandomStrategy.sw - (0, 30);

  % Align PacmanView with middle of Pacman, but stay below GhostView.
  PacmanView.left = Pacman.midx;
  PacmanView.top = GhostView.bottom - 30;
  Keyboard.se = PacmanView.nw + (0, 30);

  drawObjects(Glyph, Pacman, Ghost);
  drawObjects(Game, View, Main);
  drawObjects(World, Panel, Frame);
  drawObjects(Keyboard, PacmanView, GhostView, RandomStrategy);

  % Horizontal path from above the middle of Glyph
  % until it touches the leftside of World.
  link(associationUni)(pathHorizontal(Glyph.e + (0, 20), World.left));
  item(iAssoc)("1")(obj.ne = (xpart(World.w) - 10, ypart(Glyph.e) + 10));
  item(iAssoc)("world")(obj.se = (xpart(World.w) - 10, ypart(Glyph.e) + 30));

  % Join inheritance paths below middle of Glyph.
  link(inheritance)(pathStepY(Pacman.n, Glyph.s, 30));
  link(inheritance)(pathStepY(Ghost.n, Glyph.s, 30));

  clink(associationUni)(Game, Ghost);
  item(iAssoc)("*")(obj.nw = Ghost.e + (10, -10));
  item(iAssoc)("ghosts")(obj.sw = Ghost.e + (10, 10));

  % Create an association from Game to Pacman avoiding Ghost.
  link(associationUni)(Game.w - (0, 30) -- Game.w - (30, 30) -- 
                       Ghost.se - (-30, 30) -- Ghost.sw - (30, 30) --
                       Pacman.e + (30, 0) -- Pacman.e + (0, 0));
  item(iAssoc)("1")(obj.nw = Pacman.e + (10, -10));
  item(iAssoc)("pacman")(obj.sw = Pacman.e + (10, 10));

  clink(associationUni)(Game, World);
  item(iAssoc)("1")(obj.nw = World.s + (10, -10));
  item(iAssoc)("world")(obj.ne = World.s - (10, 10));

  clink(association)(Game, View);
  item(iAssoc)("1")(obj.nw = Game.e + (10, -10));
  item(iAssoc)("1")(obj.ne = View.w - (10, 10));

  clink(inheritance)(View, Panel);
  clink(inheritance)(Main, Frame);
  link(dependency)(pathVertical(Main.s, View.top));
  % Also shift in x direction as LaTeX makes << one character.
  item(iAssoc)("<<instantiates>>")(obj.ne = Main.s + (5, -10));

  % Vertical paths until they touch.
  link(associationUni)(pathVertical(Pacman.s - (20, 0), Keyboard.top));
  item(iAssoc)("controlled by")(obj.e = .5[Pacman.s, Keyboard.n]);
  item(iAssoc)("1")(obj.se = (xpart(Pacman.s) - 30, Keyboard.top + 10));
  link(associationUni)(pathVertical(Pacman.s + (20, 0), PacmanView.top));
  item(iAssoc)("1")(obj.se = (xpart(Pacman.s) + 10, PacmanView.top + 10));

  link(associationUni)(pathVertical(Ghost.s - (20, 0), GhostView.top));
  item(iAssoc)("1")(obj.se = (xpart(Ghost.s) - 30, GhostView.top + 10));
  link(associationUni)(pathVertical(Ghost.s + (20, 0), RandomStrategy.top));
  item(iAssoc)("1")(obj.se = (xpart(Ghost.s) + 10, RandomStrategy.top + 10));

  % Paths down from View until level with GhostView and PacmanView.
  link(association)(pathManhattanY(View.s - (20, 0), GhostView.e));
  item(iAssoc)("1")(obj.nw = View.s - (15, 10));
  item(iAssoc)("parent")(obj.ne = View.s - (25, 10));
  item(iAssoc)("1")(obj.nw = GhostView.e + (10, -10));
  link(association)(pathManhattanY(View.s + (20, 0), PacmanView.e));
  item(iAssoc)("1")(obj.ne = View.s + (15, -10));
  item(iAssoc)("parent")(obj.nw = View.s + (25, -10));
  item(iAssoc)("1")(obj.nw = PacmanView.e + (10, -10));
endfig;

end

