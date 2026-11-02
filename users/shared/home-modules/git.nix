{
  name,
  email,
  ...
}:

{
  programs.git = {
    enable = true;
    settings.user = {
      name = name;
      email = email;
    };
  };
}
