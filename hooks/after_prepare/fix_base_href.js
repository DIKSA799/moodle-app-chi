#!/usr/bin/env node

/**
 * After prepare hook to fix base href for Cordova
 * This ensures the app works when loaded from file://
 */

const fs = require('fs');
const path = require('path');

module.exports = function(context) {
    const platformRoot = path.join(context.opts.projectRoot, 'platforms', 'android');
    const indexPath = path.join(platformRoot, 'app', 'src', 'main', 'assets', 'www', 'index.html');
    
    if (fs.existsSync(indexPath)) {
        let content = fs.readFileSync(indexPath, 'utf8');
        
        // Replace base href="/" with base href="./"
        content = content.replace(/<base href="\/"\s*>/g, '<base href="./">');
        
        fs.writeFileSync(indexPath, content, 'utf8');
        console.log('✓ Fixed base href in index.html for Cordova');
    }
};
