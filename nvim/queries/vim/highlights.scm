; Override stale nvim-treesitter Vimscript queries that reference the invalid
; "tab" node with Neovim's bundled vim parser. Do not add `;; extends` here:
; this file must replace later runtime queries, not merge with them.
