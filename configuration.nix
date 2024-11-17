{ 
  pkgs, 
  lib, 
  config, 
  inputs, 
  ...  
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  environment.systemPackages = [(
    inputs.wrapper-manager.lib.build {
      inherit pkgs;
      modules = lib.pipe (builtins.readDir ./modules/wrapper) [
        (lib.filterAttrs (name: value: value == "directory"))
          builtins.attrNames
            (map (n: ./modules/wrapper/${n}))
      ];
  })] ++ (with pkgs; [
    gh
    nh
    scc
    eza
    bat
    just
    fish
    zenith
    zoxide
    direnv
    fclones
    erdtree
    alejandra
    protonvpn-cli
  ]) ++ (with inputs; [
    lstodo.packages."${pkgs.system}".default
  ]);

  services = {
    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
      # openFirewall = true;
    };
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = "east";
      dataDir = "/home/east";
      guiAddress = "0.0.0.0:8384";
      settings = { 
        gui = {
          user = "east";
          password = "east";
          theme = "dark";
        };
        folders = {
          "Documents" = {
            path = "/home/east/Documents";
            devices = [ ];
          };
        };
      };
    };
    gitea = {
      enable = true;
    };
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "east";
    };
    jellyseerr.enable = true;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nftables.enable = true;
    useDHCP = false;
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    firewall = {
      allowedTCPPorts = [ 8384 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
    };
  };

  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.east = {
    isNormalUser = true;
    description = "east";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [ ];
  };

  security.sudo.extraRules = [{
    users = [ "east" ];
    commands = [{ 
      command = "ALL" ;
      options= [ "NOPASSWD" "SETENV" ];
    }];
  }];

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05";
}
