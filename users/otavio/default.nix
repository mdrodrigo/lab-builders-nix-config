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
}
