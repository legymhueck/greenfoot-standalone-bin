# Maintainer: Mic Leh <[EMAIL_ADDRESS]>
pkgname=greenfoot-standalone-bin
pkgver=3.9.0
pkgrel=1
pkgdesc="Standalone repackaging of Greenfoot IDE with bundled JDK and JavaFX"
arch=('x86_64')
url="https://www.greenfoot.org/"
license=('GPL-2.0-only' 'GPL-2.0-only WITH Classpath-exception-2.0')
provides=('greenfoot')
conflicts=('greenfoot')

depends=(
  'bash'
  'gtk3'
  'libglvnd'
  'alsa-lib'
  'libxtst'
  'libxi'
  'libxrender'
  'libxrandr'
  'libxext'
  'fontconfig'
  'freetype2'
)
makedepends=('unzip')

source=(
  'greenfoot'
  'greenfoot.desktop'
  'greenfoot.xml'
  'greenfoot-module'
  'Greenfoot-generic-390.jar::https://www.greenfoot.org/download/files/Greenfoot-generic-390.jar'
  'openjdk-21.0.2_linux-x64_bin.tar.gz::https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz'
  'openjfx-21.0.10_linux-x64_bin-sdk.zip::https://download2.gluonhq.com/openjfx/21.0.10/openjfx-21.0.10_linux-x64_bin-sdk.zip'
)
sha256sums=('2ac4b25263cd472244eb5239b273ef4a149ca119e0de81ef2525a1a31d885898'
            'e7f59d1c908d47773e778c11ceeb90a57dd74fa57f6d0c39fcfda7ce0ec282b8'
            '16d1ae0af2ddefa9d0af8c6c28eda424aa8200a985cf0eeb4d29f612f80ea2c8'
            '4bab045a81511ce136b4f5a12a14cca1d499bac941b9e6c181559b217eafb53b'
            'd355c03a3284631aac9f10bd37be9a0341240206ae8aa87d7ea36cdffd6d12e6'
            'a2def047a73941e01a73739f92755f86b895811afb1f91243db214cff5bdac3f'
            '1d47e3291092145e2361b445a42dabcfbb89dcc9e1060ff4b8dfab64b9913fb4')

noextract=(
  'Greenfoot-generic-390.jar'
  'openjfx-21.0.10_linux-x64_bin-sdk.zip'
)

prepare() {
  cd "$srcdir"

  unzip -o "Greenfoot-generic-390.jar" greenfoot-dist.jar

  mkdir -p greenfoot-app
  unzip -o greenfoot-dist.jar -d greenfoot-app

  unzip -o "openjfx-21.0.10_linux-x64_bin-sdk.zip"
}

package() {
  cd "$srcdir"

  # --- Greenfoot application files ---
  install -dm755 "${pkgdir}/opt/greenfoot"
  cp -a greenfoot-app/. "${pkgdir}/opt/greenfoot/"

  # --- Bundled JDK ---
  cp -a "${srcdir}/jdk-21.0.2" "${pkgdir}/opt/greenfoot/jdk"
  find "${pkgdir}/opt/greenfoot/jdk" -type f -name '*.so' -exec chmod 755 {} +

  # --- Bundled JavaFX SDK ---
  cp -a "${srcdir}/javafx-sdk-21.0.10" "${pkgdir}/opt/greenfoot/javafx"

  # --- Launchers (classpath/default and module variant) ---
  install -Dm755 "${srcdir}/greenfoot"         "${pkgdir}/usr/bin/greenfoot"
  install -Dm755 "${srcdir}/greenfoot-module"  "${pkgdir}/usr/bin/greenfoot-module"

  # --- Desktop entry ---
  install -Dm644 "${srcdir}/greenfoot.desktop" \
    "${pkgdir}/usr/share/applications/greenfoot.desktop"

  # --- MIME type definition ---
  install -Dm644 "${srcdir}/greenfoot.xml" \
    "${pkgdir}/usr/share/mime/packages/greenfoot.xml"

  # --- Icon (hicolor theme) ---
  install -Dm644 "greenfoot-app/lib/images/greenfoot-icon-256.png" \
    "${pkgdir}/usr/share/icons/hicolor/256x256/apps/greenfoot.png"

  # --- Licenses ---
  install -dm755 "${pkgdir}/usr/share/licenses/${pkgname}"

  # Greenfoot license
  install -Dm644 "greenfoot-app/lib/doc/LICENSE.txt" \
    "${pkgdir}/usr/share/licenses/${pkgname}/GREENFOOT_LICENSE"

  # OpenJDK legal notices (if present in this JDK version)
  if [[ -d "${srcdir}/jdk-21.0.2/legal" ]]; then
    cp -a "${srcdir}/jdk-21.0.2/legal" \
      "${pkgdir}/usr/share/licenses/${pkgname}/jdk-legal"
  fi

  # JavaFX legal notices (if present)
  if [[ -d "${srcdir}/javafx-sdk-21.0.10/legal" ]]; then
    cp -a "${srcdir}/javafx-sdk-21.0.10/legal" \
      "${pkgdir}/usr/share/licenses/${pkgname}/javafx-legal"
  fi
}
