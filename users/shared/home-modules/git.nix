{
  name,
  email,
  ...
}: {
  programs.git = {
    enable = true;
    settings.user = {
      inherit name;
      inherit email;
    };
  };
}
