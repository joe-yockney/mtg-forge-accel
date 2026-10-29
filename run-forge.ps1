# Launches the locally built Forge desktop client, or Adventure mode with -Adventure.
# Build first with: mvn -U -B clean install -pl forge-gui-desktop,forge-gui-mobile-dev -am -DskipTests
param([switch]$Adventure)

$module = if ($Adventure) { 'forge-gui-mobile-dev' } else { 'forge-gui-desktop' }
$jar = Get-ChildItem (Join-Path $PSScriptRoot "$module\target") -Filter "$module-*-jar-with-dependencies.jar" -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $jar) { throw "$module jar not found - build the project first." }

$opens = 'java.desktop/java.beans', 'java.desktop/javax.swing.border', 'java.desktop/javax.swing.event',
    'java.desktop/sun.swing', 'java.desktop/java.awt.image', 'java.desktop/java.awt.color',
    'java.desktop/sun.awt.image', 'java.desktop/javax.swing', 'java.desktop/java.awt',
    'java.base/java.util', 'java.base/java.lang', 'java.base/java.lang.reflect', 'java.base/java.text',
    'java.desktop/java.awt.font', 'java.base/jdk.internal.misc', 'java.base/sun.nio.ch',
    'java.base/java.nio', 'java.base/java.math', 'java.base/java.util.concurrent', 'java.base/java.net'
$javaArgs = @('-Xmx4096m') + ($opens | ForEach-Object { '--add-opens', "$_=ALL-UNNAMED" }) + @('-jar', $jar.FullName)

# Run from forge-gui so both clients find their resources in ./res
Start-Process java -ArgumentList $javaArgs -WorkingDirectory (Join-Path $PSScriptRoot 'forge-gui')
