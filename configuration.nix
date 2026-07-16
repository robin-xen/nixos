# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, zen-browser, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ];


#showing password feedback 
  security.sudo = { 
    enable = true;
    extraConfig = ''
      Defaults pwfeedback
      '';
  };

  #gnome stuff 
  services.gnome.gnome-keyring.enable = true;
  services.thumbnailer.enable = true;
#darkmode
# Add this block to your configuration.nix
  programs.dconf.enable = true;  # You already have this

# Force GTK apps to use dark theme
    environment.sessionVariables = {
      GTK_THEME = "Adwaita:dark";
      XCURSOR_THEME = "Adwaita";
      XCURSOR_SIZE = "27";
    };


#new kernels
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.enable = false;

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };


#laptop stuff
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };


programs.fish.enable = true;
  environment.shells = with pkgs; [ pkgs.fish ];

  users.users.isandrin = {
    shell = pkgs.fish;
  };


#hyprland block 
programs.hyprland = { 
  enable = true;
  xwayland.enable = true;
};



#dbus-thing-block
  services.dbus.enable = true;

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

#app-image support don't forget
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;


# xdg-desktop-portal (correct option name)
  xdg.portal = { 
    enable = true;
    extraPortals = with pkgs; [ 
      xdg-desktop-portal-hyprland 
      xdg-desktop-portal-gtk
    ];
  };


  boot.kernelParams = [
      "i915.enable_psr=0"
  ];


  service.displayManager.sddm = { 
     enable = true;
     wayland.enable = true; 
  };


#flakes-setting
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = "transcendent"; # Define your hostname.

# Enable networking
    networking.networkmanager.enable = true;

# Set your time zone.
  time.timeZone = "Asia/Kolkata";

# Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

# Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


#flatpak-apps
  services.flatpak.enable = true;


# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.isandrin = {
    isNormalUser = true;
    description = "isandrin";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "kvm" ];
    packages = with pkgs; [];
  };

# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

# List packages installed in system profile. To search, run:
# $ nix search wget
  environment.systemPackages = with pkgs; [

      git
      ffmpegthumbnailer
      lm_sensors
      libnotify
      zen-browser.packages.${pkgs.system}.default
      bc
      cliphist
      glib
      gsettings-desktop-schemas
      stow
      neovim
      gcc 
      gnumake
      cmake
      gdb
      curl 
      wget 
      unzip 
      adwaita-icon-theme
      docker
      tmux
      wl-clipboard
      brightnessctl
      networkmanagerapplet
      aria2
      ];

#fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
        cantarell-fonts 
        jetbrains-mono
        nerd-fonts.fira-code
        nerd-fonts.iosevka
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrains Mono" ];
        sansSerif = [ "Cantarell" ];
        serif = [ "Noto Serif" ];
      };
    };
  };


#powersaving tlp
  services.tlp.enable = true;


#acpi-thing-block
  services.acpid.enable = true;


#keyd-program-block
  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          rightalt = "leftmeta";
        };
      };
    };
  };


#bluetooth-block
  hardware.bluetooth.enable = true;
  services.blueman.enable = true; 

  systemd.user.services.blueman-applet = { 
    enable = false; 
  };

#audio-stack(don't forget)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  security.rtkit.enable = true;

  system.stateVersion = "25.11";
}
