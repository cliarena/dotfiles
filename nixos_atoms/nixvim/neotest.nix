{ config, lib, ... }:
let
  module = "_neotest";
  deskription = "instant inline tests";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.neotest = {
      enable = true;
      adapters.zig.enable = true;
      settings = {
        summary.mappings = {
          next_failed = "u";
          output = "o";
          prev_failed = "e";
          run = "r";
          run_marked = "r";
        };
        watch.symbol_queries = {
          zig = "";
          go =
            "        ;query\n        ;captures imported types\n        (qualified_type name: (type_identifier) @symbol)\n        ;captures package-local and built-in types\n        (type_identifier)@symbol\n        ;captures imported function calls and variables/constants\n        (selector_expression field: (field_identifier) @symbol)\n        ;captures package-local functions calls\n        (call_expression function: (identifier) @symbol)\n      ";
          haskell =
            "        ;query\n        ;explicit import\n        ((import_item [(variable)]) @symbol)\n        ;symbols that may be imported implicitly\n        ((type) @symbol)\n        (qualified_variable (variable) @symbol)\n        (exp_apply (exp_name (variable) @symbol))\n        ((constructor) @symbol)\n        ((operator) @symbol)\n      ";
          javascript =
            "  ;query\n  ;Captures named imports\n  (import_specifier name: (identifier) @symbol)\n  ;Captures default import\n  (import_clause (identifier) @symbol)\n  ;Capture require statements\n  (variable_declarator \n  name: (identifier) @symbol\n  value: (call_expression (identifier) @function  (#eq? @function 'require')))\n  ;Capture namespace imports\n  (namespace_import (identifier) @symbol)\n";
          lua =
            "        ;query\n        ;Captures module names in require calls\n        (function_call\n          name: ((identifier) @function (#eq? @function 'require'))\n          arguments: (arguments (string) @symbol))\n      ";
          python =
            "        ;query\n        ;Captures imports and modules they're imported from\n        (import_from_statement (_ (identifier) @symbol))\n        (import_statement (_ (identifier) @symbol))\n      ";
          ruby =
            "        ;query\n        ;rspec - class name\n        (call\n          method: (identifier) @_ (#match? @_ '^(describe|context)')\n          arguments: (argument_list (constant) @symbol )\n        )\n\n        ;rspec - namespaced class name\n        (call\n          method: (identifier)\n          arguments: (argument_list\n            (scope_resolution\n              name: (constant) @symbol))\n        )\n      ";
          rust =
            "        ;query\n        ;submodule import\n        (mod_item\n          name: (identifier) @symbol)\n        ;single import\n        (use_declaration\n          argument: (scoped_identifier\n            name: (identifier) @symbol))\n        ;import list\n        (use_declaration\n          argument: (scoped_use_list\n            list: (use_list\n                [(scoped_identifier\n                   path: (identifier)\n                   name: (identifier) @symbol)\n                 ((identifier) @symbol)])))\n        ;wildcard import\n        (use_declaration\n          argument: (scoped_use_list\n            path: (identifier)\n            [(use_list\n              [(scoped_identifier\n                path: (identifier)\n                name: (identifier) @symbol)\n                ((identifier) @symbol)\n              ])]))\n      ";
          tsx =
            "  ;query\n  ;Captures named imports\n  (import_specifier name: (identifier) @symbol)\n  ;Captures default import\n  (import_clause (identifier) @symbol)\n  ;Capture require statements\n  (variable_declarator \n  name: (identifier) @symbol\n  value: (call_expression (identifier) @function  (#eq? @function 'require')))\n  ;Capture namespace imports\n  (namespace_import (identifier) @symbol)\n";
          typescript =
            "  ;query\n  ;Captures named imports\n  (import_specifier name: (identifier) @symbol)\n  ;Captures default import\n  (import_clause (identifier) @symbol)\n  ;Capture require statements\n  (variable_declarator \n  name: (identifier) @symbol\n  value: (call_expression (identifier) @function  (#eq? @function 'require')))\n  ;Capture namespace imports\n  (namespace_import (identifier) @symbol)\n";
        };
      };
    };

  };
}
