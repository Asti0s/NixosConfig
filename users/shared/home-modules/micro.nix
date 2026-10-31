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
      "mkparents" = true;
      "softwrap" = true;
      "tabsize" = 4;
    };
  };
}
