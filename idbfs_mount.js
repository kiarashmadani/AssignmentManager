// idbfs_mount.js
Module.preRun = Module.preRun || [];
Module.preRun.push(function() {
    // 1. Create the mount directory in virtual memory
    try {
        FS.mkdir('/assignments_data');
    } catch(e) {}

    // 2. Mount Emscripten's IDBFS to this directory
    try {
        FS.mount(IDBFS, {}, '/assignments_data');
    } catch(e) {}

    // 3. Pause application startup until IndexedDB has populated the folder
    addRunDependency('sync_idbfs');
    FS.syncfs(true, function(err) {
        if (err) {
            console.error("IDBFS startup sync error:", err);
        } else {
            console.log("Successfully mounted and restored assignments from IndexedDB!");
        }
        // 4. Resume and call Qt C++ main()
        removeRunDependency('sync_idbfs');
    });
});