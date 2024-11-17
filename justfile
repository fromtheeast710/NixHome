# rebuild and switch
b:
  nh os switch .

# list old generations
l:
  nixos-rebuild list-generations

# update
u:
  nix flake update

# test
t:
  nh os test .

# clean cache
c:
  nix-collect-garbage --delete-older-than 7d

# show services
i:
  ss -tln

# remove old gens
r +GENS:
  sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations {{GENS}}
