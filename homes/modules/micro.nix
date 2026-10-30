{
  ...
}:

{
  home.sessionVariables = {
    EDITOR = "micro";
    VISUAL = "micro";
  };

  programs.micro = {
    enable = true;
    settings = {
      "colorscheme" = "gruvbox";
      "mkparents" = true;
      "softwrap" = true;
      "tabsize" = 4;
    };
  };
}
