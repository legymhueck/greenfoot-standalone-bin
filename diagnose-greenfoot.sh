#!/bin/bash
# diagnose-greenfoot.sh
set -euo pipefail

GREENFOOT_HOME="${GREENFOOT_HOME:-/opt/greenfoot}"
JAVA_HOME="${GREENFOOT_HOME}/jdk"
JFX_LIB="${GREENFOOT_HOME}/javafx/lib"

echo "== Environment =="
echo "XDG_SESSION_TYPE=${XDG_SESSION_TYPE:-}"
echo "WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-}"
echo "GDK_BACKEND=${GDK_BACKEND:-}"
echo "PRISM_ORDER=${PRISM_ORDER:-}"
echo

echo "== Checking native libraries =="
MISSING=0
for lib in \
  "${JFX_LIB}/libglass.so" \
  "${JFX_LIB}/libprism_es2.so" \
  "${JAVA_HOME}/lib/server/libjvm.so"
do
  if [[ -f "$lib" ]]; then
    if ldd "$lib" | grep -q "not found"; then
      echo "Missing dependencies for: $lib"
      ldd "$lib" | grep "not found" || true
      MISSING=1
    else
      echo "OK: $lib"
    fi
  else
    echo "Not found: $lib"
    MISSING=1
  fi
done
echo

if [[ $MISSING -eq 1 ]]; then
  echo ">> Please install the missing system packages (e.g. fontconfig, freetype2, libxrandr, libxext, ...)."
  echo
fi

echo "== Starting Greenfoot with JavaFX verbose logging (close the app afterward) =="
echo "Tip: If it misbehaves under Wayland, use: GDK_BACKEND=x11 $0"
echo
# JAVA_TOOL_OPTIONS is automatically evaluated and then removed by the JVM
env_args=()
if [[ -n "${GDK_BACKEND:-}" ]]; then
  env_args+=("GDK_BACKEND=$GDK_BACKEND")
fi
if [[ -n "${PRISM_ORDER:-}" ]]; then
  env_args+=("PRISM_ORDER=$PRISM_ORDER")
fi

env JAVA_TOOL_OPTIONS="-Dprism.verbose=true" \
    "${env_args[@]}" \
    greenfoot || true

echo
echo "== Note =="
echo "- 'Unsupported JavaFX configuration' is normal and harmless with classpath startup."
echo "- If the editor window is only stable with PRISM_ORDER=sw, a graphics driver/OpenGL issue is likely."