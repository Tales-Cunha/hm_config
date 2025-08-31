# Productivity and utility applications (minimal essential set)
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # System information
    neofetch    # System info display
    
    # File sync (essential for backup/sync)
    rclone      # Cloud storage sync
    
    # Document processing (if you need it)
    pandoc      # Universal document converter
  ];
}
