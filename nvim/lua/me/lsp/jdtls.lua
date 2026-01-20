local fn = vim.fn
local openjdk = os.getenv("JDK21")
local jdtls_dir = os.getenv("XDG_DATA_HOME") .. "/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository"
local project_name = fn.fnamemodify(fn.getcwd(), ":p:h:t")
local workspace_dir = os.getenv("XDG_CACHE_HOME") .. "/jdtls/ws/" .. project_name
local java_debug_dir = os.getenv("XDG_DATA_HOME") .. "/java-debug/com.microsoft.java.debug.plugin/target"

-- use `mvn eclipse:clean eclipse:eclipse` or `./gradlew eclipse` to regenerate
vim.lsp.config("jdtls", {
    cmd = {
        openjdk .. "/bin/java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.level=ALL",
        "-Xmx2G",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration", jdtls_dir .. "/config_mac_arm",
        "-data", workspace_dir
    },
    filetypes = { "java" },
    -- root_markers = {
    --     { "mvnw",      "gradlew", "settings.gradle", "settings.gradle.kts", ".git" },
    --     { "build.xml", "pom.xml", "build.gradle",    "build.gradle.kts" }
    -- },
    root_dir = vim.fn.getcwd(),
    settings = {
        -- see https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        java = {
            configuration = {
                maven = {
                    downloadSources = true,
                    updateSnapshots = true
                },
                runtimes = {
                    {
                        name = "JavaSE-11",
                        path = os.getenv("JDK11"),
                        default = true
                    },
                    {
                        name = "JavaSE-17",
                        path = os.getenv("JDK17")
                    },
                    {
                        name = "JavaSE-21",
                        path = os.getenv("JDK21")
                    },
                },
                updateBuildConfiguration = "interactive"
            },
            contentProvider = {
                preferred = "fernflower"
            },
            signatureHelp = {
                enabled = true
            },
            sources = {
                organizeImports = {
                    starThreshold = 99999,
                    staticStarThreshold = 99999
                }
            },
            symbols = {
                includeSourceMethodDeclarations = true
            },
            telemetry = {
                enabled = false
            }
        }
    },
    init_options = {
        extendedClientCapabilities = {
            classFileContentsSupport = true,
            generateToStringPromptSupport = true,
            hashCodeEqualsPromptSupport = true,
            moveRefactoringSupport = true,
            overrideMethodsPromptSupport = true,
            executeClientCommandSupport = true
        },
        bundles = {
            fn.glob(java_debug_dir .. "com.microsoft.java.debug.plugin-*.jar")
        }
    }
})
