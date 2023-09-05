local nord = require("nord.colors")

-- FOR REFERENCE :
-- nord0_gui = named_colors.black, -- nord0 in palette #2E3440
-- nord1_gui = named_colors.dark_gray, -- nord1 in palette #3b4252
-- nord2_gui = named_colors.gray, -- nord2 in palette #434C5E
-- nord3_gui = named_colors.light_gray, -- nord3 in palette #4C566A
-- nord3_gui_bright = named_colors.light_gray_bright, -- out of palette #d8dee9
-- nord4_gui = named_colors.darkest_white, -- nord4 in palette  #e5e9f0
-- nord5_gui = named_colors.darker_white, -- nord5 in palette #eceff4
-- nord6_gui = named_colors.white, -- nord6 in palette #f5f7fa
-- nord7_gui = named_colors.teal, -- nord7 in palette #8FBCBB
-- nord8_gui = named_colors.off_blue, -- nord8 in palette #88c0d0
-- nord9_gui = named_colors.glacier, -- nord9 in palette #81a1c1
-- nord10_gui = named_colors.blue, -- nord10 in palette #5e81ac
-- nord11_gui = named_colors.red, -- nord11 in palette #bf616a
-- nord12_gui = named_colors.orange, -- nord12 in palette #d08770
-- nord13_gui = named_colors.yellow, -- nord13 in palette #ebcb8b
-- nord14_gui = named_colors.green, -- nord14 in palette #a3be8c
-- nord15_gui = named_colors.purple, -- nord15 in palette #b48ead
-- none = "NONE",

------------------------- TYPESCRIPT HIGHLIGHTS -------------------
vim.api.nvim_set_hl(0, "TSTag", { fg = nord.nord15_gui })
vim.api.nvim_set_hl(0, "TSTagAttribute", { fg = nord.nord15_gui })
vim.api.nvim_set_hl(0, "TSProperty", { fg = nord.nord4_gui })
vim.api.nvim_set_hl(0, "TSType", { fg = nord.nord7_gui })

-------------------------- NVIM Tree Colors---------------------------
-- vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = nord.nord1_gui })
vim.api.nvim_set_hl(0, "NvimTreeLspDiagnosticsError", { fg = nord.nord11_gui })
vim.api.nvim_set_hl(0, "NvimTreeLspDiagnosticsWarning", { fg = nord.nord13_gui })
vim.api.nvim_set_hl(0, "NvimTreeLspDiagnosticsInformation", { fg = nord.nord15_gui })
vim.api.nvim_set_hl(0, "NvimTreeLspDiagnosticsHint", { fg = nord.nord15_gui })
