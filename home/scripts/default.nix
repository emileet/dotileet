{ ... }:
{
  home.file.".local/scripts" = {
    source = ./files;
    recursive = true;
  };
}
