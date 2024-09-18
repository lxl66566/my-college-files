{
  pkgs ? import <nixpkgs> { },
}:

let
  pythonWithTk = pkgs.python312.buildEnv.override {
    extraLibs = with pkgs.python312Packages; [
      tkinter
      pip
      virtualenv
      opencv4
      scikit-image
      numpy
      pillow
    ];
    ignoreCollisions = true;
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    pythonWithTk
    git
    tcl
    tk
  ];

  shellHook = ''
    export VENV_DIR="$PWD/.venv"
    if [ ! -d "$VENV_DIR" ]; then
      ${pythonWithTk}/bin/python -m venv $VENV_DIR
      source $VENV_DIR/bin/activate
      pip install --upgrade pip setuptools wheel
    else
      source $VENV_DIR/bin/activate
    fi

    export PYTHONPATH="${pythonWithTk}/lib/python3.12/site-packages:$PYTHONPATH"
    export TCL_LIBRARY="${pkgs.tcl}/lib/tcl${pkgs.tcl.version}"
    export TK_LIBRARY="${pkgs.tk}/lib/tk${pkgs.tk.version}"
    pip install --upgrade pyinpaint
  '';
}
