{ pkgs, ... }:

{
  users.users.otavio = {
    description = "Otavio Salvador";

    isNormalUser = true;
    extraGroups = [ "docker" "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAu7exa84N7tURdEdgc7YRkxlouwrK3CbBsQh8cYIFsCwt+fd5cGzVWFMQ1ZIBo36HA9ocBGA7am4uQkBMrb5CSxpr5OGWmrPU0uE6aUtZedhdGj1f9gPJA8QeDfcYxFntQjD1f/XfprLkySD53z/w5npjquy2Y2zWrbOLyHSpU/M= otavio@server.casa.com.br"
    ];

    # Default - used for bootstrapping.
    password = "pw";
  };

  home-manager.users.otavio = {
    home = {
      packages = with pkgs; [
        tmux
        tmuxp
        tree
        htop
        fzf
        wget
        unzip
        nmap
        gitRepo
      ];

      stateVersion = "23.05";
    };

    programs.git = {
      enable = true;

      delta = {
        enable = true;
        options.syntax-theme = "base16-256";
      };

      extraConfig = {
        core.sshCommand = "${pkgs.openssh}/bin/ssh -F ~/.ssh/config";
      };
    };

    programs.ssh = {
      extraConfig = ''
        Host *.ossystems.com.br
            HostkeyAlgorithms +ssh-rsa
            PubkeyAcceptedAlgorithms +ssh-rsa

        Host *.lab.ossystems
            ForwardAgent yes
            ForwardX11 yes
            ForwardX11Trusted yes
      '';
    };
  };
}
