-- gathers all of the bemol-generated files and adds them to the LSP workspace
local function bemol()
    local bemol_dir = vim.fs.find({ ".bemol" }, { upward = true, type = "directory" })[1]
    local ws_folders_lsp = {}
    if bemol_dir then
        local file = io.open(bemol_dir .. "/ws_root_folders", "r")
        if file then
            for line in file:lines() do
                table.insert(ws_folders_lsp, "file://" .. line)
            end
            file:close()
        end
        --
        -- for _, line in ipairs(ws_folders_lsp) do
        --     if not contains(vim.lsp.buf.list_workspace_folders(), line) then
        --         vim.lsp.buf.add_workspace_folder(line)
        --     end
        -- end
    end

    return ws_folders_lsp
end

-- Some additional configuration to get debugger working, works in conjunction to nvim-dap
local function debugger()
    -- Following instructions: https://github.com/mfussenegger/nvim-jdtls?tab=readme-ov-file#debugger-via-nvim-dap

    -- java-debug will allow you to:
    --   1. Debug applications via explicit configurations
    --   2. Debug automatically discovered main classes
    local java_debug_install = require 'mason-registry'
        .get_package('java-debug-adapter')
        :get_install_path()

    -- vscode-java-test will allow you to:
    --   1. Debug junit tests. Either whole classes or individual test methods
    local java_test_install = require 'mason-registry'
        .get_package('java-test')
        :get_install_path()

    -- `glob()` gets table of all *.jar files in the directory
    local bundles = vim.fn.glob(java_debug_install .. "/extension/server/*.jar", true, true)
    vim.list_extend(bundles, vim.fn.glob(java_test_install .. "/extension/server/*.jar", true, true))

    local jdtls = require('jdtls')
    jdtls.setup_dap({
        -- To avoid 'command line too long' exception, we can use the `shortenCommandLine` flag to create a temporary pathing jar
        -- when running tests via vs-code-java-test
        -- :help jdtls.dap.setup_dap
        config_overrides = { shortenCommandLine = 'jarmanifest' },
        hotcodereplace = 'auto'
    })
    -- Keymaps for running individual tests
    vim.keymap.set('n', '<leader>dm', function() jdtls.test_nearest_method() end, { desc = "[d]ebug: Test nearest [m]ethod" })
    vim.keymap.set('n', '<leader>dc', function() jdtls.test_class() end, { desc = "[d]ebug: Test [c]lass" })

    return { bundles = bundles }
end

local jdtls = require "jdtls"
local jdtls_setup = require "jdtls.setup"
local home = os.getenv("HOME")
local root_dir = jdtls_setup.find_root({ ".bemol" })
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local path_to_mason_packages = home .."/.local/share/nvim/mason/packages"
local path_to_jdtls = path_to_mason_packages .. "/jdtls"

local config = {
    cmd = {
        -- assumes the java binary is in your PATH and at least java17;
        -- if not, specify the full path to the binary
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "-javaagent:" .. path_to_jdtls .. "/lombok.jar",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",

        "-jar",
        vim.fn.glob(path_to_jdtls .. "/plugins/org.eclipse.equinox.launcher_*.jar"),

        "-configuration",
        path_to_jdtls .. "/config_" .. (vim.fn.has("macunix") and "mac" or "linux"),

        "-data",
        home .. "/.cache/jdtls/workspace/" .. project_name,

        "-Xlog::file=/home/kwhk/tmp/test.log",
        "-verbose"
    },

    root_dir = root_dir,

    capabilities = {
        workspace = {
            configuration = true
        },
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = true
                }
            }
        }
    },

    settings = {
        java = {
            references = {
                includeDecompiledSources = true,
            },
            eclipse = {
                downloadSources = true,
            },
            maven = {
                downloadSources = true,
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            -- inlayHints = {
            --     parameterNames = { enabled = "all" }
            -- }
        }
    },

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
        bundles = debugger().bundles,
        workspaceFolders = bemol(),
    },
    --
    -- on_attach = bemol,
}


-- vim.notify_once(vim.inspect(config))

jdtls.start_or_attach(config)
