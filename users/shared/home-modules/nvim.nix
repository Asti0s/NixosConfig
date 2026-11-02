{
  default_editor,
  ...
}:

{
  nvfModule,
  ...
}:

{
  imports = [ nvfModule ];

  programs.nvf = {
    enable = true;
    enableManpages = true;
    defaultEditor = default_editor;
    settings.vim = {
      viAlias = true;
      vimAlias = true;
    };
  };
}
