local jdtls = require('jdtls')

local config = {
    on_attach = on_attach, -- We pass our on_attach keybindings to the configuration map

    cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar',
        '/home/christoph/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.6.700.v20231214-2017.jar',
        '-configuration', '/home/christoph/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux',
    },
    root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' }),
    settings = {
        java = {
        }
    },
    init_options = {
        bundles = {}
    },
}

--require('jdtls').start_or_attach(config)
jdtls.start_or_attach(config)
