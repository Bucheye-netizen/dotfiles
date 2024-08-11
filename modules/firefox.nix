{ stateVersion }:
{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    profiles.lisan = {
      bookmarks = [{
        name = "Blogs";
        toolbar = true;
        bookmarks = [
          {
            name = "vaxry";
            tags = [ "vaxry" "blog" ];
            url = "http://vaxry.net/";
          }
          {
            name = "fasterthanlime";
            tags = [ "fasterthanlime" "blog" ];
            url = "https://fasterthanli.me/";
          }
        ];
      }];

      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
            icon =
              "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          }];
        };
        "Home Manager Options" = {
          urls = [{
            template = "https://home-manager-options.extranix.com/";
            params = [
              {
                name = "release";
                value = "release-${stateVersion}";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
            icon =
              "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@hmo" ];
          }];
        };
      };

      search.force = true;
    };
  };
}
