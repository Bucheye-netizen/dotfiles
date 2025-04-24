{...}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.auto-format = true;
    languages.language = [
      {
        name = "rust";
        auto-format = true;
      }
      {
        name = "nix";
        formatter.command = "alejandra";
        auto-format = true;
      }
    ];
  };
}
