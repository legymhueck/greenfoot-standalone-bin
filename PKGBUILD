# Maintainer: Mic Leh <[EMAIL_ADDRESS]>
pkgname=greenfoot-standalone-bin
pkgver=3.9.0
pkgrel=2
pkgdesc="Standalone repackaging of Greenfoot IDE with bundled JDK and JavaFX"
arch=('x86_64')
url="https://www.greenfoot.org/"
license=('GPL-2.0-only' 'custom')
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
  'openjdk-21.0.12_linux-x64_bin.tar.gz::https://download.oracle.com/java/21/archive/jdk-21.0.12_linux-x64_bin.tar.gz'
  'openjfx-21.0.12_linux-x64_bin-sdk.zip::https://download2.gluonhq.com/openjfx/21.0.12/openjfx-21.0.12_linux-x64_bin-sdk.zip'
)
sha256sums=('57e26cddce5e87a44348e27c50c71470247256536fd60bca727d4d6fff2eeb9c'
            'e7f59d1c908d47773e778c11ceeb90a57dd74fa57f6d0c39fcfda7ce0ec282b8'
            '16d1ae0af2ddefa9d0af8c6c28eda424aa8200a985cf0eeb4d29f612f80ea2c8'
            'd6757cdd64357152585a312f8ba536a4ab66d7f4506ffed4cbc524a58c685015'
            'd355c03a3284631aac9f10bd37be9a0341240206ae8aa87d7ea36cdffd6d12e6'
            '33cc8a4ba4163b003bbf3516824861ee49e7295e6a2879ec91316c2aead78b80'
            '9d4e3daa5f2ec07a8cacec2f8a8f56d487b99aadf757c18f5f1f1c2fb594740b')

noextract=(
  'Greenfoot-generic-390.jar'
  'openjfx-21.0.12_linux-x64_bin-sdk.zip'
)

prepare() {
  cd "$srcdir"

  unzip -o "Greenfoot-generic-390.jar" greenfoot-dist.jar

  mkdir -p greenfoot-app
  unzip -o greenfoot-dist.jar -d greenfoot-app

  unzip -o "openjfx-21.0.12_linux-x64_bin-sdk.zip"
}

package() {
  cd "$srcdir"

  # --- Greenfoot application files ---
  install -dm755 "${pkgdir}/opt/greenfoot"
  cp -a greenfoot-app/. "${pkgdir}/opt/greenfoot/"

  # --- Bundled JDK ---
  cp -a "${srcdir}/jdk-21.0.12" "${pkgdir}/opt/greenfoot/jdk"
  find "${pkgdir}/opt/greenfoot/jdk" -type f -name '*.so' -exec chmod 755 {} +

  # --- Bundled JavaFX SDK ---
  cp -a "${srcdir}/javafx-sdk-21.0.12" "${pkgdir}/opt/greenfoot/javafx"

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

  # Bundled JDK legal notices (if present in this JDK version)
  if [[ -d "${srcdir}/jdk-21.0.12/legal" ]]; then
    cp -a "${srcdir}/jdk-21.0.12/legal" \
      "${pkgdir}/usr/share/licenses/${pkgname}/jdk-legal"
  fi

  # Bundled JDK license (Oracle NFTC)
  if [[ -f "${srcdir}/jdk-21.0.12/LICENSE" ]]; then
    install -Dm644 "${srcdir}/jdk-21.0.12/LICENSE" \
      "${pkgdir}/usr/share/licenses/${pkgname}/JDK_LICENSE"
  fi

  # JavaFX legal notices (if present)
  if [[ -d "${srcdir}/javafx-sdk-21.0.12/legal" ]]; then
    cp -a "${srcdir}/javafx-sdk-21.0.12/legal" \
      "${pkgdir}/usr/share/licenses/${pkgname}/javafx-legal"
  fi
}
