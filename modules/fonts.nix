{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Single programming font with icons
    nerd-fonts.jetbrains-mono

    # Essential system fonts
    liberation_ttf    # Microsoft fonts replacement
    noto-fonts       # Universal font family
    noto-fonts-emoji # Emoji support
  ];

  # Simple fontconfig for better rendering
  xdg.configFile."fontconfig/fonts.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <alias>
        <family>monospace</family>
        <prefer><family>JetBrainsMono Nerd Font</family></prefer>
      </alias>
    </fontconfig>
  '';
}
