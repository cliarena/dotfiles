f: let
  systems = ["x86_64-linux" "aarch64-linux"];
in
  builtins.listToAttrs (map (name: {
      inherit name;
      value = f name;
    })
    systems)
# forAllSystems = f:
#   builtins.listToAttrs (map (name: {
#     inherit name;
#     value = f name;
#   }) systems);

