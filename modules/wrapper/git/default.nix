{ pkgs, ... }: {
  wrappers.git = with pkgs; {
    basePackage = gitMinimal;
    extraPackages = [ git-extras ];
    env.GIT_CONFIG_GLOBAL.value = ./gitconfig;
  };
}
