{
  default_editor,
  ...
}:

{
  lib,
  ...
}:

{
  home.sessionVariables = lib.mkIf default_editor {
    EDITOR = "micro";
    VISUAL = "micro";
  };

  programs.micro = {
    enable = true;
    settings = {
      "mkparents" = true;
      "softwrap" = true;
      "tabsize" = 4;
    };
  };
}
