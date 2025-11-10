self: { lib, config, pkgs, ... }:
let
  inherit (lib) mkOption types mapAttrs';
  inherit (pkgs) writeTextDir symlinkJoin;

  konduitLandingOptions = {name, ...}: {
    options = {
      domain = mkOption {
        type = types.str;
        default = name;
        description = "The domain to host the website";
      };

      useSSL = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to use SSL for the website";
      };
    };
  };
in {
  options = {
    konduit-landings = mkOption {
      type = types.attrsOf (types.submodule konduitLandingOptions);
      default = {};
      description = "Konduit landing instances to serve";
    };
  };
  config = {
    http-services.static-sites =
      mapAttrs'
      (name: konduit-landing: {
        name = "konduit-landing-${name}";
        value = {
          inherit (konduit-landing) domain;
          useSSL = konduit-landing.useSSL;
          root = self.packages.${pkgs.system}.default;
          index-fallback = true;
        };
      })
      config.konduit-landings;
  };
}
